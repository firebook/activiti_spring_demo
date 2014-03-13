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
String message = null;

WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
IdentityService identityService = (IdentityService)context.getBean("identityService");

if(doWhat.equals("del")){
	String delIds = request.getParameter("delIds");
	String[] ids = delIds.split(",");
	for(String id : ids){
		List<User> users = identityService.createUserQuery().memberOfGroup(id).list();
		for(User u : users){
			List<Group> groups = identityService.createGroupQuery().groupMember(u.getId()).list();
			for(Group g : groups){
				identityService.deleteMembership(u.getId(), g.getId());
			}
			identityService.deleteUser(u.getId());
		}
		identityService.deleteGroup(id);
	}
	message = "ɾ���ɹ�������";
}
	
List<Group> list = identityService.createGroupQuery().orderByGroupId().asc().list();
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
            <div class="bt2">�������</div>
            <div class="cz_btn">
              <input type="button" class="ButtonCss" value="���" onclick="window.location.href='<%=request.getContextPath() %>/jsp/system/addGroup.jsp'">
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
                <td></td>
              </tr>
            <%for(Group d : list){%>
				<tr>
					<td align="center"><input name="checkBox" type="checkbox" value="<%=d.getId() %>" /></td>
					<td ><a href="<%=request.getContextPath() %>/jsp/system/user.jsp?doWhat=userByGroup&groupId=<%=d.getId() %>"><%=d.getId() %></a></td>
					<td ><%=d.getName() %></td>
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
<script type="text/javascript">
function del(){
	var checkBoxs = document.getElementsByName("checkBox");
	var delIds = '';
	for(var i = 0; i < checkBoxs.length; i++){
		var c = checkBoxs[i];
		if(c.checked)
			delIds += c.value + ',';
	}
	if(delIds != ''){
		if(confirm("ɾ�����飬�����µ��û�Ҳ����ɾ����ȷ����")){
			delIds = delIds.substring(0, delIds.length - 1);
			window.location.href = '<%=request.getContextPath() %>/jsp/system/group.jsp?doWhat=del&delIds=' + delIds;
		}else{
			return;	
		}
	}else{
		alert('��ѡ����顣����');
		return;
	}
}
</script>
</body>
</html>