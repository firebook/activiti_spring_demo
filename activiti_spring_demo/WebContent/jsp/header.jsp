<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ page import="java.util.*" %>
<%@ page import="org.activiti.engine.identity.User" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link href="<%=request.getContextPath() %>/styles/common.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath() %>/styles/topLeft.css" rel="stylesheet" type="text/css" />
<!--[if IE 6]>
<script src="JavaScripts/DD_belatedPNG_0.0.8a.js" mce_src="JavaScripts/DD_belatedPNG_0.0.8a.js"></script>
<script type="text/javascript">     /* EXAMPLE */   DD_belatedPNG.fix('.exit .btn1,.exit .btn2');   /* 将 .png_bg 改成你应用了透明PNG的CSS选择器,例如我例子中的'.trans'*/   </script> 
<![endif]-->
<title>header</title>
</head>
<%
User user = (User)session.getAttribute("user");
%>
<body>
<div class="top">
  <div class="logo"></div>
  <!-- <div class="logo"><img src="<%=request.getContextPath() %>/images/logo.jpg" /></div>-->
  <div class="topMenu">
    <ul>
      <li><a href="main.htm"><span>Activiti</span></a></li>
    </ul>
  </div>
  <div class="topBotton"></div>
  <div class="topInfo"> <span><%=user.getFirstName() %>，欢迎您！</span></div>
  <div class="exit"> 
  <!--  <a href="#" class="btn3" title="下载帮助文档"></a>-->
  <a href="#" class="btn1" title="更改用户" onclick="javascript:window.parent.location.href='<%=request.getContextPath() %>/jsp/login.jsp'"></a>
  <a href="#" class="btn2" title="退出" onclick="javascript:window.parent.location.href='<%=request.getContextPath() %>/jsp/login.jsp?doWhat=logout'"></a>
  </div>
</div>
<div class="topLine"></div>
</body>
</html>
