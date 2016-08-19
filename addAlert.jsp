<%@ page import="static com.manthan.arc.security.CrossSiteScriptingHandler.*"%>
<%
	com.manthan.promax.security.SecurityEngine.isSessionOver(request,response,"login.jsp");
	String fromKpiPub = encodeForXss(request.getParameter("fromKpiPub"),JAVASCRIPT);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.manthan.promax.util.ConstantsDef"%>
<%@page import="java.util.Properties"%>
<%@page import="com.manthan.arc.scheduler.alerts.AlertUtil"%>
<%@page import="com.manthan.arc.scheduler.alerts.AlertColShowBean"%>
<%@page import="com.manthan.promax.security.AdminController"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.manthan.promax.security.AdminDataHolder"%>
<%@page import="java.util.Vector"%>
<%@page import="com.manthan.arc.scheduler.alerts.AlertDBMediator"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Collections"%>
<%@page import="com.manthan.ga.GAOMgr"%>
<%@page import="com.manthan.arc.admin.kpimgmt.ManageKPI"%>
<%@ page import="com.manthan.promax.security.schmail.Mailer"%>
<%@page import="com.manthan.promax.calandar.DateUtil"%>
<%@page import="java.util.Calendar"%>
<%@ page import="com.manthan.promax.security.*"%>
<%@ include file="userSession.jsp" %><%@ include file="scriptLocalize.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=<%= session.getAttribute("CHARSET").toString()%>" />
<title><%= com.manthan.promax.security.schmail.Mailer.getPropValue("arc.title").toString() %></title>
<link href="css/style<%=userSelectedTheme%>.less" rel="stylesheet/less" type="text/css" />
<script language="javascript" type="text/javascript" src="js/less.js"></script>

<script language="JavaScript" src="js/calendar.js"></script>
<script language="javascript" type="text/javascript" src="js/drag.js"></script>
<script language="JavaScript" type="text/javascript" src="js/prototype.js" ></script>
<script language="javascript" type="text/javascript" src="js/general.js"></script>
<script language="JavaScript" type="text/javascript" src="js/alertsubscription.js" ></script>
<%
String mailBodyLength = Mailer.getPropValue("arc.no.of.characters.in.email");
String errMsg = ResourceUtil.getMessage("arc.rs.no.of.character.in.email", locale).replace("{0}", mailBodyLength);
%>
<!--DHTMLX-->
	<!--TAB-->
	<script  src="dhtmlX/codebaseTab/dhtmlxcommon.js"></script>
	<script  src="dhtmlX/codebaseTab/dhtmlxtabbar.js"></script>
	<script  src="dhtmlX/codebaseTab/dhtmlxtabbar_start.js"></script>
	<link rel="STYLESHEET" type="text/css" href="dhtmlX/codebaseTab/dhtmlxtabbar.css"/>

	<!--TREE GRID-->
	<link rel="STYLESHEET" type="text/css" href="dhtmlX/codebaseGrid/dhtmlxgrid.css"/>
	<script  src="dhtmlX/codebaseGrid/dhtmlxcommon.js"></script>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgrid.js"></script>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgridcell.js"></script>
	<script  src="dhtmlX/codebaseTreeGrid/dhtmlxtreegrid.js"></script>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_start.js"></script>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_pgn.js"></script>

	<!--TREE-->
	<link rel="STYLESHEET" type="text/css" href="dhtmlX/codebaseTree/dhtmlxtree.css"/>
	<script  src="dhtmlX/codebaseTree/dhtmlxtree.js"></script>
	<script  src="dhtmlX/codebaseTree/dhtmlxcommon.js"></script>
	<script  src="dhtmlX/codebaseTree/dhtmlxtree_start.js"></script>
	<script  src="dhtmlX/codebaseTree/dhtmlxtree_kn.js"></script>
	<script  src="dhtmlX/codebaseTree/dhtmlxtree_xw.js"></script>
	<script language="javascript" type="text/javascript" src="js/publish.js"></script>
	<script language="javascript" type="text/javascript" src="js/script.js"></script>
<!--DHTMLX ENDS-->


<!-- rte component -->
	<script language="JavaScript" type="text/javascript" src="js/rteCommon.js"></script>
	<link href="rte_control/rte.css" type="text/css" rel="stylesheet" />
<!-- rte component ends-->

<script language="javascript">
var isClicked=true;
function saveAlerts(){try{
	if(!isClicked)return false;
	isClicked=false;
	if(parent.document.getElementById("subsAlert"))parent.document.getElementById("subsAlert").style.opacity="0.2";
	parent.document.getElementById('mandatorySection').innerHTML = "";
	//Fetch GAO List and KPI List
	document.getElementById("hiddenLinkKpiList").value=getIdFromTbl('dataGrid2Con');
	document.getElementById("hiddenLinkGAOList").value=getIdFromTbl('dataGrid3Con');
	var url = "arcui?nav_action=getServerTime"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
	
	var myAjax = new Ajax.Request(url,
	{
		method: 'post',
		onComplete:function(orgreq){
			orgreq.responseText.evalScripts();
			updateRTE('rte1');
			//var newVal = (document.all)?document.addAlertFrm.rte1.value:(document.addAlertFrm.rte1.value.split("<st")[0]).replace('<br>','');
			//var mailBody = newVal;
			var mailBody = (document.addAlertFrm.rte1)?document.addAlertFrm.rte1.value.replace('<style type="text/css">@import url(./rte_control/);</style>',''):"";
			var mailBodyLength = '<%= mailBodyLength%>' ;
			if(trim(mailBody).length>parseInt(mailBodyLength)){
				popupTabber.setTabActive('publishFormat');
				var errMsg = '<%= errMsg%>';
				isClicked=true;
				if(parent.document.getElementById("subsAlert"))parent.document.getElementById("subsAlert").style.opacity="100";
				parent.document.getElementById('mandatorySection').innerHTML = "<font style='color:red;'>"+errMsg+"</font>";
			    return ;
			}
			document.addAlertFrm.mailBody.value = mailBody ;
			var isValid = validateAll();
			if ( isValid ) { 
    			// start update Alert counter when you create a new Alert 
 				if(null!=parent.parent.window.opener.document.getElementById('alertCounter'))  { 
   					var url = "alertnew?nav_action=getAlertCount"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
 					var myAjax = new Ajax.Request(url,
 					{
 						method: 'post',
 						onComplete:function(orgreq){
 							isClicked=true;//if(parent.document.getElementById("subsAlert"))parent.document.getElementById("subsAlert").style.opacity="100";
 							var counter=orgreq.responseText; 
 							if(parseInt(counter)>0){ 
 								parent.parent.window.opener.document.getElementById('alertCounter').style.display='';
 								parent.parent.window.opener.document.getElementById('alertCounter').innerHTML =counter;	
 							} 
 						}
 					});				
 									
				}				
				// end update Alert counter when you create a new Alert 
				if(BrowserDetect.browser!='Explorer'){
					var rte1Temp = document.addAlertFrm.rte1.value;
					document.addAlertFrm.rte1.value = rte1Temp.replace('<style type="text/css">@import url(./rte_control/);</style>','');
				}
				var tmpName = ''; 
				var url = "alertnew?templateName="+tmpName+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
				var params = Form.serialize(document.addAlertFrm);
				new Ajax.Request(url,{method: 'post',parameters: params,onComplete: updateDiv123});
			}
			else{
				isClicked=true;
				if(parent.document.getElementById("subsAlert"))parent.document.getElementById("subsAlert").style.opacity="100";
			}
		}
	});
	}catch(ex){alert(ex.message);}}

function updateDiv123( org ) {
	var msg = org.responseText;
	if(!msg.match("_1_1"))
	{

		var fromKpiPub = '<%=fromKpiPub%>';
		if(fromKpiPub=='yes'){
			<%if(null==encodeForXss(request.getParameter("fromAlertAnalyst"))){%>
				if (BrowserDetect.browser=="Explorer"){
					if(parent.parent.tree1){
						parent.parent.tree1.deleteChildItems(0);
						parent.parent.tree1.loadXML("out_xml_alerts.jsp?action=AlertsTree&selAlert="+msg.split('_')[1]+"G"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt'));
					}else{
						parent.window.location.reload(true);
					}
					alert(msg.split('_')[0]);
					parent.killPopup();
				}
				else{
					alert(msg.split('_')[0]);
					if(parent.parent.tree1){
						parent.parent.tree1.deleteChildItems(0);
						parent.parent.tree1.loadXML("out_xml_alerts.jsp?action=AlertsTree&selAlert="+msg.split('_')[1]+"G"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt'));
					}else{
						parent.window.location.reload(true);
					}
					parent.killPopup();
				}

			<%}else{%>
   				sucessAlertKillPopup(msg.split('_')[0], 'killPopup');
			<%}%>
		}else{
			 if(parent.tree1){
					parent.tree1.deleteChildItems(0);
					parent.tree1.loadXML("out_xml_alerts.jsp?action=AlertsTree&selAlert="+msg.split('_')[1]+"G"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt'));
				}else{
					parent.window.location.reload(true);
				}
			//parent.window.history.go(0);
			sucessAlertKillPopup(msg.split('_')[0], 'killPopup');
		}

	}
	else
	{
		alert(msg.split("_1_1")[0]);
		isClicked=true;
		if(parent.document.getElementById("subsAlert"))parent.document.getElementById("subsAlert").style.opacity="100";
		parent.document.getElementById('mandatorySection').innerHTML = "<font style='color:red;'>"+msg.split("_1_1")[0]+"</font>";
		popupTabber.setTabActive('general');
		document.addAlertFrm.alertNameTxt.className = "inputFieldErr";
		return false;
	}
}

function loadExp(){
	getExpressions();
	document.getElementById("showRuleBuilderTxt").style.display='none';
	document.getElementById("showRuleBuilder").style.display='none';
	document.getElementById("showExpressions").style.display='none';
}

function setDefaults(){
	if((document.getElementById('pdf').checked) ){
		document.getElementById('pdf').checked = true;
	}else if( document.getElementById('excel').checked ){
		document.getElementById('excel').checked = true;
	}else if( document.getElementById('html').checked){
		document.getElementById('html').checked = true;
	}else if( document.getElementById('email').checked){
		document.getElementById('email').checked = true;
	}else{
		document.getElementById('pdf').checked = true;
	}
}
</script>
<style>
.containerTableStyle{height:164px!important;}
#resultText1,#resultText2{height: 180px!important;}

/*.innerPortlet{padding:5px 5px 5px 5px !important;}*/
#fromDate,#toDate,#weekEndtdate,#monthEndtdate,#oneTstartdate{padding:0 !important;}
#cp{top:98px !important;}
</style>

</head>

<body onkeypress="escPopup(event)" onload="">
<%
	//com.manthan.dhtmlx.PublisherHelper pubHelper = new com.manthan.dhtmlx.PublisherHelper();
	//pubHelper.setFilterValues(request);

	DateFormat dateFormat = new SimpleDateFormat("HH");
	List<String>  guidedNameList=null;
	GAOMgr gaomgr=new GAOMgr();
    Date date = new Date();

    Hashtable labels = com.manthan.promax.report.ReportUtil.getLabels(session);
    String schedulenow = "Schedule Now";
	if(labels!=null && labels.get("alert.column.schedule.tooltip")!=null
	&& labels.get("alert.column.schedule.tooltip").toString().trim().length()>0)
	{
		schedulenow = (String)labels.get("alert.column.schedule.tooltip");
	}

	String alertShowColsNames="";
	String alertShowColsGUI="";
	String viewSelectedCols="";
	String allCols="";
	String viewSelectedColsLocale="";
	String modulename="";
	String kpiname="";
	String kpi_id="";
	String viewname="";
	String xmlname="";
	String viewid="";
	String columnname="";
	String useremail="";
	ArrayList colsdetails;
	Hashtable pagedetailstable ;
	Hashtable   kpiDetails;
	HashMap viewDetails = null;
	HashMap  allviewDetails=null;
	String dl=ConstantsDef.ALERT_COLUMN_DELIMIT;
	StringBuffer buffer;
	StringBuffer bufferLocale;
	StringBuffer bufferAllCols;
	String jsp_name="";
	String expvalueset="";
	String arcTree="";
	String alertname="";
	String urlquery="";
	boolean isDcs=false;
	
	int page1 = 1;
	int recordsPerPage1 = 0;
	int noOfPages = 0;
	
	int pageRole = 1;
	int recordsPerPageR = 0;
	int noOfPagesRole = 0;
	
	colsdetails= new java.util.ArrayList();
	pagedetailstable = new Hashtable();
	kpiDetails = new Hashtable();
	buffer = new StringBuffer();
	bufferLocale = new StringBuffer();
	bufferAllCols= new StringBuffer();
	viewSelectedCols="";
	viewSelectedColsLocale="";
	allCols="";
	viewid=(String)session.getAttribute("viewid");
	expvalueset= encodeForXss(request.getParameter("expcols"),HTMLATTRIBUTE);

	

Integer selectAlltotal = null;
if(null!= session.getAttribute("GET_TOTAL_RECORDS")){
selectAlltotal = (Integer)session.getAttribute("GET_TOTAL_RECORDS");
}else{
AdminController adminCon = new AdminController();
selectAlltotal = new Integer(adminCon.getUserCount());
}

if(selectAlltotal.intValue() < 50){
recordsPerPage1 = selectAlltotal.intValue();
}else{
recordsPerPage1 = 50;
}

Integer selectAlltotalRole = null;
if(null!= session.getAttribute("GET_ROLE_TOT_RECORDS")){
selectAlltotalRole = (Integer)session.getAttribute("GET_ROLE_TOT_RECORDS");
}else
{
PermissionDbEvaluator pDb = new PermissionDbEvaluator();
selectAlltotalRole = new Integer(pDb.getRoleCount());
}

if(selectAlltotalRole.intValue() < 50){
recordsPerPageR = selectAlltotalRole.intValue();
}else{
recordsPerPageR = 50;
}

	
	if (expvalueset==null){
		expvalueset="";
	}else{
		expvalueset= expvalueset.trim();
	}
	if (viewid !=null){
	  urlquery = ( String ) session.getAttribute("urlquery");
	  	if ((urlquery == null)  || (urlquery.trim().length() == 0) ){
			urlquery=encodeForXss(request.getParameter("reportparams"),URI);
		}
		pagedetailstable = (Hashtable)session.getAttribute(viewid);
		kpiDetails=null;
		kpi_id = encodeForXss(request.getParameter("kpi_id"),HTMLATTRIBUTE);
		kpiname= encodeForXss(request.getParameter("kpiname"),HTMLATTRIBUTE);
		viewname= encodeForXss(request.getParameter("viewname"),HTMLATTRIBUTE);
		xmlname= encodeForXss(request.getParameter("xmlname"),HTMLATTRIBUTE);
		modulename= encodeForXss(request.getParameter("modulename"),HTMLATTRIBUTE);

		if (pagedetailstable!=null )
		{
			if (pagedetailstable.containsKey("colsdetails")  ){
				colsdetails= (ArrayList)pagedetailstable.get("colsdetails");
				viewSelectedCols= (String)pagedetailstable.get("colsdetailsvalue");
				viewSelectedColsLocale=(String)pagedetailstable.get("colsdetailsvalueLocale");
			}
		}
		else{
			pagedetailstable = new Hashtable();
		}
		arcTree=encodeForXss(request.getParameter("isprint"));
		if(arcTree!=null && arcTree.trim().equalsIgnoreCase("arctree"))
		{
			Properties props = new Properties();
			props = AlertUtil.preparePropFromReportParams(urlquery);
			xmlname =AlertUtil.getArcTreeReportConfig(props);
			urlquery = urlquery+"&tree=true";
		}

		if((colsdetails == null)||(colsdetails.size()<=0))
		{
			colsdetails = AlertUtil.getColsDetailsFinal(xmlname, urlquery, session);
		}

		if(colsdetails != null)
		{
			if (buffer.length() >0)
			{
				buffer.delete(0,buffer.length());
			}
			if (bufferLocale.length() >0)
			{
				bufferLocale.delete(0,bufferLocale.length());
			}
			if (bufferAllCols.length() >0)
			{
				bufferAllCols.delete(0,bufferAllCols.length());
			}

			for (int i=0;i< colsdetails.size();i++)
			{
				AlertColShowBean colbean = (AlertColShowBean)colsdetails.get(i);
				bufferAllCols.append(colbean.getColumnId()).append(dl);
				if ( colbean.isBlselected())
				{
					buffer.append(colbean.getColumnId()).append(dl);
					bufferLocale.append(colbean.getPropertyColumnName()).append(dl);
				}
			}
		}

		if(colsdetails!=null)
		{
			pagedetailstable.put("colsdetails",colsdetails);
		}
		if (pagedetailstable!=null)
		{
			session.setAttribute(viewid,pagedetailstable );
		}
		if (buffer != null && buffer.length()>0 )
		{
				int lastpos = buffer.lastIndexOf(dl);
			if (lastpos > 0)
			{
				buffer.deleteCharAt(lastpos);
			}
			viewSelectedCols=buffer.toString();
		}
		if (bufferLocale != null && bufferLocale.length()>0 )
		{
			int lastpos1 = bufferLocale.lastIndexOf(dl);
			if (lastpos1 > 0)
			{
				bufferLocale.deleteCharAt(lastpos1);
			}
			viewSelectedColsLocale=bufferLocale.toString();
		}
		if (bufferAllCols != null && bufferAllCols.length()>0 )
		{
			int lastpos2 = bufferAllCols.lastIndexOf(dl);
			if (lastpos2 > 0)
			{
				bufferAllCols.deleteCharAt(lastpos2);
			}
			allCols=bufferAllCols.toString();
		}
		useremail=  encodeForXss(request.getParameter("useremail"),HTMLATTRIBUTE) ;
		if( (useremail == null)  || (useremail.trim().length() == 0))
		{
			if(null!=session.getAttribute("UserName"))
			{
				String user="";
				user = (String)session.getAttribute("UserName");
				useremail=AlertUtil.getUserEmail(user);
			}
		}
	}

	com.manthan.security.SummaryData userRoleData = (com.manthan.security.SummaryData)session.getAttribute("UserRoleData");
	java.util.List roleList = (ArrayList) userRoleData.getRoleList();

	ArrayList userGroups = (ArrayList)session.getAttribute("UserGroup");

	if(userGroups.contains("administrator")){
		roleList = (ArrayList)session.getAttribute("ALERT_ROLES");
	}
	
	String linkKPISize = Mailer.getPropValue("arc.link.kpi.size");
	linkKPISize = linkKPISize!=null && linkKPISize.trim().length()>0?linkKPISize:"5";	
%>

<form id="addAlertFrm" name="addAlertFrm" method="post" action="">
<input type="hidden" id="csrfPreventionSalt" name="csrfPreventionSalt" value="${csrfPreventionSalt}"/>
<!--ADDED by Manoj babu for Date Picker -->
        <%
			Date Todaysdate = Calendar.getInstance().getTime();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		%>
		<input id="hdnToday" name="hdnToday" type="hidden" value= "<%= sdf.format(Todaysdate) %>" />
		<iframe id="gToday:jsDateNormal_DFM:jsDateAgenda.js" class='iframeDatePicker'  name="gToday:jsDateNormal_DFM:jsDateAgenda.js" src="DatePicker/DateOpeng.htm" frameBorder="0" width="168" scrolling="no" height="190"></iframe>
<!-- End if Date Picker code -->

<input type="hidden" name="mailBody" id='mailBody'/>
<input type="hidden" name="selectedUser" id="selectedUser"/>
<input type="hidden" name="selectedRole" id="selectedRole"  />
<input type="hidden" name="leftExpr" id="leftExpr"/>
<input type="hidden" name="rightExpr" id="rightExpr"/>
<input type="hidden" name="outlook" id="outlook" value=""/>
<input type="hidden" name="alertshedulewindow" id="alertshedulewindow"/>
<input type="hidden" name="expressionMeasures" id="expressionMeasures" value="<%=encodeForXss(request.getParameter("expressionMeasures"),HTMLATTRIBUTE)%>"/>
<input type="hidden" name="kpiname" id="kpiname" value="<%=kpiname%>"/>
<input type="hidden" name="viewname" id="viewname" value='<%=viewname %>'/>
<input type="hidden" name="reportparams" id="reportparams" value='<%=urlquery%>'/>
<input type="hidden" name="modulename" id="modulename" value="<%=modulename %>"/>
<input type="hidden" name="schedulenow" id="schedulenow" value="<%=schedulenow %>"/>
<input type="hidden" name="view_id" id="view_id" value="<%= encodeForXss(request.getParameter("view_id"),HTMLATTRIBUTE) %>"/>
<input type="hidden" name="kpi_id" id="kpi_id" class="formfield" value="<%= kpi_id%>"/>
<input type="hidden" name="uniqueVal" id="uniqueVal" value='<%=encodeForXss(request.getParameter("configuration"),HTMLATTRIBUTE)%>'/>
<input type="hidden" name="allcols" id="allcols" class="formfield" value="<%= allCols%>"/>
<input type="hidden" name="xmlname" id="xmlname" class="formfield" value="<%= xmlname%>"/>
<input type="hidden" name="showcols" id="showcols" class="formfield" value="<%= viewSelectedCols%>"/>
<input id="hiddenLinkKpiList" name="hiddenLinkKpiList" type="hidden" value="" />
<input id="hiddenLinkGAOList" name="hiddenLinkGAOList" type="hidden" value="" />


<input id="currentPage" name="currentPage" type="hidden" value= "1" />
<input id="recordsPerPage" name="recordsPerPage" type="hidden" value= "" />
<input id="pageSizeSelectHdn" name="pageSizeSelectHdn" type="hidden" value= "" />
<input id="flagNextPrev" name="flagNextPrev" type="hidden" value= "" />
<input id="hiddenLength" name="hiddenLength" type="hidden" value= "" />
<input id="selectAllFlg" name="selectAllFlg" type="hidden" value= "false" />

<input id="currentPageRole" name="currentPageRole" type="hidden" value= "1" />
<input id="recordsPerPageRole" name="recordsPerPageRole" type="hidden" value= "" />
<input id="pageSizeSelectHdnRole" name="pageSizeSelectHdnRole" type="hidden" value= "" />
<input id="flagNextPrevRole" name="flagNextPrevRole" type="hidden" value= "" />
<input id="hiddenLengthRole" name="hiddenLengthRole" type="hidden" value= "" />
<input id="selectAllFlgRole" name="selectAllFlgRole" type="hidden" value= "false" />

	<div id="thisPageButtons" style="display:none">
		  <div style="float:left">
		  <table border="0" cellspacing="0" cellpadding="0">
		  <tr>
		  <td>
			  <div id="subsAlert" class="buttonBlueLeft" style="float:left" onclick="popUpFrame.saveAlerts();">
				  <div class='buttonText'><%= ResourceUtil.getLabel("arc.subscribe.alert", locale)%></div>
				  <div class="buttonBlueRight_M"></div>
			</div>
		  </td>
		  <td>&nbsp;</td>
		  <td>
			  	<div  class="buttonBlueLeft" style="float:left" onclick="killPopup()">
				  	<div class='buttonText'><%= ResourceUtil.getLabel("arc.cancel", locale)%></div>
				  	<div class="buttonBlueRight_M"></div>
				</div>
		  </td>
		  </tr>
		  </table>
		  </div>
	</div>
	<div id="alertTabbar" style="width:99%;height:428px;"></div>
	<div>
		<div id="general" name="General <span class='contentRed'>*</span>" style="padding:10px;" width="100">
		<table width="100%" border="0" cellspacing="2" cellpadding="4" class="tblBorder">
  			<tr>
    			<td width="20%" class="tblLabel"><%= ResourceUtil.getLabel("arc.alert.name", locale)%> <span class='contentRed' style="padding:5px;">*</span></td>
	        	<td width="80%" class="tblContent"><input name="alertNameTxt" id='alertNameTxt' maxlength="30" type="text" class="inputField" size="40"/></td>
			</tr>
    		<tr>
    			<td width="20%" class="tblLabel"><%= ResourceUtil.getLabel("arc.roles", locale)%></td>
	        	<td width="30%" class="tblContent">
    	    		<table border="0">
					<tr><td>
					<select name="userRole" class="inputField" >
					<%
					 if (roleList != null && roleList.size() > 0){
						 for (int i = 0; i < roleList.size(); i++){
							 com.manthan.security.user.RoleDetails roleDetails = (com.manthan.security.user.RoleDetails) roleList.get(i);
							 int roleId = roleDetails.getRoleID();
							 String roleName = roleDetails.getRoleName();

					%>
								<option value="<%=roleId%>" ><%=roleName%></option>
					<%
							}
						}
					%>
					</select>
					</td></tr></table>
				 <!-- Added by deepaka Module selection -->
							<tr>
        						<td width="17%" class="tblLabel"><%= ResourceUtil.getLabel("arc.module.name", locale) %> </td>
          						<td width="33%" class="tblContent">
      	<select id="moduleName" name="moduleName" class="inputField">
        	<%
        		ArrayList module_kpis = (ArrayList) request.getSession().getAttribute("PERMITTED_MODULES_KPIS");
        	    ManageKPI manageKPInew = new ManageKPI();
        		Map moduleMap = manageKPInew.getActiveModules((String)(session.getAttribute("LanguageFullName")),request);
        		for (int i = 0; i < module_kpis.size(); i++) {
        			ArrayList moduleDetails = (ArrayList) module_kpis.get(i);
        			String moduleKey = (String) moduleDetails.get(3);
        			if(!moduleDetails.get(0).toString().equalsIgnoreCase("home") && moduleMap.get(moduleKey)!=null){
        			%>
					<option value="<%=moduleKey%>"><%= moduleMap.get(moduleKey).toString()%></option>
		  			<%
        		}}
        		%>
      	</select>
      </td>
      <!-- ModuleName DropDown Content Ends here -->
					</table>
				</td>
			</tr>
		</table>

		<br />


		<div style="height:500px; overflow:hidden; overflow-y:auto">
		</div>

		<div id="showExpressions" style="height:200px; overflow:hidden; overflow-y:auto" class="tblBorder">

			<table width="100%" border="0" cellspacing="0" cellpadding="3">
				<tr onclick="highLightSelected(this)">
					<td width="2%" align="center"></td>
					<td width="98%"><b><%= ResourceUtil.getMessage("arc.select.template", locale)%> </b></td>
				</tr>
			</table>
		</div>

		<br />
		<span id="showRuleBuilderTxt" class="contentBlackBold"><%= ResourceUtil.getLabel("arc.rule.builder", locale)%></span>

		<div id="showRuleBuilder" style="height:150px; overflow:hidden; overflow-y:auto; width:100%" class="tblBorder">
			<div id="ruleBuilder" onload="setTimeout('',50);">

			</div>
		</div>
	</div>

  	<div id="Schedule" name="Schedule <span class='contentRed'>*</span>" style="padding:10px;display:none" width="100">
		<table width="100%" border="0" cellspacing="2" cellpadding="4" class="tblBorder">
			<tr>
				<td width="20%" class="tblLabel"><%= ResourceUtil.getLabel("arc.start.time", locale)%></td>
				<td width="80%" class="tblContent">
		<%
			String hrs = dateFormat.format(date);
			dateFormat = new SimpleDateFormat("mm");
			String mins = dateFormat.format(date);
			if((Integer.parseInt(mins))==58){
				hrs = (Integer.parseInt(hrs)+1==24?0:Integer.parseInt(hrs)+1)+"";
				mins = 0+"";
			}else if((Integer.parseInt(mins))==59){
				hrs = (Integer.parseInt(hrs)+1==24?0:Integer.parseInt(hrs)+1)+"";
				mins = 1+"";
			}
			else {
				mins = Integer.toString((Integer.parseInt(mins)+2));
		      }
		%>
					<input id="startHours" name="startHours" type="text" maxlength="2" value="<%=hrs %>" class="inputField" onkeypress="return maskNumeric(event);" size="5"/>
			       	<%= ResourceUtil.getLabel("arc.hr", locale)%>  &nbsp;&nbsp;
          			<input id="startMins" name="startMins" type="text" maxlength="2" value="<%=mins %>" class="inputField" onkeypress="return maskNumeric(event);" size="5"/>
		          	<%= ResourceUtil.getLabel("arc.min", locale)%> &nbsp;&nbsp;<input type="checkbox" value="afterETL" id="etlChk" name="etlChk" onclick="afterETLFun(this);" /><%= ResourceUtil.getLabel("arc.after.etl", locale)%>
		        </td>
			</tr>
		</table>

		<br />
		<table width="100%" border="0" cellspacing="2" cellpadding="4" class="tblBorder">
			<tr>
				<td width="20%" class="tblLabel"><%= ResourceUtil.getLabel("arc.recurrence", locale)%></td>
				<td width="80%" class="tblContent">
					<input type="radio" name="recurrence" id="dailySchedule" value="dailySchedule"  onclick="showRecurr('daily');disableTime(false)"/><%= ResourceUtil.getLabel("arc.add.alert.daily", locale)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="recurrence" id="weeklySchedule" value="weeklySchedule" onclick="showRecurr('weekly');disableTime(false)"/><%= ResourceUtil.getLabel("arc.add.alert.weekly", locale)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="recurrence" id="monthlySchedule" value="monthlySchedule" onclick="showRecurr('monthly');disableTime(false)"/><%= ResourceUtil.getLabel("arc.add.alert.monthly", locale)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="recurrence" id="onetimeSchedule" value="onetimeSchedule" checked="checked" onclick="showRecurr('oneTime');disableTime(false)"/><%= ResourceUtil.getLabel("arc.one.time", locale)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="recurrence" id="schedNow" value="schedulenow"  onclick="showRecurr('');disableTime(true)"/><%= ResourceUtil.getLabel("arc.schedule.now", locale)%>&nbsp;
				</td>
			</tr>
		</table>

		<br />
		<table  id="daily" width="100%" border="0" cellspacing="2" cellpadding="4" class="tblBorder" style="display:none">
			<tr>
				<td width="20%" valign="top" class="tblLabel"><%= ResourceUtil.getLabel("arc.schedule.for", locale)%></td>
				<td width="80%" class="tblContent">
					<input type="radio" name="daily" value="everyday" checked="checked" onclick="enableDays('everyday',document.addAlertFrm)" /><%= ResourceUtil.getLabel("arc.everyday", locale)%><br />
					<input type="radio" name="daily" value="weekdays" onclick="enableDays('weekdays',document.addAlertFrm)"/><%= ResourceUtil.getLabel("arc.weekdays", locale)%><br />
					<input type="radio" name="daily" value="every" onclick="enableDays('every',document.addAlertFrm)"/><%= ResourceUtil.getLabel("arc.every", locale)%>
					<input name="ddays" type="text" class="inputField" maxlength="2" disabled="true" size="5" onkeypress="return maskNumeric(event);"/> <%= ResourceUtil.getLabel("arc.days", locale)%></td>
			</tr>
<!-- 		<tr id="dailyCal" style="display: block;"> -->
			<tr>
				<td class="tblLabel"><%= ResourceUtil.getLabel("arc.select.date", locale)%></td>
				<td class="tblContent"><div class="datePickText">&nbsp;&nbsp;<%= ResourceUtil.getLabel("arc.from", locale)%>&nbsp;&nbsp;<input type="text" name="fromDate" id='fromDate' size="10" readonly="readonly" style='width:80px' maxlength="10" class="inputField"/></div><a onclick="fnClearDate(document.addAlertFrm,'fromDate','toDate','popEnd');" href="javascript:void(0);"><img class="imgDatePicker" title="Calendar"  align="absmiddle" border="0"/></a>
					<div class="datePickText">&nbsp;&nbsp;<%= ResourceUtil.getLabel("arc.to", locale)%>&nbsp;&nbsp;<input type="text" size="10" name="toDate" id="toDate" readonly="readonly" style='width:80px' maxlength="10" class="inputField"/></div><a onclick="getMyValidDate(document.addAlertFrm,'ROP','fromDate','fromDate','toDate');" href="javascript:void(0);"><img class="imgDatePicker" title="Calendar"  onclick="" align="absmiddle" border="0"/></a>
				</td>
			</tr>
		</table>

    	<table  id="weekly" width="100%" border="0" cellspacing="2" cellpadding="4" class="tblBorder" style="display:none">
			<tr>
				<td width="20%" valign="top" class="tblLabel"><%= ResourceUtil.getLabel("arc.every", locale)%></td>
				<td width="80%" class="tblContent"><input name="wweeks" type="weeklyDays" class="inputField" size="5" maxlength="2" onkeypress="return maskNumeric(event);"/> <%= ResourceUtil.getLabel("arc.weeks", locale)%></td>
			</tr>
			<tr>
				<td valign="top" class="tblLabel"><%= ResourceUtil.getMessage("arc.select.day.of.week", locale)%></td>
				<td class="tblContent">
					<table width="0" border="0" cellspacing="0" cellpadding="0">
			            <tr>
							<td width="20"><input type="checkbox" name="wday" value="MON" /></td>
							<td width="80"><%= ResourceUtil.getLabel("arc.monday", locale)%></td>
							<td width="20"><input type="checkbox" name="wday" value="TUE" /></td>
							<td width="80"><%= ResourceUtil.getLabel("arc.tuesday", locale)%></td>
							<td width="20"><input type="checkbox" name="wday" value="WED" /></td>
							<td width="80"><%= ResourceUtil.getLabel("arc.wednesday", locale)%></td>
							<td width="20"><input type="checkbox" name="wday" value="THU" /></td>
							<td width="213"><%= ResourceUtil.getLabel("arc.thursday", locale)%></td>
						</tr>
			            <tr>
			            	<td><input type="checkbox" name="wday" value="FRI" /></td>
			              	<td><%= ResourceUtil.getLabel("arc.friday", locale)%></td>
			              	<td><input type="checkbox" name="wday" value="SAT" /></td>
			              	<td><%= ResourceUtil.getLabel("arc.saturday", locale)%></td>
			              	<td><input type="checkbox" name="wday" value="SUN" /></td>
			              	<td><%= ResourceUtil.getLabel("arc.sunday", locale)%></td>
			              	<td>&nbsp;</td>
			              	<td>&nbsp;</td>
			            </tr>
					</table>
				</td>
			</tr>
			<tr>
      			<td width="20%" class="tblLabel"><%=((java.util.Hashtable)com.manthan.promax.report.ReportUtil.getLabels(session)).get("arc.end.date")%> <span class="contentRed">*</span></td>
      			<td width="80%" class="tblContent"><div class="datePickText"><input type="text" name="weekEndtdate" id='weekEndtdate' style='width:80px' readonly size="10" maxlength="10" class="inputField" /></div><a onclick="gfPop.fEndPop(document.addAlertFrm.hdnToday,document.addAlertFrm.weekEndtdate);return false;" href="javascript:style.cursor='hand';"><img class="imgDatePicker"  align='absmiddle' title='<%= ResourceUtil.getLabel("arc.alt.calendar", locale)%>' border="0"/></a>
      			</td>
    		</tr>
		</table>

		<table  id="monthly" width="100%" border="0" cellspacing="2" cellpadding="4" class="tblBorder" style="display:none">
			<tr>
				<td width="20%" valign="top" class="tblLabel"><%= ResourceUtil.getLabel("arc.every", locale)%></td>
				<td width="80%" class="tblContent">
					<input type="radio" name="moption" checked="checked" value="dayofmonth" onclick="document.addAlertFrm.mdow1.disabled = true ;document.addAlertFrm.mdow2.disabled = true ; document.addAlertFrm.mdom.disabled = false"/><%= ResourceUtil.getLabel("arc.day", locale)%>
					<input name="mdom" id="mdom" type="dateTxt" class="inputField" size="5" maxlength="2" onkeypress="return maskNumeric(event);"/>
	          		<br />
	          		<br />

					<input type="radio" name="moption" value="dayofweek" onclick="document.addAlertFrm.mdow1.disabled = false ;document.addAlertFrm.mdow2.disabled = false;document.addAlertFrm.mdom.disabled = true" /><%= ResourceUtil.getLabel("arc.the", locale)%>:
					<select name="mdow1" class="inputField" disabled = true >
						<option selected="selected" value="Select"><%= ResourceUtil.getLabel("arc.select", locale)%></option>
						<option value="1"><%= ResourceUtil.getLabel("arc.first", locale)%></option>
						<option value="2"><%= ResourceUtil.getLabel("arc.second", locale)%></option>
						<option value="3"><%= ResourceUtil.getLabel("arc.third", locale)%></option>
						<option value="4"><%= ResourceUtil.getLabel("arc.fourth", locale)%></option>
						<option value="L"><%= ResourceUtil.getLabel("arc.last", locale)%></option>
					</select>
					&nbsp;
					<select name="mdow2" class="inputField" disabled = true>
						<option selected="selected" value="Select"><%= ResourceUtil.getLabel("arc.select", locale)%></option>
						<option value="MON"><%= ResourceUtil.getLabel("arc.monday", locale)%></option>
						<option value="TUE"><%= ResourceUtil.getLabel("arc.tuesday", locale)%></option>
						<option value="WED"><%= ResourceUtil.getLabel("arc.wednesday", locale)%></option>
						<option value="THU"><%= ResourceUtil.getLabel("arc.thursday", locale)%></option>
						<option value="FRI"><%= ResourceUtil.getLabel("arc.friday", locale)%></option>
						<option value="SAT"><%= ResourceUtil.getLabel("arc.saturday", locale)%></option>
						<option value="SUN"><%= ResourceUtil.getLabel("arc.sunday", locale)%></option>
					</select>
				</td>
			</tr>
		<tr>
			<td valign="top" class="tblLabel"><%= ResourceUtil.getMessage("arc.select.month.of.year", locale)%> </td>
			<td class="tblContent">
				<table width="0" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="20"><input type="checkbox" name="mmonths" value="JAN" /></td>
						<td width="50"><%= ResourceUtil.getLabel("arc.jan", locale)%> </td>
						<td width="20"><input type="checkbox" name="mmonths" value="FEB" /></td>
						<td width="50"><%= ResourceUtil.getLabel("arc.feb", locale)%> </td>
						<td width="20"><input type="checkbox" name="mmonths" value="MAR" /></td>
						<td width="50"><%= ResourceUtil.getLabel("arc.mar", locale)%></td>
						<td width="20"><input type="checkbox" name="mmonths" value="APR" /></td>
						<td width="50"><%= ResourceUtil.getLabel("arc.apr", locale)%></td>
						<td width="20"><input type="checkbox" name="mmonths" value="MAY" /></td>
						<td width="50"><%= ResourceUtil.getLabel("arc.may", locale)%></td>
						<td width="20"><input type="checkbox" name="mmonths" value="JUN" /></td>
						<td width="384"><%= ResourceUtil.getLabel("arc.jun", locale)%></td>
					</tr>
					<tr>
						<td width="20"><input type="checkbox" name="mmonths" value="JUL" /></td>
						<td width="50"><%= ResourceUtil.getLabel("arc.jul", locale)%></td>
						<td width="20"><input type="checkbox" name="mmonths" value="AUG" /></td>
						<td width="50"><%= ResourceUtil.getLabel("arc.aug", locale)%></td>
						<td width="20"><input type="checkbox" name="mmonths" value="SEP" /></td>
						<td width="50"><%= ResourceUtil.getLabel("arc.sep", locale)%></td>
						<td width="20"><input type="checkbox" name="mmonths" value="OCT" /></td>
						<td width="50"><%= ResourceUtil.getLabel("arc.oct", locale)%></td>
						<td width="20"><input type="checkbox" name="mmonths" value="NOV" /></td>
						<td width="50"><%= ResourceUtil.getLabel("arc.nov", locale)%></td>
						<td width="20"><input type="checkbox" name="mmonths" value="DEC" /></td>
						<td width="50"><%= ResourceUtil.getLabel("arc.dec", locale)%></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
      		<td width="20%" class="tblLabel"><%=((java.util.Hashtable)com.manthan.promax.report.ReportUtil.getLabels(session)).get("arc.end.date")%> <span class="contentRed">*</span></td>
      		<td width="80%" class="tblContent"><div class="datePickText"><input type="text" name="monthEndtdate" id='monthEndtdate' readonly size="10" maxlength="10" class="inputField" style='width:80px' /></div><a onclick="gfPop.fEndPop(document.addAlertFrm.hdnToday,document.addAlertFrm.monthEndtdate);return false;" href="javascript:style.cursor='hand';">	<img class="imgDatePicker"  align='absmiddle' title='<%= ResourceUtil.getLabel("arc.alt.calendar", locale)%>' border="0"/></a>
      		</td>
    	</tr>
	</table>
	<%
			String selFromDate = (new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
	%>
	<table  id="oneTime" width="100%" border="0" cellspacing="2" cellpadding="4" class="tblBorder">

			<tr>
				<td width="20%" class="tblLabel"><%= ResourceUtil.getLabel("arc.start.date", locale)%></td>
				<td width="80%" class="tblContent"><div class="datePickText">&nbsp;&nbsp;<input type="text" name="oneTstartdate" id="oneTstartdate" readonly="readonly" style='width:80px' size="10" maxlength="10" class="inputField" value="<%=selFromDate %>" /></div><a onclick="gfPop.fEndPop(document.addAlertFrm.hdnToday,document.addAlertFrm.oneTstartdate);return false;" href="javascript:style.cursor='hand';"><img class="imgDatePicker" title="Calendar" align="absmiddle" border="0"/></a>
				</td>
			</tr>
		</table>
	</div>

	<div id="delivery" name="Delivery <span class='contentRed'>*</span>" style="padding:10px;display:none" width="100">
		<table width="100%" border="0" cellspacing="2" cellpadding="4" class="tblBorder" id="autoRefresh" style="display:table">
			<tr>
				<td width="20%" align="left" valign="top" class="tblLabel"><%= ResourceUtil.getLabel("arc.delivery.method", locale)%></td>
				<td width="80%" class="tblContent">
					<span style="display: none;"><input id="dashPortlet" name="dashPortlet" type="checkbox" value="on"  onclick="javascript:emaildeliveryCheck(this,$('useremailchk'))"/><%= ResourceUtil.getLabel("arc.dashboard.portlet", locale)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
					<input id="useremailchk" name="useremailchk" type="checkbox" checked="checked" value="on" onclick="javascript:emaildeliveryCheck($('dashPortlet'),this)"/><%= ResourceUtil.getLabel("arc.email", locale)%>&nbsp;&nbsp;<span class='contentGrey'>(<%=ResourceUtil.getMessage("arc.alert.delivery.method.info", locale)%>)</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</td>
			</tr>
			<tr>
					<td width="20%" class="tblLabel"><%= ResourceUtil.getMessage("arc.deliver.as", locale)%></td>
					<td width="80%" class="tblContent"><input  name="deliverAs" type="radio" value ="attachment" checked="checked" onclick="disableEmailHtml(false);$('thresholdId').style.display='';"/>
            		<%= ResourceUtil.getLabel("arc.attachment", locale)%>&nbsp;&nbsp;
						<input type="radio" name="deliverAs" value="link" onclick="disableEmailHtml(true);$('thresholdId').style.display='none';"/>
						<%= ResourceUtil.getLabel("arc.link", locale)%>
					</td>
				</tr>
		</table>
		<div id="emailDiv" style="display:block;margin-top:7px;">
			<table width="100%" border="0" cellspacing="2" cellpadding="4" class="tblBorder" id="thresholdId">
				<tr>
					<td width="20%" class="tblLabel"><%= ResourceUtil.getLabel("arc.attchment.threshold", locale)%></td>
					<td width="80%" class="tblContent">
						<select name="attachmentThreshold" class="inputField">
							<!--<option value="Select" selected="selected"><%= ResourceUtil.getLabel("arc.select", locale)%></option>
							--><option value="2 MB"><%= ResourceUtil.getLabel("arc.2mb", locale)%></option>
							<option value="1 MB"><%= ResourceUtil.getLabel("arc.1mb", locale)%></option>
							<option value="500 KB"><%= ResourceUtil.getLabel("arc.500kb", locale)%></option>
							<option value="200 KB"><%= ResourceUtil.getLabel("arc.200kb", locale)%></option>
							<option value="100 KB"><%= ResourceUtil.getLabel("arc.100kb", locale)%></option>
						</select>
					</td>
				</tr>
			</table>
		</div>
<!--Start Harish Added Linking KPI And Guided To Alerts -->
	<div id="guided" name="guided" style="margin-top:7px;">
	 <div id="portletLeftPopup" style="width:212px; float:left">
    <div id="metricsBrowser" class="portletSkinFlo" style="width:212px;height:271px;">
	  <!--
	  <img src="images/icon_utility_kpiBrowser.gif" alt="<%= ResourceUtil.getLabel("arc.kpi.browser", locale) %>" align="absmiddle"/>&nbsp;<%= ResourceUtil.getLabel("arc.kpi.browser", locale) %>
				  <div class="kpiUtilityBar" style="float:right"></div>-->

      <!--TABLE FOR KPI TREE TAB HEADER STARTS-->
			      <table width="100%" border="0" cellspacing="0" cellpadding="0" id="graphKPIView" onclick="setDynamicTabValueForTree()">
			        <tr>
          				 	 <td class='customTabActive' style="width:90px;">
				  				<div class="img_utility_kpiBrowser"></div><div class='utilityBrowserText' title="<%= ResourceUtil.getLabel("arc.kpis", locale) %>" ><%= ResourceUtil.getLabel("arc.kpis", locale) %></div>
				  			 </td>
							<% String isGAEnable = Mailer.getPropValue("arc.ga.enable")==null?"no":Mailer.getPropValue("arc.ga.enable").trim();
							if(isGAEnable!=null && isGAEnable.equalsIgnoreCase("yes")){%>
           					<td class="customTabActiveBrd">&nbsp;</td>
          					<td class="customTabInActive" onclick="customTab('gaView');var s=new initgSearch('resultText2','searchGA','out_xml_ga.jsp?action=GuidedTree&csrfPreventionSalt=${csrfPreventionSalt}',tree5);">
          						<div class="img_utility_guidedAnalytics"></div><div class='utilityBrowserText' title="<%= ResourceUtil.getLabel("arc.alt.ga", locale) %>" ><%= ResourceUtil.getLabel("arc.alt.ga", locale) %></div>
          					</td>
          					<%} %>

			        </tr>
			      </table>
			      <!--TABLE FOR KPI TREE TAB HEADER ENDS-->


			      <!--TABLE FOR GUIDED TREE TAB HEADER STARTS-->
			      <table width="100%" border="0" cellspacing="0" cellpadding="0" id="gaView" style="display:none" onclick="setDynamicTabValueForTree()">
			        <tr>
			          <td class="customTabInActive" style="width:80px;" onclick="customTab('graphKPIView');var s1=new initgSearch('resultText1','searchKPI','out_xml_rb.jsp?action=reportSubscription&csrfPreventionSalt=${csrfPreventionSalt}',tree4);">
							<div class="img_utility_kpiBrowser"></div><div class='utilityBrowserText' title="<%= ResourceUtil.getLabel("arc.kpis", locale) %>" ><%= ResourceUtil.getLabel("arc.kpis", locale) %></div>
						</td>
						<% if(isGAEnable!=null && isGAEnable.equalsIgnoreCase("yes")){%>
					<td class="customTabActiveInActiveBrd">&nbsp;</td>
			          <td class="customTabActive">
			          	<div class="img_utility_guidedAnalytics"></div><div class='utilityBrowserText' title="<%= ResourceUtil.getLabel("arc.alt.ga", locale) %>" ><%= ResourceUtil.getLabel("arc.alt.ga", locale) %></div>
			          </td>
					<%} %>
			        </tr>
			      </table>
			      <!--TABLE FOR GUIDED TREE TAB HEADER ENDS-->
	  	  <!-- kpi tree start -->
     <div id="graphKPIViewCon"  class="innerTreePortlet" onmouseout="hideNmFltrToolTip('kpiNamedFilterPop');"> <div class="imgPortletBullet"></div> <a href="javascript:;" onclick="swapFilters('portletsSection')"> <%= ResourceUtil.getLabel("arc.search.kpi", locale) %></a>
        <div style="display:block; padding:3px 0px 0px 8px;">
          <div style="float:left;z-index:99">
            <input type="text" id="searchKPI" class="inputField"   onkeyup="javascript:if(!selEnt){arcGsearch.showResult(this,event)}" onkeypress="if (event.keyCode==13){selEnt=true;traverse(this.value, 'out_xml_rb.jsp?csrfPreventionSalt=${csrfPreventionSalt}&action=reportSubscription', tree4, 'searchKPI');arcGsearch.gsearchCloseResult('resultText1');}else{selEnt=false;}" onfocus="maf()"/>
			<div id="resultText1" class="resultContainer"  style="position:absolute;top:200px;*top:200px;left:24px;display:none" onkeydown="javascript:arcGsearch.gsearchkeydown(event);"></div>
          </div>
          <div style="padding-left:5px;">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td>
                  <div class="buttonGreyLeft" onclick="traverse(document.getElementById('searchKPI').value, 'out_xml_rb.jsp?action=reportSubscription&csrfPreventionSalt=${csrfPreventionSalt}', tree4, 'searchKPI');arcGsearch.gsearchCloseResult('resultText1');">
                    <div class="searchButtonText"> >> </div>
                    <div class="buttonGreyRight_M"></div>
                  </div>
                </td>
              </tr>
            </table>
          </div><br />
       </div>
        <div id="treeboxbox_tree4" onmousedown="treeClick()"></div>
        <script type="text/javascript">      	  
			function maf(){
					if (document.all)
						document.onselectstart = function () { return true; };
						return false;
				}

				function sunzDragTargetShow(val){
							if(val=="treeboxbox_tree4"){
								highlightTarget("dataGrid2","");
							}
							if(val=="treeboxbox_tree5"){
								highlightTarget("dataGrid3","");
							}
						}

						function sunzDragTargetHide(){
							highlightTarget("","dataGrid2,dataGrid3");
						}

				function s_control4()
				{
					this._drag=function(sourceHtmlObject,dhtmlObject,targetHtmlObject){
						if (dhtmlObject.parentObject.id != 'treeboxbox_tree4'){
							return;
						}
						if(!tree4.hasChildren(sourceHtmlObject.parentObject.id)){
							
							var kpiSize = '<%=linkKPISize%>';
							if($('dataGrid2Con').rows.length <= (parseInt(kpiSize)) && !isIdExists('dataGrid2Con',sourceHtmlObject.parentObject.id)){
								addItem(sourceHtmlObject.parentObject.label, $('dataGrid2Con'), sourceHtmlObject.parentObject.id,'seeAlsoKpis');
							}else{
								alert("<%= ResourceUtil.getMessage("arc.maximum.kpi.linked", linkKPISize, locale) %>");
								return false;
							}
						}
						if (document.all)
						document.onselectstart = function () { return true; };
						return true;
					}
					this._dragIn=function(htmlObject,shtmlObject){
						//htmlObject.className='tblBorderRed';
						return htmlObject;
					}

					this._dragOut=function(htmlObject){
						//htmlObject.className='tblBorder';
						return this;
					}
				}

				tree4=new dhtmlXTreeObject("treeboxbox_tree4","100%","200",0);
				tree4.setImagePath("dhtmlX/codebaseTree/imgs/kpi/");
				tree4.enableDragAndDrop(true);
				tree4.setDragHandler(maf);
				tree4.enableKeyboardNavigation(true);
				tree4.enableSmartXMLParsing(true);
				tree4.loadXML("out_xml_rb.jsp?action=reportSubscription"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt'));
				tree4.attachEvent("onDblClick",addDblClick4);
				tree4.enableAutoTooltips(false);
				tree4.allTree.onmouseover = function(e){showNmFltrToolTip('kpiNamedFilterPop',e);};
				$$(".containerTableStyle")[0].style.height="150px";
				var s1=new initgSearch('resultText1','searchKPI',"out_xml_rb.jsp?action=reportSubscription"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt'),tree4);

				function addDblClick4()
				{
					if(!tree4.hasChildren(tree4.getSelectedItemId())){
						var kpiSize = '<%=linkKPISize%>';
						if($('dataGrid2Con').rows.length <= (parseInt(kpiSize)) && !isIdExists('dataGrid2Con',tree4.getSelectedItemId())){
							addItem(tree4.getSelectedItemText(), $('dataGrid2Con'), tree4.getSelectedItemId(),'seeAlsoKpis');
						}else{
							alert("<%= ResourceUtil.getMessage("arc.maximum.kpi.linked", linkKPISize, locale) %>");
							return false;
						}
					}
				}
		</script>
      </div>

  <!-- kpi tree end -->
  <!--  Search Guided Analytics Tree End -->
   <div id="gaViewCon" class='innerTreePortlet' style="display:none;"  onmouseout="hideNmFltrToolTip('kpiNamedFilterPop');"> <div class="imgPortletBullet"></div> <a href="javascript:;" onclick="swapFilters('portletsSection')"><%= ResourceUtil.getLabel("arc.search.analytics", locale) %></a> <br />
        <div style="display:block; padding:3px 0px 0px 8px;">


		  <div style="float:left;position:relative;z-index:99;">
             <input type="text" id="searchGA" class="inputField"  onkeyup="javascript:if(!selEnt){arcGsearch.showResult(this,event)}" onkeypress="if (event.keyCode==13){selEnt=true;traverse(this.value, 'out_xml_ga.jsp?action=GuidedTree&csrfPreventionSalt=${csrfPreventionSalt}', tree5, 'searchGA');arcGsearch.gsearchCloseResult('resultText2');}else{selEnt=false;}" onfocus="maf()"/>
             <div id="resultText2" class="resultContainer"  onkeydown="javascript:arcGsearch.gsearchkeydown(event);"></div>
          </div>
	          <div style="float:left; padding-left:5px;">
	            <table border="0" cellspacing="0" cellpadding="0">
	              <tr>
	                <td>
	                  <div class="buttonGreyLeft" onclick="traverse(document.getElementById('searchGA').value, 'out_xml_ga.jsp?action=GuidedTree&csrfPreventionSalt=${csrfPreventionSalt}', tree5, 'searchGA');arcGsearch.gsearchCloseResult('resultText2');">
	                   <div class="searchButtonText" onfocus="maf()" > &gt;&gt; </div>
	                  <div class="buttonGreyRight_M"></div></div>
	                </td>
	              </tr>
	            </table>
	          </div> <br /><br /><br />
	        </div>
        <div id="treeboxbox_tree5" onmousedown="treeClick()"></div>
        <script type="text/javascript"><!--

				function s_control5()
				{
					this._drag=function(sourceHtmlObject,dhtmlObject,targetHtmlObject){
					if(isNaN(tree5.getSelectedItemId()))
						return false;
					if(!tree5.hasChildren(sourceHtmlObject.parentObject.id))
					{
						if (dhtmlObject.parentObject.id != 'treeboxbox_tree5'){
							return;
						}
						var gaoSize = '<%=linkKPISize%>';
						if($('dataGrid3Con').rows.length <= (parseInt(gaoSize)) && !isIdExists('dataGrid3Con',tree5.getSelectedItemId())){
							addItem(sourceHtmlObject.parentObject.label, $('dataGrid3Con'), sourceHtmlObject.parentObject.id,'linkGaoskpi');
							
						}else{
							alert("<%= ResourceUtil.getMessage("arc.maximum.guided.linked", linkKPISize, locale) %>");
							return false;
						}
					}

					if (document.all)
						document.onselectstart = function () { return true; };
						return true;
					}
					this._dragIn=function(htmlObject,shtmlObject){
						return htmlObject;
					}

					this._dragOut=function(htmlObject){
						return this;
					}
				}

				tree5=new dhtmlXTreeObject("treeboxbox_tree5","100%","244",0);
				tree5.setImagePath("dhtmlX/codebaseTree/imgs/kpi/");
				tree5.enableDragAndDrop(true);
				tree5.setDragHandler(maf);
				tree5.enableKeyboardNavigation(true);
				tree5.enableSmartXMLParsing(true);
				tree5.loadXML("out_xml_ga.jsp?action=GuidedTree"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt'));
				tree5.attachEvent("onDblClick",addDblClick5);
				tree5.enableAutoTooltips(false);
				tree5.allTree.onmouseover = function(e){showNmFltrToolTip('kpiNamedFilterPop',e);};


				function addDblClick5()
				{
					if(!tree5.hasChildren(tree5.getSelectedItemId()))
					{
						var gaoSize = '<%=linkKPISize%>';
						if($('dataGrid3Con').rows.length <= (parseInt(gaoSize)) && !isIdExists('dataGrid3Con',tree5.getSelectedItemId())){
							addItem(sourceHtmlObject.parentObject.label, $('dataGrid3Con'), sourceHtmlObject.parentObject.id,'linkGaoskpi');
							linkGaos = tree5.getSelectedItemId();
						}else{
							alert("<%= ResourceUtil.getMessage("arc.maximum.guided.linked", linkKPISize, locale) %>");
							return false;
						}
					}
				}
		--></script>
      </div>
    </div>
</div>

<div id="portletSecondPopup" style='margin-left:220px;' onclick="">
<div id="myReportsListing" class="portletSkin" style="height:270px; display:block">
			  <div class="portletHeader"><span class="subHeadingSmall"><%= ResourceUtil.getLabel("arc.see.also", locale) %> </span> <span class="contentGrey" style='font-weight:normal'><%= ResourceUtil.getLabel("arc.see.also.kpi.content", locale) %></span><br />
				  <div class="kpiUtilityBar" style="float:right"></div>
	  </div>

			 <div class="innerPortlet" id="filtersPortletMMDiv" style="display:block;"><span class="contentBlackBold"><%= ResourceUtil.getLabel("arc.list.selected.kpis", locale) %></span> <span class="contentGrey"><%= ResourceUtil.getLabel("arc.max.five.allowed", linkKPISize ,locale) %></span><br />
				<div id="dataGrid2" style="height:95px;overflow:hidden;overflow-y:auto;margin-bottom:4px" class="tblBorder">
			 	  <table id="dataGrid2Con" width="100%" cellspacing="1" cellpadding="4" style="background-color:#CCCCCC">
				  <tr style="display:none">
						<td width="4%" height="50px" class="tblRow1" ></td>
						<td width="96%" height="50px" class="tblRow1"></td>
	                  </tr>
			  </table>
			</div>
			<% if(isGAEnable!=null && isGAEnable.equalsIgnoreCase("yes")){%>
			<span class="contentBlackBold"><%= ResourceUtil.getLabel("arc.ga", locale) %></span>&nbsp;<span class="contentGrey"><%= ResourceUtil.getLabel("arc.max.five.allowed", linkKPISize ,locale) %></span><br />
			<div id="dataGrid3" class='tblBorder' style="height:95px;overflow:hidden; overflow-y:auto">
			 	  <table id="dataGrid3Con" width="100%" cellspacing="1" cellpadding="4" style='background-color:#ccc;'>
				   <tr style='display:none'>
                        <td width="4%" align="center" class="tblRow1"></td>
                        <td width="96%" height="50px" class="tblRow1"></td>
                    </tr>
			  </table>
			</div>
			<%} %>
	  </div>
    </div>
  </div>

	</div>
</div>

<!--End Harish Added Linking KPI And Guided To Alerts -->
	</div>

	 <div id="recipients" name="Recipients <span class='contentRed'>*</span>" style="padding:10px; display:none" width="100">
		<table width="100%" border="0" cellspacing="2" cellpadding="4" class="tblBorder" id="autoRefresh" style="display:table">
		  <tr>
			<td width="20%" align="left" valign="top" class="tblLabel"><%= ResourceUtil.getLabel("arc.select.recepients", locale) %><span class='contentRed' style="padding:5px;">*</span></td>
			<td width="40%" class="tblContent"><input type="radio" value="roles" name="recipient" onclick="setSearchVal();setDivID();showRecipients('roleListing');searchColumn();if(document.getElementById('txtSearchID').style.display='none'){document.getElementById('txtSearchID').style.display='block'}"/>
			  <%= ResourceUtil.getLabel("arc.role", locale) %>
			  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  <input type="radio"  name="recipient" checked="checked" value="userid" onclick="setSearchVal();setDivID();showRecipients('userListing');searchColumn();if(document.getElementById('txtSearchID').style.display='none'){document.getElementById('txtSearchID').style.display='block'}"/>
			  <%= ResourceUtil.getLabel("arc.user", locale) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  <input name="recipient" value="extuserid" type="radio" onclick="setSearchVal();setDivID();showRecipients('externalID');searchColumn();if(document.getElementById('txtSearchID').style.display='block'){document.getElementById('txtSearchID').style.display='none'}"/>
			  <%= ResourceUtil.getLabel("arc.external.user.id", locale) %> 
			  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			   </td>
			   
		        <td width="40%"  class="tblContent">
		        <input type="text" class="auto-suggest-search-fld-ghost"  name="searchValue" id="txtSearchID" onkeypress = "if (event.keyCode==13){searchColumn();}"  onfocus="if(this.value == 'Search User/Role') {this.value = '';this.className='auto-suggest-search-fld'}" onblur="if(this.value == ''){this.value = 'Search User/Role';this.className='auto-suggest-search-fld-ghost'}" autocomplete="off" value="Search User/Role"/>
		        </td>
		      
		  </tr>		 
     </table>

		<br />
		<%
		PermissionDbEvaluator pdb= new PermissionDbEvaluator();
    	ArrayList role_names=pdb.getGroups((pageRole-1)*recordsPerPageR, recordsPerPageR,request);
		%>
		<div id="roleListing" style="display:none">
			<div id="dataGrid1">
			  <table width="100%" cellspacing="1" cellpadding="4" id="roleListingTbl" style="background-color:#CCCCCC">
			  <tr>
				<td width="25">
				<span title="<%= ResourceUtil.getLabel("arc.select.this.page", locale) %>">
           		 <input  type="checkbox" name="roleChk" id="roleChk" value="checkbox" onclick="selectPageCheckBoxesRole('<%=pageRole%>');"/>
            </span>
            </td>
            
           
          	<td style="text-align:left"><span title="<%= ResourceUtil.getLabel("arc.select.all.pages", locale) %>" style="float:left;"><input type="checkbox" name="selctAllchkBxRole" id = "selctAllchkBxRole" onclick="selectAllRecordsRole('<%=selectAlltotalRole%>');"/>  </span> 
				<%= ResourceUtil.getLabel("arc.role.listing", locale) %> </td>
			  </tr>
			  <%
				
			  	for(int i=0;i<role_names.size();i++){
					String name =(String)role_names.get(i);
					String roleSelected = "";
					if(roleList != null && roleList.contains(name)){
						roleSelected = "checked";
					}else{
						roleSelected = "";
					}
				%>
				<% int present = 0;%>
				
				<tr> <td align="center">
						 <input type="checkbox" name="roleID" id="roleID" value="<%=name%>" onclick="GetSelectedRole(this,'<%=present%>');"/>
						 </td>
						 
							<td><%=name%></td>
						</tr >
					
				<%
				}%>

			  </table>
			
			</div>
			 <div id="pagination" class="pagination">
			 <div style="float:left; width:200px; text-align:left;" id="recinfoArea"></div>
			 <% 
				
				Integer temptotRole = (Integer)session.getAttribute("GET_ROLE_TOT_RECORDS");
				Double pageCountRole =(double) temptotRole / recordsPerPageR;
				 noOfPagesRole = (int)  Math.ceil(pageCountRole);			 
				%>
				
				<input id="pagesRole" name="pagesRole" type="hidden" value= '<%=noOfPagesRole%>' />
				
					<div style="float:left;min-width:20%;" id="totalRecDivRole">
						<%= ResourceUtil.getLabel("arc.results", locale) %>&nbsp;&nbsp;<%=pageRole%>-<%=recordsPerPageR%>&nbsp;&nbsp;<%= ResourceUtil.getLabel("arc.of", locale) %>&nbsp;&nbsp;<%=selectAlltotalRole%> 
					</div>
	        		
	        			<div style="float:left;min-width:20%;" id="itemCountDivRole">
						0 &nbsp;<%= ResourceUtil.getLabel("arc.user.itemselected", locale) %>
					</div>
	        		
	        		
				<div style="float:left;" id="noOfPageSizeRole">
					<% if(pageRole == 1){%>
							 		<span title="First" class='contentBlackBold'> &lt;&lt;&nbsp;</span><span title="Previous" class='contentBlackBold'>&lt;&nbsp;&nbsp;</span>				
							 <%}else{ %>
							 		<span title="First" class='contentBlackBold'><a href="#" id="FirstPage"  onclick="javascript:loadFirstPage();"> &lt;&lt;&nbsp; </a></span>
									<span title="Previous" class='contentBlackBold'><a href="#" id="Previous"  onclick="javascript:loadPreviousPage();"> &lt;&nbsp;&nbsp;</a> 
							  <%}%>
					</div>
					<div style="float:left;min-width:7%;" id="traceCurrentPageDivRole">
	        			<%= ResourceUtil.getLabel("arc.page", locale) %>&nbsp;&nbsp;<%=pageRole%>&nbsp;&nbsp;<%= ResourceUtil.getLabel("arc.of", locale) %>&nbsp;&nbsp;<%=noOfPagesRole%>  
					</div>
				<div style="float:left;min-width:15%;" id="noOfPageSize1Role">		
							  
							  <% if(pageRole == noOfPagesRole){%>
							  		<span title="Next" class='contentBlackBold'>&gt;&nbsp;</span>
							  		<span title="Last" class='contentBlackBold'>&gt;&gt;</span>
							  <%}else{%>
							    	<span title="Next" class='contentBlackBold'><a href="#" id="Next"  onclick="javascript:loadNextPage();"> &gt;</a> </span>
									<span title="Last" class='contentBlackBold'><a href="#" id="LastPage"  onclick="javascript:loadLastPage();"> &nbsp;&gt;&gt; </a> </span>
	        					<%}%>
				 			  
				</div>
				
				<div style="float:left;" id="gotoDivRole">
				<table border="0" cellspacing="0" cellpadding="0">
				<tr><td><%= ResourceUtil.getLabel("arc.page", locale) %></td><td>&nbsp;</td>
					<td>
					<input type="text" align="right" class="inputField" id="grid_rec_pageNoRole" name="grid_rec_pageNoRole" size="3" maxlength="5" onkeypress="return maskNumeric(event);" onkeyup="maskNumericEnter(event,'<%=noOfPagesRole%>');" />
					</td>
					<td><div  class="buttonBlueLeft" style="float:left" onclick="onClickGo('<%=noOfPagesRole%>');">
							<div class="buttonText"> <%= ResourceUtil.getLabel("arc.go", locale) %> </div>
					<div class="buttonBlueRight_M"></div>					
				</td></tr></table>			
				</div>
				
				
	        	<div style="float:right;" id="dropDownDivRole"> 
	        		<span> <%= ResourceUtil.getLabel("arc.show", locale) %>
	        				<select id="bcmp_gridPagingRole" name ="pageSizeSelectRole" class="inputField" onchange="onChangePageSize();">
				 					<option value=50>50</option>
				 					 <option value=100>100</option>
				  					<option value=200>200</option>
				  					<option value=500>500</option>
				  					
				</select>
				 
	          				<%= ResourceUtil.getLabel("arc.per.page", locale) %>
	          	</span> 
	          	</div>
			
			 
				
				<div style="text-align:center;" id="pagingArea"></div>
			 </div>
		</div>


<script type="text/javascript">
tableDivInner4 = document.getElementById("dataGrid1").innerHTML;
var mygridrole=convertToDhtmlxRoleGrid("dataGrid1","roleListingTbl");

function convertToDhtmlxRoleGrid(parentContainerId,tblId){
     document.getElementById(parentContainerId).innerHTML="";
	 document.getElementById(parentContainerId).innerHTML=tableDivInner4;
	 document.getElementById("pagingArea").innerHTML="";
 	 document.getElementById("recinfoArea").innerHTML="";
     var mygrid1 = null;

	 mygrid1 = new dhtmlXGridFromTable(tblId);
	 mygrid1.setImagePath("dhtmlX/codebaseGrid/imgs/");
	 mygrid1.setSkin("light");
	 mygrid1.enableAutoHeight(true,250,true);
	 mygrid1.setInitWidthsP("5,95");
	 mygrid1.setColTypes("ro,ro");
	 mygrid1.setColSorting("na,str");
	 mygrid1.enableAlterCss("tblRow1","tblRow2");		
	 mygrid1.setSizes();
	 return mygrid1;
}

</script>
<div id="userListing" style="display:none">
<div id="dataGrid2User"><table cellspacing="1" width="100%" cellpadding="4" border="0">
<table id="userListingTbl" cellspacing="0" cellpadding="0" border="0" width="100%">
		<tr>
		<td width="25"><span title="<%= ResourceUtil.getLabel("arc.select.this.page", locale) %>"><input  type="checkbox" name="userChk" id="userChk"  onclick="selectPageCheckBoxes('<%=page1%>');"/></span></td>
		<td style="text-align:left"><span title="<%= ResourceUtil.getLabel("arc.select.all.pages", locale) %>" style="float:left;" onclick="if (event.stopPropagation) { event.stopPropagation();   } else { event.cancelBubble = true; }"><input type="checkbox" name="selctAllchkBx" id = "selctAllchkBx" onclick="selectAllRecords('<%=selectAlltotal%>');"/> </span><%= ResourceUtil.getLabel("arc.user.listing", locale) %> </td>
		</tr>
  
      <% 
      	AdminController admcontroller = new AdminController();
    	java.util.Map userDetailsMap = admcontroller.getUserGroupsHashMap((page1-1)*recordsPerPage1, recordsPerPage1,request);
  	
  	  	for (Iterator itr =userDetailsMap.keySet().iterator(); itr.hasNext(); ){
			Object key = itr.next();
			AdminDataHolder admindataholder = (AdminDataHolder) userDetailsMap.get(key);
			UserData userData = (UserData) admindataholder.getUserdata();
			String user_id = ""+userData.getUserid();
			String userName = key.toString();
		%>			
		<% int present = 0;%>
  	<tr>
  	 <td align="center"><input type="checkbox" name="userID" id="userID" value="<%=user_id%>" onclick="GetSelectedUser(this,'<%=present%>');"/></td>
		<td><%=userName%></td>
	</tr>
	
	<%
		}
    %>
    </table>
</div>

	 <div id="pagination" class="pagination">
	 <div style="float:left; width:200px; text-align:left;" id="recinfoArea1"></div>
	 <% 
		Integer temptot = (Integer)session.getAttribute("GET_TOTAL_RECORDS");
		Double pageCount =(double) temptot / recordsPerPage1;
		 noOfPages = (int)  Math.ceil(pageCount);			 
		%>
		
		<input id="pages" name="pages" type="hidden" value= '<%=noOfPages%>' />
		
		<div style="float:left;min-width:20%;" id="totalRecDiv">
			<%= ResourceUtil.getLabel("arc.results", locale) %>&nbsp;&nbsp;<%=page1%>-<%=recordsPerPage1%>&nbsp;&nbsp;<%= ResourceUtil.getLabel("arc.of", locale) %>&nbsp;&nbsp;<%=selectAlltotal.intValue()%> 
		</div>
		
			<div style="float:left;min-width:20%;" id="itemCountDiv">
			0 &nbsp;<%= ResourceUtil.getLabel("arc.user.itemselected", locale) %>
		</div>
	
		<div style="float:left;" id="noOfPageSize">
					<% if(page1 == 1){%>
				 		<span title="First" class='contentBlackBold'> &lt;&lt;&nbsp;</span><span title="Previous" class='contentBlackBold'>&lt;&nbsp;&nbsp;</span>				
				 <%}else{ %>
				 		<span title="First" class='contentBlackBold'><a href="#" id="FirstPage"  onclick="javascript:loadFirstPage();"> &lt;&lt;&nbsp; </a></span>
						<span title="Previous" class='contentBlackBold'><a href="#" id="Previous"  onclick="javascript:loadPreviousPage();"> &lt;&nbsp;&nbsp;</a> 
				  <%}%>
		</div>
		<div style="float:left;min-width:7%;" id="traceCurrentPageDiv">
			<%= ResourceUtil.getLabel("arc.page", locale) %>&nbsp;&nbsp;<%=page1%>&nbsp;&nbsp;<%= ResourceUtil.getLabel("arc.of", locale) %>&nbsp;&nbsp;<%=noOfPages%>  
		</div>
				<div style="float:left;min-width:15%;" id="noOfPageSize1">		
				  
						  <% if(page1 == noOfPages){%>
						  		<span title="Next" class='contentBlackBold'>&gt;&nbsp;</span>
						  		<span title="Last" class='contentBlackBold'>&gt;&gt;</span>
						  <%}else{%>
						    	<span title="Next" class='contentBlackBold'><a href="#" id="Next"  onclick="javascript:loadNextPage();"> &gt;</a> </span>
								<span title="Last" class='contentBlackBold'><a href="#" id="LastPage"  onclick="javascript:loadLastPage();"> &nbsp;&gt;&gt; </a> </span>
							<%}%>
	 			  
					</div>
					
					<div style="float:left;" id="gotoDiv">
					<table border="0" cellspacing="0" cellpadding="0">
					<tr><td><%= ResourceUtil.getLabel("arc.page", locale) %></td><td>&nbsp;</td>
						<td>
						<input type="text" align="right" class="inputField" id="grid_rec_pageNo" name="grid_rec_pageNo" size="5" maxlength="5" onkeypress="return maskNumeric(event);" onkeyup="maskNumericEnter(event,'<%=noOfPages%>');" />
						</td>
						<td><div  class="buttonBlueLeft" style="float:left" onclick="onClickGo('<%=noOfPages%>','<%=page1%>');">
								<div class="buttonText"> <%= ResourceUtil.getLabel("arc.go", locale) %> </div>
						<div class="buttonBlueRight_M"></div>					
					</td></tr></table>			
					</div>
					
		
		<div style="float:right;" id = "dropDownDiv"> 
		<span> <%= ResourceUtil.getLabel("arc.show", locale) %>
				<select id="bcmp_gridPaging" name ="pageSizeSelect" class="inputField" onchange="onChangePageSize();">
	 					<option value=50>50</option>
	 					 <option value=100>100</option>
	  					<option value=200>200</option>
	  					<option value=500>500</option>
	  			</select>
	  			<%= ResourceUtil.getLabel("arc.per.page", locale) %>
  	</span> 
  	</div>
  	
		<div style="text-align:center;" id="pagingArea1"></div>
	 </div>
</div>


<script type="text/javascript">
tableDivInner1 = document.getElementById("dataGrid2User").innerHTML;
var mygriduser=convertToDhtmlxGridReport("dataGrid2User","userListingTbl");

function convertToDhtmlxGridReport(parentContainerId,tblId){

     document.getElementById(parentContainerId).innerHTML="";
	 document.getElementById(parentContainerId).innerHTML=tableDivInner1;
	 document.getElementById("pagingArea1").innerHTML="";
 	 document.getElementById("recinfoArea1").innerHTML="";
     var mygrid1 = null;
	 mygrid1 = new dhtmlXGridFromTable(tblId);
	 mygrid1.setImagePath("dhtmlX/codebaseGrid/imgs/");
	 mygrid1.setSkin("light");
	 mygrid1.enableAutoHeight(true,250,true);
	 mygrid1.setInitWidthsP("5,95");
	 mygrid1.setColTypes("ro,ro");
	 mygrid1.setColSorting("na,str");
	 mygrid1.enableAlterCss("tblRow1","tblRow2");	
	 mygrid1.setSizes();
	 return mygrid1;
}





</script>

		<div id="externalID" style="display:none">
			<div style="float:left; "><span class="contentBlackBold"><%= ResourceUtil.getMessage("arc.enter.distribution.list.names", locale)%></span>
			</div>
			<div style="float:right; ">
			<div class="imgOutlook" title="Download From Outlook"></div>
			<a href="javascript:;" onclick="getOutlook(document.addAlertFrm);"><%= ResourceUtil.getMessage("arc.from.outlook", locale)%></a> &nbsp;&nbsp;

			</div>
			<textarea name="recipientsEmail" cols="" rows="18" style="width:100%; font-size:11px;" class="inputField" onmouseover="javascript:document.oncontextmenu=function(){return true}" onmouseout="javascript:document.oncontextmenu=function(){return false}"></textarea>
			<span class="contentGrey"> <%= ResourceUtil.getMessage("arc.comma.seperated.values", locale)%></span>
		</div>
  </div>

  <div id="publishFormat" name="Publish Format <span class='contentRed'>*</span>" style="padding:10px;display:block" width="110">
  	<table width="100%" border="0" cellspacing="2" cellpadding="4" class="tblBorder" id="dashBoardPortlet" style="display:none">
      <tr><td class="tblLabel" align="center" nowrap valign="middle"><%= ResourceUtil.getMessage("arc.format.not.applicable.for.dashboard", locale)%></td></tr>
   </table>
   <div id="publishFrmt" style="display:block">
    <table width="100%" border="0" cellspacing="2" cellpadding="4" class="tblBorder" id="autoRefresh">
      <tr>
        <td width="20%" class="tblLabel"><%= ResourceUtil.getMessage("arc.publish.as", locale)%></td>
        <td width="80%" class="tblContent">
          <input type="radio" id="pdf" value="pdf" name="publishFormat" onclick="if(this.checked){document.getElementById('emailPanal').style.display='none'}"/>
          <%= ResourceUtil.getLabel("arc.by.pdf", locale)%>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="radio" name="publishFormat" id="excel" value="excel" onclick="if(this.checked){document.getElementById('emailPanal').style.display='none'}"/>
          <%= ResourceUtil.getLabel("arc.by.excel", locale)%>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input name="publishFormat" type="radio" id="html" value ="html" onclick="if(this.checked){document.getElementById('emailPanal').style.display='none'}"/>
          <%= ResourceUtil.getLabel("arc.by.html", locale)%>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input name="publishFormat" type="radio"  id="email" value="email" onclick="if(this.checked){document.getElementById('emailPanal').style.display='block';}"/>
          <%= ResourceUtil.getLabel("arc.by.email", locale)%></td>
      </tr>
    </table>
    </div>
</div>
	<br />


<div id="emailPanal" style="display:;position: absolute; z-index: 9999;width: 97%; top: 93px; left: 10px;">
		<%= ResourceUtil.getMessage("arc.mail.information.location", locale)%>
		<script language="JavaScript" type="text/javascript">
		<!--
	
		initRTE("./images/rte_images/", "./rte_control/", "./rte_control/", false);

		//build new richTextEditor
		var rte1 = new richTextEditor('rte1');
		richTextEditor.prototype.rebuild=reloadMyLocalize;
		rte1.html = '';

		//enable all commands for demo
		rte1.width="100%";
		rte1.height="230";
		rte1.cmdFormatBlock = true;
		rte1.cmdFontName = true;
		rte1.cmdFontSize = true;

		rte1.cmdBold = true;
		rte1.cmdItalic = true;
		rte1.cmdUnderline = true;
		rte1.cmdStrikethrough = false;
		rte1.cmdSuperscript = false;
		rte1.cmdSubscript = false;

		rte1.cmdJustifyLeft = true;
		rte1.cmdJustifyCenter = true;
		rte1.cmdJustifyRight = true;
		rte1.cmdJustifyFull = true;

		rte1.cmdInsertHorizontalRule = true;
		rte1.cmdInsertOrderedList = true;
		rte1.cmdInsertUnorderedList = true;

		rte1.cmdOutdent = true;
		rte1.cmdIndent = true;
		rte1.cmdForeColor = true;
		rte1.cmdHiliteColor = true;
		rte1.cmdInsertLink = false;
		rte1.cmdInsertImage = false;
		rte1.cmdInsertSpecialChars = false;
		rte1.cmdInsertTable = false;
		rte1.cmdSpellcheck = false;

		rte1.cmdCut = true;
		rte1.cmdCopy = true;
		rte1.cmdPaste = true;
		rte1.cmdUndo = true;
		rte1.cmdRedo = true;
		rte1.cmdRemoveFormat = false;
		rte1.cmdUnlink = false;
	
        rte1.build();
        rte1.rebuild();
	
        $('toolbar1_rte1').parentNode.parentNode.parentNode.parentNode.style.background = "#ffffff";

		var formattedDropdown=document.getElementById("formatblock_rte1");
		var fontDropdown=document.getElementById("fontname_rte1");
		var fontSizeDropdown=document.getElementById("fontsize_rte1");

		if(formattedDropdown.addEventListener)
			formattedDropdown.addEventListener("onchange", formattedDropdownMethod, true);
		if(fontDropdown.addEventListener)
			fontDropdown.addEventListener("onchange", fontDropdownMethod, true);
		if(fontSizeDropdown.addEventListener)
			fontSizeDropdown.addEventListener("onchange", fontSizeDropdownMethod, true);

		document.getElementById("chkSrcrte1").parentNode.innerHTML=document.getElementById("chkSrcrte1").parentNode.innerHTML.replace('View Source','<%=ResourceUtil.getLabel("arc.rs.alert.email.publish.format.viewsource",locale)%>');
		document.getElementById("publishFormat").style.display="none";
		document.getElementById("emailPanal").style.display="none";
	//}
		function formattedDropdownMethod()
		{	var tmp=event.srcElement.value;
			selectFont('rte1', event.srcElement.id);
			event.srcElement.value=tmp;
			return false;
		}
		function fontDropdownMethod()
		{	var tmp=event.srcElement.value;
			selectFont('rte1', event.srcElement.id);
			event.srcElement.value=tmp;
			return false;
		}
		function fontSizeDropdownMethod()
		{	var tmp=event.srcElement.value;
			selectFont('rte1', event.srcElement.id);
			event.srcElement.value=tmp;
			return false;
		}

	var putHourAlert = document.addAlertFrm.startHours.value;
	var putMinAlert = document.addAlertFrm.startMins.value;

	function afterETLFun(chk){
	  if(chk.checked){
		document.addAlertFrm.startHours.value = '00';
		document.addAlertFrm.startMins.value = '00';
		document.addAlertFrm.startHours.disabled = true;
		document.addAlertFrm.startMins.disabled = true;
		//document.addAlertFrm.recurrence[3].disabled=true;
		document.addAlertFrm.recurrence[4].disabled=true;
		/*if(document.addAlertFrm.recurrence[3].checked){
			document.addAlertFrm.recurrence[3].checked=false;
		}
		if(document.addAlertFrm.recurrence[4].checked){
			document.addAlertFrm.recurrence[4].checked=false;
		}*/
		//document.addAlertFrm.recurrence[0].checked=true;
		if(document.addAlertFrm.daily[2].checked){
			document.getElementById('ddays').value='';
			document.getElementById('ddays').disabled=true;
			document.addAlertFrm.daily[0].checked=true;
		}

		/*document.getElementById("onetime").style.display = "none";
		document.getElementById("monthly").style.display = "none";
		document.getElementById("weekly").style.display = "none";
		document.getElementById("daily").style.display = "block";
		 */
		 if(document.addAlertFrm.recurrence[4].checked ) {
		 	//document.addAlertFrm.recurrence[3].checked =false;
		 	document.addAlertFrm.recurrence[4].checked =false;
		 	document.addAlertFrm.recurrence[0].checked=true;
			showRecurr('daily');
		}
		document.addAlertFrm.daily[2].disabled=true;
	}else if(!chk.checked){
		document.addAlertFrm.startHours.value=putHourAlert;
		document.addAlertFrm.startMins.value=putMinAlert;
		document.addAlertFrm.daily[2].disabled=false;
		document.addAlertFrm.startHours.disabled = false;
		document.addAlertFrm.startMins.disabled = false;
		//document.addAlertFrm.recurrence[3].disabled=false;
		document.addAlertFrm.recurrence[4].disabled=false;
		//showRecurr('daily');
	}
}
		</script>



  </div>
</div>
<script type="text/javascript">

	tableDivInnerga = $("gaDataGrid").innerHTML;
	var mygridGuided=convertToDhtmlxGuidedGrid('gaDataGrid','guidedata','10');
	/******************************************************************/
	function convertToDhtmlxGuidedGrid(parentContainerId,tblId,pageval){
         document.getElementById(parentContainerId).innerHTML="";
		 document.getElementById(parentContainerId).innerHTML=tableDivInnerga;
		 //document.getElementById("pagingArea1").innerHTML="";
	 	 //document.getElementById("recinfoArea1").innerHTML="";
	     var mygrid1 = null;
		 mygrid1 = new dhtmlXGridFromTable(tblId);
		 mygrid1.setImagePath("dhtmlX/codebaseGrid/imgs/");
		 mygrid1.setSkin("light");
		 mygrid1.enableAutoHeight(true,250,false);
		 mygrid1.setInitWidthsP("10,*");
		 mygrid1.setColTypes("ro,ro");
		 mygrid1.enableAlterCss("tblRow1","tblRow2");
		// mygrid1.enablePaging(true,pageval,3,"pagingArea1",true,"recinfoArea1");
		 mygrid1.setSortImgState("true",1,"asc");
		 mygrid1.sortRows(1,"str","asc");
		 mygrid1.setColSorting("na,str");
		 return mygrid1;
	}
</script>
<script language="javascript">
loadExp();
showRecurr('oneTime');
showRecipients('userListing');
parent.document.getElementById('poupButtons').innerHTML = document.getElementById('thisPageButtons').innerHTML;
parent.document.getElementById('mandatorySection').innerHTML = '<%= ResourceUtil.getMessage("arc.tabs.marked.mandatory", locale)%>';
            popupTabber=new dhtmlXTabBar("alertTabbar","top");
            popupTabber.setImagePath("dhtmlX/codebaseTab/imgs/");
            popupTabber.addTab("general","<%=ResourceUtil.getLabel("arc.general",locale) %> &nbsp;<span class='contentRed'>*</span>","100px");
            popupTabber.addTab("Schedule","<%=ResourceUtil.getLabel("arc.rs.tabber.name.schedule",locale) %> &nbsp;<span class='contentRed'>*</span>","100px");
            popupTabber.addTab("delivery","<%=ResourceUtil.getLabel("arc.rs.tabber.name.delivery",locale) %> &nbsp;<span class='contentRed'>*</span>","100px");
            popupTabber.addTab("recipients","<%=ResourceUtil.getLabel("arc.rs.tabber.name.recipients",locale) %> &nbsp;<span class='contentRed'>*</span>","100px");
            popupTabber.addTab("publishFormat","<%=ResourceUtil.getLabel("arc.rs.tabber.name.publish.format",locale) %>  &nbsp;<span class='contentRed'>*</span>","100px");
            popupTabber.setContent("general","general");
            popupTabber.setContent("Schedule","Schedule");
            popupTabber.setContent("delivery","delivery");
            popupTabber.setContent("recipients","recipients");
            popupTabber.setContent("publishFormat","publishFormat");
            popupTabber.setTabActive("general");
			popupTabber.attachEvent("onSelect",selectedTabber1);
			document.getElementById("alertNameTxt").focus();
			setDefaults();			
			function selectedTabber1(idn,no){
			if(idn=="general"){
				document.getElementById("general").style.display="";
				document.getElementById("Schedule").style.display="none";
				document.getElementById("delivery").style.display="none";
				document.getElementById("recipients").style.display="none";
				document.getElementById("publishFormat").style.display="none";
				document.getElementById("emailPanal").style.display="none";

			}else if(idn=="Schedule"){
				document.getElementById("general").style.display="none";
				document.getElementById("Schedule").style.display="";
				document.getElementById("delivery").style.display="none";
				document.getElementById("recipients").style.display="none";
				document.getElementById("publishFormat").style.display="none";
					document.getElementById("emailPanal").style.display="none";

			}else if(idn=="delivery"){
				document.getElementById("general").style.display="none";
				document.getElementById("Schedule").style.display="none";
				document.getElementById("delivery").style.display="";
				document.getElementById("recipients").style.display="none";
				document.getElementById("publishFormat").style.display="none";
					document.getElementById("emailPanal").style.display="none";

			}else if(idn=="recipients"){
				document.getElementById("general").style.display="none";
				document.getElementById("Schedule").style.display="none";
				document.getElementById("delivery").style.display="none";
				document.getElementById("recipients").style.display="";
				document.getElementById("publishFormat").style.display="none";
					document.getElementById("emailPanal").style.display="none";

			}else if(idn=="publishFormat"){
				document.getElementById("general").style.display="none";
				document.getElementById("Schedule").style.display="none";
				document.getElementById("delivery").style.display="none";
				document.getElementById("recipients").style.display="none";
				document.getElementById("publishFormat").style.display="";

				 // Issue 2574 - configurable email utility - Ayeesha


			}
			return true;
			}

	function selectedTabber(idn,ido){
	    if(idn!="publishFormat"){
	        document.getElementById('emailPanal').style.display='none';
		}else{
			if(document.addAlertFrm.publishFormat[3].checked==true && $('publishFrmt').style.display=='block'){
		        document.getElementById('emailPanal').style.display='block';
			}
		}
        return true;
    };


 // Added by Manoj babu for Hiding the Date picker on body click
 window.document.body.onclick=function(e){
  if (window.event) e = window.event;  var src = e.srcElement? e.srcElement : e.target;
 //var src=src.srcElement;
 var DatePicker = document.getElementById('gToday:jsDateNormal_DFM:jsDateAgenda.js');
	if(src.className!="imgDatePicker")
	 {
		 if(DatePicker && DatePicker.style.visibility =='visible')
		 {
		 	DatePicker.style.visibility = 'hidden';
		 	return;
		 }
	 }
 }


	// for first time

function emaildeliveryCheck(deliveryObj,emailObj){
	//31891-Option required to deliver alerts to user in dashboards (without sending mails)
	var enabDisbElems = new Object();
	var selDeselElems = new Object();
	if(deliveryObj.checked && !emailObj.checked){
		$('emailDiv').style.display='none';
		$('dashBoardPortlet').style.display='none';
		$('publishFrmt').style.display='block';

	}else{
		if(!emailObj.checked){
			$('emailDiv').style.display='none';
			selDeselElems["userid"] = true;
			selDeselElems["extuserid"] = false;
			var recipientArr = document.getElementsByName("recipient");
			if(undefined!=recipientArr && null!=recipientArr){
				var recArrLen = recipientArr.length;
				for(var k=0;k<recArrLen;k++){
					if(undefined !=recipientArr[k] && "extuserid"== recipientArr[k].value && recipientArr[k].checked == true){
						selDeselFields("recipient",selDeselElems);
						setSearchVal();
						setDivID();
						showRecipients('userListing');
						searchColumn();
						if(document.getElementById('txtSearchID').style.display='none'){
							document.getElementById('txtSearchID').style.display='block';
						}
					}
				}
			}
			enabDisbElems["extuserid"] = true;
			enableDisableFields("recipient", enabDisbElems);
		}else{
			$('emailDiv').style.display='block';
			enabDisbElems["extuserid"] = false;
			enableDisableFields("recipient", enabDisbElems);
		}
		$('dashBoardPortlet').style.display='none';
		$('publishFrmt').style.display='block';
	}
}
function disableEmailHtml(flag){
	if(flag){
		if(document.addAlertFrm.publishFormat[2].checked==true ||document.addAlertFrm.publishFormat[3].checked==true){
			document.addAlertFrm.publishFormat[0].checked=true;
		}
		document.getElementById('html').disabled = true;
		document.getElementById('email').disabled = true;
		document.getElementById('emailPanal').style.display='none';
	}else{
		document.getElementById('html').disabled = false;
		document.getElementById('email').disabled = false;

	}
}
function setDefaults(){
	if(default_attachment!=null && default_attachment!=''){
		if(default_attachment=='0'){
				document.getElementById('pdf').checked = true;
		}else if(default_attachment=='1'){
				document.getElementById('excel').checked = true;
		}else if(default_attachment=='2'){
				document.getElementById('html').checked = true;
		}else if(default_attachment=='3'){
				document.getElementById('email').checked = true;
		}
	}
}
setDefaults();

		// Added by Harish - For Drag & Drop Feature for KPI And Guided DHTMLX Tree
		var sinput1=document.getElementById('dataGrid2');
		tree4.dragger.addDragLanding(sinput1, new s_control4);
		var sinput2=document.getElementById('dataGrid3');
		tree5.dragger.addDragLanding(sinput2, new s_control5);
		gblTabFix();
		
		if(BrowserDetect.browser=='Explorer' || BrowserDetect.browser=='Mozilla'){
			document.getElementById("metricsBrowser").style.height = "267px";
		}

</script>
<input type="hidden" id="hdSelected" name="hdSelected" value=""/>
<input type="hidden" id="hdnPageFlg" name="hdnPageFlg" value=""/>
<input type="hidden" id="hdSelectedRole" name="hdSelectedRole" value=""/>
<input type="hidden" id="hdnPageFlgRole" name="hdnPageFlgRole" value=""/>

<input type="hidden" id="hdnDiv" name="hdnDiv" value=""/>
<input type="hidden" id="hdnTabDiv" name="hdnTabDiv" value=""/>

<input type="hidden" id="paramDiv" name="paramDiv" value=""/>

</form>
</body>
</html>

<script>
setDivID();

</script>
