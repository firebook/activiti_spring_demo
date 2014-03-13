<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ page import="java.util.*" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.activiti.engine.ProcessEngine" %>
<%@ page import="org.activiti.engine.RepositoryService" %>
<%@ page import="org.activiti.engine.identity.User" %>
<%@ page import="org.activiti.engine.repository.Deployment" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.FileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
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
String doWhat = request.getParameter("doWhat");

String message = null;

WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
//ProcessEngine engine = (ProcessEngine)context.getBean("processEngine");
RepositoryService repository = (RepositoryService)context.getBean("repositoryService");

if (doWhat != null && doWhat.equals("delete")){
	repository.deleteDeployment(request.getParameter("deploymentId"), true);
	message = "delete deployment success...";
} else if (doWhat != null && doWhat.equals("upload") && ServletFileUpload.isMultipartContent(request)){
	FileItemFactory factory = new DiskFileItemFactory();
	ServletFileUpload upload = new ServletFileUpload(factory);
	List<FileItem> files = upload.parseRequest(request);
	/*
	String realPath = application.getRealPath("/").replace("\\", "/");
	File file = new File(realPath + "uploadFiles/");
	if(!file.exists())
		file.mkdirs();
	*/
	for(FileItem item : files){
		if(!item.isFormField()){
			/*
			String fullFileName = realPath + "uploadFiles/" + item.getName();
			File uploadFile = new File(fullFileName);
			item.write(uploadFile);
			*/
			if(item.getName().contains("bpmn")){
				System.out.println("upload file is process file, deploying...");
				repository
					.createDeployment()
					.addInputStream(item.getName(), item.getInputStream()) // 文件流
					.name(item.getName() + "-" + DateUtil.getDateTime()) // 命名
					.deploy(); // 部署
				message = "deploy success...";
			}else{
				message = "deploy failed, the file is not bpmn type!";
			}
		}
	}
}

//List<Deployment> list = repository.createDeploymentQuery().orderByDeploymenTime().desc().list();
//分页
int firstResult = request.getParameter("firstResult") == null ? 0 : Integer.parseInt(request.getParameter("firstResult"));
int maxResults = 10;
int count = (int)repository.createDeploymentQuery().count();
int pre = firstResult < maxResults ? 0 : firstResult - maxResults;
int next = firstResult + maxResults > count ? firstResult : firstResult + maxResults;
int last = count - (count % maxResults);
int pageNum = firstResult / maxResults + 1;
List<Deployment> list = repository.createDeploymentQuery()
	.orderByDeploymenTime()
	.desc()
	.listPage(firstResult, maxResults);
%>
<body>
<%if(message != null){out.write(JavascriptMessage.alert(message));}%>

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
            <div class="bt2">上传部署文件</div>
          </div>
        </div>
        <!--功能按钮结束-->
        <div class="content">
	        <form action="<%=request.getContextPath() %>/jsp/deployment.jsp?doWhat=upload" method="post" enctype="multipart/form-data">
				<input type="file" name="file"/>
				<input type="submit" value=" 上传 "/>
			</form>
		</div>
        <!--功能按钮-->
        <div class="btnBox">
          <div class="tou">
            <div class="bt2">部署文件列表</div>
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
                <td ><div class="biaoti">Id</div></td>
                <td ><div class="biaoti">Name</div></td>
                <td ><div class="biaoti">DeploymentTime</div></td>
                <td></td>
              </tr>
            <%for(Deployment d : list){%>
				<tr>
					<td align="center"><input name="input2" type="checkbox" value="" /></td>
					<td ><%=d.getId() %></td>
					<td ><%=d.getName() %></td>
					<td ><%=DateUtil.format(d.getDeploymentTime(),"yyyy-MM-dd HH:ss") %></td>
					<td ><a href="<%=request.getContextPath() %>/jsp/deployment.jsp?doWhat=delete&deploymentId=<%=d.getId() %>">delete</a></td>
				</tr>
			<%} %>
            </tbody>
          </table>
          <!--表格结束-->
        </div>
        <!--分页--> 
        <div class="pagination">
          <div id="ContentPlaceHolder_Contents_pager">
	           <a href="<%=request.getContextPath() %>/jsp/deployment.jsp?firstResult=0" class="btn">
	           	<img src="<%=request.getContextPath() %>/images/btn_home.gif" align="absmiddle"/>首 页
	           </a> 
	           <a href="<%=request.getContextPath() %>/jsp/deployment.jsp?firstResult=<%=pre %>" class="btn">
	           	<img src="<%=request.getContextPath() %>/images/btn_prive.gif" align="absmiddle"/>上一页
	           </a> 
	           <!--  
	           <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','1')" >1</a> -->
	           <span class="currentpage"><%=pageNum %></span> 
	           <!-- 
	           <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder_Contents$pager','3')" >3</a> -->
	           <a href="<%=request.getContextPath() %>/jsp/deployment.jsp?firstResult=<%=next %>" class="btn">
	           	下一页<img src="<%=request.getContextPath() %>/images/btn_next.gif" align="absmiddle"/>
	           </a> 
	           <a href="<%=request.getContextPath() %>/jsp/deployment.jsp?firstResult=<%=last %>" class="btn">
	           	尾 页<img src="<%=request.getContextPath() %>/images/btn_end.gif" align="absmiddle"/>
	           </a> 
           </div>
        </div>
        <!--分页结束-->
      </div>
      <!--人力资源管理结束-->
    </div>
  </div>
  <!--主体内容结束-->
</div>
</body>
</html>