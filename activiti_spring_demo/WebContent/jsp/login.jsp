<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ page import="java.util.*" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.activiti.engine.ProcessEngine" %>
<%@ page import="org.activiti.engine.IdentityService" %>
<%@ page import="org.activiti.engine.identity.User" %>
<%@ page import="org.activiti.engine.identity.Group" %>
<%@ page import="com.JavascriptMessage" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link type="text/css" rel="stylesheet" charset="utf-8" href="<%=request.getContextPath() %>/css/base.css"/>
<title>login</title>
</head>
<%
request.setCharacterEncoding("GBK");
String doWhat = request.getParameter("doWhat") == null ? "" : request.getParameter("doWhat");
if(doWhat.equals("logout")){
	session.setAttribute("user", null);
}
String userName = request.getParameter("userName");
String password = request.getParameter("password");
boolean success = false;
if(userName != null){
	WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
	IdentityService identityService = (IdentityService)context.getBean("identityService");
	User user = identityService.createUserQuery().userId(userName).singleResult();
	if(user != null && user.getPassword().equals(password)){
		success = true;
		session.setAttribute("user", user);
		List<Group> groups = identityService.createGroupQuery().groupMember(user.getId()).list();
		session.setAttribute("groups", groups);
		List<String> groupIds = null;
		for(Group g : groups){
			if(groupIds == null) groupIds = new ArrayList<String>();
			groupIds.add(g.getId());
		}
		session.setAttribute("groupIds", groupIds);
	}
}
if(success){
%>
<script type="text/javascript">
window.location.href="<%=request.getContextPath() %>/jsp/frame.jsp";
</script>
<%}else if(userName != null){ 
	out.write(JavascriptMessage.alert("用户名或密码错误！"));
}%>
<body>
<form action="<%=request.getContextPath() %>/jsp/login.jsp" method="post">
	<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
		<tr><td align="center" style="border-right: 0px; border-bottom: 0px; background: #E6EAE9; font-size:11px; padding: 0px 0px 0px 0px; color: #4f6b72;">
			<table>
				<tr>
					<th scope="col" align="right">userName:</th>
					<td class="row"><input type="text" name="userName"/></td>
				</tr>
				<tr>
					<th scope="col" align="right">password:</th>
					<td class="row"><input type="password" name="password"/></td>
				</tr>
				<tr>
					<td colspan="2" align="right" class="row">
						<input type="submit" value="login"/>
					</td>
				</tr>
			</table>
		</td></tr>
	</table>
</form>
</body>
</html>