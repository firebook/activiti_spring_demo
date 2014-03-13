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
User user = (User)session.getAttribute("user");
String doWhat = request.getParameter("doWhat") == null ? "" : request.getParameter("doWhat");
String groupId = request.getParameter("groupId") == null ? "" : request.getParameter("groupId");
String message = null;

WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
IdentityService identityService = (IdentityService)context.getBean("identityService");
List<User> list = null;
List<Group> groupList = identityService.createGroupQuery().orderByGroupId().asc().list();
if(doWhat.equals("userByGroup")){
	list = identityService.createUserQuery().memberOfGroup(groupId).orderByUserId().asc().list();
}else if(doWhat.equals("del")){
	String delIds = request.getParameter("delIds");
	String[] ids = delIds.split(",");
	for(String id : ids){
		List<Group> groups = identityService.createGroupQuery().groupMember(id).list();
		for(Group g : groups){
			identityService.deleteMembership(id, g.getId());
		}
		identityService.deleteUser(id);
	}
	message = "ɾ���ɹ�������";
	if(!groupId.equals(""))
		list = identityService.createUserQuery().memberOfGroup(groupId).orderByUserId().asc().list();
	else
		list = identityService.createUserQuery().orderByUserId().asc().list();
}else{
	list = identityService.createUserQuery().orderByUserId().asc().list();
}
%>
<body>
<%if(message != null){out.write(JavascriptMessage.alert(message));}%>
<form method="post"/>
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
            <div class="bt2">�û�����&nbsp;&nbsp;
              <select id="groupId" name="groupId" onchange="groupIdOnChange();">
                <option value="">ѡ����顭��</option>
                <%for(Group g : groupList){ %>
                	<option value="<%=g.getId() %>"><%=g.getId() %></option>
                <%} %>
              </select>
              <script type="text/javascript">
              	document.getElementById('groupId').value = '<%=groupId %>';
              </script>
            </div>
            <div class="cz_btn">
              <input type="button" class="ButtonCss" value="���" onclick="window.location.href='<%=request.getContextPath() %>/jsp/system/addUser.jsp?groupId=<%=groupId %>'">
              <input type="button" class="ButtonCss" value="ɾ��" onclick="del();">
            </div>
          </div>
        </div>
        <!--���ܰ�ť����-->
        <div class="content">
          <!--���-->
          <table border="0" cellpadding="0" cellspacing="0"  class="tableBD">
            <tbody>
              <tr class="btTR">
                <td width="4%" align="center"><input name="input2" type="checkbox" value="" /></td>
                <td ><div class="biaoti">Id</div></td>
                <td ><div class="biaoti">Name</div></td>
                <td ><div class="biaoti">Password</div></td>
                <td></td>
              </tr>
            <%for(User d : list){%>
				<tr>
					<td align="center"><input name="checkBox" type="checkbox" value="<%=d.getId() %>" /></td>
					<td ><%=d.getId() %></td>
					<td ><%=d.getFirstName() %></td>
					<td ><%=d.getPassword() %></td>
					<td></td>
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
</form>
<script type="text/javascript">
function groupIdOnChange(){
	var groupId = document.getElementById('groupId').value;
	if(groupId != '')
		window.location.href='<%=request.getContextPath() %>/jsp/system/user.jsp?doWhat=userByGroup&groupId='+groupId;
	else
		window.location.href='<%=request.getContextPath() %>/jsp/system/user.jsp';
}

function del(){
	var checkBoxs = document.getElementsByName("checkBox");
	var delIds = '';
	for(var i = 0; i < checkBoxs.length; i++){
		var c = checkBoxs[i];
		if(c.checked)
			delIds += c.value + ',';
	}
	if(delIds != ''){
		delIds = delIds.substring(0, delIds.length - 1);
		window.location.href = '<%=request.getContextPath() %>/jsp/system/user.jsp?doWhat=del&groupId=<%=groupId %>&delIds=' + delIds;
	}else{
		alert('��ѡ���û�������');
		return;
	}
}
</script>
</body>
</html>


