<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
	com.manthan.promax.security.SecurityEngine.isSessionOver(request,response, "login.jsp");
%>
<%@page import="java.text.SimpleDateFormat"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=<%=session.getAttribute("CHARSET").toString()%>" />

<%@ page import="java.util.ArrayList"%>
<%@ page import="com.manthan.arc.config.kpimodel.*"%>
<%@ page import="com.manthan.arc.autoquery.AdhocMeasure"%>
<%@ page import="com.manthan.arc.ui.DynamicFilterManager"%>
<%@ include file="userSession.jsp" %>
<%@ include file="scriptLocalize.jsp" %>
<%@ include file="script.jsp" %>
<%@ page import="static com.manthan.arc.security.CrossSiteScriptingHandler.*"%>

<link href="css/style<%=userSelectedTheme%>.less" rel="stylesheet/less" type="text/css" />
<script language="javascript" type="text/javascript" src="js/less.js"></script>
<script language="javascript" type="text/javascript" src="js/general.js"></script>
<script language="javascript" type="text/javascript" src="js/script.js"></script>
<script language="javascript" type="text/javascript" src="js/drag.js"></script>
<script src="js/publish.js" language="JavaScript" type="text/javascript"></script>

<!--DHTMLX-->
	<script  src="dhtmlX/codebaseTree/dhtmlxcommon.js"></script>
	<!--TAB-->
	<link rel="STYLESHEET" type="text/css" href="dhtmlX/codebaseTab/dhtmlxtabbar.css"/>
	<script  src="dhtmlX/codebaseTab/dhtmlxtabbar.js"></script>
	<script  src="dhtmlX/codebaseTab/dhtmlxtabbar_start.js"></script>

	<!--TREE GRID-->
	<link rel="STYLESHEET" type="text/css" href="dhtmlX/codebaseGrid/dhtmlxgrid.css"/>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgrid.js"></script>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgridcell.js"></script>
	<script  src="dhtmlX/codebaseTreeGrid/dhtmlxtreegrid.js"></script>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_start.js"></script>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_excell_link.js"></script>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_drag.js"></script>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_splt.js"></script>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_mcol.js"></script>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_selection.js"></script>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_nxml.js"></script>
	<script src="dhtmlX/codebaseGrid/dhtmlxgrid_excell_cntr.js"></script>

	<!--TREE-->
	<link rel="STYLESHEET" type="text/css" href="dhtmlX/codebaseTree/dhtmlxtree.css"/>
	<script  src="dhtmlX/codebaseTree/dhtmlxtree.js"></script>
	<script  src="dhtmlX/codebaseTree/dhtmlxtree_start.js"></script>
	<script  src="dhtmlX/codebaseTree/dhtmlxtree_kn.js"></script>
	<script  src="dhtmlX/codebaseTree/dhtmlxtree_xw.js"></script>
	<script  src="dhtmlX/codebaseTree/dhtmlxtree_sb.js"></script>
	<!-- Combo  -->
	<link rel="STYLESHEET" type="text/css" href="dhtmlX/codebaseCombo/dhtmlxcombo.css"/>
	<script  src="dhtmlX/codebaseCombo/dhtmlxcombo.js"></script>
	<script  src="dhtmlX/codebaseCombo/dhtmlxcombo_extra.js"></script>
	<!-- Combo ENDS -->
	<script language="JavaScript" src="js/calendar.js"></script>
<!--DHTMLX ENDS-->
<!--Sample Charting-->
	<script language="JavaScript" src="js/fusioncharts/fusioncharts.js"></script>
<!--Sample Charting ENDS-->
	<script src="dhtmlX/codebaseTreeGrid/dhtmlxtreegrid_lines.js"></script>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_filter.js"></script>
	<script type="text/javascript">
var tree1;

function s_control3(){return true;}
	</script>
</head>
<%try{%>
<%
String draggedMID = encodeForXss(request.getParameter("draggedMID"),URI);
String divId = encodeForXss(request.getParameter("divId"),JAVASCRIPT);
String view_id=encodeForXss(request.getParameter("view_id"),JAVASCRIPT);
AdhocMeasure adhoc=new AdhocMeasure();
DynamicFilterManager dfm=new DynamicFilterManager();
String expValue="";
ViewDefinition viewDefinition = null;
String newValue="";
String cRule ="";
String aliasDesc="";
String securityValue="";
if (request.getSession().getAttribute("KPIPUB_VIEWDEF") != null) {
	viewDefinition = (ViewDefinition) request.getSession().getAttribute("KPIPUB_VIEWDEF");
}
if(viewDefinition!=null){
	expValue=adhoc.getExpMeasure(viewDefinition,draggedMID);
	securityValue=adhoc.getSecurityMeasure(viewDefinition,draggedMID);
}
//System.out.println("expValue  ::"+expValue);
if(expValue!=null&&!expValue.equalsIgnoreCase("null")){
	cRule = dfm.getExpandedRule(expValue,session);
	newValue=cRule.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
}
if(expValue==null|| expValue.equalsIgnoreCase("null")){
	expValue="";
}

aliasDesc=adhoc.getExpMeasureDesc(viewDefinition,draggedMID);
if(aliasDesc==null||aliasDesc=="null"&& aliasDesc.length()<0){
	aliasDesc="";
}
if(request!=null){
request.setAttribute("MEASURE_FILTER","MFILTER");
}
//idName=addAlies
//System.out.println("draggedMID :"+draggedMID+"  divId    :"+divId+"   mName   :"+mName);


String name=null;

%>
<body onmousemove="updatebox(event)" onclick='parent.document.getElementById("mandatorySection").innerHTML="<%= ResourceUtil.getMessage("arc.fields.mandatory", locale)%>"' onkeypress="escPopup(event)" onload="parent.document.getElementById('mandatorySection').innerHTML='<%= ResourceUtil.getMessage("arc.fields.mandatory", locale)%>'; parent.document.getElementById('poupButtons').innerHTML = document.getElementById('thisPageButtons').innerHTML">
<br/><br/>
<div id='admain'>
<form name="form1" id="form1" method="post">
<input type="hidden" id="csrfPreventionSalt" name="csrfPreventionSalt" value="${csrfPreventionSalt}"/>
<%
			Date Todaysdate = Calendar.getInstance().getTime();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		%>
<input id="hdnToday" name="hdnToday" type="hidden" value= "<%= sdf.format(Todaysdate) %>" />
		<iframe id="gToday:jsDateNormal_DFM:jsDateAgenda.js" class='iframeDatePicker'  name="gToday:jsDateNormal_DFM:jsDateAgenda.js" src="DatePicker/DateOpeng.htm" frameBorder="0" width="168" scrolling="no" height="190"></iframe>
<input type="hidden" id="view_id" name="view_id" value="KPIPUB_VIEWID_<%=session.getId()%>"/>
<div id='anotherPop'></div>
<div id="thisPageButtons" style="display:none">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
        <div class="buttonBlueLeft" style="float:left"  onclick="popUpFrame.applyAliesName();">
        		<div class="buttonText"><%=ResourceUtil.getLabel("arc.apply", request) %></div>
				  <div class="buttonBlueRight_M"></div>
		</div>
        </td>
		  <td>&nbsp;</td>
        <td><div class="buttonBlueLeft" style="float:left"  onclick="killPopup()">
        		<div class="buttonText"><%=ResourceUtil.getLabel("arc.cancel", request) %></div>
				  <div class="buttonBlueRight_M"></div>
		</div></td>
      </tr>
    </table>
</div>
<table width="100%" border="0" cellspacing="2" cellpadding="4" class="tblBorder">
    <tr>
      <td width="20%" class="tblLabel" valign="top"><%=ResourceUtil.getLabel("arc.enter.measure.alias.name", request) %>&nbsp;<span class="contentRed">*</span></td>
      <td width="80%" class="tblContent">
         <input name="measureAliesName" id='measureAliesName' type="text" class="inputField" style="width:200px;" value=""/>
		</td>
    </tr>
     <tr>
      <td  class="tblLabel" valign="top"><%=ResourceUtil.getLabel("arc.description.notes", request) %> </td>
      <td width="75%" class="tblContent">
        <textarea name="measureAliesDESC" id='measureAliesDESC' class="inputField" cols="60" rows="5"></textarea>
	</td>
	</tr>
	<tr>
      <td width="20%" class="tblLabel" valign="top"><%=ResourceUtil.getLabel("arc.data.security", request) %>&nbsp;</td>
      <td width="80%" class="tblContent">
      <%if(securityValue!=null && securityValue.trim().length()>0&& securityValue.trim().equalsIgnoreCase("N")){ %>
         <input type="radio" name="mSecurity" value="Y" /><%=ResourceUtil.getLabel("arc.yes", request) %>
         <input type="radio" name="mSecurity" value="N" checked/><%=ResourceUtil.getLabel("arc.no", request) %>
         <% }else{%>
         <input type="radio" name="mSecurity" value="Y" checked/><%=ResourceUtil.getLabel("arc.yes", request) %>
         <input type="radio" name="mSecurity" value="N" /><%=ResourceUtil.getLabel("arc.no", request) %>
          <% }%>
		</td>
    </tr>
  </table>
<script>
var sinput1=document.getElementById('measureAliesName');
tree1.dragger.addDragLanding(sinput1, new s_control3);
</script>
<br/>
<div style="height:15px">
<div style="float:left; padding-bottom:5px; padding-right:5px;"><span class="subHeadingSmall"><%= ResourceUtil.getLabel("arc.filters", locale)%></span></div>
<div style="float:right" id="treeboxbox_treeFilterLinks">
<div class="imgExpandTree" onclick="toggleExpandCollapseTree(treeboxbox_treeFilter)" id="expandCollapseImageTree"   title='<%= ResourceUtil.getLabel("arc.alt.expand.all", locale)%>'></div>
<div class="imgResetFilter" onclick="resetFilterValuesDim('fromMAlias');" title='<%= ResourceUtil.getLabel("arc.reset.filter", locale)%>'></div></div>
<br/></div>
 
 <div id="filterBox" style="float:none;width:100%;height:147px;margin-top:5px;" >
		  <%
		  	//draggedMID
		  		  	  	com.manthan.dhtmlx.publisher.Publisher kpiPublish = new com.manthan.dhtmlx.publisher.Publisher();
		  	  	request.setAttribute("fromKpiPublisher","yes");//filter autohide enh
		  		  	  	out.println(kpiPublish.getFilters(request));
		  		  	  	request.removeAttribute("fromKpiPublisher");//filter autohide enh
		  %>


</div>
</form>
</div>
<script>
//document.getElementById('selExpM').innerHTML='';
//document.getElementById('expressionMeasures').value='';
var exp='<%=expValue%>';

var expRule='<%=newValue%>';
document.getElementById('selExpM').innerHTML=expRule;
 document.getElementById('expressionMeasures').value=exp;
var isKeyboardActive='';
var cntId='<%= divId %>';
var desc='<%= aliasDesc.trim() %>';

if(desc!=null&&desc.length!=""){
	$("measureAliesDESC").value=desc;

}
function deleteExp(){
	filterTree.deleteItem("a_2");
}
setTimeout("deleteExp()",200);
$("measureAliesName").value=parent.$(cntId).innerHTML;
function applyAliesName(){
	if(trim(document.form1.measureAliesName.value)==''){
		parent.document.getElementById('mandatorySection').innerHTML="<span class='contentRed'><%=ResourceUtil.getMessage("arc.please.enter.alias.name", request) %></span>";
		$('measureAliesName').className= "inputFieldErr";
		$('measureAliesName').focus();
		return false;
	}
	if(validateAllFields()){
		var url = "arcui?nav_action=KPIPUB_ADD_MEASURE_ALIES&draggedMID=<%=draggedMID %>&csrfPreventionSalt="+ $F('csrfPreventionSalt');
		var params = Form.serialize(document.form1);
		//alert(params);
		var myAjax = new Ajax.Request(url,{
			method: 'post',
			parameters: params,
			onComplete: function(org){
				if(org.responseText.indexOf('var status=true')!=-1){
					parent.document.getElementById('mandatorySection').innerHTML="<span class='contentRed'><%=ResourceUtil.getMessage("arc.name.already.exists", request) %></span>";
					return;
				}else{
					parent.$(cntId).innerHTML=document.form1.measureAliesName.value;
					parent.$(cntId).title=document.form1.measureAliesName.value;

					org.responseText.evalScripts();
					parent.killPopup();
				}
			}
		});
	}
}
</script>
</body>
</html>
<%
}catch(Exception e){
	e.printStackTrace();
}
%>