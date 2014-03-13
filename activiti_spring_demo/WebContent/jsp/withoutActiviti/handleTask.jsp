<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ page import="java.util.*" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
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

%>
<body>

	<form action="<%=request.getContextPath() %>/jsp/startProcess.jsp?doWhat=startWithForm" method="post">
		<!--input type="hidden" name="startor" value="<%=user.getId() %>"/-->
		<table align="center" width="60%">
			<caption>处理会议室申请</caption>
			<tr>
				<th scope="col" width="50%">开会时间：</th>
				<td class="row"><input type="text" name="time"/></td>
			</tr>
			<tr>
				<th scope="col" width="50%">会议室：</th>
				<td class="row"><input type="text" name="room"/></td>
			</tr>
			<tr>
				<th scope="col" width="50%">会议主题：</th>
				<td class="row"><input type="text" name="title"/></td>
			</tr>
			<tr>
				<th scope="col" width="50%">处理：</th>
				<td class="row">
					<input type="button" value="登记会议室" />
				</td>
			</tr>
			<tr><td colspan="2" align="right"><input type="submit" value="结束"/></td></tr>
		</table>
	</form>
</body>
</html>