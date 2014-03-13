<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ page import="java.util.*" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.activiti.engine.ProcessEngine" %>
<%@ page import="org.activiti.engine.RepositoryService" %>
<%@ page import="org.activiti.engine.TaskService" %>
<%@ page import="org.activiti.engine.task.Task" %>
<%@ page import="org.activiti.engine.identity.User" %>
<%@ page import="org.activiti.engine.identity.Group" %>
<%@ page import="com.DateUtil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link href="<%=request.getContextPath() %>/styles/common.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath() %>/styles/main.css" rel="stylesheet" type="text/css" />
<title>my task</title>
</head>
<%
User user = (User)session.getAttribute("user");
List<String> groupIds = (List<String>)session.getAttribute("groupIds");
WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
RepositoryService repository = (RepositoryService)context.getBean("repositoryService");
TaskService taskService = (TaskService)context.getBean("taskService");

String doWhat = request.getParameter("doWhat");
if(doWhat != null && doWhat.equals("claim")){
	taskService.claim(request.getParameter("taskId"), user.getId());
} else if(doWhat != null && doWhat.equals("delete")){
	taskService.deleteTask(request.getParameter("taskId"), true);
}
List<Task> taskAssignee = taskService.createTaskQuery().taskAssignee(user.getId()).orderByTaskCreateTime().desc().list();
List<Task> taskCandidateGroups = taskService.createTaskQuery().taskCandidateGroupIn(groupIds).orderByTaskCreateTime().desc().list();
%>
<body>
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
            <div class="bt2">我的任务</div>
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
                <!--  <td ><div class="biaoti">Id</div></td>-->
                <td ><div class="biaoti">流程名称</div></td>
                <td ><div class="biaoti">环节名称</div></td>
                <td ><div class="biaoti">处理人</div></td>
                <td ><div class="biaoti">任务描述</div></td>
                <!--<td ><div class="biaoti">ProcessDefinitionId</div></td>
                <td ><div class="biaoti">ProcessInstanceId</div></td>
                <td ><div class="biaoti">TaskDefinitionKey</div></td>-->
                <td ><div class="biaoti">创建时间</div></td>
                <!--<td ><div class="biaoti">DelegationState</div></td>
                <td ><div class="biaoti">DueDate</div></td>-->
                <td><div class="biaoti">操作</div></td>
              </tr>
            <%for(Task t : taskAssignee){%>
				<tr>
					<td align="center"><input name="input2" type="checkbox" value="" /></td>
					<!--<td ><%=t.getId() %></td>-->
					<td >
						<a href="#" onclick="javascript:window.open('<%=request.getContextPath() %>/jsp/img.jsp?processInstanceId=<%=t.getProcessInstanceId() %>&doWhat=complex')">
							<%=repository.createProcessDefinitionQuery().processDefinitionId(t.getProcessDefinitionId()).singleResult().getName() %>
						</a>
					</td>
					<td ><%=t.getName() %></td>
					<td ><%=t.getAssignee() %></td>
					<td ><%=t.getDescription() %></td>
					<!--<td ><%=t.getProcessDefinitionId() %></td>
					<td ><%=t.getProcessInstanceId() %></td>
					<td ><%=t.getTaskDefinitionKey() %></td>-->
					<td ><%=DateUtil.format(t.getCreateTime(), "yyyy-MM-dd HH:mm") %></td>
					<!--<td ><%=t.getDelegationState() %></td>
					<td ><%=DateUtil.format(t.getDueDate(), "yyyy-MM-dd HH:mm") %></td>-->
					<td align="center">
						<a href="<%=request.getContextPath() %>/jsp/handleTask.jsp?doWhat=handle&taskId=<%=t.getId() %>&processInstanceId=<%=t.getProcessInstanceId() %>&processDefinitionId=<%=t.getProcessDefinitionId() %>">
							处理
						</a>
						<!--  
						&nbsp;
						<a href="<%=request.getContextPath() %>/jsp/myTask.jsp?doWhat=delete&taskId=<%=t.getId() %>">
							删除
						</a>-->
					</td>
				</tr>
			<%} %>
            </tbody>
          </table>
          <!--表格结束-->
          <!--表格
          <table border="0" cellpadding="0" cellspacing="0"  class="tableBD">
            <tbody>
              <tr class="btTR">
                <td width="4%" align="center"><input name="input2" type="checkbox" value="" /></td>
                <td ><div class="biaoti">Id</div></td>
                <td ><div class="biaoti">name</div></td>
                <td ><div class="biaoti">Assignee</div></td>
                <td ><div class="biaoti">Description</div></td>
                <td ><div class="biaoti">ProcessDefinitionId</div></td>
                <td ><div class="biaoti">ProcessInstanceId</div></td>
                <td ><div class="biaoti">TaskDefinitionKey</div></td>
                <td ><div class="biaoti">CreateTime</div></td>
                <td ><div class="biaoti">DelegationState</div></td>
                <td ><div class="biaoti">DueDate</div></td>
                <td></td>
              </tr>
            <%for(Task t : taskCandidateGroups){%>
				<tr>
					<td align="center"><input name="input2" type="checkbox" value="" /></td>
					<td ><%=t.getId() %></td>
					<td ><%=t.getName() %></td>
					<td ><%=t.getAssignee() %></td>
					<td ><%=t.getDescription() %></td>
					<td ><%=t.getProcessDefinitionId() %></td>
					<td ><%=t.getProcessInstanceId() %></td>
					<td ><%=t.getTaskDefinitionKey() %></td>
					<td ><%=DateUtil.format(t.getCreateTime(), "yyyy-MM-dd HH:mm") %></td>
					<td ><%=t.getDelegationState() %></td>
					<td ><%=DateUtil.format(t.getDueDate(), "yyyy-MM-dd HH:mm") %></td>
					<td ><a href="<%=request.getContextPath() %>/jsp/main.jsp?doWhat=claim&taskId=<%=t.getId() %>">claim</a></td>
				</tr>
			<%} %>
            </tbody>
          </table>-->
          <!--表格结束-->
        </div>
        <!--分页-->
        <!--  
        <div class="pagination">
          <div id="ContentPlaceHolder_Contents_pager"> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','1')" class="btn"><img src="images/btn_home.gif" align="absmiddle"/>首 页</a> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','1')" class="btn"><img src="images/btn_prive.gif" align="absmiddle"/>上一页</a> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','1')" >1</a> <span class="currentpage">2</span> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','3')" >3</a> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','3')" class="btn">下一页<img src="images/btn_next.gif" align="absmiddle"/></a> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','3')" class="btn">尾 页<img src="images/btn_end.gif" align="absmiddle"/></a> </div>
        </div>-->
        <!--分页结束-->
      </div>
      <!--人力资源管理结束-->
    </div>
  </div>
  <!--主体内容结束-->
</div>
</body>
</html>