<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ page import="java.util.*" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.activiti.engine.ProcessEngine" %>
<%@ page import="org.activiti.engine.RepositoryService" %>
<%@ page import="org.activiti.engine.RuntimeService" %>
<%@ page import="org.activiti.engine.TaskService" %>
<%@ page import="org.activiti.engine.HistoryService" %>
<%@ page import="org.activiti.engine.runtime.ProcessInstance" %> 
<%@ page import="org.activiti.engine.task.Task" %>
<%@ page import="org.activiti.engine.identity.User" %>
<%@ page import="org.activiti.engine.runtime.Execution" %>
<%@ page import="org.activiti.engine.history.HistoricProcessInstance" %>
<%@ page import="com.JavascriptMessage" %>
<%@ page import="com.DateUtil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link href="<%=request.getContextPath() %>/styles/common.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath() %>/styles/main.css" rel="stylesheet" type="text/css" />
<title>My Process Instance</title>
</head>
<%
User user = (User)session.getAttribute("user");

String message = null;

WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
//ProcessEngine engine = (ProcessEngine)context.getBean("processEngine");
RepositoryService repository = (RepositoryService)context.getBean("repositoryService");
RuntimeService runtime = (RuntimeService)context.getBean("runtimeService");
TaskService taskService = (TaskService)context.getBean("taskService");
HistoryService historyService = (HistoryService)context.getBean("historyService");

String doWhat = request.getParameter("doWhat");
if(doWhat != null && doWhat.equals("signal")){
	runtime.signal(request.getParameter("executionId"));
	message = "signal success...";
} else if(doWhat != null && doWhat.equals("delete")){
	runtime.deleteProcessInstance(request.getParameter("processInstanceId"), null);
	message = "delete success...";
}

List<ProcessInstance> list = runtime.createProcessInstanceQuery().variableValueEquals("initiator", user.getId()).list();

//分页
int firstResult = request.getParameter("firstResult") == null ? 0 : Integer.parseInt(request.getParameter("firstResult"));
int maxResults = 10;
int count = (int)historyService.createHistoricProcessInstanceQuery()
	.startedBy(user.getId())
	.finished()
	.count();
int pre = firstResult < maxResults ? 0 : firstResult - maxResults;
int next = firstResult + maxResults > count ? firstResult : firstResult + maxResults;
int last = count - (count % maxResults);
int pageNum = firstResult / maxResults + 1;
List<HistoricProcessInstance> hList = historyService.createHistoricProcessInstanceQuery()
	.startedBy(user.getId())
	.finished()
	.orderByProcessInstanceEndTime()
	.desc()
	.listPage(firstResult, maxResults);
int i = 0;
%>
<body>
<%if(message != null){out.write(JavascriptMessage.alert(message));}%>

<div class="rightSidebar">
  <!--主体内容开始-->
  <div class="pageBody">
    <div class="inner_2">
      <!--详细页-->
      <div class="rightContent">
        <h3 class="bt"> <span class="tt"><b>流程管理</b></span>
          <!--搜索-->
          <div class="search">搜索：
            <label>
              <input type="text" name="textfield" id="textfield" />
            </label>
			<input type="button" onclick="window.location.href='#'" value="查询" class="searchBtn">
          </div>
          <!--搜索结束-->
        </h3>
        <!--功能按钮-->
        <div class="btnBox">
          <div class="tou">
            <div class="bt2">正在运行</div>
            <!--  
            <div class="cz_btn">
              <input type="button" class="ButtonCss" value="发布外勤公告" onclick="window.location.href='wq_add.htm'">
              <input type="button" class="ButtonCss" value="删除" onclick="window.location.href='wq_add.htm'">
            </div>-->
          </div>
        </div>
        <!--功能按钮结束-->
        <div class="content">
          <!--表格-->
          <table border="0" cellpadding="0" cellspacing="0"  class="tableBD">
            <tbody>
              <tr class="btTR">
                <td width="4%" align="center"><input name="input2" type="checkbox" value="" /></td>
                <!--  
                <td ><div class="biaoti">Id</div></td>
                <td ><div class="biaoti">BusinessKey</div></td>-->
                <td width="30%"><div class="biaoti">流程名称</div></td>
                <td ><div class="biaoti">ProcessInstanceId</div></td>
                <td width="25%"><div class="biaoti">开始时间</div></td>
                <td width="25%"><div class="biaoti">结束时间</div></td>
                <td width="5%"></td>
              </tr>
            <%for(ProcessInstance d : list){%>
				<tr>
					<td align="center"><input name="input2" type="checkbox" value="" /></td>
					<!--  
					<td ><%=d.getId() %></td>
					<td ><%=d.getBusinessKey() %></td>-->
					<td >
						<a href="#" onclick="javascript:window.open('<%=request.getContextPath() %>/jsp/img.jsp?processInstanceId=<%=d.getId() %>&doWhat=complex')">
							<%=repository.createProcessDefinitionQuery().processDefinitionId(d.getProcessDefinitionId()).singleResult().getName() %>
						</a>
					</td>
					<td ><%=d.getProcessInstanceId() %></td>
					<td ></td>
					<td ></td>
					<td >
						<a href="<%=request.getContextPath() %>/jsp/myProcessInstance.jsp?processInstanceId=<%=d.getId() %>&doWhat=delete"/>删除</a>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="4">
						<%
						List<Task> taskList = taskService.createTaskQuery().processInstanceId(d.getId()).list();
						for(Task t : taskList){
							out.write("流程正在【"+ t.getName()  +"】环节，");
							if(t.getAssignee() == null)
								out.write("暂无人处理。。。");
							else
								out.write("由" + t.getAssignee() + "处理。。。");
							out.write("</br>");
						}
						
						Execution execution = runtime.createExecutionQuery()
							.processInstanceId(d.getProcessInstanceId())
							.activityId("receivetask1")
							.singleResult();
						
						if(execution != null){
							out.write("流程正在【" + execution.getId() + "】等待</br>");
						}
						%>
					</td>
					<td>
					<%if(execution != null){%>
						<a href="<%=request.getContextPath() %>/jsp/myProcessInstance.jsp?doWhat=signal&executionId=<%=execution.getId() %>"/>解除等待</a>
					<%} %>
					</td>
				</tr>
			<%} %>
			</tbody>
          </table>
          <!--表格结束-->
        </div>
        <!--功能按钮-->
        <div class="btnBox">
          <div class="tou">
            <div class="bt2">历史</div>
          </div>
        </div>
        <!--功能按钮结束-->
		<div class="content">
          <!--表格-->
          <table border="0" cellpadding="0" cellspacing="0"  class="tableBD">
            <tbody>
              <tr class="btTR">
                <td width="4%" align="center"><input name="input2" type="checkbox" value="" /></td>
                <!--  
                <td ><div class="biaoti">Id</div></td>
                <td ><div class="biaoti">BusinessKey</div></td>-->
                <td width="30%"><div class="biaoti">流程名称</div></td>
                <td ><div class="biaoti">ProcessInstanceId</div></td>
                <td width="25%"><div class="biaoti">开始时间</div></td>
                <td width="25%"><div class="biaoti">结束时间</div></td>
                <td width="5%"></td>
              </tr>
			<%for(HistoricProcessInstance d : hList){%>
				<tr>
					<td align="center"><input name="input2" type="checkbox" value="" /></td>
					<!--  
					<td ><%=d.getId() %></td>
					<td ><%=d.getBusinessKey() %></td>-->
					<td >
						<a href="#" onclick="javascript:window.open('<%=request.getContextPath() %>/jsp/img.jsp?processDefinitionId=<%=d.getProcessDefinitionId() %>&doWhat=simple')">
							<%=repository.createProcessDefinitionQuery().processDefinitionId(d.getProcessDefinitionId()).singleResult().getName() %>
						</a>
					</td>
					<td >&nbsp;</td>
					<td ><%=DateUtil.format(d.getStartTime(), "yyyy-MM-dd HH:mm") %></td>
					<td ><%=DateUtil.format(d.getEndTime(), "yyyy-MM-dd HH:mm") %></td>
					<td ></td>
				</tr>
			<%} %>
            </tbody>
          </table>
          <!--表格结束-->
        </div>
        <!--分页--> 
        <div class="pagination">
          <div id="ContentPlaceHolder_Contents_pager">
	           <a href="<%=request.getContextPath() %>/jsp/myProcessInstance.jsp?firstResult=0" class="btn">
	           	<img src="<%=request.getContextPath() %>/images/btn_home.gif" align="absmiddle"/>首 页
	           </a> 
	           <a href="<%=request.getContextPath() %>/jsp/myProcessInstance.jsp?firstResult=<%=pre %>" class="btn">
	           	<img src="<%=request.getContextPath() %>/images/btn_prive.gif" align="absmiddle"/>上一页
	           </a> 
	           <!--  
	           <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','1')" >1</a> -->
	           <span class="currentpage"><%=pageNum %></span> 
	           <!-- 
	           <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','3')" >3</a> -->
	           <a href="<%=request.getContextPath() %>/jsp/myProcessInstance.jsp?firstResult=<%=next %>" class="btn">
	           	下一页<img src="<%=request.getContextPath() %>/images/btn_next.gif" align="absmiddle"/>
	           </a> 
	           <a href="<%=request.getContextPath() %>/jsp/myProcessInstance.jsp?firstResult=<%=last %>" class="btn">
	           	尾 页<img src="<%=request.getContextPath() %>/images/btn_end.gif" align="absmiddle"/>
	           </a> 
           </div>
        </div>
        <!--分页结束-->
      </div>
      <!--人力资源管理结束-->
    </div>
  </div>
  <!--主体内容结束-->
</div>
</body>
</html>