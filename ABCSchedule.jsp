<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%com.manthan.promax.security.SecurityEngine.isSessionOver(request,response,"login.jsp");%>
<%@ page import="com.manthan.promax.security.schmail.Mailer"%>
<%@ include file="userSession.jsp" %>
<%@ include file="scriptLocalize.jsp" %>
<%@ include file="script.jsp" %>
<%@page import="com.manthan.arc.mining.commons.MeasureSelectionHelper"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	int user_id = Integer.parseInt(request.getSession().getAttribute("UserID").toString());
%>
<meta http-equiv="Content-Type" content="text/html; charset=<%= session.getAttribute("CHARSET").toString()%>" />
<title><%= com.manthan.promax.security.schmail.Mailer.getPropValue("arc.title").toString() %> - <%=ResourceUtil.getLabel("arc.abc.title", locale)%></title>
<link href="css/style<%=userSelectedTheme%>.less" rel="stylesheet/less" type="text/css" />
<script language="javascript" type="text/javascript" src="js/less.js"></script>
<script language="javascript" type="text/javascript" src="js/general.js"></script>
<script language="javascript" type="text/javascript" src="js/drag.js"></script>
<script language="javascript" type="text/javascript" src="js/script.js"></script>
<script language="javascript" type="text/javascript" src="js/mining.js"></script>
<script type="text/javascript">
isNav = (document.all) ? false : true;
isIE = (document.all) ? true : false;
if (isNav && !isIE)
	window.onclick = closeUtilitys;
else if (isIE && !isNav)
	document.onclick = closeUtilitys;
</script>

<!--DHTMLX-->
<!--TAB-->
<link rel="STYLESHEET" type="text/css" href="dhtmlX/codebaseTab/dhtmlxtabbar.css"/>
<script  src="dhtmlX/codebaseTab/dhtmlxcommon.js"></script>
<script  src="dhtmlX/codebaseTab/dhtmlxtabbar.js"></script>
<script  src="dhtmlX/codebaseTab/dhtmlxtabbar_start.js"></script>
<!--TREE GRID-->
<link rel="STYLESHEET" type="text/css" href="dhtmlX/codebaseGrid/dhtmlxgrid.css"/>
<script  src="dhtmlX/codebaseGrid/dhtmlxcommon.js"></script>
<script  src="dhtmlX/codebaseGrid/dhtmlxgrid.js"></script>
<script  src="dhtmlX/codebaseGrid/dhtmlxgridcell.js"></script>
<script  src="dhtmlX/codebaseTreeGrid/dhtmlxtreegrid.js"></script>
<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_start.js"></script>
<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_excell_link.js"></script>
<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_drag.js"></script>
<!--TREE-->
<link rel="STYLESHEET" type="text/css" href="dhtmlX/codebaseTree/dhtmlxtree.css"/>
<script  src="dhtmlX/codebaseTree/dhtmlxtree.js"></script>
<script  src="dhtmlX/codebaseTree/dhtmlxcommon.js"></script>
<script  src="dhtmlX/codebaseTree/dhtmlxtree_start.js"></script>
<script  src="dhtmlX/codebaseTree/dhtmlxtree_kn.js"></script>
<script  src="dhtmlX/codebaseTree/dhtmlxtree_xw.js"></script>
<!--DHTMLX ENDS-->

<script>
var userId = '<%= user_id%>';
var schjob = "ADP_"+userId;	//ABC_DATA_PREP

 var swapAr=new Array("A","B","C","D","E");
function swapChar(obj,ordNo){
 for(i=0; i< swapAr.length; i++){
   if(obj.value==swapAr[i]){
    document.getElementById("drop_"+(i+1)).value=swapAr[ordNo-1];
	swapAr[i]=swapAr[ordNo-1];
	swapAr[ordNo-1]=obj.value;
   }
 }
}


function getProcessDetails(){
	document.getElementById('resultsDiv').style.display='block';
	var url = "miningAction?nav_action=schedulingProcessDetailsInfoGrid&uniqueJob=ABC_DATA_PREP"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
	new PeriodicalExecuter(function(pe) {
		new Ajax.Updater({success: 'processUpdater'}, url, {asynchronous:true, onFailure: reportError, evalScripts: true,
			onComplete:function(ob){
				if ((ob.responseText).indexOf('Execution Completed')>=0 || (ob.responseText).indexOf('Execution Failed')>=0){
					pe.stop();

					$('loadForecastBtnDiv').onclick=loadData;
					$('previousBtnDiv').onclick=navigate;

				}
			}
		});
	},1);
}

</script>
</head>
<body>
<form name="form1" id="form1">
<input type="hidden" id="csrfPreventionSalt" name="csrfPreventionSalt" value="${csrfPreventionSalt}"/>
<%
	try{

	String [] arr = null ;
	String len = "";

	String rankSelectedSchedule =com.manthan.arc.security.CrossSiteScriptingHandler.encodeForXss(request.getParameter("rankSelected"),com.manthan.arc.security.CrossSiteScriptingHandler.HTMLATTRIBUTE);
	session.setAttribute("RANK_SELECTED",rankSelectedSchedule);

	String ranks = rankSelectedSchedule.substring(0, rankSelectedSchedule.lastIndexOf(","));
	session.setAttribute("RANKS", ranks);


	// get the selected measures list
	// and store it in session

	String selectedMeasureList = (null!=request.getParameter("selectedMeasureList") && request.getParameter("selectedMeasureList").trim().length()>0 ? com.manthan.arc.security.CrossSiteScriptingHandler.encodeForXss(request.getParameter("selectedMeasureList"),com.manthan.arc.security.CrossSiteScriptingHandler.HTMLATTRIBUTE) : "");
	String[] tempArr = {};
	String[] dtlsArr = {};
	if(!"".equals(selectedMeasureList)){
		if(selectedMeasureList.indexOf(",")>=0){
			dtlsArr = selectedMeasureList.split(",");
		}
		else{
			dtlsArr = new String[1];
			dtlsArr[0]=selectedMeasureList;
		}
	}
	HashMap<String, String> selectedMeasDtls = new HashMap<String, String>();
	if(null!=dtlsArr && dtlsArr.length>0){
		for(int i=0; i<dtlsArr.length; i++){
			if(null!=dtlsArr[i] && dtlsArr[i].trim().length()>0 && dtlsArr[i].indexOf("!")>=0){
				tempArr = dtlsArr[i].split("!OF!");
				selectedMeasDtls.put(tempArr[0], tempArr[1]);
			}
		}
	}
	if(null==session.getAttribute("PRODUCT_RATIONALIZATION_SELECTED_MEASURE_DETAIL") || ((HashMap<String, String>) session.getAttribute("PRODUCT_RATIONALIZATION_SELECTED_MEASURE_DETAIL")).size()==0){
		session.setAttribute("PRODUCT_RATIONALIZATION_SELECTED_MEASURE_DETAIL", selectedMeasDtls);
	}

	String measureName = new MeasureSelectionHelper().getSelectedMeasureName(request, "Sales");
	String measureNameMargin = new MeasureSelectionHelper().getSelectedMeasureName(request, "Margin");
	String measureNameInv = new MeasureSelectionHelper().getSelectedMeasureName(request, "Inventory");

%>
<div class="heading" style="float:none"><%=ResourceUtil.getLabel("arc.abc.analysis", locale)%></div>
<div id="headingLine"><div id="headingLine_inner"></div></div>
<!--MAIN SECTION-->
<div id="admain" style='float:left;width:98%'>
	<div   class="topIcons"  onclick="location.href='ABC_introduction.jsp?csrfPreventionSalt=${csrfPreventionSalt}'">
	 <span class="img_Introduction"   title='<%= ResourceUtil.getLabel("arc.abc.introduction", locale)%>'></span>
	 <%=ResourceUtil.getLabel("arc.abc.introduction", locale)%></div>
	<div class="topIconsSeperatorPro"></div>
  <div   class="topIcons"  onclick="location.href='ABCAnalysis.jsp?csrfPreventionSalt=${csrfPreventionSalt}'">
  <span class="img_Atrribute"></span>
    <%=ResourceUtil.getLabel("arc.abc.attribute.selection", locale)%></div>
  <div class="topIconsSeperatorPro"></div>
  <div   class="topIconsActive" >
   <span class="imgSubscribeReports"></span>
    <%=ResourceUtil.getLabel("arc.abc.schedule", locale)%></div>
    <br/>
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
	  <tr>
	    <td><img src="images/spacer.gif" width="1" height="4" /></td>
	    <td><img src="images/spacer.gif" width="1" height="4" /></td>
	    <td><img src="images/spacer.gif" width="1" height="4" /></td>
	  </tr>
	  <tr>
	    <td><img src="images/infobarLeftTop.gif" width="2" height="2" /></td>
	    <td background="images/infobarTop.gif"><img src="images/spacer.gif" width="1" height="1" /></td>
	    <td><img src="images/infobarRightTop.gif" width="2" height="2" /></td>
	  </tr>
	  <tr>
	    <td background="images/infobarLeft.gif"><img src="images/spacer.gif" width="1" height="1" /></td>
	    <td bgcolor="#fff5b3" width="100%" style="padding:2px" height="28"> <%=ResourceUtil.getLabel("arc.abc.schedule.content", locale)%></td>
	    <td background="images/infobarRight.gif"><img src="images/spacer.gif" width="1" height="1" /></td>
	  </tr>
	  <tr>
	    <td><img src="images/infobarLeftBottom.gif" width="2" height="2" /></td>
	    <td background="images/infobarBottom.gif"><img src="images/spacer.gif" width="1" height="1" /></td>
	    <td><img src="images/infobarRightBottom.gif" width="2" height="2" /></td>
	  </tr>
	</table>
  <img src="images/spacer.gif" width="200" height="15" /><br />
  <div id="hierarchyBrowser" class="portletSkin" style="display:block">
    <div class="portletHeader">


    <div class="kpiUtilityBar" style="float:right"> <!--  <a href='javascript:void(0)' onclick="invokePopup('Product Rationalization - Schedule Status Report ', 'rationalizationScheduledJobs.jsp', '30,50', '500', '90')"><img src='images/icon_topbar_myreport.gif' align='absmiddle' border='0'/>Schedule Status</a>--></div>


      <%=ResourceUtil.getLabel("arc.common.schedule", locale)%> </div>
    <div class="innerPortlet" style="min-height:375px; height:auto"><span class="subHeadingSmall"><%=ResourceUtil.getLabel("arc.abc.rank.classification", locale) %></span><br />
	    <table width="100%" border="0" cellspacing="1" cellpadding="4" class="tblBorder">
	      <tr>
            <td class="tblLabel" valign="top"><%=ResourceUtil.getLabel("arc.abc.master.classification", locale)%></td>
	        <td class="tblContent"><%=ranks %> </td>
          </tr>
	      <tr>
            <td class="tblLabel" valign="top"><%=ResourceUtil.getLabel("arc.selected.measures", locale)%></td>
	        <td class="tblContent">
	        <%
	        	String allMeasures = measureName + "," + measureNameMargin + "," + measureNameInv ;
	        	out.println(allMeasures);
	        %>

	        </td>
          </tr>


          <!-- Classification by sales row starts -->

          <tr>
            <td width="17%" class="tblLabel" valign="top"><%=ResourceUtil.getLabel("arc.abc.classification.by.sales", locale)%></td>
            <td width="83%" class="tblContent">
            <table  border="0" cellspacing="1" cellpadding="2">
<%	      			if(session.getAttribute("RANK_SELECTED")!=null){
					String rankSelected = (String) session.getAttribute("RANK_SELECTED");
					if(rankSelected.contains(",")){
						arr = rankSelected.split(",");
						int count=0;
						int divideSalesMeasures = Integer.parseInt(rankSelected.split("_")[1]);
						double percentileShare = 100/divideSalesMeasures;
						double incrementalPercentileShare = 0;
						int tempCount = 0;
						for(String arrElement:arr){
							if(arrElement.contains("number")){
									break;
							}
							incrementalPercentileShare=incrementalPercentileShare+percentileShare;
							tempCount = count+1;
							if(count==0 ){
							%>

								<tr>
	          					<td><span class='contentBlackBold'><%=ResourceUtil.getLabel("arc.abc.condition", locale)%>  <%=++count %>:</span>  </td>
	          					<td><%=ResourceUtil.getLabel("arc.abc.if.cumulative",measureName, locale)%></td><td colspan='2'><b> <strong>&lt;=</strong></b>
	              					<input name="textfieldSales<%=tempCount %>" onkeypress="return maskNumeric(event);" type="text"  id="textSales<%=tempCount %>_<%=tempCount %>" class="inputField" <%if(tempCount==(arr.length)-1){ %>value="100" <% }else {%> value="<%= incrementalPercentileShare%>" <%} %> size="5" readonly="readonly" />
	            					<%=ResourceUtil.getLabel("arc.abc.if.greater.then",arrElement, locale)%>
	            				</td>
	        				</tr>
							<%
							}else{%>
								<tr>
		          				<td><span class='contentBlackBold'><%=ResourceUtil.getLabel("arc.abc.condition", locale)%>  <%=++count %>:</span>  </td>
		          				<td><%=ResourceUtil.getLabel("arc.abc.if.cumulative",measureName, locale)%></td> <td><b> <strong>&gt;</strong></b>
		              				<input name="textfieldSales<%=tempCount %>"  onkeypress="return maskNumeric(event);" type="text" id="text<%=tempCount %>_<%=tempCount %>" class="inputField" value="<%=incrementalPercentileShare - percentileShare%>" size="5" readonly="readonly"/>
		            				<%=ResourceUtil.getLabel("arc.abc.if.less.and", locale)%>
		            				<input name="textfieldSales<%=tempCount %><%=tempCount %>" onkeypress="return maskNumeric(event);"  type="text" id="textSales<%=tempCount %>_<%=tempCount+1 %>" class="inputField" <%if(tempCount==(arr.length)-1){ %>value="100" <% }else {%> value="<%= incrementalPercentileShare%>" <%} %> size="5" />
		            				<%=ResourceUtil.getLabel("arc.abc.if.greater.then",arrElement, locale)%>
		            			</td>
		        			</tr>
							<%}
						}
					}
				}else{ %>
	        			<tr>
	          				<td><%=ResourceUtil.getLabel("arc.abc.condition1", locale)%> : </td>
	          				<td>
	          					<%=ResourceUtil.getLabel("arc.abc.cumulative", locale)%> <%= measureName%>% <b>&lt;=</b>
	              				<input name="textfieldSales" onkeypress="return maskNumeric(event);" type="text" id="text1_1"  class="inputField" value="70" size="5" />
	            				% A
	            			</td>
	        			</tr>
	        			<tr>
	          				<td width="15%" class="tblLabel" valign="top"><%=ResourceUtil.getLabel("arc.abc.condition2", locale)%> :</td>
	          				<td width="85%" class="tblContent">
	          					<%=ResourceUtil.getLabel("arc.abc.cumulative", locale)%>  <%= measureName%>% <b>&gt;</b>
	              				<input name="textfieldSales2" type="text" onkeypress="return maskNumeric(event);" id="text2_2"  class="inputField" value="70" size="5" />
	            				% <strong>AND</strong> <b>&lt;=</b>
	            				<input name="textfieldSales22" type="text" id="text2_3" onkeypress="return maskNumeric(event);" class="inputField" value="90" size="5" />
	            				% B
	            			</td>
	        			</tr>
	        			<tr>
	          				<td class="tblLabel" valign="top"><%=ResourceUtil.getLabel("arc.abc.condition3", locale)%> : </td>
	          				<td class="tblContent">
	          					<%=ResourceUtil.getLabel("arc.abc.cumulative", locale)%>  <%= measureName%>% <b>&gt;</b>
	              				<input name="textfieldSales3" type="text" id="text3_3" onkeypress="return maskNumeric(event);" class="inputField" value="90" size="5" />
	            				% C
	            			</td>
	        			</tr>
	        			<%} %>
	      			</table>
              </td>
          </tr>
          <tr>
            <td class="tblLabel" valign="top"><%=ResourceUtil.getLabel("arc.abc.classification.by.margin", locale)%></td>
            <td class="tblContent">
            <table  border="0" cellspacing="0" cellpadding="3">
              <tr>
	      					<%

	      						if ( session.getAttribute("RANK_SELECTED") == null ){
	      							session.setAttribute("RANK_SELECTED","A,B,C,number_3");
	      						}
				      			if(session.getAttribute("RANK_SELECTED")!=null){
								String rankSelected = (String) session.getAttribute("RANK_SELECTED");
								if(rankSelected.contains(",")){
									arr = rankSelected.split(",");
									int count=0;
									int divideSalesMeasures = Integer.parseInt(rankSelected.split("_")[1]);
									double percentileShare = 100/divideSalesMeasures;
									double incrementalPercentileShare = 0;
									int tempCount = 0;
									for(String arrElement:arr){
										if(arrElement.contains("number")){
												break;
										}
										incrementalPercentileShare=incrementalPercentileShare+percentileShare;
										tempCount = count+1;
										if(count==0 ){
							%>

								<tr>
	          					<td><span class='contentBlackBold'><%=ResourceUtil.getLabel("arc.abc.condition", locale)%>  <%=++count %>:</span> </td>
	          					<td>
	          					<%=ResourceUtil.getLabel("arc.abc.if.cumulative",measureNameMargin, locale)%> <b><strong>&lt;=</strong></b>
	              					<input name="textfieldMargin<%=tempCount %>" type="text" onkeypress="return maskNumeric(event);" id="textMargin<%=tempCount %>_<%=tempCount %>" class="inputField" <%if(tempCount==(arr.length)-1){ %>value="100" <% }else {%> value="<%= incrementalPercentileShare%>" <%} %> size="5" />
	            					<%=ResourceUtil.getLabel("arc.abc.if.greater.then",arrElement, locale)%>
	            			</td>
	        			</tr>
							<%
							}else{%>
								<tr>
		          				<td><span class='contentBlackBold'><%=ResourceUtil.getLabel("arc.abc.condition", locale)%>  <%=++count %>:</span> </td>
		          				<td>
		          				<%=ResourceUtil.getLabel("arc.abc.if.cumulative",measureNameMargin, locale)%> <b>&gt;</b>
		              				<input name="textfieldMargin<%=tempCount %>_<%=tempCount %>"  onkeypress="return maskNumeric(event);" type="text" id="textMargin<%=tempCount %>_<%=tempCount %>" class="inputField" value="<%=incrementalPercentileShare- percentileShare%>" size="5" />
		            				<%=ResourceUtil.getLabel("arc.abc.if.less.and",locale)%>
		            				<input name="textfieldMargin<%=tempCount %>_<%=tempCount+1 %>"  onkeypress="return maskNumeric(event);" type="text" id="textMargin<%=tempCount %>_<%=tempCount+1 %>" class="inputField" <%if(tempCount==(arr.length)-1){ %>value="100" <% }else {%> value="<%= incrementalPercentileShare%>" <%} %> size="5" />
		            				<%=ResourceUtil.getLabel("arc.abc.if.greater.then",arrElement, locale)%>
		            			</td>
		        			</tr>
							<%}
						}
					}
					}else{ %>
	        					<tr>
	          						<td><span class='contentBlackBold'><%=ResourceUtil.getLabel("arc.abc.condition1", locale)%> : </span></td>
	          						<td>
	          							<%=ResourceUtil.getLabel("arc.abc.cumulative", locale)%>  <%= measureNameMargin%> <b>&lt;=</b>
	              						<input name="textfieldMargin" type="text" id='text1_1' onkeypress="return maskNumeric(event);" class="inputField" value="70" size="5" />
	            						% A
	            					</td>
	        					</tr>
	        					<tr>
	          						<td><span class='contentBlackBold'><%=ResourceUtil.getLabel("arc.abc.condition2", locale)%> : </span></td>
	          						<td>
	          							<%=ResourceUtil.getLabel("arc.abc.cumulative", locale)%>  <%= measureNameMargin%> <b>&gt;</b>
	              						<input name="textfield2Margin" type="text" id='text2_1' onkeypress="return maskNumeric(event);" class="inputField"  value="70" size="5" />
	            						<%=ResourceUtil.getLabel("arc.abc.if.less.and",locale)%>
	            						<input name="textfield22Margin" type="text" id='text2_2' onkeypress="return maskNumeric(event);" class="inputField"  value="90" size="5" />
	            						% B
	            					</td>
	        					</tr>
	        					<tr>
	          						<td><span class='contentBlackBold'><%=ResourceUtil.getLabel("arc.abc.condition3", locale)%> : </span></td>
	          						<td>
	          							<%=ResourceUtil.getLabel("arc.abc.cumulative", locale)%>  <%= measureNameMargin%> <b>&gt;</b>
	              						<input name="textfield3Margin" type="text" id='text3_1' onkeypress="return maskNumeric(event);" class="inputField"  value="90" size="5" />
	            						% C
	            					</td>
	        					</tr>
	        					<%} %>
	      					</table>
               </td>
          </tr>


          <tr>
            <td class="tblLabel" valign="top"><%=ResourceUtil.getLabel("arc.abc.classification.by.inventory", locale)%></td>
            <td class="tblContent">
            <table  border="0" cellspacing="0" cellpadding="3">
              <%	if(session.getAttribute("RANK_SELECTED")!=null){
					int p=1;
					String rankSelected = (String) session.getAttribute("RANK_SELECTED");
					if(rankSelected.contains(",")){
						arr = rankSelected.split(",");
						int count=0;
						int divideSalesMeasures = Integer.parseInt(rankSelected.split("_")[1]);
						double percentileShare = 100/divideSalesMeasures;
						double incrementalPercentileShare = 0;
						int tempCount = 0;
						for(String arrElement:arr){
							if(arrElement.contains("number")){
									break;
							}
							incrementalPercentileShare = incrementalPercentileShare + percentileShare;
							tempCount = count+1;
							if(count==0 ){ p=1;
							%>

							<tr>
	          					<td><span class='contentBlackBold'><%=ResourceUtil.getLabel("arc.abc.condition", locale)%>  <%=++count %>:</span> </td>
	          					<td>
	          						<%=ResourceUtil.getLabel("arc.abc.schedule.if.gt",measureNameInv, locale)%>
	              					<input name="textfieldInv<%=tempCount+"_"+p %>" type="text" onkeypress="return maskNumeric(event);" id="textInv<%=tempCount+"_"+p %>" class="inputField" value="" size="5"  />
	            					<b>%</b> <strong> <%=ResourceUtil.getLabel("arc.common.then", locale)%></strong> <%=ResourceUtil.getLabel("arc.abc.classification.is", locale)%><strong> <strong><%=arrElement %></strong>
		            			</td>
		        			</tr>
								<%
							}else{ p=1;%>
								<tr>
			          				<td><span class='contentBlackBold'><%=ResourceUtil.getLabel("arc.abc.condition", locale)%>  <%=++count %>:</span></td>
			          				<td>
			          					<%=ResourceUtil.getLabel("arc.abc.schedule.if.lt",measureNameInv, locale)%>
			              				<input name="textfieldInv<%=tempCount+"_"+p %>" type="text" onkeypress="return maskNumeric(event);" id="textInv<%=tempCount+"_"+p %>" class="inputField" value="" size="5" />
			            				<b>%</b> <strong><%=ResourceUtil.getLabel("arc.common.and", locale)%></strong> <b>&gt;=</b>
			            				<input name="textfieldInv<%=tempCount+"_"+ ++p %>" type="text" onkeypress="return maskNumeric(event);" id="textInv<%=tempCount+"_"+p %>" class="inputField" value=""  size="5" />
			            				 <b>%</b> <strong> <%=ResourceUtil.getLabel("arc.common.then", locale)%></strong> <%=ResourceUtil.getLabel("arc.abc.classification.is", locale)%> <strong> <strong><%=arrElement %></strong>
			            			</td>
			        			</tr>
								<%}
							}
						}
					} %>
            </table></td>
          </tr>


          <tr>
            <td class="tblLabel" valign="top"><%=ResourceUtil.getLabel("arc.abc.final.classification", locale) %></td>
            <td class="tblContent">
            <table  border="0" cellspacing="0" cellpadding="3">
             <%
	        			if(session.getAttribute("RANK_SELECTED")!=null){
						int p=1;
						String rankSelected = (String) session.getAttribute("RANK_SELECTED");
						if(rankSelected.contains(",")){
							 arr = rankSelected.split(",");
							int count=0;
							int divideSalesMeasures = Integer.parseInt(rankSelected.split("_")[1]);
							double percentileShare = 100/divideSalesMeasures;
							double incrementalPercentileShare = 0;
							int tempCount = 0;
							for(String arrElement:arr){
								if(arrElement.contains("number")){
										break;
								}
								incrementalPercentileShare = incrementalPercentileShare + percentileShare;
								tempCount = count+1;
					%>
							<tr>
								<td valign="top"><span class='contentBlackBold'><%=ResourceUtil.getLabel("arc.abc.condition", locale)%>  <%=++count %>:</span> </td>

								<td class="tblContent">
									<strong><%=ResourceUtil.getLabel("arc.common.if", locale)%></strong> <%=ResourceUtil.getLabel("arc.abc.count.of", locale)%></td>
								<td><%=arrElement  %></td><td> <b>&gt;=</b></td>
								<td>
									<input name="textfieldFinal<%=tempCount %>" type="text" onkeypress="return maskNumeric(event);" id="textFinal<%=tempCount %>" class="inputField" value="" size="5"  />

									&nbsp;&nbsp;<strong><%=ResourceUtil.getLabel("arc.common.then", locale)%></strong> <%=ResourceUtil.getLabel("arc.abc.classification.is", locale)%>&nbsp;&nbsp;
										<select id="drop_<%=tempCount %>" name="drop_<%=tempCount %>" class='inputField' onchange="swapChar(this,<%=tempCount %>)">
											<%
											if(session.getAttribute("RANK_SELECTED")!=null){
												String selectedRank = (String) session.getAttribute("RANK_SELECTED");
												if(selectedRank.contains(",")){
													String [] rankArr = rankSelected.split(",");
													len = (rankArr.length)+"";
													for( int k=0;k<rankArr.length-1;k++){
														%>
														<option name="<%=rankArr[k]%>" value="<%=rankArr[k]%>" <%if ( k == tempCount-1) {%> selected <%} %>><%=rankArr[k]%></option>
													<%
														}
												}}
													%>

									  </select>

								</td>
							</tr>
					<%
							}
						}
					}%>
            </table></td>
          </tr>

      </table>
						<div  style="display:none;" id='scheduleDiv'>
							<br/><span class="subHeadingSmall" style='padding:5px;'><%= ResourceUtil.getLabel("arc.common.scheduled.information", locale)%></span>
						    <div class="thresholdInfo" id='ScheduledDiv' style='margin:5px;'>
						   		<div style="float:left; padding:10px"><img src="images/iconScheduleIcon.gif"/></div>
						   		<div style="float:left; padding:13px 10px 10px 0px">&nbsp;<%=ResourceUtil.getLabel("arc.common.scheduled.for.execution", locale)%> <span id="spnSchDate" class='contentBlackBold'></span>&nbsp;<%=ResourceUtil.getLabel("arc.common.at", locale)%>&nbsp;<span id="spnSchTime" class='contentBlackBold'></span></div>
						    </div>
						</div>

			  <div id='resultsDiv' style="float:left;margin-top:10px;width:100%;display:none;">
    					<span class="subHeadingSmall"><%=ResourceUtil.getLabel("arc.abc.computation.details", locale)%></span>
    					<div style='text-align:left'>
						<table border='0' cellspacing='0' cellpadding='0' width='100%'>
							<tr>
							<td><img src='images/spacer.gif' width='1' height='4' /></td>
							<td><img src='images/spacer.gif' width='1' height='4' /></td>
							<td><img src='images/spacer.gif' width='1' height='4' /></td>
							</tr>
							<tr>
							<td><img src='images/progressbarLeftTop.gif' width='2' height='2' /></td>
							<td background='images/progressbarTop.gif'><img src='images/spacer.gif' width='1' height='1' /></td>
							<td><img src='images/progressbarRightTop.gif' width='2' height='2' /></td>
							</tr>
							<tr>
							<td background='images/progressbarLeft.gif'><img src='images/spacer.gif' width='1' height='1' /></td>
							<td bgcolor='#e6e6e6' width='100%' style='padding:2px'>
							<div class='subHeadingSmall' style='width:100%;'><span class='contentBlackBold style3'><%=ResourceUtil.getLabel("arc.common.computation.progress.bar", locale)%></span></div>
							<div>
							<table width='100%' border='0' cellspacing='0' cellpadding='0' style='border:1px solid #999999'>
							<tr>
							<td background='images/algorithmProgressBarGreyBg.gif'><span id='algorithemBg' style="background-image:url('images/algorithmProgressImg.gif');"><img id='imgProgressBar' src='images/spacer.gif' height='1' width='1'/><img id='imgProgressOnly' height='18' width='1' src='images/algorithmProgressMover.gif'/></span></td>
							</tr>
							</table>
					</div>

				<div style='float:left;width:100%;padding-top:4px;'><div style='float:left;' id='currentStatus'><span class='contentBlackBold'><%=ResourceUtil.getLabel("arc.common.currently.executing", locale)%></span> </div><div style='float:right; padding-right:5px;' id='perctComplete'></div></div>
									<div style='float:left;padding-top:15px;'><span class='subHeadingSmall'><%=ResourceUtil.getLabel("arc.common.info.log", locale)%></span></div>
									<div style='float:right;padding-top:15px;'>, &nbsp;&nbsp; <%=ResourceUtil.getLabel("arc.common.executing.product.no", locale)%> <span id='currProdNum'>0</span>, &nbsp;&nbsp; <%=ResourceUtil.getLabel("arc.abc.current.step", locale)%> <span id='currStepNum'>0</span></div>
									<div style='float:right;padding-top:15px;'><%=ResourceUtil.getLabel("arc.common.current.step", locale)%> <span id='currStepNum'>0</span></div>
									<div id='scrollAreaProgress' style='background-color:#FFFFFF; width:100%; border:1px solid #CCCCCC; height:175px; overflow-y:scroll;'>
										<div style='padding-left:10px; padding-top:5px;'><span class='contentBlackBold'><%=ResourceUtil.getLabel("arc.abc.starting", locale)%></span><%=ResourceUtil.getLabel("arc.abc.initializing", locale)%> <%=ResourceUtil.getLabel("arc.common.initializing", locale)%></div>
									</div>
					<div id='processUpdater' style='width:100%;'></div>
					</td>
					<td background='images/progressbarRight.gif'><img src='images/spacer.gif' width='1' height='1' /></td>
					</tr>
					<tr>
					<td><img src='images/progressbarLeftBottom.gif' width='2' height='2' /></td>
					<td background='images/progressbarBottom.gif'><img src='images/spacer.gif' width='1' height='1' /></td>
					<td><img src='images/progressbarRightBottom.gif' width='2' height='2' /></td>
					</tr>
				</table>
			</div>
				</div>
	</div>
  </div>
  </div>
  <div style='float:left;margin-left:10px;display:none;' class='contentRed' id='errorAlert'></div>
  <div style="float:right;margin-top:5px; margin-right:10px;">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td><div class="buttonGreyLeft" onclick="location.href='ABCAnalysis.jsp?csrfPreventionSalt=${csrfPreventionSalt}'">
            <div class="buttonText" id="previousBtnDiv"><%=ResourceUtil.getLabel("arc.common.previous", locale)%></div>
             <div class="buttonGreyRight_M"> </div>
          </div></td>
		 <td>&nbsp;</td>
		  <td><div class="buttonBlueLeft" onclick="loadData();">
            <div class="buttonText" id="loadForecastBtnDiv"><%=ResourceUtil.getLabel("arc.abc.schedule", locale)%></div>
        	 <div class="buttonBlueRight_M"> </div>
         </div>
		  </td>
      </tr>
    </table>
  </div>
<%
	}catch( Exception ex ){
		ex.printStackTrace();
	}
%>
</form>
</body>
<script>


function navigate(){
	location.href='ABCAnalysis.jsp?csrfPreventionSalt='+ $F("csrfPreventionSalt");
}
//--------------------------------------------------------------------------------
function loadData(){
	var params = Form.serialize(document.form1);

	var url="miningAction?nav_action=checkScheduleJobStatus&uniqueJob=ABC_DATA_PREP"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
	new Ajax.Request(url, {method: 'post', parameters:params, onComplete:removeJobFromQuartz});
}

function removeJobFromQuartz(ob){
	var msg = ob.responseText;
	var status = msg.split('#~delimts~#')[0];

	if(parseInt(status)==1){
		if(confirm('<%= ResourceUtil.getMessage("arc.mining.re.scheduling.confirm.part1", locale)+" "%>'+msg.split('#~delimts~#')[1]+'<%= ". \\n"+ResourceUtil.getMessage("arc.mining.re.scheduling.confirm.part2", locale)%>')){
			var url="miningAction?nav_action=commonRemovalOfJobFromQuartz&uniqueJob=ABC_DATA_PREP"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
			new Ajax.Request(url, {method: 'post', onComplete: function(o){openSchedulerWindow();}});
		}
	}
	else if(parseInt(status)==2){
		alert(msg.split('#~delimts~#')[1]);
		return;
	}
	else{
		openSchedulerWindow();
	}
}
//--------------------------------------------------------------------------------
var oldErrorObj=null;
function openSchedulerWindow(){

	// validation of text boxes done here
		var isValid = true;
		var allTextBox = document.getElementsByTagName("input");
			for(i=0;i<allTextBox.length;i++){
				if(allTextBox[i].type == 'text' && allTextBox[i].name != 'search'){
					if(trim(allTextBox[i].value) == ''){
						allTextBox[i].focus();
						allTextBox[i].className = 'inputFieldErr';
						//alert("Please enter a Value.");
						$('errorAlert').style.display='block';
						$('errorAlert').innerHTML='Cannot be Empty, Please re-try.';
						isValid = false;
						return;
					}else{
					    allTextBox[i].className="inputField";
					    $('errorAlert').innerHTML='';
					}
				}
			}
	//

	if (isValid){
		var params = Form.serialize(document.form1);
		 var url = 'miningScheduling.jsp?uniqueJob=ABC_DATA_PREP&uniqueTrigger=ABCDataLoading&jobDescription=ABCDataLoadingJob'+params+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
		 invokePopup('ABC Schedule', url, '40,100', '350', '70');
	 }

}

</script>


</html>