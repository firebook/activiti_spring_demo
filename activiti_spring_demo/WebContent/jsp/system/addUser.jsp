<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ page import="java.util.*" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.activiti.engine.ProcessEngine" %>
<%@ page import="org.activiti.engine.RepositoryService" %>
<%@ page import="org.activiti.engine.identity.User" %>
<%@ page import="org.activiti.engine.repository.Deployment" %>
<%@ page import="org.activiti.engine.IdentityService" %>
<%@ page import="org.activiti.engine.identity.User" %>
<%@ page import="org.activiti.engine.identity.Group" %>
<%@ page import="com.JavascriptMessage" %>
<%@ page import="com.DateUtil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link href="<%=request.getContextPath() %>/styles/common.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath() %>/styles/main.css" rel="stylesheet" type="text/css" />
<title>Deployment</title>
</head>
<%
request.setCharacterEncoding("GBK");
User user = (User)session.getAttribute("user");
String doWhat = request.getParameter("doWhat") == null ? "" : request.getParameter("doWhat");
String groupId = request.getParameter("groupId");
String message = null;

WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
IdentityService identityService = (IdentityService)context.getBean("identityService");
List<Group> groupList = identityService.createGroupQuery().orderByGroupId().asc().list();
if(doWhat.equals("add")){
	User u = identityService.newUser(request.getParameter("userId"));
	u.setFirstName(request.getParameter("userName"));
	u.setPassword(request.getParameter("password"));
	identityService.saveUser(u);
	identityService.createMembership(request.getParameter("userId"), groupId);
	message = "����ɹ�������";
}

%>
<body>
<%if(message != null){out.write(JavascriptMessage.alert(message));}%>
<%if(message != null){ %>
	<script type="text/javascript">
	window.location.href="<%=request.getContextPath() %>/jsp/system/user.jsp?doWhat=userByGroup&groupId=<%=groupId %>";
	</script>
<%} %>
<form action="<%=request.getContextPath() %>/jsp/system/addUser.jsp?doWhat=add" method="post"/>
<div class="rightSidebar">
  <!--�������ݿ�ʼ-->
  <div class="pageBody">
    <div class="inner_2">
      <!--��ϸҳ-->
      <div class="rightContent">
        <h3 class="bt"> <span class="tt"><b>ϵͳ����</b></span>
          <!--����-->
          <div class="search"><a href="#" class="back"><< ����</a></div>
          <!--��������-->
        </h3>
        <div class="nk">
          <!--���-->
          <div class="wj_search_box">
          <h3 class="wj_search">�û���Ϣ</h3>
          <div class="LM">
          <table border="0" align="center" cellpadding="0" cellspacing="0"  class="table_4" >
            <tbody>
              <tr>
                <th align="right">Id��</th>
                <td>
					<input name="userId" type="text" class="input_2" size="30" />
                </td>
              </tr>
              <tr>
                <th align="right">Name��</th>
                <td>
					<input name="userName" type="text" class="input_2" size="30" />
                </td>
              </tr>
              <tr>
              <th align="right">Password��</th>
                <td>
					<input name="password" type="text" class="input_2" size="30" />
                </td>
              </tr>
              <th align="right">���飺</th>
			  <td>
				  <select id="groupId" name="groupId">
	                <option value="">ѡ����顭��</option>
	                <%for(Group g : groupList){ %>
	                	<option value="<%=g.getId() %>"><%=g.getId() %></option>
	                <%} %>
	              </select>
		          <script type="text/javascript">
	              document.getElementById('groupId').value = '<%=groupId %>';
	              </script>
			  </td>
            </tbody>
          </table>
          
          </div>
          </div>
          <!--������-->
		  <!--�ύ��ť-->
          <div class="submit_btn">
               <input type="submit" value="�ύ" class="btn">
               <input type="reset" value="����" class="btn">
      	  </div>
          <!--�ύ��ť����-->
        </div>
      </div>
      <!--������Դ�������-->
    </div>
  </div>
  <!--�������ݽ���-->
</div>
</form>
</body>
</html>



