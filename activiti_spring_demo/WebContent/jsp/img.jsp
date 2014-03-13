<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>流程图</title>
<%
String processInstanceId = request.getParameter("processInstanceId");
String doWhat = request.getParameter("doWhat");
String processDefinitionId = request.getParameter("processDefinitionId");
%>
</head>

<body>
<img alt="" src="<%=request.getContextPath() %>/img?processDefinitionId=<%=processDefinitionId %>&processInstanceId=<%=processInstanceId %>&doWhat=<%=doWhat %>&time=<%=new Date() %>">
</body>
</html>