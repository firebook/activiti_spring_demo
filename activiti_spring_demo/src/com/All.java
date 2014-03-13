package com;

import java.util.List;

import org.activiti.engine.HistoryService;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.ProcessEngineConfiguration;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.task.Task;

public class All {
	
	public static void main(String[] args) {
		// ���� Activiti��������
		ProcessEngine processEngine = ProcessEngineConfiguration
			.createStandaloneProcessEngineConfiguration()
			.buildProcessEngine();
		// ȡ�� Activiti ����
		RepositoryService repositoryService = processEngine.getRepositoryService();
		RuntimeService runtimeService = processEngine.getRuntimeService();
		// �������̶���
		repositoryService.createDeployment()
			.addClasspathResource("FinancialReportProcess.bpmn20.xml")
			.deploy();
		// ��������ʵ��
		String procId = runtimeService.startProcessInstanceByKey("financialReport").getId();
		// ��õ�һ������
		TaskService taskService = processEngine.getTaskService();
		List<Task> tasks = taskService.createTaskQuery().taskCandidateGroup("accountancy").list();
		for (Task task : tasks) {
			System.out.println("Following task is available for accountancy group: " + task.getName());
			// ��������
			taskService.claim(task.getId(), "fozzie");
		}
		// �鿴Fozzie �����Ƿ��ܹ���ȡ��������
		tasks = taskService.createTaskQuery().taskAssignee("fozzie").list();
		for (Task task : tasks) {
			System.out.println("Task for fozzie: " + task.getName());
			// �������
			taskService.complete(task.getId());
		}
		System.out.println("Number of tasks for fozzie: "
				+ taskService.createTaskQuery().taskAssignee("fozzie").count());
		// ��ȡ������ڶ�������
		tasks = taskService.createTaskQuery().taskCandidateGroup("management").list();
		for (Task task : tasks) {
			System.out.println("Following task is available for accountancy group: " + task.getName());
			taskService.claim(task.getId(), "kermit");
		}
		//��ɵڶ������������������
		for (Task task : tasks) {
			taskService.complete(task.getId());
		}
		// ��ʵ�����Ƿ����
		HistoryService historyService = processEngine.getHistoryService();
		HistoricProcessInstance historicProcessInstance = historyService.createHistoricProcessInstanceQuery().processInstanceId(procId).singleResult();
		System.out.println("Process instance end time: " + historicProcessInstance.getEndTime());
	}
}