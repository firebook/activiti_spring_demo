package com;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.impl.RepositoryServiceImpl;
import org.activiti.engine.impl.bpmn.diagram.ProcessDiagramGenerator;
import org.activiti.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

public class Img extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(req.getSession().getServletContext());
		RepositoryService repositoryService = (RepositoryService)context.getBean("repositoryService");
		RuntimeService runtimeService = (RuntimeService)context.getBean("runtimeService");
		
		String doWhat = req.getParameter("doWhat");
		if(doWhat != null && doWhat.equals("simple")){
			ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery().processDefinitionId(req.getParameter("processDefinitionId")).singleResult();
			System.out.println("-------------:"+processDefinition.getName());
			InputStream in = repositoryService.getResourceAsStream(processDefinition.getDeploymentId(), processDefinition.getDiagramResourceName());
			
			resp.setContentType("image/png");
			ServletOutputStream out = resp.getOutputStream();
			BufferedInputStream bin = new BufferedInputStream(in);
			
			byte[] b = new byte[1024];
			int l = bin.read(b);
			while(l != -1){
				out.write(b);
				l = bin.read(b);
			}
			bin.close();
			in.close();
			out.flush();
			out.close();
		}else if(doWhat != null && doWhat.equals("complex")){
			String processInstanceId = req.getParameter("processInstanceId");
			
			ProcessInstance processInstance = runtimeService.createProcessInstanceQuery().processInstanceId(processInstanceId).singleResult();
			String processDefinitionId = processInstance.getProcessDefinitionId();
			
			ProcessDefinitionEntity processDefinition = (ProcessDefinitionEntity)((RepositoryServiceImpl)repositoryService).getDeployedProcessDefinition(processDefinitionId);
			InputStream in = ProcessDiagramGenerator.generateDiagram((ProcessDefinitionEntity)processDefinition, "png", runtimeService.getActiveActivityIds(processInstanceId));
			//InputStream in = repositoryService.getResourceAsStream(processDefinition.getDeploymentId(), processDefinition.getDiagramResourceName());
			
			resp.setContentType("image/png");
			ServletOutputStream out = resp.getOutputStream();
			BufferedInputStream bin = new BufferedInputStream(in);
			
			byte[] b = new byte[1024];
			int l = bin.read(b);
			while(l != -1){
				out.write(b);
				l = bin.read(b);
			}
			bin.close();
			in.close();
			out.flush();
			out.close();
		}
	}
	

	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}
}
