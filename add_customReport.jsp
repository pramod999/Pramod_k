<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@page import="dm.ca.churnanalysis.helper.ChurnAnalysisQueryManipulator"%>
<%@page import="static com.manthan.arc.security.CrossSiteScriptingHandler.*"%>
<%
com.manthan.promax.security.SecurityEngine.isSessionOver(request,response,"login.jsp");
%>
<!-- Added include JSP's for Localization -->
<%@ include file="userSession.jsp" %>
<%@ include file="scriptLocalize.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="dm.ca.listgen.dbutil.ListGenDBUtil"%>
<%@ page import="com.manthan.promax.db.ApplicationConfig"%>
<%@ page import="dm.ca.rfmanalysis.dbutil.RFMAnalysisDBUtil"%>

<%
String modelId = (null!=request.getParameter("modelId") && request.getParameter("modelId").trim().length()>0 ? request.getParameter("modelId") :"");
String modelName = (null!=request.getParameter("modelName") && request.getParameter("modelName").trim().length()>0 ? request.getParameter("modelName") :"");
String display = (null!=request.getParameter("display") && request.getParameter("display").trim().length()>0 ? request.getParameter("display") :"none");
	try {
	session.removeAttribute("KPIPUB_VIEWDEF_DEFAULT_FILTER");
	session.removeAttribute("FILTER_MANAGER_CALL");
	session.removeAttribute("KPIPUB_VIEWDEF");
	session.removeAttribute("FILTER_MANAGEMENT_VALUES");
	session.removeAttribute("KPIPUB_DRILACROSS");
	session.removeAttribute("LINKGRAPH");
	session.removeAttribute("enableEntity");
	session.removeAttribute("KPILINKMEASURE");
	session.removeAttribute("KPILINKDIMMEASURE");
	session.removeAttribute("DIM_TREE_EXP");
	session.removeAttribute("MINING_CHANGE_FLT");
	session.removeAttribute("MINING_LINKED_VIEWDEF");
	request.getSession().setAttribute("FROM_MINING","yes");
	request.getSession().setAttribute("FROM_MINNING_FLAG","RFM");
	java.util.HashMap allViewDetails = com.manthan.promax.db.ApplicationConfig.getViewDetails();
	allViewDetails.remove("KPIPUB_VIEWID_"+session.getId());
	allViewDetails=null;
	com.manthan.dhtmlx.publisher.Publisher publisher = new com.manthan.dhtmlx.publisher.Publisher();
	String kpiId = request.getParameter("kpiId");
	String dimStyle = "dimension";
	
	String diName = null!= com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.dimension.used") && com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.dimension.used").trim().length()>0 ? com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.dimension.used").trim() : "";

	String hiName = null!= com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.hierarchy.used") && com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.hierarchy.used").trim().length()>0 ? com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.hierarchy.used").trim() : "";

	String levelName = null!= com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.level.used") && com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.level.used").trim().length()>0 ? com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.level.used").trim() : "";

	String paramNameForCustomer = new ChurnAnalysisQueryManipulator().getDimensionInfoLevel(ApplicationConfig.getDataModel(), diName, hiName, levelName);
			
	String RFMMeasureUsed = null!=com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.measure.id") && com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.measure.id").trim().length()>0 ? com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.measure.id").trim() : ""; 
	
	String RFMDimensionLevelUsed = null!=com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.level.used") && com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.level.used").trim().length()>0 ? com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.level.used").trim() : "";
	
	RFMAnalysisDBUtil rfmDButil = new RFMAnalysisDBUtil();

	rfmDButil.setRFMFilterSelected(request, Integer.parseInt(modelId));
	
	List<String> reqTimeFilterList = new ArrayList<String>();
	reqTimeFilterList.add("ytd");
	reqTimeFilterList.add("yearly"); 
	reqTimeFilterList.add("halfyearly");
	reqTimeFilterList.add("quarterly"); 
	reqTimeFilterList.add("monthly"); 
	reqTimeFilterList.add("monthrange"); 
	reqTimeFilterList.add("mtd"); 
	reqTimeFilterList.add("qtd"); 
	reqTimeFilterList.add("wtd"); 
	reqTimeFilterList.add("weekly"); 
	reqTimeFilterList.add("weekrange"); 
	reqTimeFilterList.add("quarterrange"); 
	reqTimeFilterList.add("yearrange"); 
	reqTimeFilterList.add("lastxweeks"); 
	reqTimeFilterList.add("lastxmonths"); 
	reqTimeFilterList.add("lastxquarters");
	request.getSession().setAttribute("MINING_TIME_FILTERS", reqTimeFilterList);
	request.getSession().setAttribute("ListGen","yes");
	Properties properties = rfmDButil.getRFMParamsDef(modelId);
	String expOnMeasure = null;
	if(properties!=null && null!= properties.get("expressionMeasures")) {
    	expOnMeasure = properties.get("expressionMeasures").toString();
       	request.setAttribute("EXPRESSION_MEAURES",expOnMeasure);
       	request.getSession().setAttribute("DIM_TREE_EXP",expOnMeasure);
	}
%>

<%@page import="java.util.Vector"%>
<%@page import="com.manthan.arc.scheduler.alerts.AlertDBMediator"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%= com.manthan.promax.security.schmail.Mailer.getPropValue("arc.title").toString() %> - <%= ResourceUtil.getLabel("arc.rfm.modeling.set.scope", locale) %></title>
<style>
#LoadingDiv{
	margin:0px 0px 0px 0px;
	position:fixed;
	height: 100%;
	z-index:9999;
	padding-left:30%;
	width:100%;
	clear:none;
	background:#000;
	opacity: .2;
    filter: alpha(opacity=20);
	}
/*IE*/
* html #LoadingDiv{
     position: absolute;
     height: expression(document.body.scrollHeight &gt; document.body.offsetHeight ? document.body.scrollHeight : document.body.offsetHeight + 'px');
	}
#loader_div {
background-image:url(images/segmentLoader.gif);background-repeat:no-repeat;
width:300px;height:100px;
float:left;display:none;position:absolute;
margin: 0% 0% 0% 0%;z-index:9999;
}
#treeboxbox_tree1 .containerTableStyle{height:290px !important;}
#treeboxbox_tree4 .containerTableStyle{height:290px !important;}
html{overflow: visible !important;}
#treeboxbox_tree1 .containerTableStyle table,#treeboxbox_tree4 .containerTableStyle table {width:98.2% !important;}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=<%=session.getAttribute("CHARSET").toString()%>" />
<link href="css/style<%=userSelectedTheme%>.less" rel="stylesheet/less" type="text/css" />
<script language="javascript" type="text/javascript" src="js/less.js"></script>
<script language="javascript" type="text/javascript" src="js/mining.js"></script>
<script language="JavaScript" type="text/javascript" src="js/prototype.js"></script>
<script language="JavaScript" type="text/javascript" src="js/main.js"></script>
<script language="javascript" type="text/javascript" src="js/general.js"></script>
<script language="javascript" type="text/javascript" src="js/drag.js"></script>
<script src="js/script.js" language="JavaScript" type="text/javascript"></script>
<script src="js/publish.js" language="JavaScript" type="text/javascript"></script>
<script type="text/javascript" src="dsh/js/portal.js"></script>
<%@ include file="script.jsp" %>
<script type="text/javascript">
var count=0;
var globalParams="";
hasRowCounter_FirstColumn=true; // grid having the first column as row counter
masterTimerVlaue = 2000;
if (isNav && !isIE)
	window.onclick = closeUtilitys;
else if (isIE && !isNav)
	document.onclick = closeUtilitys;

window.onload = function() {
	if(parent.document.getElementById('mandatorySection1'))
	{
		parent.document.getElementById('mandatorySection1').innerHTML='';
	}
	parent.document.getElementById('poupButtons').innerHTML = document.getElementById('thisPageButtons').innerHTML;
	if(document.getElementById('treeboxbox_treeFilter'))document.getElementById('treeboxbox_treeFilter').style.height = '220px';
}
</script>
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
	<script  src="dhtmlX/codebaseTab/dhtmlxcommon.js"></script>
	<!-- Combo ENDS -->
<!--  New Custom Form UI-->
<script type="text/javascript" src="jqtransformplugin/jquery.min.js"></script>
<script type="text/javascript" src="jqtransformplugin/jquery.jqtransform.js"></script>

	<script language="JavaScript" src="js/calendar.js"></script>
<!--DHTMLX ENDS-->
<!--  New Nano Scroll Bar-->
<script type="text/javascript" src="jqtransformplugin/jquery.nanoscroller.js"></script>
<!--  New Help Slider UI-->
		<script src="js/jquery.tabSlideOut.v1.3.js"></script>
		<script type="text/javascript">
		 var j = jQuery.noConflict();

         j(function(){
			  j('.nano').nanoScroller({preventPageScrolling: true});
			  j(".nano").nanoScroller();
		});

		j(function(){
             j('.slide-out-div').tabSlideOut({
                 tabHandle: '.handle',                              //class of the element that will be your tab
                 pathToTabImage: 'images/helpSliderIcon.png',        //path to the image for the tab (optionaly can be set using css)
                 imageHeight: '48px',                               //height of tab image
                 imageWidth: '30px',                      	         //width of tab image
                 tabLocation: 'right',                               //side of screen where tab lives, top, right, bottom, or left
                 speed: 300,                                        //speed of animation
                 action: 'click',                                   //options: 'click' or 'hover', action to trigger animation
                 topPos: '80px',                                   //position from the top
                 fixedPosition: false                               //options: true makes it stick(fixed position) on scroll
             });
         });

<!--Sample Charting-->
	<script language="JavaScript" src="js/fusioncharts/fusioncharts.js"></script>
<!--Sample Charting ENDS-->
	<script src="dhtmlX/codebaseTreeGrid/dhtmlxtreegrid_lines.js"></script>
	<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_filter.js"></script>
		<!--  New Help Slider UI-->
		<script src="js/jquery.tabSlideOut.v1.3.js"></script>
		<script type="text/javascript">
		 var j = jQuery.noConflict();

         j(function(){
			  j('.nano').nanoScroller({preventPageScrolling: true});
			  j(".nano").nanoScroller();
		});

		j(function(){
             j('.slide-out-div').tabSlideOut({
                 tabHandle: '.handle',                              //class of the element that will be your tab
                 pathToTabImage: 'images/helpSliderIcon.png',        //path to the image for the tab (optionaly can be set using css)
                 imageHeight: '48px',                               //height of tab image
                 imageWidth: '30px',                      	         //width of tab image
                 tabLocation: 'right',                               //side of screen where tab lives, top, right, bottom, or left
                 speed: 300,                                        //speed of animation
                 action: 'click',                                   //options: 'click' or 'hover', action to trigger animation
                 topPos: '80px',                                   //position from the top
                 fixedPosition: false                               //options: true makes it stick(fixed position) on scroll
             });
         });

		</script>
<style>
		/*IE*/
		* html #LoadingDiv{
		     position: relative;
		     height: expression(document.body.scrollHeight &gt; document.body.offsetHeight ? document.body.scrollHeight : document.body.offsetHeight + 'px');
			}

		#filterSummary{background-color: #eee; padding:5px; border:1px dotted #afafaf; border-width:0 1px 1px 1px;}
		#filterMainSection #treeboxbox_treeFilter{height:180px !important;width:100%; float:left;}
		#filterMainSection #treeboxbox_treeFilter table{width:96% !important;}
		.bttmBtn{margin: -17px 0 5px;}
</style>
</head>
<body class="CABgClr" onkeypress="escPopup1(event)" onmousemove="updateloaderLoc(event)" onunload="javascript:removeSessionvariable();">
<script language="javascript" type="text/javascript" src="js/customTooltipSetup.js"></script>
<script language="javascript" type="text/javascript" src="js/customCallout.js"></script>
<form name="form1" id='form1'>
<input type="hidden" id="csrfPreventionSalt" name="csrfPreventionSalt" value="${csrfPreventionSalt}"/>
        <%
			java.util.Date Todaysdate = java.util.Calendar.getInstance().getTime();
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
			String forceAggregateName = null!= com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.force.aggragate") && com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.force.aggragate").trim().length()>0 ? com.manthan.promax.security.schmail.Mailer.getMiningPropValue("arc.rfm.analysis.force.aggragate").trim() : "";
		%>
		<input id="hdnToday" name="hdnToday" type="hidden" value= "<%= sdf.format(Todaysdate) %>" />
		<input type="hidden" id="miningScope" name="miningScope" value="yes"/>
		<iframe id="gToday:jsDateNormal_DFM:jsDateAgenda.js" class='iframeDatePicker'  name="gToday:jsDateNormal_DFM:jsDateAgenda.js" src="DatePicker/DateOpeng.htm" frameBorder="0" width="168" scrolling="no" height="190"></iframe>
<!-- End if Date Picker code -->
<input type="hidden" id="view_id" name="view_id" value="KPIPUB_VIEWID_<%=session.getId()%>"/>
<!--MAIN SECTION-->
<div id="loader_div"  align='center'><div id="loaderMsgDiv" style="display:none;"><span id='loaderTextSpan' class="loaderTextStyle"><%= ResourceUtil.getLabel("arc.rfm.extracting.data.please.wait", locale) %></span></div></div>
			<div id="LoadingDiv" style="display:none;width:100%; position:absolute;left:0px;top:0px;float:left;"></div>
   <div class="heading" style="float:none"><span class='miningHeading'><%= ResourceUtil.getLabel("arc.rfm.modeling", locale) %>&nbsp;-&nbsp;<span class="mdlName"><%=encodeForXss(modelName,HTML)%></span></span></div>
			<div id="wizardCntr">
				<div class="stpCntrCompleted" title="<%= ResourceUtil.getLabel("arc.rfm.create.modify.and.run.analysis", locale) %>" onclick="javascript: window.open('rfm_summary.jsp?csrfPreventionSalt=${csrfPreventionSalt}','_self')">
					<span class="stpIcn initialize"></span>
			        <span class="stpText"><%= ResourceUtil.getLabel("arc.rfm.initialize", locale) %></span>
				</div>
    			<div class="stpSeperator"></div>
			    <div class="stpCntrActive" title="<%= ResourceUtil.getLabel("arc.rfm.limit.data.for.analysis", locale) %>">
					<span class="stpIcn analysisScope"></span>
			        <span class="stpText"><%= ResourceUtil.getLabel("arc.rfm.set.scope", locale) %></span>
				</div>
			    <div class="stpSeperator"></div>
			    <div class="stpCntrInactive" title="<%= ResourceUtil.getLabel("arc.rfm.define.the.definitions.to.determine.rfm", locale) %>">
					<span class="stpIcn churnDefinition"></span>
			        <span class="stpText"><%= ResourceUtil.getLabel("arc.rfm.define.rfm", locale) %></span>
				</div>
				<div class="stpSeperator"></div>
				<div class="stpCntrInactive" title="<%= ResourceUtil.getLabel("arc.rfm.select.bucket.types.compute.thresholds.create.model", locale) %>">
					<span class="stpIcn createModel"></span>
					<span class="stpText"><%= ResourceUtil.getLabel("arc.rfm.create.model", locale) %></span>
				</div>
    			<div class="stpSeperator"></div>
    			<div class="stpCntrInactive" title="<%= ResourceUtil.getLabel("arc.rfm.finalize.model.viewing.results", locale) %>">
    				<span class="stpIcn modelResult"></span>
    				<span class="stpText"><%= ResourceUtil.getLabel("arc.rfm.finalize.model", locale) %></span>
    			</div>
    			<div class="stpSeperator"></div>
    			<div class="stpCntrInactive" title="<%= ResourceUtil.getLabel("arc.rfm.apply.the.rfm.model.and.share.it", locale) %>">
    				<span class="stpIcn applyModel"></span>
    				<span class="stpText"><%= ResourceUtil.getLabel("arc.rfm.apply.model", locale) %></span>
    			</div>
    			<div class="stpSeperator"></div>
    			<div class="stpCntrInactive" title="<%= ResourceUtil.getLabel("arc.rfm.view.the.rfm.results", locale) %>">
    				<span class="stpIcn churnResults"></span>
    				<span class="stpText"><%= ResourceUtil.getLabel("arc.rfm.view.rfm.results", locale) %></span>
    			</div>
			</div>
<div id='helpDiv' class="slide-out-div" style='display:none;' title="<%= ResourceUtil.getLabel("arc.help", locale) %>" style='z-index:99'>
<a class="handle" href="javascript:void(0);"></a>
	<div class="nano">
    	<div class="content">
    	<%if(Mailer.getMiningPropValue("arc.doc.data.mining.training.rfm.modeling")!=null && Mailer.getMiningPropValue("arc.doc.data.mining.training.rfm.modeling").toString().trim().length()>0) {%>
				<span style='float:right; background:#eee; text-decoration:underline; padding:5px; margin:3px; display:block;cursor:hand !important; border-radius:3px;' onclick="opeWindowURL('<%=Mailer.getMiningPropValue("arc.doc.data.mining.training.rfm.modeling")%>')"><a>Click here for Video Training</a></span></br></br></br>
		<%}%>
			<h1><span>Setting Scope</span></h1>
			<p><span>To define the scope of an RFM Model:</span></p>
			<p><span>1.&nbsp;&nbsp;&nbsp;&nbsp; Use filters available in the <b>Filter data for analysis </b>to further refine your selection.</span></p>
			<p><span>You can drag Dimensions and Defaults to the <b>Filter data for analysis</b> area and use the <b>Expression on Measures</b> option to build expressions for further refining your selection.</span><br/></p>
			<p><span><b>Note:</b> If you have selected a time filter such as <i>Yearly, Quarterly, Monthly, Weekly, Daily, Year Range, Quarter Range, Month Range, Week Range, or Day,</i> Customer360 shows the selected time filter on the <i>Apply Model</i> page to limit the data for scoring. Hence, only the <b>Specify Date and Time</b> and <b>Immediate</b> options will be available on the <i>Apply Model</i> page.</span></p>
			
			<p><span>2.&nbsp;&nbsp;&nbsp;&nbsp; Click <strong><span>Analyze</span></strong>. The summary of the selected data is displayed at the bottom of the page.<br/> <b>Note:</b> Please wait while the application extracts the required data. The duration of this process depends on your filter selection.</span></p>
			<p><span>3.&nbsp;&nbsp;&nbsp;&nbsp; Click <b>Next</b> to display the <i>Define RFM</i> page.</span></p> 
		</div>
	</div>
</div>
<span id="calloutContent" style="display:none">
</span>
<input type="hidden" name="DMFTabValue" id="DMFTabValue" value="measures"/>
	
	<div id="portletLeftPopup2" style='margin-right:0' >

	<div style="float:left;width:100%;margin-bottom:5px;display: none;">
	<div class="dvFloatLeft">
          <span class="contentBlackBold"><%= ResourceUtil.getLabel("arc.views", locale)%> </span> <span class="contentGrey"><%= ResourceUtil.getLabel("arc.drag.dimension.as.view", locale)%> </span>
            </div>
            <div id="viewDragTable" style="float:left;width:100%;height:30px; overflow:hidden; overflow-y:auto" class="tblBorder">
              <table id="viewDragTableCon" width="100%" cellspacing="1" cellpadding="4" style="background-color:#CCCCCC">
                <tr style="display:none">
                  <td width="4%" class="tblRow1" ></td>
                  <td width="96%" class="tblRow1"></td>
                </tr>
              </table>
            </div><br/><br/>
	</div>

	    <table width="100%" border="0" cellspacing="0" cellpadding="5" class="tblBorderFlo" style="display:none">
          <tr>
          <td align="left" valign="top" style="width:45%;"  class="myRowhead"></td>

		<td align="left" valign="top" style="width:55%;border-left:2px solid #d6de28"><span id="crosstabTxt"><span class="contentBlackBold"><%= ResourceUtil.getLabel("arc.cross.tab", locale)%></span> <span class="contentGrey"><%= ResourceUtil.getLabel("arc.drag.single.dimension.ascross.tab", locale)%></span></span>
            </td>
        </tr>
        <tr>
          <td align="left" valign="top" style="border-top:2px solid #d6de28">
          <div class="dvFloatLeft">
          <span class="contentBlackBold"><%= ResourceUtil.getLabel("arc.views", locale)%> </span> <span class="contentGrey"><%= ResourceUtil.getLabel("arc.drag.dimension.as.view", locale)%> </span>
            <!-- default view -->
            </div>
            <div id="viewDragTable" style="float:left;width:99%;height:190px; overflow:hidden; overflow-y:auto" class="tblBorder">
              <table id="viewDragTableCon" width="100%" cellspacing="1" cellpadding="4" style="background-color:#CCCCCC">
                <tr style="display:none">
                  <td width="4%" class="tblRow1" ></td>
                  <td width="96%" class="tblRow1"></td>
                </tr>
              </table>
            </div></td>
            <td align="left" valign="top" style="border-top:2px solid #d6de28; border-left:2px solid #d6de28;" ><span class="contentBlackBold"><%= ResourceUtil.getLabel("arc.measures", locale)%></span> <span class="contentGrey"><%= ResourceUtil.getLabel("arc.drag.measures", locale)%> </span>
            	<br/>
            	<div style="clear:left;position:relative;overflow:hidden;">
						  <div class="tblBorderBlueBgWhite" id="utilityMeasure" style="position:absolute;top:0px;height:180px;overflow:hidden;#padding-left:12px;width:22px;right:0px; ">
              </div>
              <div style="margin-bottom:5px;" onclick="clearMeasureSelection();" class="imgClearMeasure" title='<%= ResourceUtil.getLabel("arc.kpi.publisher.clear.measures", locale)%>' ></div>
			  <% if(request.getSession().getAttribute("AdminL")!=null && request.getSession().getAttribute("AdminL").toString().equalsIgnoreCase("yes")){ %>
				  <div style="margin-bottom:5px;float:right;*float:none;cursor:pointer;width:14px;" onclick="document.getElementById('compRank').style.display='block';getComplexRankUI();" class="img_DM_Complex" title='<%= ResourceUtil.getLabel("arc.complex.ranking", locale)%>'></div>
				  <div style="margin-bottom:5px;" onclick="openmeasurelink();" title='<%= ResourceUtil.getLabel("arc.kpi.publisher.clear.measures", locale)%>' >
			  	<span style="cursor:pointer;float:right;" title="<%=ResourceUtil.getLabel("LINK_MEASURE_KPI", locale)%>"><img src="images/iconMeasureLink.gif"/></span> </div>
			  <% } %>
			  </div>
									<div id="measuresDragTable" style="float:none;height:190px; overflow:hidden; overflow-y:auto;margin-right:44px;" class="tblBorder">
									<table id="measuresDragTableCon"  cellspacing="1"  border=0 cellpadding="4" style="background-color:#CCCCCC;width:100%;"><tr style="display:none"><td width="4%" class="tblRow1" ></td><td width="96%" class="tblRow1"></td></tr></table></div>
        </div>
        </div>
		</td>
		</tr>
      </table>
      <div id="wrapper">
      <div style="margin-right:280px;">
    
		<div style="float:left; width:100%;">
		<div style="height:22px;float:left;width:100%;">
		<span class="subHeadingSmall1" style="margin-bottom:-15px;"><%= ResourceUtil.getLabel("arc.filter.data.for.analysis", locale) %></span>
        <div id="treeboxbox_treeFilterLinks" class="dvFloatRight" style='margin-left:5px;'>
          <div class="imgExpandTree" onclick="toggleExpandCollapseTree(treeboxbox_treeFilter)" id="expandCollapseImageTree"   title='<%= ResourceUtil.getLabel("arc.alt.expand.all", locale)%>'></div>
          <div onclick='callSaveFilterPopUp(null,"mining");' style='cursor:hand' class='imgEnabled imgSaveFilter' title='<%= ReportUtil.getUtilLabels(request,"40",false)%>'></div>
          <div class="imgResetFilter" onclick="resetFilterValuesDim();" title='<%= ResourceUtil.getLabel("arc.reset.filter", locale)%>'></div>
        	<div class="imgDeleteFilter" onclick="deleteKPIPUBFilter(treeboxbox_treeFilter.getSelectedItemId());"  title='<%= ResourceUtil.getLabel("arc.delete.selected.filter", locale)%>'></div>
        </div>
      </div>
		  <div id="filterBox" style="float:none; width:100%;height:220px;" >
		  <%
		  	  	com.manthan.dhtmlx.publisher.Publisher kpiPublish = new com.manthan.dhtmlx.publisher.Publisher();
			  	request.setAttribute("fromKpiPublisher","yes");//filter autohide enh
		  	  	out.println(kpiPublish.getFilters(request));
		  	  	request.removeAttribute("fromKpiPublisher");//filter autohide enh
		  %>
	<div class="bttmBtn">
	<div class="contentRed" id="filterMandatorySection" style="FLOAT: left;position:relative;margin-top:5px;"></div>
	<div class="buttonText" style='float:none;margin: 2px 0 2px 3px;'>
		<span class="actionBtnOrange" onclick="if(!validateAllFields()){return false;}getautoquery();">
		<span style=" padding:0 4px;"><%= ResourceUtil.getLabel("arc.churn.analyze", locale) %></span></span>
		    </div>
	</div>
	<div id="resultId" style="float:left;display:<%=display%>; width:100%;">
		<div class="subHeadingCntr">
			<span class="subHeadingSmall"><%= ResourceUtil.getLabel("arc.summary.of.selected.data", locale) %></span>
		</div>&nbsp;
		<div id="ScopeSummary" style="margin-top:-10px;"></div>
		<img src="images/spacer.gif" height="5px" width="19px"/>
		<div class="subHeadingCntr" style="display:none">
			<span class="subHeadingSmall"><%= ResourceUtil.getLabel("arc.churn.filter.details", locale) %></span>
		</div>
		<div id="filterSummary" style="display:none;overflow:auto;height:120px;background-color: #fff !important;color:#737c93 !important;border:none !important;border-top:1px!important;">
		</div>
	</div>
	</div>
	</div>
	<div id="portletRight" style="width:250px">
		<div id="dimensionBrowserGra"  class="portletSkinFlo" style="display:block;width:100%;height:413px;">
		 <table width="100%" border="0" cellspacing="0" cellpadding="0" id="dimensionView" style="display:block" onclick="setDynamicTabValueForTree()">
			<tr>
			<td class="customTabActive" style="width:48%"><div class="img_utility_dimensionBrowser"></div><div class='utilityBrowserText' title='<%= ResourceUtil.getLabel("arc.dimensions", locale)%>'><%= ResourceUtil.getLabel("arc.dimensions", locale)%></div></td>
			<td class="customTabActiveBrd">&nbsp;</td>
			<td class="customTabInActive" style="width:48%" onclick="javascript:var s4=new initgSearch('resultText3','searchSavedFilters','out_xml.jsp?csrfPreventionSalt=${csrfPreventionSalt}&action=namedFilters&callFrom=kpipublisher',tree4Filter);customTab('globalView');tree4Filter.deleteChildItems(0);tree4Filter.loadXML('out_xml.jsp?csrfPreventionSalt=${csrfPreventionSalt}&action=namedFilters&callFrom=kpipublisher');"><div class="img_utility_DefaultBrowser"></div><div class='utilityBrowserText' title='<%= ResourceUtil.getLabel("arc.defaults", locale)%>' ><%= ResourceUtil.getLabel("arc.defaults", locale)%></div></td>
			 </tr>
		  </table>
		   <table width="100%" border="0" cellspacing="0" cellpadding="0" id="globalView" style="display:none" onclick="setDynamicTabValueForTree()">
			<tr>
			  <td class="customTabInActive" style="width:48%" onclick="javascript:var s1=new initgSearch('resultText','searchDimId','out_xml_mining.jsp?csrfPreventionSalt=${csrfPreventionSalt}&action=miningDimTree&isExpresionCall=false&expMeasure='+expMeasure+'&forceAggregateName=<%=forceAggregateName%>',tree1);customTab('dimensionView');"><div class="img_utility_dimensionBrowser"></div><div class='utilityBrowserText' title='<%= ResourceUtil.getLabel("arc.dimensions", locale)%>' ><%= ResourceUtil.getLabel("arc.dimensions", locale)%></div></td>
			   <td class="customTabActiveInActiveBrd">&nbsp;</td>
			  <td class="customTabActive" style="width:48%"><div class="img_utility_DefaultBrowser"></div><div class='utilityBrowserText' title='<%= ResourceUtil.getLabel("arc.defaults", locale)%>' ><%= ResourceUtil.getLabel("arc.defaults", locale)%></div></td>
			</tr>
		  </table>
			<img src="images/spacer.gif" alt=" " width="100" height="5"/>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" style='background-color:#ffffff;z-index:99'>
        <tr>
          <td width="4%" align="left" valign="top" onclick="showHideGraphLayer('dimensionBrowserGra',42,340)" title="<%= ResourceUtil.getLabel("arc.hide", locale)%>" ></td>
            <td width="96%" align="left" valign="top"><div id="dimensionViewCon" style="display:block;positon:relative;padding:3px 0px 0px 8px;" onmouseout="hideNmFltrToolTip('kpiNamedFilterPop');">
                <div class="imgPortletBullet"></div>
                &nbsp;<a href="javascript:;" onclick="swapFilters('dimensionSection')"><%= ResourceUtil.getLabel("arc.search.dimensions", locale)%></a> <br />
                <div id="dimensionSection" style="display:block;*float:left;padding:3px 0px 0px 0px;position:relative;z-index:99;width:100%;">
                  <div style="float:left;">
                    <input name="text" type="text" id="searchDimId" class="inputField" size="25" onkeyup="javascript:if(!selEnt){arcGsearch.showResult(this,event)}" onkeypress="if (event.keyCode==13){selEnt=true;traverse(this.value, 'out_xml_mining.jsp?csrfPreventionSalt=${csrfPreventionSalt}&action=miningDimTree&isExpresionCall=false&expMeasure='+expMeasure+'&fromRFM=true&forceAggregateName=<%=forceAggregateName%>', tree1, 'searchDimId');arcGsearch.gsearchCloseResult('resultText');}else{selEnt=false;}" onfocus="maf()"/>
                    <div id="resultText" class="resultContainer" onkeydown="javascript:arcGsearch.gsearchkeydown(event);"></div>
                  </div>
                  <div style="float:left;padding-left:5px">
                    <table border="0" cellspacing="0" cellpadding="0" style="display: block;margin-top: -2px;">
                      <tr>
                        <td><div class="buttonGreyLeft" onclick="traverse(document.getElementById('searchDimId').value, 'out_xml_mining.jsp?csrfPreventionSalt=${csrfPreventionSalt}&action=miningDimTree&isExpresionCall=false&expMeasure='+expMeasure+'&fromRFM=true&forceAggregateName=<%=forceAggregateName%>', tree1, 'searchDimId');" onfocus="maf()">
                            <div class="searchButtonText">&gt;&gt;</div>
							<div class='buttonGreyRight_M'></div>
                          </div></td>
                      </tr>
                    </table>
                  </div>
                    <div style='float:right;cursor:pointer'>
                    	<table cellspacing='0' cellpadding='0' border='0'>
                    	<tr><td><div   style='float:left;border-bottom:1px solid #3d82b3;' class="imgTreeSort_DESC"  title='<%= ResourceUtil.getLabel("arc.kpi.sort.desc",locale) %>' id='imgSortTree' onclick="toggleTreeSort(tree1,'0','imgSortTree')"></div></td></tr>
                    	<tr><td></td></tr>
                    	</table>
				  	   </div>

			  </div>
			    <img src="images/spacer.gif" width="200px" height="10px"/>
				<div id="treeboxbox_tree1" style="width:100%;overflow-x:hidden" onmousedown="treeClick()"></div>
				<script type="text/javascript">
						function maf(){
							if (document.all)
								document.onselectstart = function () { return true; };
						    return false;
						}
						function sunzDragTargetShow(val)
						{
							if(val=="treeboxbox_tree1")
							{
								highlightTarget("viewDragTable,treeboxbox_treeFilter","measuresDragTable");
							}
						}

						function sunzDragTargetHide()
						{
							highlightTarget("","viewDragTable,measuresDragTable,treeboxbox_treeFilter");
						}

						function s_control1()
						{
							this._drag=function(sourceHtmlObject,dhtmlObject,targetHtmlObject){
								if(document.getElementById("DMFTabValue").value!="dimensions" && document.getElementById("DMFTabValue").value!="recent") return false;
								if(fn_check_single_value('measuresDragTable')){
									alert("<%=ResourceUtil.getMessage("arc.select.one.measure",locale)%>");
									return false;
								}
							    if(!sourceHtmlObject.parentObject.id.startsWith('D')){
									return;
								}

							    if(!fn_check_single_value('viewDragTable')){
									return;
								}

								if(!tree1.hasChildren(sourceHtmlObject.parentObject.id))
								{
									var viewLbl = sourceHtmlObject.parentObject.label+' ('+sourceHtmlObject.parentObject.parentObject.label+')';
									if(viewLbl.length>23){
										viewLbl = viewLbl.substr(0, 22)+'...';
									}
									addKPIPubViewListGen(viewLbl, 'viewDragTableCon', sourceHtmlObject.parentObject.id,'<%=dimStyle%>');
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

						function s_control3()
						{
								this._drag=function(sourceHtmlObject,dhtmlObject,targetHtmlObject){
								if(sourceHtmlObject.parentObject.id.indexOf("NAMEDEXPGROUP_") > -1 ||
										sourceHtmlObject.parentObject.id.indexOf("NAMEDFGROUP_") > -1){
										return;
									}
								var tabValue = document.getElementById("DMFTabValue").value;
								if(sourceHtmlObject.parentObject.id.indexOf("NAMEDFILTER")>-1){
									if(fn_check_single_value('measuresDragTable')){
										alert("<%=ResourceUtil.getMessage("arc.select.one.measure",locale)%>");
										return false;
									}
									if(fn_check_single_value('viewDragTable')){
										alert('<%= ResourceUtil.getMessage("arc.select.dimensions", locale)%>');
										return false;
									}
									var draggedARCID = sourceHtmlObject.parentObject.id;
									var url="arcui?nav_action=addDHTMLXFilterManager&draggedARCID="+draggedARCID+"&fromPublisher=yes"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
									var params = Form.serialize(document.form1);
									var myAjax = new Ajax.Request(url,
									{
										method: 'post',
										parameters: params,
										onComplete: updateColumns
									});
								}
								if(sourceHtmlObject.parentObject.parentObject.id=="SectionB" ||
										sourceHtmlObject.parentObject.id.indexOf("NAMEDEXPGROUP_")>-1){
									if(fn_check_single_value('measuresDragTable')){
										alert("<%=ResourceUtil.getMessage("arc.select.one.measure",locale)%>");
										return false;
									}
									if(fn_check_single_value('viewDragTable')){
										alert('<%= ResourceUtil.getMessage("arc.select.dimensions", locale)%>');
										return false;
									}
									if(!tree4Filter.hasChildren(sourceHtmlObject.parentObject.id))
									{
										var params = "selQuestionValue="+sourceHtmlObject.parentObject.label;
										var url="arcui?nav_action=putFilterQuestion&fromMiningDrag=yes"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
										var myAjax = new Ajax.Request(url,
										{
										method: 'post',
										parameters: params,
										onComplete: updateColumns
										});
									}
								}
								if(tabValue=="measures") return false;
								if(fn_check_single_value('measuresDragTable')){
									alert("<%=ResourceUtil.getMessage("arc.select.one.measure",locale)%>");
									return false;
								}
								if(tabValue=='dimensions' || tabValue=='recent'){
									if(!(sourceHtmlObject.parentObject.id.startsWith('D') || sourceHtmlObject.parentObject.id.startsWith('Others_'))){
										return;
									}
									addKPIPubFilter(sourceHtmlObject.parentObject.id);
								}
								if(sourceHtmlObject.parentObject.parentObject.id=="$Alert Templates$"){
									if(fn_check_single_value('viewDragTable')){
										alert('<%= ResourceUtil.getMessage("arc.select.atleast.one.view", locale)%>');
										return false;
									}
									addGlobalExpression(sourceHtmlObject.parentObject.id);
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
						var expMeasure = "<%=expOnMeasure%>";
						function loadDimensionTree(isExpresionCall){
						document.getElementById('treeboxbox_tree1').innerHTML = '';
						expMeasure = '';
						if(document.getElementById('expressionMeasures')!=null){
							expMeasure = encodeURIComponent(document.getElementById('expressionMeasures').value) ;
						} else if(isExpresionCall){
							expMeasure = null;
						}
						tree1 = null;
						tree1=new dhtmlXTreeObject("treeboxbox_tree1","100%","280",0);
						tree1.setImagePath("dhtmlX/codebaseTree/imgs/dimension/");
						tree1.enableDragAndDrop(true);
						tree1.setDragHandler(maf);
						tree1.enableKeyboardNavigation(true);
						tree1.enableSmartXMLParsing(true);
						tree1.enableKeySearch(true);
						tree1.enableDistributedParsing(true,5,50);
						tree1.loadXML("miningAction?csrfPreventionSalt="+ $F('csrfPreventionSalt')+"&nav_action=miningDimTree&isExpresionCall="+isExpresionCall+"&expMeasure="+expMeasure+"&fromRFM=true&forceAggregateName=<%=forceAggregateName%>",function(){
						new initgSearch('resultText','searchDimId','miningAction?csrfPreventionSalt='+ $F("csrfPreventionSalt")+'&nav_action=miningDimTree&isExpresionCall=false&expMeasure='+expMeasure+'&fromRFM=true&forceAggregateName=<%=forceAggregateName%>',tree1);
						});
						tree1.allTree.onmouseover = function(e){showNmFltrToolTip('kpiNamedFilterPop',e);};
						}
				</script>
			</div>
			<div id="measureViewCon" style="display:none;positon:relative;padding:3px 0px 0px 8px;" onmouseout="hideNmFltrToolTip('kpiNamedFilterPop');">
                <div class="imgPortletBullet"></div>
                &nbsp;<a href="javascript:;" onclick="swapFilters('measureSection')"><%= ResourceUtil.getLabel("arc.search.measures", locale)%></a> <br />
                <div id="measureSection" style="display:block;*float:left; padding:3px 0px 0px 0px;position:relative;z-index:99;width:100%;">
                  <div style="float:left;">
                    <input type="text" id="searchMeasure" class="inputField" size="25" onclick="if(!s2)var s2=new initgSearch('resultText1','searchMeasure','out_xml.jsp?csrfPreventionSalt=${csrfPreventionSalt}&action=measureTree',tree2);" onkeyup="javascript:if(!selEnt){arcGsearch.showResult(this,event)}" onkeypress="if (event.keyCode==13){selEnt=true;traverse(this.value, 'out_xml.jsp?action=measureTree', tree2, 'searchMeasure');arcGsearch.gsearchCloseResult('resultText');}else{selEnt=false;}" onfocus="maf()"/>
                    <div id="resultText1" class="resultContainer" onkeydown="javascript:arcGsearch.gsearchkeydown(event);"></div>
                  </div>
                  <div style="float:left;padding-left:5px">
                    <table border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div class="buttonGreyLeft"  onclick="traverse(document.getElementById('searchMeasure').value, 'out_xml.jsp?csrfPreventionSalt=${csrfPreventionSalt}&action=measureTree', tree2, 'searchMeasure');arcGsearch.gsearchCloseResult('resultText');" onfocus="maf()">
                            <div class="searchButtonText" >&gt;&gt;</div>
							<div class='buttonGreyRight_M'></div>
                          </div></td>
                      </tr>
                    </table>
                  </div>
                  <div class="imgTreeSort_DESC" style='border-bottom:1px solid #4f8dbc' title='<%= ResourceUtil.getLabel("arc.kpi.sort.desc",locale) %>' id='imgSortTree_2' onclick="toggleTreeSort(tree2,'0','imgSortTree_2')"></div>
			     </div>
			    <img src="images/spacer.gif" width="200px" height="10px"/>
			</div>
			<div id="globalViewCon" style="display:none;positon:relative;padding:3px 0px 0px 8px;" onmouseout="hideNmFltrToolTip('kpiNamedFilterPop');">
                <div class="imgPortletBullet"></div>
                &nbsp;<a href="javascript:;" onclick="swapFilters('globalViewCon')"><%= ResourceUtil.getLabel("arc.search.defaults", locale)%></a> <br />
                <div id="filterSavedSection" style="display:block;*float:left; padding:3px 0px 0px 0px;position:relative;z-index:99;width:100%;">
                  <div style="float:left;">
                    <input type="text" id="searchSavedFilters" class="inputField" size="25" onclick="if(!s4)var s4=new initgSearch('resultText3','searchSavedFilters','out_xml.jsp?csrfPreventionSalt=${csrfPreventionSalt}&action=namedFilters&callFrom=kpipublisher',tree4Filter);" onkeyup="javascript:if(!selEnt){arcGsearch.showResult(this,event)}" onkeypress="if (event.keyCode==13){selEnt=true;traverse(this.value, 'out_xml.jsp?action=namedFilters&callFrom=kpipublisher', tree4Filter, 'searchSavedFilters');arcGsearch.gsearchCloseResult('resultText');}else{selEnt=false;}" onfocus="maf()"/>
                    <div id="resultText3" class="resultContainer" onkeydown="javascript:arcGsearch.gsearchkeydown(event);"></div>
                  </div>
                  <div style="float:left;padding-left:5px">
                    <table border="0" cellspacing="0" cellpadding="0" style="display: block;margin-top: -2px;">
                      <tr>
                        <td><div class="buttonGreyLeft"  onclick="traverse(document.getElementById('searchSavedFilters').value, 'out_xml.jsp?csrfPreventionSalt=${csrfPreventionSalt}&action=namedFilters&callFrom=kpipublisher', tree4Filter, 'searchSavedFilters');arcGsearch.gsearchCloseResult('resultText');" onfocus="maf()">
                            <div class="searchButtonText" >&gt;&gt;</div>
							<div class='buttonGreyRight_M'></div>
                          </div></td>
                      </tr>
                    </table>
                  </div>
                  <div class="imgTreeSort_DESC" style='border-bottom:1px solid #4f8dbc' title='<%= ResourceUtil.getLabel("arc.kpi.sort.desc",locale) %>'  id='imgSortTree_4' onclick="toggleTreeSort(tree4Filter,'0','imgSortTree_4')"> </div>
                </div>
			    <img src="images/spacer.gif" width="200px" height="10px"/>
			  <div id="treeboxbox_tree4" style="width:100%;overflow-x:hidden" onmousedown="treeClick()"></div>
			<script type="text/javascript">
				tree4Filter=new dhtmlXTreeObject("treeboxbox_tree4","100%","359",0);
				tree4Filter.setImagePath("dhtmlX/codebaseTree/imgs/savedFilter/");
				tree4Filter.enableDragAndDrop(true);
				tree4Filter.setDragHandler(maf);
				tree4Filter.enableKeyboardNavigation(true);
				tree4Filter.enableSmartXMLParsing(true);
				tree4Filter.enableDistributedParsing(true,10,200);
				tree4Filter.enableMultiselection(true);
				tree4Filter.enableKeySearch(true);
				tree4Filter.loadXML("out_xml.jsp?action=namedFilters&callFrom=kpipublisher"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt'));
				tree4Filter.allTree.onmouseover = function(e){showNmFltrToolTip('kpiNamedFilterPop',e);};
				tree4Filter.attachEvent("onDblClick",addDblClick4);

				function addDblClick4()
				{
					var tabValue = document.getElementById("DMFTabValue").value;
					if(tree4.getSelectedItemId().indexOf("NAMEDEXPGROUP_") > -1 ||
						tree4.getSelectedItemId().indexOf("NAMEDFGROUP_") > -1){
						return;
					}
					if(tree4Filter.getParentId(tree4Filter.getSelectedItemId())=="NamedFilter" ||
						tree4Filter.getParentId(tree4Filter.getSelectedItemId()).indexOf("NAMEDFGROUP_")>-1){
						if(fn_check_single_value('measuresDragTable')) {
							alert("<%=ResourceUtil.getMessage("arc.select.one.measure",locale)%>");
							return false;
						}
						if(fn_check_single_value('viewDragTable')){
							alert('<%= ResourceUtil.getMessage("arc.select.dimensions", locale)%>');
							return false;
						}
						var draggedARCID = tree4Filter.getSelectedItemId();
						var url="arcui?nav_action=addDHTMLXFilterManager&draggedARCID="+draggedARCID+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
						var params = Form.serialize(document.form1);
						var myAjax = new Ajax.Request(url,
						{
							method: 'post',
							parameters: params,
							onComplete: updateColumns
						});
					}
					if(tree4Filter.getParentId(tree4Filter.getSelectedItemId())=="SectionB" ||
						tree4Filter.getParentId(tree4Filter.getSelectedItemId()).indexOf("NAMEDEXPGROUP_")>-1){
						if(fn_check_single_value('measuresDragTable')){
							alert("<%=ResourceUtil.getMessage("arc.select.one.measure",locale)%>");
							return false;
						}
						if(fn_check_single_value('viewDragTable')){
							alert('<%= ResourceUtil.getMessage("arc.select.dimensions", locale)%>');
							return false;
						}
						if(!tree4Filter.hasChildren(tree4Filter.getSelectedItemId()))
						{
							var params = "selQuestionValue="+tree4Filter.getSelectedItemText();
							var url="arcui?nav_action=putFilterQuestion&fromMiningDrag=yes"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
							var myAjax = new Ajax.Request(url,
							{
							method: 'post',
							parameters: params,
							onComplete: updateColumns
							});
						}
					}
				}
			</script>
			</div>

			  <div id="filterViewCon" style="display:none;positon:relative;padding:3px 0px 0px 8px;" onmouseout="hideNmFltrToolTip('kpiNamedFilterPop');">
                <div class="imgPortletBullet"></div>
                &nbsp;<a href="javascript:;" onclick="swapFilters('filterSection')"><%= ResourceUtil.getLabel("arc.search.global.rules", locale)%></a><br />
                <div id="filterSection" style="display:block; padding:3px 0px 0px 0px;position:relative;z-index:99">
                  <div style="float:left">
                    <input type="text" id="searchRules" class="inputField" size="25" onkeyup="javascript:if(!selEnt){arcGsearch.showResult(this,event)}" onkeypress="if(event.keyCode==13){selEnt=true;traverse(this.value, 'out_xml.jsp?csrfPreventionSalt=${csrfPreventionSalt}&action=TemplateTree', tree3, 'searchRules');arcGsearch.gsearchCloseResult('resultText');}else{selEnt=false;}" onfocus="maf()"/>
                    <div id="resultText2" class="resultContainer" onkeydown="javascript:arcGsearch.gsearchkeydown(event);"></div>
                  </div>
                  <div style="float:left;padding-left:5px">
                    <table border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div class="buttonGreyLeft"  onclick="traverse(document.getElementById('searchRules').value, 'out_xml.jsp?csrfPreventionSalt=${csrfPreventionSalt}&action=TemplateTree', tree3, 'searchRules');arcGsearch.gsearchCloseResult('resultText');" onfocus="maf()">
                            <div class="searchButtonText" >&gt;&gt;</div>
							<div class='buttonGreyRight_M'></div>
                          </div></td>
                      </tr>
                    </table>
                    <div id="kpiNamedFilterPop" style="z-index:99999999;width:auto;min-height:20px;height:auto;display:none;background-color:#ffffe1;border:1px solid #000000;position:absolute;left:0px;top:0px;"></div>
                  </div>
                  <div class="imgTreeSort_DESC" style='border-bottom:1px solid #4f8dbc' title='<%= ResourceUtil.getLabel("arc.kpi.sort.desc",locale) %>' id='imgSortTree_3' onclick="toggleTreeSort(tree3,'0','imgSortTree_3')"> </div>
                </div>
                <img src="images/spacer.gif" width="200px" height="10px"/>
			  <div id="treeboxbox_tree3" style="width:100%;overflow-x:hidden" onmousedown="treeClick()"></div>
				  <script type="text/javascript">
							tree3=new dhtmlXTreeObject("treeboxbox_tree3","100%","359",0);
							tree3.setImagePath("dhtmlX/codebaseTree/imgs/expression/");
							tree3.enableDragAndDrop(true);
							tree3.setDragHandler(maf);
							tree3.enableMultiLineItems(true);
							tree3.enableKeyboardNavigation(true);
							tree3.enableSmartXMLParsing(true);
							tree3.loadXML("out_xml.jsp?action=TemplateTree"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt'));
							tree3.allTree.onmouseover = function(e){showNmFltrToolTip('kpiNamedFilterPop',e);};
							tree3.attachEvent("onDblClick",addDblClick3);

							function addDblClick3()
							{
								var tabValue = document.getElementById("DMFTabValue").value;

								if(tabValue=="measures") return false;
								if(fn_check_single_value('measuresDragTable')){
									alert("<%=ResourceUtil.getMessage("arc.select.one.measure",locale)%>");
									return false;
								}
								if(tree3.getParentId(tree3.getSelectedItemId())=="$Alert Templates$"){
									if(fn_check_single_value('viewDragTable')){
										alert('<%= ResourceUtil.getMessage("arc.select.atleast.one.view", locale)%>');
										return false;
									}
									addGlobalExpression(tree3.getSelectedItemId());
								}
							}
					</script>
			</div>
			</td>
        </tr>
      </table>
</div>
      <div id="dimensionBrowserGraMini" class="portletSkinFlo" style="height:492px;width:30px;display:none;position:absolute;margin-left:295px">
        <table border="0" cellspacing="0" cellpadding="0" height="100%">
          <tr>
            <td align="left" valign="top" onclick="showHideGraphLayer('dimensionBrowserGra',42,340)" style="cursor:pointer"><div class="openKPIImgRight" title="<%= ResourceUtil.getLabel("arc.show", locale)%>"></div></td>
            <td align="center" valign="top" onclick="showHideGraphLayer('dimensionBrowserGra',42,340)" style="cursor:pointer; padding-top:2px"><div id="graphBrowserNONIE" class="verticalTextNONIE" style="padding:1px;margin-top:-20px;display:block;line-height:25px;"> <br/>
                <div class='DMDGRBrowser' title="<%= ResourceUtil.getLabel("arc.show", locale)%>"></div>
              </div></td>
          </tr>
        </table>
      </div>
	</div>
	 <div class="bttmNxtPrevBtn"  style="margin-top:20px;  width: 100%; position: relative; right: 0; bottom:0; float: left;">
		<span class="actionBtnGrey"  onclick="javascript:getNextAction();" style="width:50px;"><%= ResourceUtil.getLabel("arc.next", locale) %></span>
 				<span class="actionBtnGrey"  onclick="javascript:getOpenRFMDefPre();" style="width:80px;">&nbsp;&nbsp;<%= ResourceUtil.getLabel("arc.previous", locale) %></span>
	</div>
    </div>
  </div>
<!--MAIN SECTION ENDS-->
<input type="hidden" id="kpiId" name="kpiId" value="<%=kpiId%>"/>
<input type="hidden" name="loadSelectFlag" id="loadSelectFlag" value="yes" />
<input type="hidden" id="layoutSelected" name="layoutSelected" value=""/>
<input type="hidden" id="layoutOrder" name="layoutOrder" value=""/>
<input type="hidden" id="hdKpiPublisher" name="hdKpiPublisher" value="yes"/>
<div id="gridProp" class="toolBar" style="position:absolute;display:none;z-index:99999;top:200px;left:58%;" onmouseover="javascript:hideFlag=false;" onmouseout="javascript:hideFlag=true; if(hideFlag==true){invokeCloser('gridProp')};">
		<div id='toolBarHeader' style='width:375px;cursor:move;' onmousedown="makeFloat('gridProp')">
		    <div style='float:left;cursor:default;'>&nbsp;&nbsp;<%= ResourceUtil.getLabel("arc.select.kpi", locale)%></div>
		    <div style='float:right;'> <div class="imgPortletClose" onclick="document.getElementById('gridProp').style.display='none';" style="cursor:pointer"></div> </div>
	  	</div>
	  	<div id='toolBarContainer' style='width:380px;'>
   		<div class='ContainerStyle'>
			<table width="100%" cellpadding='4' cellspacing='1' border='0' class='tblBorder'>
				<tr>
					<td width='30%' class='tblLabel'><%= ResourceUtil.getLabel("arc.module", locale) %></td>
					<td width='70%' class='tblContent'>
						 <div id="moduleList">
							 <select name="moduleListBox" class='inputField' id="moduleListBox" size="1" onchange="loadKPIGroupList(this)">
							 	<option value="-1"><%= ResourceUtil.getLabel("arc.all", locale) %></option>
							 </select>
						 </div>
					</td>
				</tr>
				<tr>
					<td class='tblLabel'><%= ResourceUtil.getLabel("arc.kpi_group", locale) %></td>
					<td class='tblContent'>
						 <div id="kpiGroupList">
							 <select name="kpiGroupListBox" class='inputField' id="kpiGroupListBox" size="1" onchange="loadKPIList()">
								<option value="-1"><%= ResourceUtil.getLabel("arc.select", locale) %></option>
							 </select>
						</div>
					</td>
				</tr>
				<tr>
					<td class='tblLabel'><%= ResourceUtil.getLabel("arc.kpi", locale) %></td>
					<td class='tblContent'>
					  <div id="kpiList">
						  <select name="kpiListBox" class='inputField' id="kpiListBox" size="1" onchange="loadKPIViewList()">
						  	<option value="-1"><%= ResourceUtil.getLabel("arc.select", locale) %></option>
						  </select>
					  </div>
					</td>
				</tr>
			</table>
			<div  id="gridTble1" style="height:200px">
			 	<div id="kpiViewtbl"></div>
			</div>
			<div class="FooterGrayBarFav">
			<div id="mandatorySection1" style="float:left;display:none;margin: 8px;"></div>
	       	  <div style="float:right; padding-top:4px;">
		        <table border="0" cellspacing="0" cellpadding="0">
		          <tr>
		            <td>
		             <div class="buttonBlueLeft" onclick="selectKPIView()">
		                <div class="buttonText"  ><%= ResourceUtil.getLabel("arc.apply", locale)%></div>
		                <div class="buttonBlueRight_M"></div>
		              </div>
		            </td>
		            <td>&nbsp;</td>
		            <td> 
		               <div class="buttonBlueLeft" onclick="document.getElementById('gridProp').style.display='none'; parent.location.reload(true);">
		                <div class="buttonText"  ><%= ResourceUtil.getLabel("arc.cancel", locale)%></div>
		                <div class="buttonBlueRight_M"></div>
		              </div>
		           </td>
		            <td>&nbsp;</td>
		           </tr>
		         </table>
	           </div>
	         </div>
		</div>
		</div>
</div>
</form>
</body>
</html>
<script type="text/javascript">
gblTabFix();
function buildMeasureLinkTable(tblId){
 document.getElementById('MeasureLinkKPI').style.display='';
 var tblObj=$(tblId);
 var oldexistTab=$('measureLinkTbl');
 var measureids='';
 for(k=1;k<tblObj.rows.length;k++)	{
			 if(k==0){
				 measureids= tblObj.rows[k].id;
			 }else{
			 	measureids=measureids+","+ tblObj.rows[k].id;
			 }
	}
	if(tblObj.rows.length >0){
		 var url="BCMControllerServlet?servletAction=AddEditMeasureLinkKPI&actionMode=Select&measureids="+measureids+"&KPIID=<%=kpiId==null?"":kpiId%>&time="+new Date().getUTCMilliseconds()+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
		 var myAjax = new Ajax.Request(url,
					{
					method: 'post',
					onComplete: function(or){document.getElementById('measureLinkTbl').parentNode.innerHTML=or.responseText;}
					});
	}
}
 var activeBoxId="";
 function updateActiveBox(cntId){
   activeBoxId=cntId;
 }
 function selectKPIView(){
 var myFlag=false;
 var radioInd;
 	for(k=0;k<document.getElementsByName("graphid").length;k++){
 		if(document.getElementsByName("graphid")[k].checked){
 		myFlag=true;
 		radioInd=k;
 		break;
 		}
 	}
 	if(myFlag){
 		document.getElementById(activeBoxId).value=document.getElementsByName("graphid")[0].value;
		document.getElementById(activeBoxId+"_desc").value=document.getElementsByName("graphid")[0].parentNode.nextSibling.nextSibling.innerHTML;
	 	document.getElementsByName("graphid")[radioInd].checked=false;
        document.getElementById('gridProp').style.display='none';
 	}
 	else{
 	document.getElementById('mandatorySection').style.display='block';
 	}
 }
 function showList(obj){
var extVal=obj.id.split("_")[0];
var dropdownVal = obj.value;
		if(dropdownVal == 'KPI'){
		document.getElementById(extVal+'_kpi_span').style.display = 'block';
		document.getElementById(extVal+'_bcm_span').style.display = 'none';
		document.getElementById(extVal+'_jsp_span').style.display = 'none';

	}else if(dropdownVal == 'BCM'){
		document.getElementById(extVal+'_kpi_span').style.display = 'none';
		document.getElementById(extVal+'_bcm_span').style.display = 'block';
		document.getElementById(extVal+'_jsp_span').style.display = 'none';
	}
	else if(dropdownVal == 'JSP'){
		document.getElementById(extVal+'_kpi_span').style.display = 'none';
		document.getElementById(extVal+'_bcm_span').style.display = 'none';
		document.getElementById(extVal+'_jsp_span').style.display = 'block';
	}

}
function submitMeasureLinkDetails(kpiId){
	var tblObj=$('measureLinkTbl');
	var rowNum = tblObj.rows.length-1;
	var msrId = '';
	unSelectedMeasureIds = '';
	for(a=1;a<=rowNum;a++){
		if(tblObj.rows[a].childNodes[0].childNodes[0].checked){
			msrId = tblObj.rows[a].childNodes[0].childNodes[0].value;
			msrId = msrId.split("_")[0];
			var optionSelected = tblObj.rows[a].childNodes[2].childNodes[0].value.toLowerCase().toLowerCase();
			var textValue = $(msrId+"_"+optionSelected).value;
			var textOldValue ='';
			if($(msrId+"_"+optionSelected+"_old"))
			textOldValue =$(msrId+"_"+optionSelected+"_old").value;
			if(textValue=='' && textOldValue==''){
				alert("<%=ResourceUtil.getMessage("ARC.PUBLISHER.BLANK.VALUE", locale)%>");
				return false;
			}
			if(optionSelected=='bcm' && textValue!='')
				if(textValue.split(".")[textValue.split(".").length-1].toLowerCase()!='bcm'){
					alert("<%=ResourceUtil.getMessage("ARC.PUBLISHER.SELECT.BCM", locale)%>");
					return false;
				}
			if(optionSelected=='jsp' && textValue!='')
				if(textValue.split(".")[textValue.split(".").length-1].toLowerCase()!='jsp'){
					alert("<%=ResourceUtil.getMessage("ARC.PUBLISHER.SELECT.JSP", locale)%>");
					return false;
				}
		}
		else{
			if(unSelectedMeasureIds == '')
				unSelectedMeasureIds = tblObj.rows[a].childNodes[0].childNodes[0].value;
			else
				unSelectedMeasureIds = unSelectedMeasureIds + ',' + tblObj.rows[a].childNodes[0].childNodes[0].value;
		}
	}
	document.mform.action="BCMControllerServlet?csrfPreventionSalt="+ $F('csrfPreventionSalt')+"&servletAction=AddEditMeasureLinkKPI&actionMode=Save&fromKPIId="+kpiId+"&unSelectedMeasureIds="+unSelectedMeasureIds;
	document.mform.submit();
}
setDHTMLXTreeHeight('treeboxbox_tree1,treeboxbox_tree3','405');

function openmeasurelink(){
if(document.getElementById('measuresDragTable').childNodes[0].childNodes[0].childNodes.length>=2){
buildMeasureLinkTable('measuresDragTableCon');
}
else{alert("Please Drag Atleast One Measure To Link");
document.getElementById('MeasureLinkKPI').style.display='none';
}
}
</script>

<script>
function blockUI(){
	document.getElementById('LoadingDiv').style.display='block';
	document.getElementById('loader_div').style.display='block';
	document.getElementById('loaderMsgDiv').style.display='block';

}
function unBlockUI(){
	document.getElementById('LoadingDiv').style.display='none';
	document.getElementById('loader_div').style.display='none';
	document.getElementById('loaderMsgDiv').style.display='none';
}
function showToolTip(tipId){
	TagToTip(tipId, BALLOON, true, ABOVE, true, PADDING, 8, TEXTALIGN, 'justify', OFFSETX, -17);
}
var modelId = '<%= modelId%>';
var mygrid = null;
getLoadScope();
function addKPIPubViewListGen(val, val1, val2, itemType,fromDest){
	try{
	var benchmarkTarget;
	var callFrom="no";
	if ( fromDest == 'undefined'){
		fromDest = null ;
	}else if(fromDest=="BenchmarkTarget"){
		benchmarkTarget ="yes";
		fromDest="yes";
	}
	if(itemType.indexOf("_")!=-1){
	callFrom=itemType.split("_")[1];
	itemType=itemType.split("_")[0];
	}
	var url="arcui?nav_action=KPIPUB_VIEWS&draggedVID="+val2+"&srcHtmlObjLabel="+val+"&targetHtmlObject="+val1+"&itemType="+itemType+"&fromDest="+fromDest+"&benchmarkTarget="+benchmarkTarget+"&callFrom="+callFrom+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
	url=encodeURI(url);
	var params = Form.serialize(document.form1);
	var myAjax = new Ajax.Request(url,
	{
	method: 'post',
	parameters:params,
	onComplete: function(or){updateColumns(or);
	if(document.getElementById('LoadingDiv').style.display!='none')
		unBlockUI();
	}
	});
	}catch(e){
		if(document.getElementById('LoadingDiv').style.display!='none')
			unBlockUI();
	}
}

window.document.body.onclick=function(e){
	if (window.event) e = window.event;
	var src = e.srcElement? e.srcElement : e.target;
	var DatePicker = document.getElementById('gToday:jsDateNormal_DFM:jsDateAgenda.js');
	if(src.className!="imgDatePicker") {
		 if(DatePicker && DatePicker.style.visibility =='visible') {
		 	DatePicker.style.visibility = 'hidden';
		 	return;
		 }
	 }
}
	    function getNextAction(){
	    	var pageName = "ANALYSIS_SCOPE";
	    	var nextURL = "RFMAnalysisHandler?csrfPreventionSalt="+ $F('csrfPreventionSalt')+"&nav_action=getNextAction&modelId="+<%=modelId%>+"&pageName="+pageName;
	    	var myAjax = new Ajax.Request(nextURL,
			{
				method: 'post',
				onComplete: nextAction
			});
	    }
	    function nextAction(resObj){
	    	var returnMag = resObj.responseText;
	    	if(returnMag == 0){
	    		alert('<%= ResourceUtil.getMessage("arc.rfm.please.complete.set.scope", locale)%>');
	    	}else{
	    		getOpenRFMDef();
	    	}
	    }
	    function getOpenRFMDefPre(){
	         var url = "rfm_summary.jsp?modelId="+<%=modelId%>+"&modelName="+'<%=encodeForXss(modelName,URI)%>'+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
	         window.open(url,'_self');
	    }
	    function getOpenRFMDef(){
	        var url = "rfm_definition.jsp?modelId="+<%=modelId%>+"&modelName="+'<%=encodeForXss(modelName,URI)%>'+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
	        window.open(url,'_self');
	   }
	function getautoquery(){
	 var url="RFMAnalysisHandler?nav_action=previousPageCheck&modelId="+<%=modelId%>+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
	var myAjax = new Ajax.Request(url,{method: 'post',asynchronous:false,onComplete: function(or){performAction(or);}});
	}

function performAction(or){
	var returnMsg = or.responseText;
	if(returnMsg == 'true' || returnMsg == true){
		alert("<%= ResourceUtil.getMessage("arc.rfm.model.is.finalized.cannot.update.model", locale)%>");
		return false;
	}else{
		document.getElementById('loaderTextSpan').innerHTML='<%= ResourceUtil.getLabel("arc.rfm.extracting.data.please.wait", locale) %>';
		blockUI();
        var url = "RFMAnalysisHandler?nav_action=getAutoquery&view_id=KPIPUB_VIEWID_C094006398598BB366B05E81B20D86A1&reqFrom=RFM&modelId="+ modelId+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
	            var params = Form.serialize(document.form1);
			var myAjax = new Ajax.Request(url,{method: 'post',parameters:params,onComplete: function(orgreq){
				if(orgreq.responseText == 'running'){
					unBlockUI();
					alert("<%= ResourceUtil.getMessage("arc.rfm.another.user.is.preparing.model.data.please.try.after.some.time", locale)%>");
					return;
				}else if(orgreq.responseText.indexOf("invalidData")!=-1) {
					 //document.getElementById("resultId").style.display="Block";
					 //getLoadScope();
					 unBlockUI();
					 alert("<%= ResourceUtil.getMessage("arc.rfm.min.number.customer.required", locale)%> "+orgreq.responseText.split('##')[1]+", <%= ResourceUtil.getMessage("arc.rfm.retry", locale)%>");
					 return;
				 }
				 else if(orgreq.responseText=="0") {
					 document.getElementById("resultId").style.display="none";
  			      unBlockUI();
			      alert('<%= ResourceUtil.getMessage("arc.rfm.current.selection.fetched.no.records.retry.again", locale)%>');
			    }else if(orgreq.responseText=="-1") {
  			      unBlockUI();
			      alert('<%= ResourceUtil.getMessage("arc.rfm.error.while.execute.query", locale)%>');
			    }
			    else {
				   	 document.getElementById("resultId").style.display="Block";
				   			  getLoadScope();
				   			 unBlockUI();
				 	 alert('<%= ResourceUtil.getMessage("arc.rfm.model.data.preparation.successfully.completed", locale)%>');
				 }
			  }
			});
	}
}
function removeSessionvariable(){
    var url="out_xml_mining.jsp?action=clearSessionvariable"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
	var myAjax = new Ajax.Request(url,{method: 'post',
		onComplete: function(o){
		//unBlockUI();
	}
	});
}
function getLoadScope(){
	 var url = "RFMAnalysisHandler?nav_action=LoadScopeSummary&modelId="+ modelId+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
new Ajax.Updater({success: 'ScopeSummary'}, url, {asynchronous:true, onFailure: reportError,evalScripts: true});
}
function updateStepId(resObj){
  return true;
}
function resetFilterValuesDimForMining(){
		var url = "segmentationHandler?nav_action=resetFilters"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
  	var myAjax = new Ajax.Request(url,{method: 'post',onComplete: function(orgreq){orgreq.responseText.evalScripts();}});
}
document.getElementById('helpDiv').style.display='block';
function deleteKPIPUBFilter(selFID){
	if(selFID.length==0){
		alert('<%=ResourceUtil.getMessage("arc.script.select.filter.todelete", locale)%>');
		return;
	}

	if(selFID.indexOf("a_2")!=-1){
		alert('<%= ResourceUtil.getMessage("arc.script.expression.cannot.bedeleted", locale)%>');
		return;
	}
	if(selFID.indexOf("time")!=-1 || selFID.indexOf("period")!=-1 || selFID.indexOf("a_2")!=-1){
		alert("<%= ResourceUtil.getMessage("arc.rfm.time.filter.cannot.be.deleted", locale)%>");
		return;
	}
	var pId = treeboxbox_treeFilter.getParentId(selFID);
	if(confirm('<%=ResourceUtil.getMessage("arc.you.want.todelete.filters", locale)%>')){
		treeboxbox_treeFilter.deleteItem(selFID,true);
		if(!treeboxbox_treeFilter.hasChildren(pId)){
			treeboxbox_treeFilter.deleteItem(pId,true);
		}
		var url="arcui?nav_action=KPIPUB_DELFILTER&selFID="+selFID+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
		var myAjax = new Ajax.Request(url,
		{
		method: 'post',
		onComplete: updateColumns
		});
	}
}
document.onreadystatechange = function() {
	if (this.readyState == "complete") {
		this.onreadystatechange = null;
		document.getElementById('loaderTextSpan').innerHTML='<%= ResourceUtil.getLabel("arc.listgen.initializing.startup.screen.please.wait", locale) %>';
		blockUI();
		addKPIPubMeasure("",'measuresDragTableCon','<%=RFMMeasureUsed%>','measure');
		document.getElementById('DMFTabValue').value="dimensions";
		var t2=setTimeout(function(){ addKPIPubViewListGen('<%=RFMDimensionLevelUsed%>', 'viewDragTableCon', '<%=paramNameForCustomer%>','dimension_yes');clearTimeout(t2);},3000);
	}
}
</script>
<%
	}catch(Exception e){
		e.printStackTrace();
	}
%>
