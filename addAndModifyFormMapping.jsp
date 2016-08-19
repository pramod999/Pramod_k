<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    com.manthan.promax.security.SecurityEngine.isSessionOver(request,
					response, "login.jsp");
%>
<%@ include file="userSession.jsp"%>
<%@ include file="scriptLocalize.jsp"%>
<%@ page import="java.util.Locale"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title><%= com.manthan.promax.security.schmail.Mailer.getPropValue("arc.title").toString() %> - Enter a new form name</title>
<link href="css/style<%=userSelectedTheme%>.less" rel="stylesheet/less" type="text/css" />
<script language="javascript" type="text/javascript" src="js/less.js"></script>
<script language="javascript" type="text/javascript" src="js/general.js"></script>
<script language="javascript" type="text/javascript" src="js/prototype.js"></script>
<script language="javascript" type="text/javascript" src="js/script.js"></script>
<!-- Combo STARTS -->
<link rel="STYLESHEET" type="text/css"
	href="dhtmlX/codebaseCombo/dhtmlxcombo.css" />
<script src="dhtmlX/codebaseCombo/dhtmlxcommon.js"></script>
<script src="dhtmlX/codebaseCombo/dhtmlxcombo.js"></script>
<script src="dhtmlX/codebaseCombo/dhtmlxcombo_extra.js"></script>
<script src="dhtmlX/codebaseCombo/dhtmlxcombo_whp.js"></script>
<!-- Combo ENDS -->
</head>
<body onclick='parent.document.getElementById("mandatorySection").innerHTML="<%=ResourceUtil.getMessage("arc.fields.mandatory",	locale)%>"'
	onkeypress="escPopup(event)" onload='parent.document.getElementById("mandatorySection").innerHTML="<%=ResourceUtil.getMessage("arc.fields.mandatory",locale)%>"; parent.document.getElementById("poupButtons").innerHTML = document.getElementById("thisPageButtons").innerHTML'>
	<form name="form1">
<input type="hidden" id="csrfPreventionSalt" name="csrfPreventionSalt" value="${csrfPreventionSalt}"/>
		<span id="passwordChangedStatus" style="display: none;"></span>
		<div id="thisPageButtons" style="display: none">
			<div style="float: left">
				<table border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<div class="buttonBlueLeft" style="float:left" onclick="popUpFrame.renameForm();">
								<div class='buttonText'>Add Mapping</div>
								<div class="buttonBlueRight_M"></div>
							</div>
						</td>
						<td>&nbsp;</td>
						<td>
							<div class="buttonBlueLeft" style="float:left" onclick="killPopup();">
								<div class='buttonText'><%=ResourceUtil.getLabel("arc.cancel", locale)%></div>
								<div class=buttonBlueRight_M></div>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<br /> <br />
		<div id="admain">
				<table width="100%" border="0" cellspacing="1" cellpadding="4"
					style="background-color: #CCCCCC;" id="taskDetails">
					<tr>
						<td width="30%" valign="top" class="tblLabel">Mapping Details<span class="contentRed"> * </span></td>
						<td>&nbsp;</td>
						<td>
							<textarea rows="8" cols="100" id="mapping"></textarea>
						</td>
					</tr>
				</table>
		</div>

	</form>
	<script>
	var formName = parent.globalformID;
		function renameForm(){
			if($F("mapping").blank()){
				alert("Sorry..! mapping cannot be blank");
			}else{
				var url = "netHandler?action=updateMapping"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
				var params = {"mapping":$F("mapping"),"fileName":formName};
				
				var myAjax = new Ajax.Request(url, {
					method : 'post',
					parameters : params,
					onSuccess : function(transport) {
						transport.responseText.evalScripts();
						parent.killPopup();
					}
				});
			}
			
		}
		
		var url = "netHandler?action=getMapping"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
		var params = {"mapping":$F("mapping"),"fileName":formName};
		
		var myAjax = new Ajax.Request(url, {
			method : 'post',
			parameters : params,
			onSuccess : function(transport) {
				$("mapping").value=transport.responseText;
				//transport.responseText.evalScripts();
			}
		});
		
	</script>
</body>
</html>