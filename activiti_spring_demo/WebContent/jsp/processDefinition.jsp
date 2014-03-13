<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ page import="java.util.*" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.activiti.engine.ProcessEngine" %>
<%@ page import="org.activiti.engine.RepositoryService" %>
<%@ page import="org.activiti.engine.RuntimeService" %>
<%@ page import="org.activiti.engine.FormService" %>
<%@ page import="org.activiti.engine.repository.ProcessDefinition" %> 
<%@ page import="org.activiti.engine.form.StartFormData" %>
<%@ page import="org.activiti.engine.form.FormProperty" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link href="<%=request.getContextPath() %>/styles/common.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath() %>/styles/main.css" rel="stylesheet" type="text/css" />
<title>Process Definition</title>
</head>
<%
WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
//ProcessEngine engine = (ProcessEngine)context.getBean("processEngine");
RepositoryService repository = (RepositoryService)context.getBean("repositoryService");
RuntimeService runtime = (RuntimeService)context.getBean("runtimeService");
FormService form = (FormService)context.getBean("formService");

List<FormProperty> formProperties = null;
String doWhat = request.getParameter("doWhat");
if(doWhat != null && doWhat.equals("start")){
	StartFormData formData = form.getStartFormData(request.getParameter("processDefinitionId"));
	formProperties = formData.getFormProperties();
	//runtime.startProcessInstanceById(request.getParameter("processDefinitionId"));
}
//List<ProcessDefinition> list = repository.createProcessDefinitionQuery().list();
List<ProcessDefinition> list = repository.createProcessDefinitionQuery().latestVersion().list();
%>
<body>
<div class="rightSidebar">
  <!--主体内容开始-->
  <div class="pageBody">
    <div class="inner_2">
      <!--详细页-->
      <div class="rightContent">
        <h3 class="bt"> <span class="tt"><b>系统管理</b></span>
          <!--搜索-->
          <div class="search">搜索：
            <label>
              <input type="text" name="textfield" id="textfield" />
            </label>
			<input type="button" onclick="window.location.href='#'" value="查询" class="searchBtn">
          </div>
          <!--搜索结束-->
        </h3>
        <!--功能按钮-->
        <div class="btnBox">
          <div class="tou">
            <div class="bt2">流程定义</div>
            <!--  
            <div class="cz_btn">
              <input type="button" class="ButtonCss" value="发布外勤公告" onclick="window.location.href='wq_add.htm'">
              <input type="button" class="ButtonCss" value="删除" onclick="window.location.href='wq_add.htm'">
            </div>-->
          </div>
        </div>
        <!--功能按钮结束-->
        <div class="content">
          <!--表格-->
          <table border="0" cellpadding="0" cellspacing="0"  class="tableBD">
            <tbody>
              <tr class="btTR">
                <td width="4%" align="center"><input name="input2" type="checkbox" value="" /></td>
                <!--  <td ><div class="biaoti">Id</div></td>-->
                <td ><div class="biaoti">key</div></td>
                <td ><div class="biaoti">name</div></td>
                <td ><div class="biaoti">version</div></td>
                <!--  <td ><div class="biaoti">DeploymentId</div></td>
                <td ><div class="biaoti">Category</div></td>
                <td ><div class="biaoti">DiagramResourceName</div></td>
                <td ><div class="biaoti">ResourceName</div></td>
                <td ><div class="biaoti">hasStartFormKey</div></td>
                <td ><div class="biaoti">isSuspended</div></td>-->
                <td></td>
              </tr>
            <%for(ProcessDefinition d : list){%>
				<tr>
					<td align="center"><input name="input2" type="checkbox" value="" /></td>
					<!--<td ><%=d.getId() %></td>-->
					<td ><%=d.getKey() %></td>
					<td ><%=d.getName() %></td>
					<td ><%=d.getVersion() %></td>
					<!--<td ><%=d.getDeploymentId() %></td>
					<td ><%=d.getCategory() %></td>
					<td ><%=d.getDiagramResourceName() %></td>
					<td ><%=d.getResourceName() %></td>
					<td ><%=d.hasStartFormKey() %></td>
					<td ><%=d.isSuspended() %></td>-->
					<td ><a href="<%=request.getContextPath() %>/jsp/startProcess.jsp?doWhat=start&processDefinitionId=<%=d.getId() %>">start</a></td>
				</tr>
			<%} %>
            </tbody>
          </table>
          <!--表格结束-->
        </div>
        <!--分页-->
        <!--  
        <div class="pagination">
          <div id="ContentPlaceHolder_Contents_pager"> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','1')" class="btn"><img src="images/btn_home.gif" align="absmiddle"/>首 页</a> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','1')" class="btn"><img src="images/btn_prive.gif" align="absmiddle"/>上一页</a> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','1')" >1</a> <span class="currentpage">2</span> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','3')" >3</a> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','3')" class="btn">下一页<img src="images/btn_next.gif" align="absmiddle"/></a> <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','3')" class="btn">尾 页<img src="images/btn_end.gif" align="absmiddle"/></a> </div>
        </div>-->
        <!--分页结束-->
      </div>
      <!--人力资源管理结束-->
    </div>
  </div>
  <!--主体内容结束-->
</div>
</body>
</html>