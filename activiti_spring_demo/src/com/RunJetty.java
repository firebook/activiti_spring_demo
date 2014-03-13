package com;
import org.mortbay.jetty.Connector;
import org.mortbay.jetty.Server;
import org.mortbay.jetty.nio.SelectChannelConnector;
import org.mortbay.jetty.webapp.WebAppContext;

public class RunJetty {
	public static void main(String[] args) {
        try {
        	System.out.println("Jetty服务器开始启动。。。");
			String jetty_home = "WebContent";
			int port = 8020;

			Server server = new Server();
			
			Connector connector=new SelectChannelConnector();
			connector.setPort(port);
			server.addConnector(connector);
			
			WebAppContext webapp = new WebAppContext(jetty_home, "/activiti");
			webapp.setDefaultsDescriptor(jetty_home+"/etc/webdefault.xml");
			
			server.setHandler(webapp);
			
			server.start();
			System.out.println("Jetty服务器启动完毕。。。");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
