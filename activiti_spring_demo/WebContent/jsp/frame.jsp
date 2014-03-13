<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>Activiti Demo</title>
</head>
<%if(session.getAttribute("user") == null){%>
<script type="text/javascript">
alert("您尚未登录或者登录时间过期，请登录。。。");
window.location.href='<%=request.getContextPath() %>/jsp/login.jsp';
</script>
<%
}else{
%>
<frameset rows="132,*"  frameborder="no" framespacing="0">
  <frame src="<%=request.getContextPath() %>/jsp/header.jsp" noresize="noresize" scrolling="no"  />
  <frameset cols="190,*" frameborder="no">
    <frame src="<%=request.getContextPath() %>/jsp/menu.jsp" noresize="noresize" scrolling="no" />
    <frame src="<%=request.getContextPath() %>/jsp/myTask.jsp" noresize="noresize" name="showframe"  scrolling="yes"/>
  </frameset>
</frameset><noframes></noframes>
<%} %>
</html>
