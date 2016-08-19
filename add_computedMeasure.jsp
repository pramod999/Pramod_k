<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
	com.manthan.promax.security.SecurityEngine.isSessionOver(request,response,"login.jsp");
%>
<%@ page language="java" import="com.manthan.promax.db.*"%>
<%@ page import="org.core.config.security.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="org.core.util.*"%>
<%@ page import="org.core.lowservice.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.manthan.promax.security.*"%>
<%@ page import="org.core.engine2.util.*"%>
<%@ page import="org.core.engine2.component.*"%>
<%@ page import ="java.sql.*"%>
<%@ page import="org.core.bcm.report.*" %>
<!--   Modified the code for Localization - By Manjunath A   -->
<%@ include file="userSession.jsp" %> 

<%
try
{
String lang = "";
String engLang = "en";
String arcLang = "arclang";

if(null!=session){
	if(session.getAttribute("lang") != null);
	{
		if(session.getAttribute("lang").toString().intern() != engLang.intern() && session.getAttribute("lang").toString().intern() != arcLang.intern())
		{
			lang = "_"+session.getAttribute("lang").toString();
		}
	}
}

String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

List measureGroups = new ArrayList();
//measureGroups = ApplicationConfig.getMeasureGroups();
Hashtable allMeasuresFromCache = ApplicationConfig.getAllMeasures();
Set keySet = allMeasuresFromCache.keySet();
Iterator iter = keySet.iterator();
while(iter.hasNext())
{
	String key  = (String)iter.next();
	HashMap measureMap = (HashMap)allMeasuresFromCache.get(key);
	String mGroup = (String)measureMap.get("MEASUER_GROUP_NAME");
	if(mGroup!=null && mGroup.length()>0 && !measureGroups.contains(mGroup))
	{
		measureGroups.add(mGroup);
	}
}

String group = "";
if(request.getParameter("measure_Id")!=null && request.getParameter("measure_Id").length()>0)
{
	group = (String)((HashMap)allMeasuresFromCache.get(request.getParameter("measure_Id"))).get("MEASUER_GROUP_NAME");
}

String view_id = encodeForStoredXSS(request.getParameter("view_id"));

if(request.getAttribute("ACTION_MSG") != null){
	com.manthan.arc.ui.util.KPIPublishUtil kpiPublishUtil = new com.manthan.arc.ui.util.KPIPublishUtil();
	String mIds = kpiPublishUtil.getMIdsAddCompMeasures(view_id, request);
	out.println("<script language='javascript' src='js/script.js'></script>");
	out.println("<script language='javascript' src='js/prototype.js'></script>");
	out.println("<script>getReport('"+view_id+"','"+mIds+"');</script>");
}

%>
 <%
 java.util.Hashtable labels = (java.util.Hashtable)com.manthan.promax.report.ReportUtil.getLabels(session);
 String measurenamecannotbeempty = "Measure name cannot be empty";
    if(labels.get("arc.measurenamecannotbeempty") != null){
    measurenamecannotbeempty = (String)labels.get("arc.measurenamecannotbeempty");
    }

    String defineruleforthemeasure = "Define a rule for the Measure";
    if(labels.get("arc.defineruleforthemeasure") != null){
    defineruleforthemeasure = (String)labels.get("arc.defineruleforthemeasure");
    }

    String selectameasureforcontribution = "Select a Measure for % Contribution";
    if(labels.get("arc.measure.selectameasureforcontribution") != null){
    selectameasureforcontribution = (String)labels.get("arc.measure.selectameasureforcontribution");
    }
    String selectameasurefocumulativetotal  = "Select a Measure for Cumulative Total ";
    if(labels.get("arc.measure.selectameasurefocumulativetotal") != null){
    selectameasurefocumulativetotal = (String)labels.get("arc.measure.selectameasurefocumulativetotal");
    }

    String measuresdetails  = "Measures Details";
    if(labels.get("arc.measure.measuresdetails") != null){
    measuresdetails = (String)labels.get("arc.measure.measuresdetails");
     }

    String measurename  = "Measure Name";
    if(labels.get("arc.measure.measurename") != null){
    measurename = (String)labels.get("arc.measure.measurename");
    }
    String measuredatatype  = "Measure Data Type";
    if(labels.get("arc.measure.measuredatatype") != null){
    measuredatatype = (String)labels.get("arc.measure.measuredatatype");
    }
    String measuretype   = "Measure Type ";
    if(labels.get("arc.measure.measuretype") != null){
    measuretype = (String)labels.get("arc.measure.measuretype");
      }

      String rulemeasure   = "Rule Measure ";
    if(labels.get("arc.measure.rulemeasure") != null){
   rulemeasure = (String)labels.get("arc.measure.rulemeasure");
      }

      String measuregroup   = "Measure Group ";
    if(labels.get("arc.measure.measuregroup") != null){
   measuregroup = (String)labels.get("arc.measure.measuregroup");
      }


	String save = "Save";
    if(labels!=null && labels.get("alert.column.save.tooltip")!=null
	&& labels.get("alert.column.save.tooltip").toString().trim().length()>0){
	save = (String)labels.get("alert.column.save.tooltip");
     }

 String close = "close";
    if(labels!=null && labels.get("alert.column.close.tooltip")!=null
	&& labels.get("alert.column.close.tooltip").toString().trim().length()>0){
	close = (String)labels.get("alert.column.close.tooltip");
     }





   %>


<html>
<head>
<title><%= com.manthan.promax.security.schmail.Mailer.getPropValue("arc.title").toString() %></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%= session.getAttribute("CHARSET").toString()%>">
<link href="<%=basePath%>/styles/style.css" rel="stylesheet" type="text/css">
<BASE href="<%=basePath%>">

<SCRIPT language="javascript">

	function loadGroups()
	{
		var group = '<%=group%>';
		for(var i=0;i<document.form1.measureGroup.length;i++)
		{
			if(document.form1.measureGroup.options[i].value==group)
			{
				document.form1.measureGroup.options[i].selected = true;
				return;
			}
		}
	}

  function showContributionLayer(obj){
    if(obj.checked){
		document.getElementById('contributionCol').style.display='';
	}else{
		document.getElementById('contributionCol').style.display='none';
	}
  }

  function showColumnsPopup(pAction){
		var link = 'ColumnListpopup.jsp?parentAction='+pAction+'&csrfPreventionSalt='+ $F('csrfPreventionSalt');
		newwindow=window.open(link,'name','height=440,width=620');
  }



  function setColType(obj){
  	 if(obj.id == "dbCol"){
		document.getElementById('basemeasurecolumn').style.display='';
		document.getElementById('basemeasurefunc').style.display='';
	 	document.getElementById('ruleColumn').style.display='none';
		document.getElementById('contributionCol').style.display='none';
	 }
	 if(obj.id == "ruleCol"){
		document.getElementById('basemeasurecolumn').style.display='none';
		document.getElementById('basemeasurefunc').style.display='none';
		document.getElementById('ruleColumn').style.display='';
		document.getElementById('contributionCol').style.display='none';
	 }
	 if(obj.id == "percentCont"){
		document.getElementById('basemeasurecolumn').style.display='none';
		document.getElementById('basemeasurefunc').style.display='none';
		document.getElementById('ruleColumn').style.display='none';
		document.getElementById('contributionCol').style.display='';
	 }
  }

  function selectMeasure()
  {
  	var measureType = document.form1.measureType.value;
  	if(measureType=='dbCol')
  	{
  		document.getElementById('basemeasurecolumn').style.display='';
		document.getElementById('basemeasurefunc').style.display='';
	 	document.getElementById('ruleColumn').style.display='none';
		document.getElementById('contributionCol').style.display='none';
		document.getElementById('growthText').style.display='none';
		document.getElementById('expressionText').style.display='none';
		document.getElementById('cumulativeCol').style.display='none';
  	}
  	else if(measureType=='ruleCol')
  	{
  		document.getElementById('basemeasurecolumn').style.display='none';
		document.getElementById('basemeasurefunc').style.display='none';
		document.getElementById('ruleColumn').style.display='';
		document.getElementById('contributionCol').style.display='none';
		document.getElementById('growthText').style.display='none';
		document.getElementById('expressionText').style.display='none';
		document.getElementById('cumulativeCol').style.display='none';
  	}
  	else if(measureType=='percentCont')
  	{
  		document.getElementById('basemeasurecolumn').style.display='none';
		document.getElementById('basemeasurefunc').style.display='none';
		document.getElementById('ruleColumn').style.display='none';
		document.getElementById('contributionCol').style.display='';
		document.getElementById('growthText').style.display='none';
		document.getElementById('expressionText').style.display='none';
		document.getElementById('cumulativeCol').style.display='none';
  	}
  	else if(measureType=='growth')
  	{
  		document.getElementById('basemeasurecolumn').style.display='none';
		document.getElementById('basemeasurefunc').style.display='none';
		document.getElementById('ruleColumn').style.display='none';
		document.getElementById('contributionCol').style.display='none';
		document.getElementById('growthText').style.display='';
		document.getElementById('expressionText').style.display='none';
		document.getElementById('cumulativeCol').style.display='none';
  	}
  	else if(measureType=='expression')
  	{
  		document.getElementById('basemeasurecolumn').style.display='none';
		document.getElementById('basemeasurefunc').style.display='none';
		document.getElementById('ruleColumn').style.display='none';
		document.getElementById('contributionCol').style.display='none';
		document.getElementById('growthText').style.display='none';
		document.getElementById('expressionText').style.display='';
		document.getElementById('cumulativeCol').style.display='none';
  	}
	else if(measureType=='cumulativeTotal')
  	{
  		document.getElementById('basemeasurecolumn').style.display='none';
		document.getElementById('basemeasurefunc').style.display='none';
		document.getElementById('ruleColumn').style.display='none';
		document.getElementById('contributionCol').style.display='none';
		document.getElementById('growthText').style.display='none';
		document.getElementById('expressionText').style.display='none';
		document.getElementById('cumulativeCol').style.display='';
  	}
  }

  function expressionPopup(id){

		var newwindow;
		var link = 'BCMExpressionBuilder.jsp?csrfPreventionSalt='+ $F('csrfPreventionSalt')+'&alias='+id+"&view_id="+<%=view_id%>;
		newwindow=window.open(link,'name','resizable=yes,height=550,width=650');
		if (window.focus) {newwindow.focus()}
	}

	function submitPage1(){
	    var _measurenamecannotbeempty = "<%=measurenamecannotbeempty%>";
	    var _defineruleforthemeasure = "<%=defineruleforthemeasure %>";
	    var _selectameasureforcontribution = "<%= selectameasureforcontribution %>";
		var val = document.form1.measureName.value;
		if(val == null || val == ""){
			alert(_measurenamecannotbeempty);
			document.form1.measureName.focus();
			return;
		}
		if(document.getElementById('ruleCol').checked){
			if(document.form1.measureRule.value == null || document.form1.measureRule.value == "")
			{
				alert(_defineruleforthemeasure);
				document.form1.measureRule.focus();
				return;
			}
		}
		if(document.getElementById('percentCont').checked){
			if(document.form1.measureContribution.value == null || document.form1.measureContribution.value == "")
			{
				alert(_selectameasureforcontribution);
				document.form1.measureContribution.focus();
				return;
			}
		}
		document.form1.submit();
	}

	function submitPage(){
	      var _measurenamecannotbeempty = "<%=measurenamecannotbeempty%>";
	    var _defineruleforthemeasure = "<%=defineruleforthemeasure %>";
	    var _selectameasureforcontribution = "<%= selectameasureforcontribution %>";
	    var _selectameasurefocumulativetotal = "<%= selectameasurefocumulativetotal %>";

		document.getElementById('pleaseWait').style.display="";
		var measureType = document.form1.measureType.value;
		var val = document.form1.measureName.value;
		if(val == null || val == ""){
			alert(_measurenamecannotbeempty);
			document.form1.measureName.focus();
			return;
		}
		if(measureType == 'ruleCol'){
			if(document.form1.measureRule.value == null || document.form1.measureRule.value == "")
			{
				alert(_defineruleforthemeasure);
				document.form1.measureRule.focus();
				return;
			}
		}
		if(measureType == 'percentCont'){
			if(document.form1.measureContribution.value == null || document.form1.measureContribution.value == "")
			{
				alert(_selectameasureforcontribution);
				document.form1.measureContribution.focus();
				return;
			}
		}
		if(measureType == 'cumulativeTotal'){
			if(document.form1.cumulativeTotCol.value == null || document.form1.cumulativeTotCol.value == "")
			{
				alert(_selectameasurefocumulativetotal);
				document.form1.cumulativeTotCol.focus();
				return;
			}
		}

		setInputs();
		document.form1.submit();
	}

	function setInputs()
	{
		var measureType = document.form1.measureType.value;
		if(measureType=='dbCol')
  		{
  			document.form1.measureRule.value="";
			document.form1.measureContribution.value="";
			document.form1.growthContribution.value="";
			document.form1.measureExpression.value="";
			document.form1.cumulativeTotCol.value = "";
  		}
		if(measureType == 'ruleCol')
		{
			document.form1.dbColumn.value="";
			document.form1.aggregateFunc.value="";
			document.form1.measureContribution.value="";
			document.form1.growthContribution.value="";
			document.form1.measureExpression.value="";
			document.form1.cumulativeTotCol.value = "";
		}
		if(measureType=='percentCont')
  		{
  			document.form1.dbColumn.value="";
			document.form1.aggregateFunc.value="";
			document.form1.measureRule.value="";
			document.form1.growthContribution.value="";
			document.form1.measureExpression.value="";
			document.form1.cumulativeTotCol.value = "";
  		}
  		if(measureType=='growth')
  		{
  			document.form1.dbColumn.value="";
			document.form1.aggregateFunc.value="";
			document.form1.measureContribution.value="";
			document.form1.measureRule.value="";
			document.form1.measureExpression.value="";
			document.form1.cumulativeTotCol.value = "";
  		}
  		if(measureType=='expression')
  		{
  			document.form1.dbColumn.value="";
			document.form1.aggregateFunc.value="";
			document.form1.measureContribution.value="";
			document.form1.measureRule.value="";
			document.form1.growthContribution.value="";
			document.form1.cumulativeTotCol.value = "";
  		}
		if(measureType=='cumulativeTotal')
  		{
  			document.form1.dbColumn.value="";
			document.form1.aggregateFunc.value="";
			document.form1.measureRule.value="";
			document.form1.growthContribution.value="";
			document.form1.measureExpression.value="";
			document.form1.measureContribution.value = "";
  		}
	}
</SCRIPT>

<link href="styles/style.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style1 {	color: #333333;
	font-weight: bold;
	font-size: 12px;
}
-->
</style>
</head>
<script language="javascript" src="js/main.js"></script>

<body leftmargin="0" topmargin="0">

<form name="form1" method="post" action="<%=path%>/BCMControllerServlet?csrfPreventionSalt=${csrfPreventionSalt}&servletAction=AddEditMeasure&utilForward=yes&view_id=<%=view_id%>" >
<input type="hidden" id="csrfPreventionSalt" name="csrfPreventionSalt" value="${csrfPreventionSalt}"/>


 	<input type="hidden" name="currentLevel"/>


    <table width="100%" border="0" cellspacing="0" cellpadding="0">

      <tr valign="top">
        <td height="1" colspan="2" bgcolor="#CCCCCC"><img src="admin_images/1x1trans.gif" width="1" height="1"></td>
      </tr>
      <tr valign="top">
        <td width="20" height="506"><p>&nbsp;</p></td>
        <td align="center"><br>
          <table width="100%"  border="0" cellspacing="0" cellpadding="3">
            <tr>
              <td align="right">&nbsp;</td>
            </tr>
            <tr>
              <td height="5"></td>
            </tr>
            <tr>
              <td><table width="100%"  border="0" cellspacing="1" cellpadding="0" bgcolor="#999999">
                <tr>
                  <td><table width="100%"  border="0" cellspacing="0" cellpadding="3" bgcolor="#FFFFFF">
                      <tr bgcolor="#000000" >
                        <td colspan="2" height="3"></td>
                      </tr>
                      <tr>
                        <td height="25" colspan="2" class="bgtbentryrow"><strong><%=measuresdetails%> </strong></td>
                      </tr>


                      <%
                      String actionMode = "new";
                      String dataType = "";
                      String colName = null;
                      String rule = null;
                      String percentPos = null;
                      //String filter = null;
                      String dbColumn = null;
                      String aggregateFunction = null;
                      String growth = "";
                      String expression = "";
                      HashMap clientMName = null;
					  HashMap measure = new HashMap();
                      if(request.getParameter("measure_Id") != null){
                      		actionMode = "edit";
                      		String measureToEdit = request.getParameter("measure_Id");
                      		Hashtable list = com.manthan.promax.db.ApplicationConfig.getAllMeasures();
            	       		measure = (HashMap)list.get(measureToEdit);

            	       		if(measure.get("COLUMN_NAME") != null){
				          	 	colName = (String)measure.get("COLUMN_NAME");
				          	}
				          	if(measure.get("COLUMN_TYPE") != null){
					          	dataType = (String)measure.get("COLUMN_TYPE");
				          	}
				          	if(measure.get("RULE") != null){
				          		rule = (String)measure.get("RULE");
				          	}
				          	if(measure.get("CONTRIBUTION_COL_ID") != null){
				          	 	percentPos = (String)measure.get("CONTRIBUTION_COL_ID");
				          	}
				          	/*if(measure.get("FILTER") != null){
				          	 	filter = (String)measure.get("FILTER");
				          	}   */
				          	if(measure.get("DB_COLUMN_NAME") != null){
				          	 	dbColumn = (String)measure.get("DB_COLUMN_NAME");
				          	}
				          	if(measure.get("AGGREGATE_FUNCTION")!= null){
				          	 	aggregateFunction = (String)measure.get("AGGREGATE_FUNCTION");
				          	}
				          	if(measure.get("CLIENT_MEASURE_NAME")!= null){
				          	 	clientMName = (HashMap)measure.get("CLIENT_MEASURE_NAME");
				          	}
				          	if(measure.get("GROWTH_CONTRIBUTION")!= null){
				          	 	growth = (String)measure.get("GROWTH_CONTRIBUTION");
				          	}
				          	if(measure.get("MEASURE_EXPRESSION")!= null){
				          	 	expression = (String)measure.get("MEASURE_EXPRESSION");
				          	}


				          	%>
				          	<input type="hidden" id="measureId" name="measureId" value='<%=measureToEdit%>'>
				          	<%
				          	session.removeAttribute("MEASURES_LIST");
                      }
                      %>
                      <tr>
                      	<td>&nbsp;
                      	</td>
                      </tr>
                      <input name="actionMode" type="hidden" value="<%=actionMode%>">
                      <tr>
                        <td width="36%" class="frmtxt" align="right"><%= measurename %>:&nbsp;</td>
                        <td width="64%">

                        <%
                        if(colName != null){
                          %>
                          <input name="measureName" type="text" id="measureName" value='<%=colName%>' maxlength="50">
                          <%
                        }else{
                        %>
                        <input name="measureName" type="text" id="measureName" class=frmtxtbox maxlength="50">
                        <%
                        }
                        %>
                        </td>
                      </tr>
                      <tr>
                      	<td width="36%" class="frmtxt" align="right"><%= measuredatatype %> :&nbsp;
                      	</td>
                      	<td>
							<select name="dataType" id="select"  class="frmdropdown">
<!--                         		<option value="number" <%=dataType.equalsIgnoreCase("number")? "selected":"" %>>Number</option>
                        		<option value="currency" <%=dataType.equalsIgnoreCase("currency")? "selected":"" %>>Currency</option>
                        		<option value="percentage" <%=dataType.equalsIgnoreCase("percentage")? "selected":"" %>>Percentage</option>
                        		<option value="string" <%=dataType.equalsIgnoreCase("string")? "selected":"" %>>String</option>
                        		<option value="date" <%=dataType.equalsIgnoreCase("date")? "selected":"" %>>Date</option>
                        		<option value="time" <%=dataType.equalsIgnoreCase("time")? "selected":"" %>>Time</option> -->
	                       		<option value="1" <%=dataType.equalsIgnoreCase("1")? "selected":"" %>><%= ResourceUtil.getLabel("arc.number", locale)%></option>
                        		<option value="2" <%=dataType.equalsIgnoreCase("2")? "selected":"" %>><%= ResourceUtil.getLabel("arc.currency", locale)%></option>
                        		<option value="3" <%=dataType.equalsIgnoreCase("3")? "selected":"" %>><%= ResourceUtil.getLabel("arc.percentage", locale)%></option>
                        		<option value="4" <%=dataType.equalsIgnoreCase("4")? "selected":"" %>><%= ResourceUtil.getLabel("arc.string", locale)%></option>
                        		<option value="5" <%=dataType.equalsIgnoreCase("5")? "selected":"" %>><%= ResourceUtil.getLabel("arc.date", locale)%></option>
                        		<option value="6" <%=dataType.equalsIgnoreCase("6")? "selected":"" %>><%= ResourceUtil.getLabel("arc.time", locale)%></option>
                            </select>
                      	</td>
                      </tr>
					  <tr>
                        <td class="frmtxt" align="right"><%= measuretype %>:&nbsp;</td>
                        <td>
	                          <select name="measureType" id="measureType"  class="frmdropdown" onclick="selectMeasure();">
<!-- 	                          	<option value="dbCol">Base Measure</option> -->
	                          	<option value="ruleCol"><%= ResourceUtil.getLabel("arc.computed.measure", locale)%></option>
	                          	<option value="percentCont"><%= ResourceUtil.getLabel("arc.contribution.measure", locale)%></option>
<!-- 	                          	<option value="growth">% Contribution Growth</option>
	                          	<option value="expression">Expression Measure</option> -->
	                          	<option value="cumulativeTotal"><%= ResourceUtil.getLabel("arc.cumulative.total.measure", locale)%></option>
	                          </select>
                          </td>
                      </tr>
                      <tr id="basemeasurecolumn" style="display:none">
                        <td  class="frmtxt" align="right"><%= ResourceUtil.getLabel("arc.database.column.name", locale)%> :&nbsp;</td>
                        <td nowrap><div>
                            <input name="dbColumn" type="text" id="dbColumn" value = ""/>
                        </div></td>
                      </tr>
                      <tr id="basemeasurefunc" style="display:none">
                        <td  class="frmtxt" align="right"><%= ResourceUtil.getLabel("arc.aggregate.function", locale)%> :&nbsp;</td>
                        <td nowrap><div>
                            <input name="aggregateFunc" type="text" id="aggregateFunc" value = ""/>
                        </div></td>
                      </tr>
                      <tr id="ruleColumn" style="display:none">
                        <td  class="frmtxt" align="right"><%= rulemeasure %> :&nbsp;</td>
                        <td nowrap><div>
                            <input name="measureRule" type="text" id="measureRule" value = "" size="40">
&nbsp;
              <input name="Expression" type="button" class="formfield" id="Expression" onclick="javascript:expressionPopup('measureRule')" value="...">
                        </div></td>
                      </tr>
                      <tr id="contributionCol" style="display:none">
                        <td class="frmtxt" align="right"><%= ResourceUtil.getLabel("arc.contribution.measure", locale)%> :&nbsp;</td>
                        <td nowrap>
                        <div>
                            <input name="measureContribution" type="text" id="measureContribution" value = "">&nbsp;
				            <input name="getCol" type="button" class="formfield" id="getCol" onClick="javascript:showColumnsPopup('getColId');" value="...">
                        </div>
                        </td>
                      </tr>
                      <tr id="cumulativeCol" style="display:none">
                        <td class="frmtxt" align="right"><%= ResourceUtil.getLabel("arc.cumulative.total.measure", locale)%> :&nbsp;</td>
                        <td nowrap>
                        <div>
                            <input name="cumulativeTotCol" type="text" id="cumulativeTotCol" value = "">&nbsp;
				            <input name="getCol" type="button" class="formfield" id="getCol" onClick="javascript:showColumnsPopup('getCumColId');" value="...">
                        </div>
                        </td>
                      </tr>

<!--                       <tr>
                        <td align="right" class="frmtxt">Client Measure Name :&nbsp;</td>
                        <td><input name="clientMName" type="text" id="clientMName" <%if(clientMName != null){%>value="<%=clientMName%>"<%}else{%>value=""<%}%> size="20"></td>
                      </tr> -->

                      <!-- measure group start-->
                      <tr>
                      	<td width="36%" class="frmtxt" align="right"><%= measuregroup %> :&nbsp;
                      	</td>
                      	<td>
							<select name="measureGroup" id="measureGroup"  class="frmdropdown">
								<%
									if(measureGroups!=null && measureGroups.size()>0)
									{
										for(int i=0;i<measureGroups.size();i++)
										{
								%>
											<option value="<%=measureGroups.get(i)%>"><%=measureGroups.get(i)%></option>
								<%
										}
									}
								%>
                            </select>
                      	</td>
                      </tr>

                      <!-- measure group end-->

                      <!-- measure growth start -->
                      <tr id="growthText" style="display:none">
                      	<td width="36%" class="frmtxt" align="right"><%= ResourceUtil.getLabel("arc.growth.contribution", locale)%> :&nbsp;
                      	</td>
                      	<td><input name="growthContribution" type="text" id="growthContribution" size="20" value="<%=growth%>">
                      	<input name="getCol" type="button" class="formfield" id="getCol" onClick="javascript:showColumnsPopup('growthId');" value="...">
						</td>
                      </tr>
                      <!-- measure growth end -->

                      <!-- measure expression start -->
                      <tr id="expressionText" style="display:none">
                      	<td width="36%" class="frmtxt" align="right"><%= ResourceUtil.getLabel("arc.measure.expression", locale)%> :&nbsp;
                      	</td>
                      	<td><input name="measureExpression" type="text" id="measureExpression" size="20" value="<%=expression%>">
						</td>
                      </tr>
                      <!-- measure expression end -->



<%
	TreeMap selectedLanguages = (TreeMap) com.manthan.promax.config.ConfigurationSettings.getSelectedLanguages();

	String language = com.manthan.promax.config.ConfigurationSettings.getDefaultLanguage();

				if(selectedLanguages.size() > 0)
				{
					for (Iterator it=selectedLanguages.keySet().iterator(); it.hasNext(); )
					{
						Object key = it.next();

						String languageName = "";
						if(clientMName != null && clientMName.get(key) != null)
						{
							languageName = (String)clientMName.get(key);
						}
					%>

					<%
					}
				}
				%>

                      <tr >
                      	<td colspan="2">&nbsp;
                      	</td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td align='right'>
							<img src="images/save<%=lang%>_off.gif" alt = "<%= save %>"   onClick="javascript:submitPage();" id="id1" onmouseover="MM_swapImage('id1','','images/save<%=lang%>_on.gif',1)" onmouseout="MM_swapImgRestore()">
			  				<img src="images/cancel<%=lang%>_off.gif" alt = "<%= close %>"   onClick="javascript:window.close();" id="id2" onmouseover="MM_swapImage('id2','','images/cancel<%=lang%>_on.gif',1)" onmouseout="MM_swapImgRestore()">
						</td>
                      </tr>
                      <tr>
                      	<td>&nbsp;
                      	</td>
                      </tr>
                  </table></td>
                </tr>
              </table></td>
            </tr>
			<tr>
			<td align="right">
			<%
				String fromPage = request.getParameter("fromPage");
				if(fromPage != null && fromPage.equalsIgnoreCase("customizeColumn"))
				{
			%>
					<input type="hidden" name="fromPage" value="<%=fromPage%>">

					<img src="admin_images/back_button.gif" width="48" height="21" border="0" onClick="window.location='<%=path%>/BCMCust_Columns.jsp?csrfPreventionSalt=${csrfPreventionSalt}'">
			<%
				}
				else
				{
			%>

			<%
				}
			%>
             </td>
            </tr>
			<tr>
			  <td align="right">&nbsp;</td>
		    </tr>
			<%
				 if(request.getAttribute("ACTION_MSG") != null){
			%>
			<tr>
			  <td><table width="100%"  border="0" cellpadding="4" cellspacing="1" bgcolor="#333333">
                <tr>
                  <td bgcolor="#F0F0F0" nowrap><span  class="style1"><img src = "admin_images/alert_icon.gif"> <%=request.getAttribute("ACTION_MSG").toString() %> </span></td>
                </tr>
              </table></td>
		    </tr>
			<%
			}
			%>


			<%
				 if(request.getAttribute("ERROR_MSG") != null){
			%>
			<tr>
			  <td><table width="100%"  border="0" cellspacing="1" cellpadding="3" bgcolor="#333333">
                <tr>
                  <td bgcolor="#F0F0F0" nowrap><span  class="style1"><img src = "admin_images/alert_icon.gif"> <%= ResourceUtil.getMessage("arc.error.message", locale)%></span></td>
                </tr>
                <tr>
                  <td bgcolor="#F0F0F0" class="frmtxt"><%=(String)request.getAttribute("ERROR_MSG")%></td>
                </tr>
              </table></td>
		    </tr>
			<%
			}
			%>

			<tr id="pleaseWait" style="display:none">
			  <td><table width="100%"  border="0" cellspacing="1" cellpadding="3" bgcolor="#333333">
                <tr>
                  <td bgcolor="#F0F0F0" nowrap><span  class="style1"><img src = "admin_images/alert_icon.gif"><%= ResourceUtil.getMessage("arc.prompt.wait", locale)%></span></td>
                </tr>
              </table></td>
		    </tr>

          </table></td>
      </tr>
    </table>
 				<%
                       if(request.getParameter("measure_Id") != null && rule != null && rule.length()>0){
                       %>
                       <script>
                       		window.onload = setState();
                       		function setState(){
	                       		//document.getElementById('ruleCol').checked = true;
	                       		document.form1.measureType.options[1].selected = true;
	                       		document.getElementById('ruleColumn').style.display='';
								//document.getElementById('contributionCol').style.display='none';
								loadGroups();
							}
                       </script>
                       <%
                       }else if(request.getParameter("measure_Id") != null && percentPos != null && percentPos.length()>0){
                      %>
                      	<script>
                      	    window.onload = setState();
                       		function setState(){
	                       		//document.getElementById('percentCont').checked = true;
	                       		document.form1.measureType.options[2].selected = true;
	                       		//document.getElementById('ruleColumn').style.display='none';
								document.getElementById('contributionCol').style.display='';
								loadGroups();
							}
                       </script>
                      <%
                      }
                      else if(request.getParameter("measure_Id") != null && growth != null && growth.length()>0){
                      %>
                      	<script>
                      	    window.onload = setState();
                       		function setState(){
	                       		//document.getElementById('percentCont').checked = true;
	                       		document.form1.measureType.options[3].selected = true;
	                       		//document.getElementById('ruleColumn').style.display='none';
								//document.getElementById('contributionCol').style.display='none';
								document.getElementById('growthText').style.display='';
								//document.getElementById('expressionText').style.display='none';
								loadGroups();
							}
                       </script>
                      <%

                      }else if(request.getParameter("measure_Id") != null && expression != null && expression.length()>0){
                      %>
                      	<script>
                      	    window.onload = setState();
                       		function setState(){
	                       		//document.getElementById('percentCont').checked = true;
	                       		document.form1.measureType.options[4].selected = true;
	                       		//document.getElementById('ruleColumn').style.display='none';
								//document.getElementById('contributionCol').style.display='none';
								//document.getElementById('growthText').style.display='none';
								document.getElementById('expressionText').style.display='';
								loadGroups();
							}
                       </script>
                      <%

                       }
                      else{
                       %>

                       <%
                       }
                      %>
</form>
<script>
//load computed selection
		document.getElementById('basemeasurecolumn').style.display='none';
		document.getElementById('basemeasurefunc').style.display='none';
		document.getElementById('ruleColumn').style.display='';
		document.getElementById('contributionCol').style.display='none';
		document.getElementById('growthText').style.display='none';
		document.getElementById('expressionText').style.display='none';
</script>


</body>
</html>
<%
}catch(Exception ex)
{
	ex.printStackTrace();
}
%>
