package com;

public class JavascriptMessage {
	public final static String alert(String message){
		StringBuffer sb = new StringBuffer();
		sb.append("<script type=\"text/javascript\">");
		sb.append("alert('");
		sb.append(message);
		sb.append("')");
		sb.append("</script>");
		return sb.toString();
	}
}
