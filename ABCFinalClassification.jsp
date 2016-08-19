<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="dm.ca.campaign.helper.CampaignMDMHelper"%>
<%@ page import="org.fourfive.config.security.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@page import="dm.ca.campaign.dbutil.CampaignMDMDbUtil"%>
<%
com.manthan.promax.security.SecurityEngine.isSessionOver(request,response,"login.jsp");
%>
<!-- Added include JSP's for Localization -->
<%@ include file="userSession.jsp" %>
<%@ include file="scriptLocalize.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

		<meta http-equiv="Content-Type" content="text/html; charset=<%= session.getAttribute("CHARSET").toString()%>" />
		<title><%= com.manthan.promax.security.schmail.Mailer.getPropValue("arc.title").toString()%> - <%=ResourceUtil.getLabel("arc.listgen.campaign", locale)%></title>
		<link href="css/style<%=userSelectedTheme%>.less" rel="stylesheet/less" type="text/css" />
		<script language="javascript" type="text/javascript" src="js/less.js"></script>
		<script language="javascript" type="text/javascript" src="js/general.js"></script>
		<script language="javascript" type="text/javascript" src="js/script.js"></script>
		<script language="javascript" type="text/javascript" src="js/publish.js"></script>
		<script language="javascript" type="text/javascript" src="js/drag.js"></script>
		<!--DHTMLX STARTS-->
		<!--TAB-->
		<link rel="STYLESHEET" type="text/css" href="dhtmlX/codebaseTab/dhtmlxtabbar.css"/>
		<script type="text/javascript" src="dhtmlX/codebaseTab/dhtmlxcommon.js"></script>
		<script type="text/javascript" src="dhtmlX/codebaseTab/dhtmlxtabbar.js"></script>
		<script type="text/javascript" src="dhtmlX/codebaseTab/dhtmlxtabbar_start.js"></script>
		<!--TREE GRID-->
		<link rel="STYLESHEET" type="text/css" href="dhtmlX/codebaseGrid/dhtmlxgrid.css"/>
		<script  src="dhtmlX/codebaseGrid/dhtmlxcommon.js"></script>
		<script  src="dhtmlX/codebaseGrid/dhtmlxgrid.js"></script>
		<script  src="dhtmlX/codebaseGrid/dhtmlxgridcell.js"></script>
		<script  src="dhtmlX/codebaseTreeGrid/dhtmlxtreegrid.js"></script>
		<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_start.js"></script>
		<script src="dhtmlX/codebaseGrid/dhtmlxgrid_filter.js"></script>

		<!--GRID PAGENATION-->
		<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_pgn.js"></script>

		<!--TREE-->
		<link rel="STYLESHEET" type="text/css" href="dhtmlX/codebaseTree/dhtmlxtree.css"/>
		<script  src="dhtmlX/codebaseTree/dhtmlxtree.js"></script>
		<script  src="dhtmlX/codebaseTree/dhtmlxcommon.js"></script>
		<script  src="dhtmlX/codebaseTree/dhtmlxtree_kn.js"></script>
	<!--DHTMLX ENDS-->
<script language="javascript">
function saveData(){
	$('initatorList').value = collectAllRowIds("initiatorTable");
	$('managerList').value= collectAllRowIds("managerTable");
	var params = Form.serialize(document.form1);
	var url="campaignMDMHandler?nav_action=updateInitiatorAndManager"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
	new Ajax.Request(url,
	{
		method: 'post',
		parameters: params,
		onComplete: function(orgreq){
			orgreq.responseText.evalScripts();
		}
	});
}
function onNodeSelect1(val){
	// DO what ?
}

</script>
<script>
setDHTMLXTreeHeight("treeboxbox_tree1,treeboxbox_tree4","465,450",true);
var initatorUserIds='';
var initatorRolesIds='';
var managerUserIds='';
var managerRolesIds='';
</script>
</head>
<%
try{

	// Only user from Administrator  can Assign Users
	if(!CampaignMDMHelper.isUserFromAdministratorRole(request)){
		%>
		<script language="javascript" type="text/javascript">
		parent.killPopup();
		alert("<%=ResourceUtil.getMessage("arc.campaign.mdm.you.do.not.have.permission.to.assign.initiators.managers", locale)%>");
		</script>
		<%
		return;
	}

	Map<String,String> allDetails = CampaignMDMDbUtil.getAllInitiatorAndManager();

	if(allDetails != null && allDetails.get("initatorUserIdsStr") != null){
		%>
		<script>
		initatorUserIds = "<%=allDetails.get("initatorUserIdsStr")%>";
		</script>
		<%
	}
	if(allDetails != null && allDetails.get("initatorRolesIdsStr") != null){
		%>
		<script>
		initatorRolesIds = "<%=allDetails.get("initatorRolesIdsStr")%>";
		</script>
		<%
	}
	if(allDetails != null && allDetails.get("managerUserIdsStr") != null){
		%>
		<script>
		managerUserIds = "<%=allDetails.get("managerUserIdsStr")%>";
		</script>
		<%
	}
	if(allDetails != null && allDetails.get("managerRolesIdsStr") != null){
		%>
		<script>
		managerRolesIds = "<%=allDetails.get("managerRolesIdsStr")%>";
		</script>
		<%
	}
%>
<body onmousemove="updatebox(event)" onkeypress="escPopup(event)"  onload="parent.document.getElementById('poupButtons').innerHTML = document.getElementById('thisPageButtons').innerHTML">
<script language="javascript" type="text/javascript" src="js/customTooltipSetup.js"></script>
<script language="javascript" type="text/javascript" src="js/customCallout.js"></script>
<div id="kpiNamedFilterPop" style="display:none;"></div>
<form name="form1">
<input type="hidden" id="csrfPreventionSalt" name="csrfPreventionSalt" value="${csrfPreventionSalt}"/>
<div id="thisPageButtons" style="display:none">
  <div style="float:left">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
       <td><div class="buttonBlueLeft" onclick="popUpFrame.saveData();">
            <div class="buttonText" ><%=ResourceUtil.getLabel("arc.save", locale)%></div>
          <div class="buttonBlueRight_M"> </div></div></td>
        <td>&nbsp;</td>
        <td><div class="buttonBlueLeft" onclick="killPopup()">
            <div class="buttonText" ><%=ResourceUtil.getLabel("arc.cancel", locale)%></div>
          <div class="buttonBlueRight_M"> </div></div></td>
      </tr>
    </table>
  </div>
</div>
<div id="admain" style="float:none">
<br /><br />
<input type="hidden" name="initatorList" id="initatorList" value="" />
<input type="hidden" name="managerList" id="managerList" value="" />
<div id="portletLeft" style="height:500px;width:23%!important; display:block">
	<!-- DIV for both Dimension & Measure Browser Starts-->
	<div id="filterDimensionBrowser"  class="portletSkin">
	<!--TAB SELECT TABLES STARTS-->
	<table width="100%" border="0" cellspacing="0" cellpadding="0" id="dimensionView" style="display:block">
       	<tr>
        <td class="customTabInActive" onclick="javascript:glbTargetTree=tree;glbUsrClk=false;glbRoleClk=true;var s=new initgSearch('resultText','searchDimension','campaignMDMHandler?csrfPreventionSalt=${csrfPreventionSalt}&nav_action=getSecurityTree',tree);customTab('dimensionView');treeOpenSelectTimer();"><div class="img_utility_userRoleBrowser"></div><div class='utilityBrowserText' title='<%= ResourceUtil.getLabel("arc.roles.or.users.browser", locale)%>'><%= ResourceUtil.getLabel("arc.roless.users", locale)%></div></td>
        </tr>
    </table>
    <!--DIMENSION TREE IMPLEMENTATION STARTS -->
      					<div id="dimensionViewCon" style="display:block; width:96%; padding:3px 0px 0px 8px;" onmouseout="hideNmFltrToolTip('kpiNamedFilterPop');">
      						<div class="imgPortletBullet"></div>&nbsp;<a href="javascript:;" onclick="swapFilters('dimensionSection')"> <%=ResourceUtil.getLabel("arc.campaign.mdm.search.user", locale)%></a> <br />
      						<div id="dimensionSection" style="display:block; padding:3px 0px 0px 8px;position:relative;z-index:99;">
          						<div style="float:left;">
            						<input id='searchDimension' type="text" class="inputField" size="25" onkeyup="javascript:if(!selEnt){arcGsearch.showResult(this, event)}" onkeypress="if(event.keyCode==13){selEnt=true;traverse(this.value, 'campaignMDMHandler?csrfPreventionSalt=${csrfPreventionSalt}&nav_action=getSecurityTree', tree1, 'searchDimension');arcGsearch.gsearchCloseResult('resultText');var xTm=setTimeout('onNodeSelect1(tree1.getSelectedItemId());clearTimeout(xTm);',500);}else{selEnt=false;}" onfocus="maf()"/>
            						<div id="resultText" class="resultContainer" onkeydown="javascript:arcGsearch.gsearchkeydown(event);"></div>
          						</div>
          						<div style="float:left;	padding-left:5px;">
            						<!--TABLE FOR DIMENSION SEARCH BUTTON STARTS-->
            						<table border="0" cellspacing="0" cellpadding="0">
              							<tr>
                							<td>
                  								<div class="buttonGreyLeft"  onclick="traverse(document.getElementById('searchDimension').value, 'campaignMDMHandler?csrfPreventionSalt=${csrfPreventionSalt}&nav_action=getSecurityTree', tree1, 'searchDimension');var xTm=setTimeout('onNodeSelect1(tree1.getSelectedItemId());clearTimeout(xTm);',500);"  onfocus="maf()" >
                    								<div class="searchButtonText">&gt;&gt;</div>
													<div class="buttonGreyRight_M"></div>
                  								</div>
                							</td>
              							</tr>
            						</table>
            						<!--TABLE FOR DIMENSION SEARCH BUTTON ENDS-->
          						</div>
          						<br/><br/>
        					</div><br/>
        					<div id="treeboxbox_tree1" onmousedown="treeClick()"></div>
	        				<script type="text/javascript">
	        					function maf(){
									if(document.all)
										document.onselectstart = function () { return true; };
								    return false;
								}
								var tree1 = null;
					        	tree1=new dhtmlXTreeObject("treeboxbox_tree1","100%","360",0);
					        	tree1.setImagePath("dhtmlX/codebaseTree/imgs/security/");
								tree1.enableDragAndDrop(true);
								tree1.setDragHandler(maf);
								tree1.enableKeyboardNavigation(true);
								tree1.enableSmartXMLParsing(true);
								tree1.enableDistributedParsing(true,5,50);
								tree1.enableKeySearch(true);
								tree1.enableAutoTooltips(true);
								tree1.setOnClickHandler("onNodeSelect1");
								//tree1.attachEvent("onDblClick",addDblClick1);
								tree1.loadXML("campaignMDMHandler?nav_action=getSecurityTree"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt'));
								tree1.allTree.onmouseover = function(e){showNmFltrToolTip('kpiNamedFilterPop',e);};

								var xTm=setTimeout("tree1.openItem(tree1.htmlNode.childNodes[0].id);tree1.selectItem(tree1.htmlNode.childNodes[0].id);onNodeSelect1(tree1.htmlNode.childNodes[0].id);clearTimeout(xTm);",2000);
								var s=new initgSearch('resultText','searchDimension','campaignMDMHandler?csrfPreventionSalt='+ $F('csrfPreventionSalt')+'&nav_action=getSecurityTree',tree1);

							</script>
      					</div>
    				</div>
</div>
 <div style="width:75%; height:450px; display:block;margin-left:10px;float:right;" id=portletSecond class="portletSkin">
	 <div class="portletHeader"><%=ResourceUtil.getLabel("arc.campaign.mdm.drag.arc.roles.and.users.for.assignmaent", locale)%></div>
	 <div class="innerPortlet">
	<div id="assignmentTabArea" style="width:100%; color:#000000; height:400px;"></div>
	<div  id="initiatorDiv" style="height:370px;" class="tblBorder">
		<table id="initiatorTable" width="98%" border="0" cellspacing="1" cellpadding="4" >
			<thead align='center'>
	     	<tr style="">
	       		<td width='10%' align="center"><%=ResourceUtil.getLabel("arc.delete", locale)%></td>
				<td width='45%' align='center'><%=ResourceUtil.getLabel("arc.campaign.mdm.user", locale)%></td>
				<td width='345%' align='center'><%=ResourceUtil.getLabel("arc.role", locale)%></td>
			</tr>
			</thead>
		</table>
	</div>
	<div  id="managerDiv" style="height:370px;" class="tblBorder">
		<table id="managerTable" width="98%" border="0" cellspacing="1" cellpadding="4" >
			<thead align='center'>
	     	<tr style="">
	       		<td width='10%' align="center"><%=ResourceUtil.getLabel("arc.delete", locale)%></td>
				<td width='45%' align='center'><%=ResourceUtil.getLabel("arc.campaign.mdm.user", locale)%></td>
				<td width='345%' align='center'><%=ResourceUtil.getLabel("arc.role", locale)%></td>
			</tr>
			</thead>
		</table>
	</div>
	</div>
	<br />
	<br />
  </div>
  </div>
  <script><!--
if(document.getElementById('initiatorDiv')){
	var sinput1=document.getElementById('initiatorDiv');
	tree1.dragger.addDragLanding(sinput1, new addInitiator);
}
if(document.getElementById('managerDiv')){
	var sinput2=document.getElementById('managerDiv');
	tree1.dragger.addDragLanding(sinput2, new addManager);
}

tabbar1=new dhtmlXTabBar("assignmentTabArea","topSimple", "", "", "tabbar1");
tabbar1.setImagePath("dhtmlX/codebaseTab/imgs/");
tabbar1.setSkinColors("#ffffff","#F4F3EE","#ffffff");
tabbar1.addTab("initiatorDiv1","Approver","130px");
tabbar1.addTab("managerDiv1","Manager","130px");
tabbar1.setTabActive("initiatorDiv1");
tabbar1.setContent("initiatorDiv1","initiatorDiv");
tabbar1.setContent("managerDiv1","managerDiv");


	function addInitiator(){
		this._drag=function(sourceHtmlObject,dhtmlObject,targetHtmlObject){

		var label = sourceHtmlObject.parentObject.label;
		var id =sourceHtmlObject.parentObject.id;
		addRowToTable(id,label,"initiatorTable");

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
function addManager(){
	this._drag=function(sourceHtmlObject,dhtmlObject,targetHtmlObject){

		var label = sourceHtmlObject.parentObject.label;
		var id =sourceHtmlObject.parentObject.id;
		addRowToTable(id,label,"managerTable");

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
function validateBeforeAdd(id,tableId){
	if(!id.startsWith("U") && !id.startsWith("R")){
		alert("<%=ResourceUtil.getMessage("arc.campaign.mdm.only.roles.and.users.are.allowed.to.drag", locale)%>");
		return false;
	}


	for (var i = 0, row; row = $(tableId).rows[i]; i++) {
		if("TR_"+tableId+"_"+id == row.id){
		if(id.startsWith("R")){
			alert("<%=ResourceUtil.getMessage("arc.campaign.mdm.role.already.exist", locale)%>");
			return false;
		}else if(id.startsWith("U")){
			alert("<%=ResourceUtil.getMessage("arc.campaign.mdm.user.already.exist", locale)%>");
			return false;
		}

		}
	}
	return true;
}
function addRowToTable(id,label,tableId){
	if(!validateBeforeAdd(id,tableId))
		return;
	var addClass="";
	var newRow = $(tableId).insertRow($(tableId).rows.length);

	if($(tableId).rows.length%2 == 1){
		addClass = "tblRow1";
	}else{
		addClass = "tblRow2";
	}
	var rowId = "TR_"+tableId+"_"+id;
	newRow.setAttribute("id", rowId);
	var newCell1 = document.createElement("td");
	newCell1.setAttribute("className", addClass);
	newCell1.setAttribute("class", addClass);
	newCell1.setAttribute("align", "center");
	newCell1.setAttribute("width", "10");
	newCell1.innerHTML = '<span class="imgDeleteSmallRow" onclick="deleteTableRow(\''+rowId+'\')"></span>';

	var newCell2 = document.createElement("td");
	newCell2.setAttribute("className", addClass);
	newCell2.setAttribute("class", addClass);
	newCell2.innerHTML = id.startsWith("U") ? label :"";

	var newCell3 = document.createElement("td");
	newCell3.setAttribute("className", addClass);
	newCell3.setAttribute("class", addClass);
	newCell3.innerHTML = id.startsWith("R") ? label :"";

	newRow.appendChild(newCell1);
	newRow.appendChild(newCell2);
	newRow.appendChild(newCell3);
}
function deleteTableRow(rowId){
	$(rowId).parentNode.removeChild($(rowId));
}

function collectAllRowIds(tableId){
	var rowIdPrefix = "TR_"+tableId+"_";
	var allRowIds = "";
	for (var i = 0, row; row = $(tableId).rows[i]; i++) {
		if(null != row.id && row.id.startsWith(rowIdPrefix)){
			allRowIds += row.id.substring(row.id.indexOf(rowIdPrefix)+rowIdPrefix.length)+",";
		}
	}
	if(allRowIds.length > 0)
		allRowIds = allRowIds.substring(0,allRowIds.length-1);
	return allRowIds;
}
function loadExistingRecords(){
	loadToTable(initatorUserIds, "initiatorTable");
	loadToTable(initatorRolesIds, "initiatorTable");
	loadToTable(managerUserIds, "managerTable");
	loadToTable(managerRolesIds, "managerTable");
}
function loadToTable(dataString, tableId){
	if(dataString == null || dataString.length < 1)
		return;

	var dataArray = dataString.split(",");
	for(var i=0;i<dataArray.length;i++){
		if(dataArray[i].indexOf("##") >=0){
			var idAndName = dataArray[i].split("##");
			addRowToTable(idAndName[0],idAndName[1],tableId);
		}

	}
}
window.onload = loadExistingRecords;
</script>
<script language="javascript">
parent.document.getElementById('mandatorySection').innerHTML='';
parent.document.getElementById('poupButtons').innerHTML = document.getElementById('thisPageButtons').innerHTML;
</script>
</form>
</body>
</html>
<%
	}catch(Exception e){
		e.printStackTrace();
	}
%>
