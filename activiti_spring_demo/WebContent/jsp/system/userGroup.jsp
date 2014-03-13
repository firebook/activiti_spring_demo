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

List<Group> groupList = identityService.createGroupQuery().orderByGroupId().asc().list();
%>
<body>
<%if(message != null){out.write(JavascriptMessage.alert(message));}%>
<div class="content">
  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
    <tbody>
      <tr>
        <td width="200" valign="top" >
          <!--��Ŀ��-->
          <div style="height:13px;"></div>
          <ul id="treeMenu" class="treeNav">
            <li>
              <label><a href="javascript:;">�û�����</a></label>
              <ul class="two">
               <%if(groupList != null)for(int i = 0; i < groupList.size(); i++){ Group g = groupList.get(i);%>
         	    <li <%if(i == groupList.size()-1)out.write("class='end'");%> >
                   <label><a href="<%=request.getContextPath() %>/jsp/system/user.jsp?doWhat=userByGroup&groupId=<%=g.getId() %>" target="userFrame"><%=g.getName() %></a></label>
                 </li>
         	  <%} %>
              </ul>
            </li>
          </ul>
          <!--��Ŀ������-->
        </td>
        <td valign="top">
        	<iframe name="userFrame" scrolling="none" frameborder="0" align="center,center" 
        		src="<%=request.getContextPath() %>/jsp/system/user.jsp" 
        		width="100%" height="420">
        	</iframe>
        </td>
      </tr>
    </tbody>
  </table>
</div>
<script type="text/javascript" >
 function addEvent(el,name,fn){//���¼�
  if(el.addEventListener) return el.addEventListener(name,fn,false);
  return el.attachEvent('on'+name,fn);
 }
 function nextnode(node){//Ѱ����һ���ֵܲ��޳��յ��ı��ڵ�
  if(!node)return ;
  if(node.nodeType == 1)
   return node;
  if(node.nextSibling)
   return nextnode(node.nextSibling);
 }
 function prevnode(node){//Ѱ����һ���ֵܲ��޳��յ��ı��ڵ�
  if(!node)return ;
  if(node.nodeType == 1)
   return node;
  if(node.previousSibling)
   return prevnode(node.previousSibling);
 }
 function parcheck(self,checked){//�ݹ�Ѱ�Ҹ���Ԫ�أ����ҵ�inputԪ�ؽ��в���
  var par =  prevnode(self.parentNode.parentNode.parentNode.previousSibling),parspar;
  if(par&&par.getElementsByTagName('input')[0]){
   par.getElementsByTagName('input')[0].checked = checked;
   parcheck(par.getElementsByTagName('input')[0],sibcheck(par.getElementsByTagName('input')[0]));
  }
 }
 function sibcheck(self){//�ж��ֵܽڵ��Ƿ��Ѿ�ȫ��ѡ��
  var sbi = self.parentNode.parentNode.parentNode.childNodes,n=0;
  for(var i=0;i<sbi.length;i++){
   if(sbi[i].nodeType != 1)//���ں��ӽ���а����յ��ı��ڵ㣬���������ۼƳ��ȵ�ʱ��ҲҪ����ȥ
    n++;
   else if(sbi[i].getElementsByTagName('input')[0].checked)
    n++;
  }
  return n==sbi.length?true:false;
 }
 addEvent(document.getElementById('treeMenu'),'click',function(e){//��input����¼���ʹ��treeMenu��Ԫ�ش���
  e = e||window.event;
  var target = e.target||e.srcElement;
  var tp = nextnode(target.parentNode.nextSibling);
  switch(target.nodeName){
   case 'A'://���A��ǩչ������������Ŀ¼�����ı�����ʽ��ѡ��checkbox
    if(tp&&tp.nodeName == 'UL'){
     if(tp.style.display != 'block' ){
      tp.style.display = 'block';
      prevnode(target.parentNode.previousSibling).className = 'ren'
     }else{
      tp.style.display = 'none';
      prevnode(target.parentNode.previousSibling).className = 'add'
     }
    }
    break;
   case 'SPAN'://���ͼ��ֻչ����������
    var ap = nextnode(nextnode(target.nextSibling).nextSibling);
    if(ap.style.display != 'block' ){
     ap.style.display = 'block';
     target.className = 'ren'
    }else{
     ap.style.display = 'none';
     target.className = 'add'
    }
    break;
   case 'INPUT'://���checkbox������Ԫ��ѡ�У����ӽڵ��е�checkboxҲͬʱѡ�У����ӽ��ȡ����Ԫ����֮ȡ��
    if(target.checked){
     if(tp){
      var checkbox = tp.getElementsByTagName('input');
      for(var i=0;i<checkbox.length;i++)
       checkbox[i].checked = true;
     }
    }else{
     if(tp){
      var checkbox = tp.getElementsByTagName('input');
      for(var i=0;i<checkbox.length;i++)
       checkbox[i].checked = false;
     }
    }
    parcheck(target,sibcheck(target));//�����ӽ��ȡ��ѡ�е�ʱ����ø÷����ݹ��丸�ڵ��checkbox��һȡ��ѡ��
    break;
  }
 });
 window.onload = function(){//ҳ�����ʱ���к��ӽ���Ԫ�ض�̬���ͼ��
  var labels = document.getElementById('treeMenu').getElementsByTagName('label');
  for(var i=0;i<labels.length;i++){
   var span = document.createElement('span');
   span.style.cssText ='display:inline-block;height:18px;vertical-align:middle;width:16px;cursor:pointer;';
   span.innerHTML = ' '
   span.className = 'ren';
   if(nextnode(labels[i].nextSibling)&&nextnode(labels[i].nextSibling).nodeName == 'UL')
    {
		nextnode(labels[i].nextSibling).style.cssText='display:block';		
		labels[i].parentNode.insertBefore(span,labels[i]);
		}
   else
   {
    labels[i].className = 'rem'
  	}
  }
 }
</script>
</body>
</html>
