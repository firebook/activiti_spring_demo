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
<%@ page import="com.JavascriptMessage" %>
<%@ page import="com.DateUtil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link href="<%=request.getContextPath() %>/styles/common.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath() %>/styles/main.css" rel="stylesheet" type="text/css" />
<title>Process Instance</title>
</head>
<%
User user = (User)session.getAttribute("user");

String message = null;

WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
//ProcessEngine engine = (ProcessEngine)context.getBean("processEngine");
RepositoryService repository = (RepositoryService)context.getBean("repositoryService");
RuntimeService runtime = (RuntimeService)context.getBean("runtimeService");
TaskService taskService = (TaskService)context.getBean("taskService");

String doWhat = request.getParameter("doWhat");
if(doWhat != null && doWhat.equals("signal")){
	runtime.signal(request.getParameter("executionId"));
	message = "signal success...";
} else if(doWhat != null && doWhat.equals("delete")){
	runtime.deleteProcessInstance(request.getParameter("processInstanceId"), null);
	message = "delete success...";
}

List<ProcessInstance> list = runtime.createProcessInstanceQuery().list();
%>
<body>
<%if(message != null){out.write(JavascriptMessage.alert(message));}%>

<div class="rightSidebar">
  <!--�������ݿ�ʼ-->
  <div class="pageBody">
    <div class="inner_2">
      <!--��ϸҳ-->
      <div class="rightContent">
        <h3 class="bt"> <span class="tt"><b>ϵͳ����</b></span>
          <!--����-->
          <div class="search">������
            <label>
              <input type="text" name="textfield" id="textfield" />
            </label>
			<input type="button" onclick="window.location.href='#'" value="��ѯ" class="searchBtn">
          </div>
          <!--��������-->
        </h3>
        <!--���ܰ�ť-->
        <div class="btnBox">
          <div class="tou">
            <div class="bt2">��������</div>
            <!--  
            <div class="cz_btn">
              <input type="button" class="ButtonCss" value="�������ڹ���" onclick="window.location.href='wq_add.htm'">
              <input type="button" class="ButtonCss" value="ɾ��" onclick="window.location.href='wq_add.htm'">
            </div>-->
          </div>
        </div>
        <!--���ܰ�ť����-->
        <div class="content">
          <!--���-->
          <table border="0" cellpadding="0" cellspacing="0"  class="tableBD">
            <tbody>
              <tr class="btTR">
                <td width="4%" align="center"><input name="input2" type="checkbox" value="" /></td>
                <!--  
                <td ><div class="biaoti">Id</div></td>
                <td ><div class="biaoti">BusinessKey</div></td>-->
                <td width="30%"><div class="biaoti">��������</div></td>
                <td ><div class="biaoti">ProcessInstanceId</div></td>
                <td width="25%"><div class="biaoti">��ʼʱ��</div></td>
                <td width="25%"><div class="biaoti">����ʱ��</div></td>
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
						<a href="<%=request.getContextPath() %>/jsp/processInstance.jsp?processInstanceId=<%=d.getId() %>&doWhat=delete"/>ɾ��</a>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="4">
						<%
						List<Task> taskList = taskService.createTaskQuery().processInstanceId(d.getId()).list();
						for(Task t : taskList){
							out.write("�������ڡ�"+ t.getName()  +"�����ڣ�");
							if(t.getAssignee() == null)
								out.write("�����˴�������");
							else
								out.write("��" + t.getAssignee() + "��������");
							out.write("</br>");
						}
						
						Execution execution = runtime.createExecutionQuery()
							.processInstanceId(d.getProcessInstanceId())
							.activityId("receivetask1")
							.singleResult();
						
						if(execution != null){
							out.write("�������ڡ�" + execution.getId() + "���ȴ�</br>");
						}
						%>
					</td>
					<td>
					<%if(execution != null){%>
						<a href="<%=request.getContextPath() %>/jsp/processInstance.jsp?doWhat=signal&executionId=<%=execution.getId() %>"/>����ȴ�</a>
					<%} %>
					</td>
				</tr>
			<%} %>
			</tbody>
          </table>
          <!--������-->
        </div>
      </div>
      <!--������Դ�������-->
    </div>
  </div>
  <!--�������ݽ���-->
</div>
</body>
</html>