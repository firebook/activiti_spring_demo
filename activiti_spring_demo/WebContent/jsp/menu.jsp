<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link href="<%=request.getContextPath() %>/styles/common.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath() %>/styles/topLeft.css" rel="stylesheet" type="text/css" />
<title>menu</title>
</head>
<body>
<!--���˵�-->
<div class="leftSidebar">
  <div class="navBg">
    <ul id="menu_left_ucsmy" class="leftNav">      
      <li>
        <label class="yj"><a href="javascript:;">����ϵͳ�ķ�ʽ</a></label>
        <ul class="two">
          <li> <a href="<%=request.getContextPath() %>/jsp/withoutActiviti/startProcess.jsp" target="showframe" class="NOMe"><span>���������</span></a> </li>
          <li class="end"> <a href="<%=request.getContextPath() %>/jsp/withoutActiviti/handleTask.jsp" target="showframe" class="NOMe"><span>�������������</span></a> </li>
        </ul>
      </li>
      <li>
        <label class="yj"><a href="javascript:;">���̹���</a></label>
        <ul class="two">
          <li > <a href="<%=request.getContextPath() %>/jsp/myTask.jsp" target="showframe" class="NOMe"><span>�ҵ�����</span></a> </li>
          <li class="end"> <a href="<%=request.getContextPath() %>/jsp/myProcessInstance.jsp" target="showframe" class="NOMe"><span>������������</span></a> </li>
          <!--  
          <li class="end"> <a href="<%=request.getContextPath() %>/jsp/history.jsp" target="showframe" class="NOMe"><span>����������������</span></a> </li>
          -->
        </ul>
      </li>
      <li>
        <label class="yj"><a href="javascript:;">ϵͳ����</a></label>
        <ul class="two">
          <li> <a href="<%=request.getContextPath() %>/jsp/system/userGroup.jsp" target="showframe" class="NOMe"><span>�û�����</span></a> </li>
          <li> <a href="<%=request.getContextPath() %>/jsp/system/group.jsp" target="showframe" class="NOMe"><span>�������</span></a> </li>
          <li> <a href="<%=request.getContextPath() %>/jsp/processInstance.jsp" target="showframe" class="NOMe"><span>����ʵ��</span></a> </li>
          <li> <a href="<%=request.getContextPath() %>/jsp/processDefinition.jsp" target="showframe" class="NOMe"><span>���̶���</span></a> </li>
          <li class="end"> <a href="<%=request.getContextPath() %>/jsp/deployment.jsp" target="showframe" class="NOMe"><span>���̲���</span></a> </li>
        </ul>
      </li>
    </ul>
  </div>
  </div>
<script type="text/javascript" language="javascript" >
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
 addEvent(document.getElementById('menu_left_ucsmy'),'click',function(e){//��input����¼���ʹ��menu_left_ucsmy��Ԫ�ش���
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
  var labels = document.getElementById('menu_left_ucsmy').getElementsByTagName('label');
  for(var i=0;i<labels.length;i++){
   var span = document.createElement('span');
   span.style.cssText ='display:inline-block;vertical-align:middle;cursor:pointer;';
   span.innerHTML = ' '
   span.className = 'add';
   if(nextnode(labels[i].nextSibling)&&nextnode(labels[i].nextSibling).nodeName == 'UL')
    {
		labels[i].parentNode.insertBefore(span,labels[i]);
		}
   else
   {
    labels[i].className = 'rem'
  	}
  }
 }
</script>
<script>
var lastMenu;

document.body.onclick = function(evt){
	evt=evt || window.event;
	var srcElements=(evt.srcElement?evt.srcElement:evt.target);
	var PsrcElements=(srcElements.parentElement?srcElements.parentElement:srcElements.parentNode);

	if(PsrcElements.className == "NOMe"){
		if(lastMenu!=null) lastMenu.className="NOMe";
		PsrcElements.className="isMe";
		lastMenu=PsrcElements;
    }
}
</script>
<!--���˵�����-->
</body>
</html>
