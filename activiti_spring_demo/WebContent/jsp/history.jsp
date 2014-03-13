<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ page import="java.util.*" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.activiti.engine.ProcessEngine" %>
<%@ page import="org.activiti.engine.RepositoryService" %>
<%@ page import="org.activiti.engine.RuntimeService" %>
<%@ page import="org.activiti.engine.HistoryService" %>
<%@ page import="org.activiti.engine.runtime.ProcessInstance" %> 
<%@ page import="org.activiti.engine.history.HistoricProcessInstance" %>
<%@ page import="org.activiti.engine.history.HistoricTaskInstance" %>
<%@ page import="org.activiti.engine.identity.User" %>
<%@ page import="com.DateUtil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link href="<%=request.getContextPath() %>/styles/common.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath() %>/styles/main.css" rel="stylesheet" type="text/css" />
<title>history</title>
</head>
<%
User user = (User)session.getAttribute("user");

WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
//ProcessEngine engine = (ProcessEngine)context.getBean("processEngine");
RepositoryService repository = (RepositoryService)context.getBean("repositoryService");
RuntimeService runtime = (RuntimeService)context.getBean("runtimeService");
HistoryService historyService = (HistoryService)context.getBean("historyService");

List<HistoricProcessInstance> list = historyService.createHistoricProcessInstanceQuery().startedBy(user.getId()).list();

int i = 0;
%>
<body>
<div class="rightSidebar">
  <!--�������ݿ�ʼ-->
  <div class="pageBody">
    <div class="inner_2">
      <!--��ϸҳ-->
      <div class="rightContent">
        <h3 class="bt"> <span class="tt"><b>���̹���</b></span>
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
            <div class="bt2">����������������</div>
            <!--  
            <div class="cz_btn">
              <input type="button" class="ButtonCss" value="�������ڹ���" onclick="window.location.href='wq_add.htm'">
              <input type="button" class="ButtonCss" value="ɾ��" onclick="window.location.href='wq_add.htm'">
            </div>-->
          </div>
        </div>
        <!--���ܰ�ť����-->
        <div class="content">
          <!--���-->
          <table border="0" cellpadding="0" cellspacing="0"  class="tableBD">
            <tbody>
              <tr class="btTR">
                <td width="4%" align="center"><input name="input2" type="checkbox" value="" /></td>
                <td ><div class="biaoti">��������</div></td>
                <td ><div class="biaoti">StartTime</div></td>
                <td ><div class="biaoti">EndTime</div></td>
                <td></td>
              </tr>
            <%for(HistoricProcessInstance d : list){%>
				<tr>
					<td align="center"><input name="input2" type="checkbox" value="" /></td>
					<td ><%=repository.createProcessDefinitionQuery().processDefinitionId(d.getProcessDefinitionId()).singleResult().getName() %></td>
					<td ><%=DateUtil.format(d.getStartTime(), "yyyy-MM-dd HH:mm") %></td>
					<td ><%=DateUtil.format(d.getEndTime(), "yyyy-MM-dd HH:mm") %></td>
					<td ></td>
				</tr>
				<!--  
				<tr>
					<td class="row" colspan="5">
					<%/*
					List<HistoricTaskInstance> taskList = historyService.createHistoricTaskInstanceQuery().processInstanceId(d.getId()).list();
					for(HistoricTaskInstance h : taskList){
						out.write(h.getName()+"</br>");
					}*/
					%>
					</td>
				<tr>-->
			<%} %>
            </tbody>
          </table>
          <!--������-->
        </div>
        <!--��ҳ-->
        <!--  
        <div class="pagination">
          <div id="ContentPlaceHolder_Contents_pager"> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','1')" class="btn"><img src="images/btn_home.gif" align="absmiddle"/>�� ҳ</a> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','1')" class="btn"><img src="images/btn_prive.gif" align="absmiddle"/>��һҳ</a> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','1')" >1</a> <span class="currentpage">2</span> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','3')" >3</a> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','3')" class="btn">��һҳ<img src="images/btn_next.gif" align="absmiddle"/></a> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','3')" class="btn">β ҳ<img src="images/btn_end.gif" align="absmiddle"/></a> </div>
        </div>-->
        <!--��ҳ����-->
      </div>
      <!--������Դ�������-->
    </div>
  </div>
  <!--�������ݽ���-->
</div>
</body>
</html>