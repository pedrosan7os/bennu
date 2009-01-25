<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/fenix-renderers.tld" prefix="fr" %>
<%@page import="pt.ist.fenixWebFramework.FenixWebFramework"%>

<%@page import="pt.utl.ist.fenix.tools.util.i18n.Language"%>
<table width="100%">
  <tr>
    <td rowspan="2" width="60%" valign="top">
		<h1><bean:write name="myOrg" property="applicationTitle"/></h1>
		<p><bean:write name="myOrg" property="applicationSubTitle"/></p>
    </td>
    <td align="right" nowrap="nowrap" width="40%">
		<%
			final String contextPath = request.getContextPath();
			final boolean isCasEnabled = FenixWebFramework.getConfig().isCasEnabled();
		%>
		<logic:notPresent name="USER_SESSION_ATTRIBUTE">
			<% if (isCasEnabled) {%>
				<div class="login">
					<% final String portString = request.getServerPort() == 80 || request.getServerPort() == 443 ? "" : ":" + request.getServerPort(); %>
					<bean:define id="loginUrl"><%= FenixWebFramework.getConfig().getCasLoginUrl() + "https" + "://" + request.getServerName() + contextPath %>/</bean:define>
					<html:link href="<%= loginUrl %>"><bean:message key="label.login.link" bundle="MYORG_RESOURCES"/></html:link>
				</div>
			<% } else { %>
				<form action="<%= contextPath %>/authenticationAction.do" class="login" method="post">
					<input type="hidden" name="method" value="login"/>
					<bean:message key="label.login.username" bundle="MYORG_RESOURCES"/>: <input type="text" name="username" size="10"/>
					<bean:message key="label.login.password" bundle="MYORG_RESOURCES"/>: <input type="password" name="password" size="10"/>
					<bean:define id="loginLabel"><bean:message key="label.login.submit" bundle="MYORG_RESOURCES"/></bean:define>
					<input class="inputbuttonlogin" type="submit" name="Submit" value="<%= loginLabel %>"/>
				</form>
			<% } %>
		</logic:notPresent>
		<logic:present name="USER_SESSION_ATTRIBUTE">
			<div class="login">
				<logic:present role="MANAGER">
					<!-- HAS_CONTEXT --><html:link page="/configuration.do?method=applicationConfiguration">
						<bean:message bundle="MYORG_RESOURCES" key="label.application.configuration"/>
					</html:link> |
				</logic:present>
				<a href="https://193.136.132.88/Qualidade/Aquisicoes" target="_blank"><bean:message key="label.help.link" bundle="MYORG_RESOURCES"/></a> |  
				<bean:message key="label.login.loggedInAs" bundle="MYORG_RESOURCES"/>: <bean:write name="USER_SESSION_ATTRIBUTE" property="username"/> |
				<% if (isCasEnabled) {%>
					<html:link href="<%= FenixWebFramework.getConfig().getCasLogoutUrl() %>"><bean:message key="label.login.logout" bundle="MYORG_RESOURCES"/></html:link>
				<% } else { %>
					<html:link action="/authenticationAction.do?method=logout"><bean:message key="label.login.logout" bundle="MYORG_RESOURCES"/></html:link>
				<% } %>
			</div>
		</logic:present>
	</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap" width="40%">
			<div>
				<bean:define id="languageUrl"><%= request.getContextPath() %>/content.do</bean:define>
				<form action="<%= languageUrl %>" method="post" class="login">
					<input type="hidden" name="method" value="viewPage" />
					<logic:present name="selectedNode">
						<bean:define id="arg" name="selectedNode" property="OID"/>
						<input type="hidden" name="nodeOid" value="<%= arg %>"/>
					</logic:present>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<select name="locale" onchange="this.form.submit();">
						<% final String country = Language.getLocale().getCountry(); %>
						<% for (Language language : Language.values()) {
							if (language == Language.getLanguage()) {
						    	%>
							    	<option value="<%= language.name() %>_<%= country %>" selected="selected">
						    			<%= language.name() %>
						    		</option>
						    	<%
							} else {
							    %>
						    		<option value="<%= language.name() %>_<%= country %>">
							    		<%= language.name() %>
						    		</option>
						    	<%							    
							}
						} %>
					</select>
					<input class=" button" type="submit" name="Submit" value="Ok" />
				</form>

				<!-- BLOCK_HAS_CONTEXT -->
				<!-- NO_CHECKSUM --><form method="get" action="http://www.google.com/search">
					<input type="hidden" name="site" value="" />
					<input type="hidden" name="hl" value="en" />
					<input type="hidden" name="btnG" value="Search" />
					<input type="hidden" name="domains" value="" />
					<input type="hidden" name="sitesearch" value="" />

					<input type="text" id="q" name="q" value="Search..." />
					<input class=" button" type="submit" name="Submit" value="Google" />
				</form>
				<!-- END_BLOCK_HAS_CONTEXT -->
			</div>
		</td>
	</tr>
</table>
