package com;

import org.activiti.engine.delegate.DelegateExecution;
import org.activiti.engine.delegate.JavaDelegate;

public class ServiceTaskTest implements JavaDelegate {

	@Override
	public void execute(DelegateExecution execution) throws Exception {
		String i = (String) execution.getVariable("i");
		i += "-ServiceTask";
		execution.setVariable("i", i);
	}

}
