<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ page import="java.util.*" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.activiti.engine.ProcessEngine" %>
<%@ page import="org.activiti.engine.RepositoryService" %>
<%@ page import="org.activiti.engine.RuntimeService" %>
<%@ page import="org.activiti.engine.FormService" %>
<%@ page import="org.activiti.engine.IdentityService" %>
<%@ page import="org.activiti.engine.repository.ProcessDefinition" %> 
<%@ page import="org.activiti.engine.form.StartFormData" %>
<%@ page import="org.activiti.engine.form.FormProperty" %>
<%@ page import="org.activiti.engine.identity.User" %>
<%@ page import="com.JavascriptMessage" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link type="text/css" rel="stylesheet" charset="utf-8" href="<%=request.getContextPath() %>/css/base.css"/>
<title>start Process Instance</title>
</head>
<%
request.setCharacterEncoding("GBK");
User user = (User)session.getAttribute("user");

WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
RepositoryService repository = (RepositoryService)context.getBean("repositoryService");
RuntimeService runtime = (RuntimeService)context.getBean("runtimeService");
FormService formService = (FormService)context.getBean("formService");
IdentityService identityService = (IdentityService)context.getBean("identityService");

List<FormProperty> formProperties = null;
StartFormData formData = null;
%>
<body>
<% 
boolean startSuccess = false;
String doWhat = request.getParameter("doWhat");

if(doWhat != null && doWhat.equals("startWithForm")){
	formData = formService.getStartFormData(request.getParameter("processDefinitionId"));
	formProperties = formData.getFormProperties();
	if(formProperties != null && formProperties.size() != 0){
		//获取流程表单
		Map<String, Object> formMap = new HashMap<String, Object>();
		for(FormProperty f : formProperties){
			formMap.put(f.getId(), request.getParameter(f.getId()));
		}
		//设置流程申请人ID
		identityService.setAuthenticatedUserId(user.getId());
		//启动流程
		runtime.startProcessInstanceById(request.getParameter("processDefinitionId"), formMap);
		startSuccess = true;
	}
} else if(doWhat != null && doWhat.equals("start")){
	formData = formService.getStartFormData(request.getParameter("processDefinitionId"));
	formProperties = formData.getFormProperties();
	if(formProperties == null || formProperties.size() == 0){
		Map<String, Object> map = new HashMap<String, Object>();
		//map.put("startor", user.getId());
		identityService.setAuthenticatedUserId(user.getId());
		runtime.startProcessInstanceById(request.getParameter("processDefinitionId"), map);
		startSuccess = true;
	}else{
%>
	<form action="<%=request.getContextPath() %>/jsp/startProcess.jsp?doWhat=startWithForm" method="post">
		<input type="hidden" name="processDefinitionId" value="<%=request.getParameter("processDefinitionId") %>"/>
		<!--input type="hidden" name="startor" value="<%=user.getId() %>"/-->
		<table align="center" width="60%">
			<%for(FormProperty f : formProperties){ %>
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
					<input type="text" name="<%=f.getId() %>" value=""/>
					<%} %>
				</td>
			</tr>
			<%}%>
			<tr><td colspan="2" align="right"><input type="submit" value="发送"/></td></tr>
		</table>
	</form>
	<%} %>
<%
} 
if(startSuccess){
	out.write(JavascriptMessage.alert("成功启动流程..."));%>
	<script type="text/javascript">
	window.location.href = "<%=request.getContextPath() %>/jsp/processDefinition.jsp";
	</script>
<%} %>
</body>
</html>