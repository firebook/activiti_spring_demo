<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ page import="java.util.*" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.activiti.engine.ProcessEngine" %>
<%@ page import="org.activiti.engine.RuntimeService" %>
<%@ page import="org.activiti.engine.FormService" %>
<%@ page import="org.activiti.engine.TaskService" %>
<%@ page import="org.activiti.engine.form.TaskFormData" %>
<%@ page import="org.activiti.engine.form.StartFormData" %>
<%@ page import="org.activiti.engine.form.FormProperty" %>
<%@ page import="org.activiti.engine.identity.User" %>
<%@ page import="org.activiti.engine.task.Task" %>
<%@ page import="com.JavascriptMessage" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link type="text/css" rel="stylesheet" charset="utf-8" href="<%=request.getContextPath() %>/css/base.css"/>
<title>handle task</title>
</head>
<%
request.setCharacterEncoding("GBK");
User user = (User)session.getAttribute("user");
String taskId = request.getParameter("taskId");

WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
RuntimeService runtimeService = (RuntimeService)context.getBean("runtimeService");
FormService formService = (FormService)context.getBean("formService");
TaskService taskService = (TaskService)context.getBean("taskService");

Task task = taskService.createTaskQuery().taskId(taskId).singleResult();

List<FormProperty> formProperties = null;
TaskFormData formData = null;

formProperties = formService.getStartFormData(task.getProcessDefinitionId()).getFormProperties();
%>
<body>
<table align="center" width="60%">
	<%for(FormProperty f : formProperties){%>
	<tr>
		<th scope="col" width="50%"><%=f.getName() %></th>
		<td class="row">
			<%=runtimeService.getVariable(task.getProcessInstanceId(), f.getId()) %>
		</td>
	</tr>
	<%}%>
</table>

<% 
String message = null;
String doWhat = request.getParameter("doWhat");

if(doWhat != null && doWhat.equals("handleWithForm")){
	formData = formService.getTaskFormData(taskId);
	formProperties = formData.getFormProperties();
	if(formProperties != null && formProperties.size() != 0){
		//设置流程表单
		Map<String, Object> formMap = new HashMap<String, Object>();
		for(FormProperty f : formProperties){
			formMap.put(f.getId(), request.getParameter(f.getId()));
		}
		//完成任务
		taskService.complete(taskId, formMap);
		message = "task is completed...";
	}else{
		taskService.complete(taskId);
		message = "task is completed...";
	}
}else if(doWhat != null && doWhat.equals("handle")){
	formData = formService.getTaskFormData(taskId);
	formProperties = formData.getFormProperties();
	//if(formProperties == null || formProperties.size() == 0){
		//taskService.complete(taskId);
		//message = "task is completed...";
	//}else{
%>
	<form action="<%=request.getContextPath() %>/jsp/handleTask.jsp?doWhat=handleWithForm" method="post">
		<input type="hidden" name="taskId" value="<%=taskId %>"/>
		<table align="center" width="60%">
			<%for(FormProperty f : formProperties){%>
			<tr>
				<th scope="col" width="50%"><%=f.getName() %></th>
				<td class="row">
					<%if(f.getType().getName().equals("enum")){
						Map<String, String> map = (Map<String, String>)f.getType().getInformation("values");
					%>
					<select name="<%=f.getId() %>">
						<%for(String key : map.keySet()){ %>
						<option value="<%=key %>"><%=map.get(key) %></option>
						<%} %>
					</select>
					<%}else{ %>
					<input type="text" name="<%=f.getId() %>" value="<%=f.getValue()==null?"":f.getValue() %>"/>
					<%} %>
				</td>
			</tr>
			<%}%>
			<tr><td colspan="2" align="right"><input type="submit" value="提交"/></td></tr>
		</table>
	</form>
	<%//} %>
<%
} 
if(message != null){
	out.write(JavascriptMessage.alert(message));%>
	<script type="text/javascript">
	window.location.href = "<%=request.getContextPath() %>/jsp/myTask.jsp";
	</script>
<%} %>
</body>
</html>