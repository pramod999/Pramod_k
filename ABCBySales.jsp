<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%com.manthan.promax.security.SecurityEngine.isSessionOver(request,response,"login.jsp");%>
<%@ include file="userSession.jsp" %>
<%@ include file="scriptLocalize.jsp" %>
<%@page import="java.util.HashMap"%>
<%@page import="com.manthan.arc.mining.rationalization.ProductRationalizationHelper"%>
<%@page import="com.manthan.arc.mining.commons.MeasureSelectionHelper"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%

    session.removeAttribute("PRODUCT_RATIONALIZATION_SELECTED_MEASURE_DETAIL");
	try{
		if(null!=request.getSession()){
			if(null!=request.getSession().getAttribute("Extra_Col_In_AbcAnalysis")){
				request.getSession().removeAttribute("Extra_Col_In_AbcAnalysis");
			}
		}

		String selectedMeasureList = (null!=request.getParameter("selectedMeasureList") && request.getParameter("selectedMeasureList").trim().length()>0 ? request.getParameter("selectedMeasureList") : "");
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
		// selectedMeasDtls - HashMap contains the selected measure details in the format of :
		// key = GroupId!GroupName (Separated by !)
		// vlue = aMeasureId!MeasureName (Separated by !)
		if(null==session.getAttribute("PRODUCT_RATIONALIZATION_SELECTED_MEASURE_DETAIL") || ((HashMap<String, String>) session.getAttribute("PRODUCT_RATIONALIZATION_SELECTED_MEASURE_DETAIL")).size()==0){
			session.setAttribute("PRODUCT_RATIONALIZATION_SELECTED_MEASURE_DETAIL", selectedMeasDtls);
		}
		String measureName = new MeasureSelectionHelper().getSelectedMeasureName(request, "Sales");
		System.out.println(measureName);
		if (measureName == null || (measureName != null && measureName.trim().equalsIgnoreCase(""))){
			measureName = (String)session.getAttribute("SELECTED_MEASURE_NAME");
		}else {
			session.setAttribute("SELECTED_MEASURE_NAME",measureName);
		}



%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=<%= session.getAttribute("CHARSET").toString()%>" />
		<title><%= com.manthan.promax.security.schmail.Mailer.getPropValue("arc.title").toString() %> <%=ResourceUtil.getLabel("arc.abc.title", locale)%></title>
		<link href="css/style<%=userSelectedTheme%>.less" rel="stylesheet/less" type="text/css" />
		<script language="javascript" type="text/javascript" src="js/less.js"></script>
		<script language="javascript" type="text/javascript" src="js/general.js"></script>
		<script language="javascript" type="text/javascript" src="js/drag.js"></script>
		<script language="javascript" type="text/javascript" src="js/prototype.js"></script>
		<script language="javascript" type="text/javascript" src="js/mining.js"></script>
		<script type="text/javascript">
			var isKeyboardActive='';
				var mygrid=null;
		</script>
		<!--DHTMLX-->
		<!--TREE GRID-->
		<link rel="STYLESHEET" type="text/css" href="dhtmlX/codebaseGrid/dhtmlxgrid.css"/>
		<script  src="dhtmlX/codebaseGrid/dhtmlxcommon.js"></script>
		<script  src="dhtmlX/codebaseGrid/dhtmlxgrid.js"></script>
		<script  src="dhtmlX/codebaseGrid/dhtmlxgridcell.js"></script>
		<script  src="dhtmlX/codebaseTreeGrid/dhtmlxtreegrid.js"></script>
		<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_start.js"></script>
		<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_excell_link.js"></script>
		<script  src="dhtmlX/codebaseGrid/dhtmlxgrid_drag.js"></script>
		<script src="dhtmlX/codebaseGrid/dhtmlxgrid_filter.js"></script>
		<!--DHTMLX ENDS-->
	</head>
	<body onmousemove="updateloaderLoc(event)">
	<script language="javascript" type="text/javascript" src="js/customTooltipSetup.js"></script>
	<script language="javascript" type="text/javascript" src="js/customCallout.js"></script>
	<span id="calloutContent" style="display:none"></span>
	<div id="kpiNamedFilterPop" style="display:none;"></div>
		<form name="form1" id="form1">
<input type="hidden" id="csrfPreventionSalt" name="csrfPreventionSalt" value="${csrfPreventionSalt}"/>
		<input type="hidden" name="analyzeFlag" id="analyzeFlag" value="false" />
		<div class="heading" style="float:none"><%=ResourceUtil.getLabel("arc.abc.analysis", locale)%></div>
		<div id="headingLine"><div id="headingLine_inner"></div></div>
		<!--MAIN SECTION-->
		<div id="admain" style='float:left;width:98%'>
		<div style="100%">

		<div class="topIcons"  onclick="location.href='ABC_introduction.jsp?csrfPreventionSalt=${csrfPreventionSalt}'">
			<span class="img_Introduction"   title='<%= ResourceUtil.getLabel("arc.abc.introduction", locale)%>'></span>
				 		 <%=ResourceUtil.getLabel("arc.abc.introduction", locale)%></div></div>
					  <div class="topIconsSeperatorPro"></div>
			<div class="topIcons"  onclick="location.href='ABCAnalysis.jsp?csrfPreventionSalt=${csrfPreventionSalt}'">
				<span class="img_Atrribute"></span>
	  			<%=ResourceUtil.getLabel("arc.abc.attribute.selection", locale)%>
	  		</div>
		  	<div class="topIconsSeperatorPro"></div>
	  		<div class="topIconsActive" >
		 		<span class="img_ClassificationSales"></span>
	  			<%=ResourceUtil.getLabel("arc.abc.classification.by.sales", locale)%>
	  		</div>
		  	<div class="topIconsSeperatorPro"></div>
	  		<div class="topIcons imgDisabled" >
		 		<span class="img_ClassificationMargin"></span>
	  			<%=ResourceUtil.getLabel("arc.abc.classification.by.margin", locale)%>
	  		</div>
		  	<div class="topIconsSeperatorPro"></div>
	  		<div class="topIcons imgDisabled" >
		 		<span class="img_ClassificationInventory"></span>
	  			<%=ResourceUtil.getLabel("arc.abc.classification.by.inventory", locale)%>
	  		</div>
		  	<div class="topIconsSeperatorPro"></div>
	  		<div class="topIcons imgDisabled" >
		 		<span class="img_ABCfinalClassification"></span>
	  			<%=ResourceUtil.getLabel("arc.abc.final.classification", locale)%>
	  		</div>

	  	<!--
		<div id="infobarRight_M">
    		<div id="infobarLeft"> &nbsp;&nbsp;&nbsp;Classification by <%= measureName%> is identified based upon the user defined range of cumulative values of <%= measureName%>.</div>
  		</div> -->
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
				    <td bgcolor="#fff5b3" width="100%" style="padding:2px" height="28"> &nbsp;&nbsp;&nbsp;<%=ResourceUtil.getLabel("arc.abc.classification.by",measureName, locale)%> <%=ResourceUtil.getLabel("arc.abc.classification.comment", locale)%> '<%= measureName%>'.</td>
				    <td background="images/infobarRight.gif"><img src="images/spacer.gif" width="1" height="1" /></td>
				  </tr>
				  <tr>
				    <td><img src="images/infobarLeftBottom.gif" width="2" height="2" /></td>
				    <td background="images/infobarBottom.gif"><img src="images/spacer.gif" width="1" height="1" /></td>
				    <td><img src="images/infobarRightBottom.gif" width="2" height="2" /></td>
				  </tr>
				</table>
  		<img src="images/spacer.gif" width="200" height="10" /><br />
  		<div id="hierarchyBrowser" class="portletSkin" style="display:block;height:auto; min-height:428px" >
    		<div class="portletHeader">
      			<div class="kpiUtilityBar" style="float:right"></div>
      			<%=ResourceUtil.getLabel("arc.abc.classification.by",measureName, locale)%>
      		</div>
      		<div class="innerPortlet" >
      				 <div class="openClose">
				        <div class="imgMaximize" title='<%= ResourceUtil.getLabel("arc.hide", locale) %>' onclick="javascript:summaryPageMaxminWithGridChange('openCloseTable', this, 'dataGrid1',366,245,mygrid);"></div>
				      </div>
	      		<span class='subHeadingSmall'><%=ResourceUtil.getLabel("arc.abc.applied.filters", locale)%></span>
				<div id="openCloseTable" style="padding-top:8px;">
	      			<div id='filterDtls' class='tblBorder' style='width:99.8%;overflow:hidden;overflow-y:auto' ></div>
				<br/>
				</div>
      			<span class="subHeadingSmall"><%=ResourceUtil.getLabel("arc.abc.classification.rules",measureName, locale)%></span>
	      			<table width="100%" border="0" cellspacing="2" cellpadding="4" class="tblBorder" id="tblResults">
<%	      			if(session.getAttribute("RANK_SELECTED")!=null){
					String rankSelected = (String) session.getAttribute("RANK_SELECTED");
					String [][] retainValArr=(String[][])request.getSession().getAttribute("Retain_Sales_Values");
					if(rankSelected.contains(",")){
						String [] arr = rankSelected.split(",");
						int count=0;
						int divideSalesMeasures = Integer.parseInt(rankSelected.split("_")[1]);
						double percentileShare = 100/divideSalesMeasures;
						double incrementalPercentileShare = 0;
						String retainedVal="";
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
	          					<td class="tblLabel"><%=ResourceUtil.getLabel("arc.abc.condition", locale)%> <%=++count %> </td>
	          					<td class="tblContent">
	          					<%=ResourceUtil.getLabel("arc.abc.if.less",measureName,locale)%>

	          					<%
	          					 if(null!=retainValArr){
	          					 retainedVal=retainValArr[tempCount-1][0];
	          					 }else if(tempCount==(arr.length)-1)
	          					{retainedVal=""+100;}
	          					else{
	          					retainedVal=""+incrementalPercentileShare;
	          					}


	          					%>



	              					<input name="textfield<%=tempCount %>" onkeypress="return maskNumeric(event);"  type="text"  id="text<%=tempCount %>_<%=tempCount %>" class="inputField" value="<%=retainedVal%>" size="5" />
	            				<%=ResourceUtil.getLabel("arc.abc.if.less.then",arrElement,locale)%>
	            			</td>
	        			</tr>
							<%
							}else{%>
								<tr>
		          				<td width="25%" class="tblLabel"><%=ResourceUtil.getLabel("arc.abc.condition", locale)%> <%=++count %> </td>
		          				<td width="75%" class="tblContent">

		              				<%=ResourceUtil.getLabel("arc.abc.if.greater",measureName,locale)%>
		              				<%
	          					 if(null!=retainValArr){
	          					 retainedVal=retainValArr[tempCount-1][0];
	          					 }else{
	          					retainedVal=""+(incrementalPercentileShare - percentileShare);
	          					}


	          					%>
		              				<input name="textfield<%=tempCount %>" onkeypress="return maskNumeric(event);" type="text" id="text<%=tempCount %>_<%=tempCount %>" class="inputField" value="<%=retainedVal%>" size="5" />

		            				<%=ResourceUtil.getLabel("arc.abc.if.less.and",measureName,locale)%>

		            				<%
	          					 if(null!=retainValArr){
	          					 retainedVal=retainValArr[tempCount-1][1];
	          					 }else if(tempCount==(arr.length)-1)
	          					{retainedVal=""+100;}
	          					else{
	          					retainedVal=""+incrementalPercentileShare;
	          					}


	          					%>
		            				<input name="textfield<%=tempCount %><%=tempCount %>" onkeypress="return maskNumeric(event);"  type="text" id="text<%=tempCount %>_<%=tempCount+1 %>" class="inputField" value="<%=retainedVal%>" size="5" />
		            				<%=ResourceUtil.getLabel("arc.abc.if.greater.then",arrElement,locale)%>
		            			</td>
		        			</tr>
							<%}
						}
					}
				}else{ %>
	        			<tr>
	          				<td class="tblLabel"><%=ResourceUtil.getLabel("arc.abc.condition1", locale)%> </td>
	          				<td class="tblContent">
	          					<%=ResourceUtil.getLabel("arc.abc.cumulative", locale)%><%= measureName%>% <b>&lt;=</b>
	              				<input name="text1_1" type="text" id="text1_1" onkeypress="return maskNumeric(event);"  class="inputField" value="70" size="5" />
	            				% A
	            			</td>
	        			</tr>
	        			<tr>
	          				<td width="15%" class="tblLabel"><%=ResourceUtil.getLabel("arc.abc.condition2", locale)%> </td>
	          				<td width="85%" class="tblContent">
	          					<%=ResourceUtil.getLabel("arc.abc.cumulative.greater",measureName, locale)%>
	              				<input name="textfield2" type="text" id="text2_2"  onkeypress="return maskNumeric(event);" class="inputField" value="70" size="5" />
	            				% <strong><%=ResourceUtil.getLabel("arc.common.and", locale)%></strong> <b>&lt;=</b>
	            				<input name="textfield22" type="text" id="text2_3"  onkeypress="return maskNumeric(event);" class="inputField" value="90" size="5" />
	            				% B
	            			</td>
	        			</tr>
	        			<tr>
	          				<td class="tblLabel"><%=ResourceUtil.getLabel("arc.abc.condition3", locale)%> </td>
	          				<td class="tblContent">
	          					<%=ResourceUtil.getLabel("arc.abc.cumulative.greater",measureName, locale)%>
	              				<input name="textfield3" type="text" id="text3_3" onkeypress="return maskNumeric(event);" class="inputField" value="90" size="5" />
	            				% C
	            			</td>
	        			</tr>
	        			<%} %>
	      			</table>
	      			<img src="images/spacer.gif" width="200" height="5" /><br />
	      			<div style="float:right;">
	        			<table border="0" cellspacing="0" cellpadding="0">
	          				<tr>
	            				<td>
	            					<div class="buttonBlueLeft" onclick="document.getElementById('buttons').style.display='block';document.getElementById('resultsDiv').style.display='block';$('analyzeFlag').value='true';loadGrid();">
	                					<div class="buttonText">
	                						<%=ResourceUtil.getLabel("arc.abc.analyze", locale)%>
	                					</div>
	              					<div class="buttonBlueRight_M"></div></div>
	              				</td>
	          				</tr>
	        			</table>
	      			</div>
			        <img src="images/spacer.gif" width="200" height="30"/><br />

      			<div id="resultsDiv" style="width:100%; display:none">
        			<div id='outerDataGrid1'>
		        		<div id="dataGrid1"></div>
        			</div>
      			</div>
      			<script type="text/javascript">
      				var maximized = false;
					var globalMetadataGridval=null;
					var productAfinityAnalyze=true;
					function loadGrid(){
							var analyzeFlag = $('analyzeFlag').value ;
											var url = "miningAction?nav_action=getAbcBySalesGrid&analyzeFlag="+analyzeFlag+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
											var params = Form.serialize(document.form1);
											new Ajax.Request(url, {method: 'post', parameters: params, onComplete: changeTheDivContent});

					}
					//}

					function changeTheDivContent(resObj){
						var msg = resObj.responseText.split("#REQUEST_FOR#");
						if(msg[0].indexOf("xmlGridData")>=0){
							dhtmlxGrid(msg[1]);
							globalMetadataGridval=msg[1];
						}
						else if(msg[0].indexOf("divData")>=0){
							$('dataGrid1').style.display="block";
							$('dataGrid1').innerHTML = '';
							$('dataGrid1').innerHTML = msg[1];
						}
						summaryPageMaxminWithGridChange('openCloseTable', this,'dataGrid1',366,240,mygrid);
					}

					function dhtmlxGrid(gridData){
						$("outerDataGrid1").innerHTML="<div id='dataGrid1' style='height:150px;overflow:hidden;'></div>";
						$('dataGrid1').innerHTML="";
						mygrid = new dhtmlXGridObject("dataGrid1");
						mygrid.enableCollSpan(true);
						mygrid.loadXMLString(gridData);
						mygrid.attachHeader("#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter");
						//mygrid.attachHeader("#text_filter,#text_filter,#numeric_filter,#numeric_filter,#numeric_filter,#numeric_filter,#numeric_filter,#numeric_filter,#numeric_filter,#numeric_filter,#numeric_filter,#text_filter");
						mygrid.setImagePath("dhtmlX/codebaseGrid/imgs/");
						mygrid.setSkin("light");
						mygrid.enableAlterCss("tblRow1","tblRow2");
						if(maximized){
							mygrid.enableAutoHeight(true,"366",true);
						}else{
						 	mygrid.enableAutoHeight(true,"240",true);
						}
						mygrid.sortRows(1,"int","desc");
						mygrid.setColSorting("str,str,int,int,int,str");
					}

					function forwardToNextpage(){

							if ($('analyzeFlag').value == 'true'){
								location.href="ABCByMargin.jsp?csrfPreventionSalt="+ $F('csrfPreventionSalt');
							}else{
								var params = Form.serialize(document.form1)
								var url = "miningAction?nav_action=getAbcBySalesGrid&"+params+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
								new Ajax.Request(url, {method: 'post', parameters: params, onComplete: function(resObj){$('analyzeFlag').value = 'false';location.href="ABCByMargin.jsp?csrfPreventionSalt="+ $F('csrfPreventionSalt')+"&measureName="+'<%=measureName%>';}});
							}
					}


				function forwardToPreviousPage(){
								var params = Form.serialize(document.form1)
								var url = "miningAction?nav_action=getAbcBySalesGrid&setValues=true"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
								new Ajax.Request(url, {method: 'post', parameters: params, onComplete: function(resObj){location.href='ABCAnalysis.jsp?csrfPreventionSalt='+ $F("csrfPreventionSalt");}});

							}
					renderFilterDetails();


				</script>
    		</div>
  		</div>

		<div style="float:right; " id="buttons">
    		<table border="0" cellspacing="0" cellpadding="0">
      			<tr>
        			<td>

        				<div class="buttonGreyLeft" onclick="forwardToPreviousPage();">
            				<div class="buttonText">
            					<%=ResourceUtil.getLabel("arc.common.previous", locale)%></div>
          				<div class="buttonGreyRight_M"></div></div>
          			</td>
        			<td>&nbsp;</td>
        			<td>

        				<div class="buttonGreyLeft" onclick="forwardToNextpage();">
            				<div class="buttonText">
            					<%=ResourceUtil.getLabel("arc.common.next", locale)%>
            				</div>
          				<div class="buttonGreyRight_M"></div></div>
          			</td>
      			</tr>
    		</table>
  		</div>
  		</div>
	</form>
</body>
</html>
<%}catch(Exception e){e.printStackTrace();}%>
