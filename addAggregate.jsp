<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="com.manthan.arc.config.metadata.*"%>

<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Collections"%>
<%@ page import="com.manthan.arc.config.dbmodel.*"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="com.manthan.promax.security.schmail.Mailer"%>
<%@ page import="static com.manthan.arc.security.CrossSiteScriptingHandler.*"%>

<% com.manthan.promax.security.SecurityEngine.isSessionOver(request,response,"login.jsp"); %>
<!-- Added include JSP's for Localization -->
<%@ include file="userSession.jsp" %>
<%@ include file="scriptLocalize.jsp" %>
<%

String selAggName = "";
String selDataSource = "";
try{
	String labelNameMaxLength = (Mailer.getPropValue("arc.metadata.leblename.maxlength")!=null ? Mailer.getPropValue("arc.metadata.leblename.maxlength").toString():"30");

	MetaDataUtil util = new MetaDataUtil();
	List<String> dataSources = util.getDataSources(request);
	//ArrayList<String> aggTables = util.getAggregateTablesList();
	ArrayList<String> aggTablesFromDBModel = util.getAggregateTableNamesFromDataModel();
	String selAggregateName = encodeForXss(request.getParameter("selAggregate"));

	String action = encodeForXss(request.getParameter("actionType"), URI);

	if(action == null){
		action = "add";
		session.removeAttribute("aggregate");
	}
	Aggregate aggregate = null;

	if( selAggregateName != null){
		aggregate = util.getAggregateFromMetadataTreeId(selAggregateName);
		selDataSource = (null == aggregate.getDataSource() || "".equals(aggregate.getDataSource()))? "sample" : aggregate.getDataSource();
		session.setAttribute("aggregate", aggregate);
	}

	aggregate = (Aggregate) session.getAttribute("aggregate");
	if(aggregate == null && action.equals("add")){
		aggregate = new Aggregate();
		session.setAttribute("aggregate", aggregate);
	}
	//HashMap<String, ArrayList> columns = util.getTableColumnNames(aggTables);

	ArrayList<String> dimName = new ArrayList<String>();
	HashMap<String, String> dimNameMap = new HashMap<String, String>();
	Module module = com.manthan.promax.db.ApplicationConfig.getDataModel();
	Dimension dimension[] = module.getDimension();
	for(int dimCnt=0; dimCnt< dimension.length; dimCnt++){
		Dimension dim = dimension[dimCnt];
		dimName.add(dim.getName());
		
		dimNameMap.put(dim.getName(), dim.getDisplayLabel());
	}
	Collections.sort(dimName);

	int linkRowCnt=1;
	if(aggregate != null && aggregate.getDimensionUsageCount()>0){
		linkRowCnt = aggregate.getDimensionUsageCount();
	}
	Hashtable propLabels = com.manthan.promax.report.ReportUtil.getLabels(session);

	String addAggregate = (String)propLabels.get("arc.metadata.addaggregate");
    if(addAggregate  == null || addAggregate.equals("")){
    	addAggregate = "Add Aggregate";
	}

    String editAggregate = (String)propLabels.get("arc.metadata.editaggregate");
    if(editAggregate  == null || editAggregate.equals("")){
    	editAggregate = "Modify Aggregate";
    }

    String aggregateTypeTable = (String)propLabels.get("arc.metadata.aggregatetype.table");
    if(aggregateTypeTable  == null || aggregateTypeTable.equals("")){
    	aggregateTypeTable = "Table";
    }

    String aggregateTypeInlinequery = (String)propLabels.get("arc.metadata.aggregatetype.inlinequery");
    if(aggregateTypeInlinequery  == null || aggregateTypeInlinequery.equals("")){
    	aggregateTypeInlinequery = "Inline Query";
    }

    String aggregateTable = (String)propLabels.get("arc.metadata.aggregatetable");
    if(aggregateTable  == null || aggregateTable.equals("")){
    	aggregateTable = "Aggregation Table";
    }

    String validateSql = (String)propLabels.get("arc.metadata.validatesql");
    if(validateSql  == null || validateSql.equals("")){
    	validateSql = "Validate SQL";
    }

    String aggregateTimePeriod = (String)propLabels.get("arc.metadata.aggregate.timeperiod");
    if(aggregateTimePeriod  == null || aggregateTimePeriod.equals("")){
    	aggregateTimePeriod = "Aggregate Time Period";
    }

    String aggregateTimePeriodCnt = (String)propLabels.get("arc.metadata.aggregate.timeperiodcount");
    if(aggregateTimePeriodCnt  == null || aggregateTimePeriodCnt.equals("")){
    	aggregateTimePeriodCnt = "Aggregate Time Period Count";
    }

    String dimensionUsed = (String)propLabels.get("arc.metadata.dimensionused");
    if(dimensionUsed  == null || dimensionUsed.equals("")){
    	dimensionUsed = "Dimensions Used";
    }

    String dimensionName = (String)propLabels.get("arc.metadata.dimension");
    if(dimensionName  == null || dimensionName.equals("")){
    	dimensionName = "Dimension";
    }

    String cancel = (String)propLabels.get("arc.metadata.cancel");
    if(cancel  == null || cancel.equals("")){
    	cancel = "Cancel";
    }

    String addAnother = (String)propLabels.get("arc.metadata.addanother");
    if(addAnother  == null || addAnother.equals("")){
    	addAnother = "Add Another";
    }

    String delete = (String)propLabels.get("arc.metadata.delete");
    if(delete  == null || delete.equals("")){
    	delete = "Delete";
    }

    String foreignKeyLbl = (String)propLabels.get("arc.metadata.foreignkey");
    if(foreignKeyLbl  == null || foreignKeyLbl.equals("")){
    	foreignKeyLbl = "Foreign Key";
    }

    if(aggregate != null && aggregate.getName() != null){
		selAggName = aggregate.getName();
		selDataSource=aggregate.getDataSource();
	}
%>
<%@page import="com.manthan.promax.db.ApplicationConfig"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=<%= session.getAttribute("CHARSET").toString()%>" />
<title><%= com.manthan.promax.security.schmail.Mailer.getPropValue("arc.title").toString() %></title>
<link href="css/style<%=userSelectedTheme%>.less" rel="stylesheet/less" type="text/css" />
<script language="javascript" type="text/javascript" src="js/less.js"></script>
<script language="javascript" type="text/javascript" src="js/general.js"></script>
<script language="javascript" type="text/javascript" src="js/drag.js"></script>
<script language="javascript" type="text/javascript" src="js/script.js"></script>
<script language="javascript" type="text/javascript">
	var columnsTable = new Hashtable();
<%

if(request.getAttribute("closeAction") != null && ((String)request.getAttribute("closeAction")).equalsIgnoreCase("true")){
	%>
		var measGrpVal = '<%= (String)request.getAttribute("aggName")%>';
		parent.aggFlag = false;
		parent.aggregateSelNodeVal = measGrpVal;
		parent.loadSelectedAggregate(measGrpVal);
		<%if(encodeForXss(request.getParameter("actionType")).equalsIgnoreCase("edit")){%>
			sucessAlertKillPopup('<%= ResourceUtil.getMessage("arc.aggreg.update.success", locale)%>','killPopup1');
		<%}else{%>
			sucessAlertKillPopup('<%= ResourceUtil.getMessage("arc.aggreg.added.success", locale)%>','killPopup');
		<%}%>
	<%
}

if(aggregate != null && aggregate.getTable() != null){
	List dimColumns = util.getTableColumnNames(aggregate.getTable().getName());
%>
	var colNames = new Array();
<%
	for(int colCnt=0; colCnt<dimColumns.size(); colCnt++){
	%>
		colNames[<%=colCnt%>] = "<%=dimColumns.get(colCnt)%>";
	<%
	}
%>
	columnsTable.put("<%=aggregate.getTable().getName()%>",colNames);
<%
}
%>

   	var rowCnt = 1;
	<%
	if(aggregate != null && aggregate.getDimensionUsageCount()>0){
	%>
		rowCnt = <%=aggregate.getDimensionUsageCount()%>;
	<%
	}



	ArrayList<String> msgs = (ArrayList<String>) request.getAttribute("validations");
	String errMsg = "";

	if(msgs != null){
      	for(int msgCnt=0; msgCnt<msgs.size(); msgCnt++){
			if(errMsg.equals("")){
				errMsg = msgs.get(msgCnt);
			}else{
				errMsg = errMsg +";"+msgs.get(msgCnt);
			}
      	}
      	errMsg = "<span class=contentRed>"+errMsg+"</span>";
	}
	else{
		errMsg = ResourceUtil.getMessage("arc.fields.mandatory", locale);
	}

	%>

	var action = '<%= action%>';

	function onChangeAggType(aggType){
		var tbl = document.getElementById('dimTable');
	  	var lastRowNo = tbl.rows.length;

		if(aggType=="table"){
			document.getElementById('tableDiv').style.display='';
			document.getElementById('inlineDiv').style.display='none';

			for(var i=1; i<lastRowNo; i++){
				row = tbl.rows[i];
				rowId = row.id;
				document.getElementById('foreignKey'+rowId).style.display='';
				document.getElementById('inlineforeignKey'+rowId).style.display='none';
			}


		}
		if(aggType=="inline"){
			document.getElementById('inlineDiv').style.display='';
			document.getElementById('tableDiv').style.display='none';

			for(var i=1; i<lastRowNo; i++){
				row = tbl.rows[i];
				rowId = row.id;
				document.getElementById('foreignKey'+rowId).style.display='none';
				document.getElementById('inlineforeignKey'+rowId).style.display='';
			}
		}
	}

	function onChangeAggTable()
	{

		var tableName = document.form1.aggTableName.value;
		var dataSource = document.form1.dataSource.value;
		var url="arcui?nav_action=getTableColumns&selTable="+tableName+"&dataSource="+dataSource+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
			var myAjax = new Ajax.Request(url,
			{
			method: 'post',
			onComplete: loadTableColNames
			});
	}
	function onChangeDataSource()
	{
		document.form1.dataSource.disabled=true;
		setTimeout("document.form1.dataSource.disabled=false",4000);
		var dataSource = document.form1.dataSource.value;
		document.form1.aggTableName.options.length=0;
		var url="arcui?nav_action=getAggregateTables&dataSource="+dataSource+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
		new Ajax.Updater({success: 'aggTableName'}, url, {asynchronous:true, onFailure: reportError, evalScripts: true});
	}

	function loadData(){
		var tbl = document.getElementById('dimTable');
		var firstRow = tbl.rows[1];
   		var lastRow = tbl.rows[tbl.rows.length-1];
   		var firstRowData = document.getElementById('foreignKey'+firstRow.id);
   		var lastRowData = document.getElementById('foreignKey'+lastRow.id);
   		if(lastRowData){
   			deleteOptions(lastRowData);
   		}
   		var colName;
   		if(firstRowData && lastRowData){
	   		for(i=0;firstRowData.options.length;i++){
	   			colName = firstRowData.options[i].value
	   			if(colName!=""){
	   			addOption(lastRowData, colName, colName);
	   			}
	   		}
   		}
	}

	function loadTableColNames(orgReq){
		var tableName = document.form1.aggTableName.value;
		var responseXMLString = orgReq.responseText;
		var finalXMLString = convertXmlFromStr(responseXMLString);
		var filElements = finalXMLString.getElementsByTagName('column');
		//var filElements = orgReq.responseXML.getElementsByTagName("columns")[0].childNodes;

		var colNames = new Array();
		var tbl = document.getElementById('dimTable');
   		var lastRow = tbl.rows.length;
		//alert(lastRow);
		for(var i=1; i<lastRow; i++){
			row = tbl.rows[i];
			rowId = row.id;
			//alert(rowId);
			deleteOptions(document.getElementById('foreignKey'+rowId));
		}


		for(var j=0; j<filElements.length; j++){
			var filelement = filElements.item(j);
			var colName = filelement.getAttribute('name');

			colNames[j] = colName;

			for(var rowCnt=1; rowCnt<lastRow; rowCnt++){
				row = tbl.rows[rowCnt];
				rowId = row.id;

				addOption(document.getElementById('foreignKey'+rowId), colName, colName);
			}
		}
		columnsTable.put(tableName,colNames);

		/*columnsTable.moveFirst();
		while(columnsTable.next()){
			if(columnsTable.getKey()==tableName){
				columns = columnsTable.getValue();


				var tbl = document.getElementById('dimTable');
   				var lastRow = tbl.rows.length;

				var ids = new Array();
				for(var i=1; i<lastRow; i++){
					row = tbl.rows[i];
					rowId = row.id;

					deleteOptions(document.getElementById('foreignKey'+rowId));
					addOption(document.getElementById('foreignKey'+rowId), "Select", "");
					for(var cnt=0; cnt<columns.length; cnt++){
						var colName = columns[cnt];
						addOption(document.getElementById('foreignKey'+rowId), colName, colName);
					}

				}
			}
		}*/
	}

	function validateSQL(){
		if(!eval("validateNSubmit('aggName:nn','')")){
			$('aggName').focus();
			return false;
		}
		if(!eval("validateNSubmit('inlineTableName:nn','')")){
			$('inlineTableName').focus();
			return false;
		}
		if(!eval("validateNSubmit('inlineQuery:nn','')")){
			setValidationMessage('<%=ResourceUtil.getMessage("arc.add.sql.kpi.wrong.query", locale)%>');
			$('inlineQuery').focus();
				return false;
		}
		var url = "arcui?nav_action=validateAggregateSQL&skipForSome=true&inlineQuery="+encodeURIComponent(trim(document.form1.inlineQuery.value))+"&inlineTableName="+encodeURIComponent(trim(document.form1.inlineTableName.value))+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
		var myAjax = new Ajax.Request(url,{method: 'post', onComplete: showValidationMessage});
	}

	function showValidationMessage(orgReq){
		var filElements = orgReq.responseXML.getElementsByTagName("Message")[0];
		parent.document.getElementById('mandatorySection1').innerHTML = "<span class=contentRed>"+filElements.getAttribute('msg')+"</span>";
	}

    function removeRowFromTable(id){
    	var tbl = document.getElementById('dimTable');
    	var tblRow = document.getElementById(id);
    	tbl.deleteRow(tblRow.rowIndex);

    }

 	function enableControls(){
		document.form1.aggName.disabled=false;
		document.form1.aggTableName.disabled=false;
		document.form1.inlineTableName.disabled=false;
	}
 	var isClicked=true;
	function chkDuplicateAggregateName(){
		var chkErrorClass=document.getElementsByClassName('inputFieldErrSel');
		if(chkErrorClass.length>0){
		for (var i = 0; i < chkErrorClass.length; i++) {
			checkMultiple(chkErrorClass[i]);
			return false; 
		}}
		resetTextBoxClassDefault(document.form1);
		if(validateNSubmit('aggName:nn,sc','')){
		if(trim($('aggName').value) != '<%= selAggName%>'){
			var aggregateName = $('aggName').value;
			var url = "arcui?nav_action=chkForDuplicateAggregate&aggregateName="+aggregateName+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
			new Ajax.Request(url, {method:'post', onComplete:showResponse});
			/* if(!isClicked)return false;
			isClicked=false;if(parent.document.getElementById("AddModifyBtn")) {parent.document.getElementById("AddModifyBtn").style.opacity="0.2";} */
		}else{
				saveAggregate();
			}
		}
		else{
			return false;
		}
	}

	function showResponse(resObj){
		var msg = resObj.responseText;
		if(msg == "already exists"){
			setValidationMessage('<%= ResourceUtil.getMessage("arc.aggregate.name.already.exist", locale)%>');
			$('aggName').className = "inputFieldErr";
			return false;
			if(!isClicked)return false;
			isClicked=false;if(parent.document.getElementById("AddModifyBtn")) {parent.document.getElementById("AddModifyBtn").style.opacity="0.2";}
		}
		else{
			saveAggregate();
			/* if(!isClicked)return false;
			isClicked=false;if(parent.document.getElementById("AddModifyBtn")) {parent.document.getElementById("AddModifyBtn").style.opacity="0.2";} */
			//validation will done in saveAggregate() method
		}
	}

	function saveAggregate(){
	  	var aggT = "table";
	  	document.form1.aggName.value = trim(document.form1.aggName.value);
		document.form1.aggName.value = document.form1.aggName.value.replace(/\s+/g,' ');
		if(document.getElementById('inlineQuery')!=null)
			document.form1.inlineQuery.value = trim(document.form1.inlineQuery.value);
		if(document.getElementById('inlineTableName')!=null)
			document.form1.inlineTableName.value = trim(document.form1.inlineTableName.value);

		//if(!eval("validateNSubmit('aggName:nn,sc','')")){
			//return false;
		//}
	  	if(document.form1.aggType[1] != null){
	  		if(document.form1.aggType[1].checked==true){
	  			aggT = "inline";
	  		}
	  	}else{
	  		aggT = document.form1.aggType.value;
	  	}

		if(aggT == "table"){
			if(document.form1.aggTableName.value == null || document.form1.aggTableName.value == "" ){
				setValidationMessage('<%= ResourceUtil.getLabel("arc.select.aggregate.table", locale) %>');
				document.form1.aggTableName.className = "inputFieldErrSel";
				return false;
			}
		}else{
			/*if(document.form1.inlineTableName.value == null || document.form1.inlineTableName.value == "" ||
			document.form1.inlineQuery.value == null || document.form1.inlineQuery.value == "" ){
				alert(<%= ResourceUtil.getLabel("arc.enter.inline.query", locale) %>);
				return;
			}*/
			if(!eval("validateNSubmit('inlineTableName:nn,sc','')")){
				return false;
			}
			if(!eval("validateNSubmit('inlineQuery:nn','')")){
				return false;
			}
		}

		var tbl = $('dimTable');
		if(tbl.rows.length > 1){
			resetTextBoxClassDefault(document.form1);
			for(var cnt=1; cnt<tbl.rows.length; cnt++){
				var tblRow = tbl.rows[cnt];
				var tempColId = tblRow.id;
				var col = tempColId.substring(3,tempColId.length)

				selDim = $F('namedim'+col);
				selDimForKey = $F('foreignKeydim'+col);
				selDimInlineForKey = $F('inlineforeignKeydim'+col);

				if(selDim==''){
					$('namedim'+col).className = "inputFieldErrSel";
					setValidationMessage('<%= ResourceUtil.getMessage("arc.dimension.usage.dimension", locale)%>');
					return false;
				}

				if(aggT == "table"){
					if(selDimForKey == ''){
						setValidationMessage('<%= ResourceUtil.getMessage("arc.dimension.usage.foreignkey", locale)%>'.replace('?',selDim));
						$('foreignKeydim'+col).className = "inputFieldErrSel";
						return false;
					}
				}else
				{
					if(selDimInlineForKey == ''){
						setValidationMessage('<%= ResourceUtil.getMessage("arc.dimension.usage.foreignkey", locale)%>'.replace('?',selDim));
						$('inlineforeignKeydim'+col).className = "inputFieldErrSel";
						return false;
					}
				}
			}
		}
		enableControls();
		checkDataModelReadOnlyMode();
		if(!isClicked)return false;
		isClicked=false;if(parent.document.getElementById("AddModifyBtn")) {parent.document.getElementById("AddModifyBtn").style.opacity="0.2";}		
	}

function errorClassForDimension(){
	resetTextBoxClassDefault(document.form1);

	if(("<%=errMsg %>").match('Dimension usage is mandatory') || ("<%=errMsg %>").match('Foreign Key is mandatory for dimension Usage')){
		if(("<%=errMsg %>").match('Dimension usage is mandatory')){
			document.form1.namedim1.className = "inputFieldErrSel";
			return false;
		}
		else if(("<%=errMsg %>").match('Foreign Key is mandatory for dimension Usage')){
			document.form1.foreignKeydim1.className = "inputFieldErrSel";
			return false;
		}
	}
}

function checkDataModelReadOnlyMode(){
	var url = "arcui?nav_action=checkDatamodelReadOnlyMode"+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
	new Ajax.Request(url, { method: 'post',onComplete: returnModeStatus	});
}

function returnModeStatus(resObj){
	var msg = resObj.responseText;
	if(msg.length>0){
		setValidationMessage(msg);
		if(action == 'edit'){
			disableElementsOnEdit();
		}
		return false;
	}
	else{
		document.form1.action = "MetaDataController?servletAction=saveAggregate&skipForSome=true&csrfPreventionSalt="+ $F('csrfPreventionSalt');
		document.form1.submit();
		isClicked=true;if($("previewBtn"))$("previewBtn").style.opacity="100";
	}
}

//deepaka to check selected "Dimension Used" is allowed with Multiple selection or not.Based Upon that selection of multiple foreign key is possible
function checkMultiple(obj){
	var dimTableValue=document.getElementById('namedim'+(obj.id).split('foreignKeydim')[1]).value;
	var countSelection=0;
	var cnt;
	var foreignKeySel=document.getElementById(obj.id);
	foreignKeySel.className = "inputField";
	bodyClick();
	if(dimTableValue==''){
		$('namedim'+(obj.id).split('foreignKeydim')[1]).className = "inputFieldErrSel";
		setValidationMessage('<%= ResourceUtil.getMessage("arc.dimension.usage.dimension", locale)%>');
		for(cnt=0;cnt<foreignKeySel.length;cnt++){
			foreignKeySel[cnt].selected=false;
		}
		return;
	}else{
		for(cnt=0;cnt<foreignKeySel.length;cnt++){
			if(foreignKeySel[cnt].selected==true)
				countSelection++;
		}
	}
	if(countSelection>0){
		var url = "arcui?nav_action=checkMultiPrimary&DimTable="+dimTableValue+"&csrfPreventionSalt="+ $F('csrfPreventionSalt');
		new Ajax.Request(url, { method: 'post',onComplete:function(orgreq){
		if(countSelection>orgreq.responseText){
			foreignKeySel.className = "inputFieldErrSel";
			setValidationMessage('Only '+orgreq.responseText+' Foreign Key is allowed for '+dimTableValue);
			for(cnt=0;cnt<foreignKeySel.length;cnt++){
				if(foreignKeySel[cnt].selected==true)
					foreignKeySel[cnt].selected=false;
			}
		}
		else if(countSelection<orgreq.responseText){
			foreignKeySel.className = "inputFieldErrSel";
			setValidationMessage('Select '+ parseInt(orgreq.responseText-countSelection)+' more Foreign Key for '+dimTableValue);
		}
	}});
	}
}
function changeClass(obj){
	obj.className = "inputField";
	var foreignKeySel=document.getElementById('foreignKeydim'+obj.id.split('namedim')[1]);
	for(var cnt=0;cnt<foreignKeySel.length;cnt++){
		foreignKeySel[cnt].selected=false;
	}
}
function disableElementsOnEdit(){
	$('aggName').disabled = true;
	$('aggTableName').disabled = true;
}

function bodyClick(){
  parent.document.getElementById('mandatorySection1').innerHTML='<%= errMsg %>';
}
function bodyLoading(){
  parent.document.getElementById('mandatorySection1').innerHTML='<%= errMsg %>';
  parent.document.getElementById('poupButtons1').innerHTML = document.getElementById('thisPageButtons1').innerHTML
}
</script>
</head>

<body onmousemove="updatebox(event)" onkeypress="escPopup(event)" onload="bodyLoading();" >
	<div id="thisPageButtons1" style="display:none">
		  <div style="float:left">
		  <table border="0" cellspacing="0" cellpadding="0">
		  <tr>
		  <td>
			  <div id="AddModifyBtn" class="buttonBlueLeft" onclick="popUpFrame1.chkDuplicateAggregateName()">
				  <div class="buttonText">

				  <%
				  if(action.equals("add")){
				  %>
				  <%= ResourceUtil.getLabel("arc.add.aggregate", locale) %>
				  <%
				  }else{
				  %>
				  <%= ResourceUtil.getLabel("arc.modify.aggregate", locale)%>
				  <%
				  }
				  %>

				  </div>
				   <div class="buttonBlueRight_M" ></div>
			  </div>
		  </td>
		  <td>&nbsp;</td>
		  <td>
			  <div class="buttonBlueLeft" onclick="killPopup1()">
				  <div class="buttonText"><%= ResourceUtil.getLabel("arc.cancel", locale)%></div>
				  <div class="buttonBlueRight_M" ></div>
			  </div>
		  </td>
		  </tr>
		  </table>
		  </div>
	</div>
<form name="form1" method="post" action="addDimension.jsp" >
<input type="hidden" id="csrfPreventionSalt" name="csrfPreventionSalt" value="${csrfPreventionSalt}"/>
<input type="hidden" name="actionType" value="<%=encodeForXss(action,HTMLATTRIBUTE)%>" />
<%
	String selected = "";
	String disabled = "";
	if(action!= null && action.equalsIgnoreCase("edit")){
		disabled = "disabled";
	}
%>
<div id="admain">
<table width="100%"  border="0" cellspacing="2" cellpadding="3" class="tblBorder" align="center">
  <tr>
  	<td width="20%" align="left" valign="top" class="tblLabel"><%= ResourceUtil.getLabel("arc.datasource", locale)%><span class=contentRed> *</span></td>
    <td width="50%" colspan="3" align="left" valign="top" class="tblContent">

	<select name="dataSource" id="dataSource" class="inputField" onchange="onChangeDataSource();" <%if(action.length()>0 && action.equalsIgnoreCase("edit")){ %> disabled='disabled'<%}%> >
		<%
			String selectedDs = "";
			String dataSource = "";
			for(int dsCnt=0; dsCnt<dataSources.size(); dsCnt++){
				selected="";
				dataSource = dataSources.get(dsCnt);
				if(selDataSource!=null && selDataSource.trim().length()>0 && dataSource.equalsIgnoreCase(selDataSource)){
					selected="selected";
				}

		%>
			<option value="<%=dataSource%>" <%=selected%>><%=dataSource%></option>
		<%
			}
		%>
	</select>
	</td>
  </tr>
  <tr>
    <td width="20%" align="left" valign="top" class="tblLabel"><%= ResourceUtil.getLabel("arc.aggregate.name", locale)%><span class=contentRed> *</span></td>
    <td width="30%" align="left" valign="top" class="tblContent">
    	<input name="aggName" id="aggName" size="40" <%=disabled%> type="text" maxlength="<%= labelNameMaxLength%>" class="inputField" value="<%=selAggName%>" />
    </td>
    <td width="20%" align="left" valign="top" class="tblLabel"><%= ResourceUtil.getLabel("arc.aggregat.type", locale)%>  <span class="contentRed">*</span></td>
    <td width="30%" class="tblContent">

    <%
		String aggType = "";
		if(aggregate != null && aggregate.getTable() != null && aggregate.getTable().getViewSql() != null && !aggregate.getTable().getViewSql().equals("")){
			aggType = "inline";
		}
	%>

	<%
		if(action.equalsIgnoreCase("edit")){
	%>
		<input type="hidden" name="aggType" id="aggType" value='<%=aggType.equals("inline")?"inline":"table"%>'/><%=aggType.equals("inline")? ResourceUtil.getLabel("arc.inline.query", locale) : ResourceUtil.getLabel("arc.table", locale)%>

	<%
		}else{
	%>
		<input type="radio" value="table" name="aggType"  <%=aggType.equals("")?"checked":""%> onclick="onChangeAggType('table')" /><%= ResourceUtil.getLabel("arc.table", locale)%>
		<input type="radio" value="inline" name="aggType" <%=aggType.equals("inline")?"checked":""%> onclick="onChangeAggType('inline')" /><%= ResourceUtil.getLabel("arc.inline.query", locale)%>
	<%
		}
	%>
	</td>
  </tr>

	<%
		String selTable = "";
		String viewSql = "";
		if(aggregate != null && aggregate.getTable() != null ){
			selTable = aggregate.getTable().getName();
			if(aggregate.getTable().getViewSql() != null){
				viewSql = aggregate.getTable().getViewSql();
			}
		}
	%>
	<%
		String tabstyle = "display:''";
		String inlineStyle = "display:none";
		if(aggType.equalsIgnoreCase("inline")){
			tabstyle = "display:none";
			inlineStyle = "display:''";
		}
	%>

    <tr id="tableDiv" style="<%=tabstyle%>">

    <td width="20%" align="left" valign="top" class="tblLabel"><%= ResourceUtil.getLabel("arc.aggregation.table", locale)%> <span class=contentRed>*</span></td>
    <td width="30%" colspan="3" align="left" valign="top" class="tblContent">
	<select name="aggTableName" id="aggTableName" class="inputField" onchange="onChangeAggTable();" <%if(action.length()>0 && action=="edit"){ %> style="display: none;"<%}else{ %>style="display: '';"<%} %>>
		<option value=""><%= ResourceUtil.getLabel("arc.select", locale)%></option>

		<%
			String selectedAgg = "";
			if(action.equalsIgnoreCase("add"))
			{
				aggTablesFromDBModel=null;
			}
			if(aggTablesFromDBModel!=null && aggTablesFromDBModel.size()>0){


			for(int aggTabCnt=0; aggTabCnt<aggTablesFromDBModel.size(); aggTabCnt++){
				selectedAgg = "";
				String tableName = aggTablesFromDBModel.get(aggTabCnt);

				if(!action.equalsIgnoreCase("add") && !action.equalsIgnoreCase("edit") && aggTablesFromDBModel.contains(tableName)){
					continue;
				}
				if(selTable != null && tableName!=null && selTable.equalsIgnoreCase(tableName)){
					selectedAgg = "selected";
				}
		%>
			<option value="<%=tableName%>" <%=selectedAgg%> ><%=tableName%></option>
		<%
			}
			}
		%>

	</select>
	</td>
	</tr>



	<tr id="inlineDiv" style="<%=inlineStyle%>">
	  <td width="20%" align="left" valign="top" class="tblLabel"><%= ResourceUtil.getLabel("arc.aggregation.table", locale)%> <span class=contentRed>*</span></td>
      <td width="30%" align="left" valign="top" class="tblContent">
		<input class="inputField" type="text" name="inlineTableName" id="inlineTableName" value="<%=selTable%>" <%=disabled%> />
	  </td>
	  <td width="20%" align="left" valign="top" class="tblLabel"><%= ResourceUtil.getLabel("arc.inline.query", locale)%> <span class=contentRed>*</span></td>
	  <td width="30%" align="left" valign="top" class="tblContent">
	 	<textarea  class="inputField" name="inlineQuery" id="inlineQuery" rows="3" cols="32" ><%=viewSql%> </textarea>
	<div style="float:right; padding-top:3px; margin-right:5px">
		<table border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>
		  <div class="buttonGreyLeft"  onclick="validateSQL();">
				  <div class="buttonText"><%=validateSql %></div>
				  <div class="buttonGreyRight_M" style="float:right;">
  		  </div>
		  </div>
		  </td>
		  </tr>
		  </table>
  </div>
	  </td>
	</tr>

	<tr >
	  <td width="20%" align="left" valign="top" class="tblLabel"><%=ResourceUtil.getLabel("arc.aggr.time.period", locale)%></td>
      <td width="30%" align="left" valign="top" class="tblContent">

		<select name="aggPeriodType" id="aggPeriodType" class="inputField" >
    			<option value=""> <%= ResourceUtil.getLabel("arc.select", locale)%> </option>
    			<%
    				String period = "";
    				if(aggregate != null){
    					period = aggregate.getPeriod();
    					period = (period==null)?"":period;
    				}

    			%>
    			<option value="MONTHS" <%=(period.equalsIgnoreCase("MONTHS")?"selected":"") %> > <%= ResourceUtil.getLabel("arc.monthly", locale)%> </option>
    			<option value="WEEKS" <%=(period.equalsIgnoreCase("WEEKS")?"selected":"") %> > <%= ResourceUtil.getLabel("arc.weekly", locale)%> </option>
    			<option value="DAYS" <%=(period.equalsIgnoreCase("DAYS")?"selected":"") %> ><%= ResourceUtil.getLabel("arc.daily", locale)%> </option>
    		</select>
	  </td>
	  <td width="20%" align="left" valign="top" class="tblLabel"><%= ResourceUtil.getLabel("arc.aggregate.time.period.count", locale)%></td>
	  <td width="30%" align="left" valign="top" class="tblContent">
	 	<input class="inputField" type="text" size="5" maxlength="5" onkeypress='javascript:if(checkKeycode(event)==46){return false;}else{return decimalValidation(this,event);}' name="aggPeriodCount" id="aggPeriodCount" value='<%=((aggregate != null && aggregate.getPeriodCount()>0)?aggregate.getPeriodCount():"")%>' />
	  </td>
	</tr>

	<tr>
	  <td width="20%" align="left" valign="top" class="tblLabel"><%=dimensionUsed %> <span class="contentRed">*</span></td>
      <td width="30%" align="left" valign="top" class="tblContent" colspan="3">
      <table width="100%" cellspacing="1" cellpadding="4" style="background-color:#CCCCCC">
		  <thead>
			<tr>
			  <td width="45px"><%= ResourceUtil.getLabel("arc.delete", locale)%>&nbsp;</td>
			  <td width="250px"><%= ResourceUtil.getLabel("arc.dimension_name", locale)%></td>
			  <td width="250px"><%= ResourceUtil.getLabel("arc.foreign.key", locale)%></td>
			</tr>
		</thead></table>
		<div style="width:100%;height:136px;overflow:hidden; overflow-y:auto;">
		<table id="dimTable" width="100%" cellspacing="1" cellpadding="4" style="background-color:#CCCCCC;magin-top:-7px;">
		  <thead>
			<tr style="font-size:0.0009em;display:none;height:0.009em;background-color:#ffffff;">
				  <td width="50px"></td>
				  <td></td>
				  <td></td>
				</tr>
		</thead>
		<tbody>
          	<%
            String style = "tblRow1";
			if(aggregate != null && aggregate.getDimensionUsageCount()>0){
				List<String> inActDimensions = ApplicationConfig.getModuleBaseInactiveDimensions();
            	for(int dimCnt=0; dimCnt<aggregate.getDimensionUsageCount(); dimCnt++){
					DimensionUsage dimUsage = aggregate.getDimensionUsage(dimCnt);
					String dimname = dimUsage.getName();
					String foreignKey = dimUsage.getForeignKey();
			%>
					<tr id="dim<%=dimCnt+1%>">
						<td width="45px" align="center" class="<%=style%>">
							<input type="hidden" name="selDims" value="dim<%=dimCnt+1%>" />
							<div class='imgDeleteSmallRow' onclick="javascript:removeRowFromTable('dim<%=dimCnt+1%>');"  title='<%= ResourceUtil.getLabel("arc.delete", locale)%>'></div>
						</td>
						<td  width="250px"  class="<%=style%>">
                  			<select class="inputField" name="namedim<%=dimCnt+1%>" id="namedim<%=dimCnt+1%>" onchange="changeClass(this)">
								<option value="" ><%= ResourceUtil.getLabel("arc.select", locale)%></option>
				<%
							selected = "";
							for(int dimNameCnt=0; dimNameCnt<dimName.size(); dimNameCnt++){
								selected = "";
								//condition for module base inactive meausres
								if(inActDimensions.contains(dimName.get(dimNameCnt))) continue;
								if(dimname.equalsIgnoreCase(dimName.get(dimNameCnt))){
									selected = "selected";
								}
				%>
								<option value="<%=dimName.get(dimNameCnt)%>" <%=selected%> ><%=dimName.get(dimNameCnt)%></option>
				<%
							}
				%>
							</select>
						</td>
						<td width="250px"  class="<%=style%>">
							<select class="inputField" name="foreignKeydim<%=dimCnt+1%>" id="foreignKeydim<%=dimCnt+1%>" size="3" multiple="multiple" style="width:250px;<%=tabstyle%>" onChange="checkMultiple(this);">
				<%
							List<String> columnNames = null;
							if(selTable != null && selDataSource!=null && selDataSource.trim().length()>0){
								columnNames = util.getTableColumnNamesForDataSource(selTable, selDataSource);
							}
							if(msgs!=null && msgs.size()>0){
								columnNames = null;
							}
							selected = "";
							if(columnNames != null && foreignKey!=null){
							for(int keyCnt=0; keyCnt<columnNames.size(); keyCnt++){
								selected = "";
									String[] foreignKeySplit=foreignKey.split(",");
									for(int commaCount=0;commaCount<foreignKeySplit.length;commaCount++)
									{
										if(columnNames.get(keyCnt).equalsIgnoreCase(foreignKeySplit[commaCount])){
											selected = "selected";
											break;
										}
									}
				%>
								<option value="<%=columnNames.get(keyCnt)%>" <%=selected%> ><%=columnNames.get(keyCnt)%></option>
				<%
							}
							}
				%>
							</select>
							<input type="text" name="inlineforeignKeydim<%=dimCnt+1%>" class='inputField' id="inlineforeignKeydim<%=dimCnt+1%>"  style="<%=inlineStyle%>" value="<%=foreignKey%>"/>

						</td>
					</tr>
			<%
					if(style.equals("tblRow1")){
						style = "tblRow2";
					}else{
						style = "tblRow1";
					}
            	}
			}else{
			%>
					<tr id="dim1">
						<td width="45px"  align="center" class="<%=style%>">
							<input type="hidden" name="selDims" value="dim1" />
							<div class='imgDeleteSmallRow' onclick="javascript:removeRowFromTable('dim1');"  title='<%= ResourceUtil.getLabel("arc.delete", locale)%>'></div>
						</td>
						<td width="250px"  class="<%=style%>">
                  			<select class="inputField" name="namedim1" id="namedim1" onchange="changeClass(this)">
								<option value="" ><%= ResourceUtil.getLabel("arc.select", locale)%></option>
				<%
							for(int dimNameCnt=0; dimNameCnt<dimName.size(); dimNameCnt++){
								String dimDisplayLbl = "";
								if(null!=ResourceUtil.getLabel(dimNameMap.get(dimName.get(dimNameCnt)), locale) && ResourceUtil.getLabel(dimNameMap.get(dimName.get(dimNameCnt)), locale).trim().length()>0){
									dimDisplayLbl = ResourceUtil.getLabel(dimNameMap.get(dimName.get(dimNameCnt)), locale);
								}else{
									dimDisplayLbl = dimName.get(dimNameCnt);
								}
				%>
								<option value="<%=dimName.get(dimNameCnt)%>" ><%=dimDisplayLbl%></option>
				<%
							}
				%>
							</select>
						</td>
						<td width="250px"  class="<%=style%>">
							<select class="inputField" name="foreignKeydim1" id="foreignKeydim1" size="3" multiple="multiple" style="width:250px;<%=tabstyle%>" onChange="checkMultiple(this);">
				<%
							List<String> columnNames = null;
							if(selTable != null){
								columnNames = util.getTableColumnNames(selTable);
							}

							if(columnNames != null){
							for(int keyCnt=0; keyCnt<columnNames.size(); keyCnt++){

				%>
								<option value="<%=columnNames.get(keyCnt)%>" ><%=columnNames.get(keyCnt)%></option>
				<%
							}
							}
				%>
							</select>
							<input type="text" class="inputField" name="inlineforeignKeydim1" id="inlineforeignKeydim1"  style="<%=inlineStyle%>" value=""/>

						</td>
					</tr>

			<%
			}
			%>
		  </tbody>
		 </table>
		<img src="images/spacer.gif" width="7"/></div>

		<div style="float:right; padding-top:8px;">
		<table border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>
			  <div class="buttonGreyLeft" onclick="addRowToLinkDimTable()">
				<div class="buttonText"><%= ResourceUtil.getLabel("arc.add.another", locale)%></div>
				 <div class="buttonGreyRight_M"></div>
			  </div>
			</td>
		  </tr>
		</table>
		</div>
	  </td>

	</tr>


</table>
</div>
</form>
<script language="javascript" type="text/javascript">
var errmsg='<%= msgs %>';
if(errmsg!=''&& errmsg!=null&& errmsg.length>0&&errmsg!='null'){
	onChangeDataSource();
	}
	function addRowToLinkDimTable(){
//		alert(rowCnt);
    	destinationTable = document.getElementById('dimTable');
    	var addClass="";
    	newRow = destinationTable.insertRow(destinationTable.rows.length);

		rowCnt = rowCnt+1;
		var id = "dim"+rowCnt;

		newRow.setAttribute("id", id);
		if(destinationTable.rows.length%2 == 1)
		{
			addClass = "tblRow2";
		}
		else
		{
			addClass = "tblRow1";
		}

		newCell1 = document.createElement("td");
		if(BrowserDetect.browser!='Explorer'){
			newCell1.setAttribute("class", addClass);
		}else{
			newCell1.setAttribute("className", addClass);
		}
		newCell1.setAttribute("align", "center");
		newCell1.setAttribute("width", "45px");

		newCell1.innerHTML = "<div class='imgDeleteSmallRow' id='disImg"+id+"' name='disImg"+id+"' title='<%= ResourceUtil.getLabel("arc.delete", locale)%>' onclick='javascript:removeRowFromTable(this.parentNode.parentNode.id);'></div>";
	  	//newCell1.appendChild(e1);

		eInput = document.createElement('input');
	 	eInput.setAttribute('type', 'hidden');
	  	eInput.setAttribute('name', 'selDims');
  		eInput.setAttribute('id', 'selDims');
		eInput.setAttribute('value', id);
		eInput.setAttribute("width", "250px");
		newCell1.appendChild(eInput);

		newRow.appendChild(newCell1);

		newCell2 = document.createElement("td");
		if(BrowserDetect.browser!='Explorer'){
			newCell2.setAttribute("class", addClass);
		}else{
			newCell2.setAttribute("className", addClass);
		}
		newCell2.setAttribute("width", "250px");

		e2 = document.createElement('select');
		e2.style.width = "185px";
	 	e2.setAttribute('name', 'namedim' + rowCnt);
	 	e2.setAttribute('id', 'namedim' + rowCnt);
	 	e2.setAttribute("width", "250px");
	  	e2.className = 'inputField';
	 	if(BrowserDetect.browser!='Explorer'){
			e2.setAttribute("onchange", "changeClass(this)");
		}else{
			e2.attachEvent ("onchange", function(){changeClass(e2);});
		} 
   		var opt = document.createElement('option');
   		opt.value="";
		setInnerText(opt, '<%=ResourceUtil.getLabel("arc.select", locale)%>');
  		e2.appendChild(opt);

<%
	  		for(int dimCnt=0; dimCnt<dimName.size(); dimCnt++){

	  	%>
	  		 opt = document.createElement('option');
	  		 opt.value="<%=dimName.get(dimCnt)%>";
			 setInnerText(opt, '<%=dimName.get(dimCnt)%>');
	  		  e2.appendChild(opt);
	  	<%
	  		}
	  	%>
	  	newCell2.appendChild(e2);
	  	newRow.appendChild(newCell2);

	  	newCell3 = document.createElement("td");
	  	if(BrowserDetect.browser!='Explorer'){
			newCell3.setAttribute("class", addClass);
		}else{
			newCell3.setAttribute("className", addClass);
		}
	  	newCell3.setAttribute("width", "250px");
	  	e3 = document.createElement('select');
	 	e3.setAttribute('name', 'foreignKeydim' + rowCnt);
	 	e3.setAttribute('id', 'foreignKeydim' + rowCnt);
	 	e3.style.cssText = "width:"+250+"px;";
	 	e3.setAttribute("size", "3");
	 	e3.setAttribute("multiple", "multiple");
	 	if(BrowserDetect.browser!='Explorer'){
			e3.setAttribute("onchange", "checkMultiple(this)");
		}else{
			e3.attachEvent ("onchange", function(){checkMultiple(e3);});
		} 
	  	e3.className = 'inputField';

	  	var aggT = "table";
	  	if(document.form1.aggType[1] != null){
	  		if(document.form1.aggType[1].checked==true){
	  			aggT = "inline";
	  		}
	  	}else{
	  		aggT = document.form1.aggType.value;
	  	}


	 	if(aggT == "inline" ){
	  		e3.style.display = 'none';
	  	}else{
	  		e3.style.display = '';
	  	}

  		var tableName = document.form1.aggTableName.value;


		columnsTable.moveFirst();
		var columns = null;
		while(columnsTable.next()){
			if(columnsTable.getKey()==tableName){
				columns = columnsTable.getValue();
			}
		}
		if(columns != null){
			for(var i=0; i<columns.length; i++){
				var colName = columns[i];
	  		 	opt = document.createElement('option');
	  		 	opt.value=colName;
				setInnerText(opt, colName);
	  		  	e3.appendChild(opt);
	  		}
	  	}


	  	newCell3.appendChild(e3);

	  	e4 = document.createElement('input');
	  	e4.setAttribute('type','text');
	  	e4.setAttribute('class', "inputField");
	  	e4.setAttribute('className', "inputField");
	 	e4.setAttribute('name', 'inlineforeignKeydim' + rowCnt);
	 	e4.setAttribute('id', 'inlineforeignKeydim' + rowCnt);
	 	if(aggT == "table" ){
	  		e4.style.display = 'none';
	  	}else{
	  		e4.style.display = '';
	  	}
	  	newCell3.appendChild(e4);

	  	newRow.appendChild(newCell3);

		document.getElementById("disImg"+id).onclick = function()
		{
	 		 removeRowFromTable(id);
	 	}
	 	if(action == 'edit'){
	 		loadData();
	 	}

    }

    if(action == 'edit'){
		disableElementsOnEdit();
	}
</script>

</body>

</html>
<%
 }catch(Exception e){
 	e.printStackTrace();
 }
%>