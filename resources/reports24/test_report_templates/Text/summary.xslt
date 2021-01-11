<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- The format of the xml string is as follows: 
	<Summary>
		<TestCase>test case url</TestCase>
		<ExecutionStart>2007/08/13 08:15:22</ExecutionStart>
		<ExecutionEnd>2007/08/13 08:15:39</ExecutionEnd>
		<ExecutionDuration>00:00:16</ExecutionDuration>
		<TotalReportItems>6</TotalReportItems>
		<TotalIssues>2</TotalIssues>
		<Status>Fail</Status>
		<Notes>Notes</Notes>
	</Summary>
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dateFormatter="xalan://com.fnfr.foundation.xslt.DateFormatter"
    xmlns:uriDecoder="xalan://java.net.URLDecoder"
    extension-element-prefixes="dateFormatter uriDecoder">
  
<xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<xsl:template name = "render_parameter">
	<xsl:param name = "session"/>
	<xsl:param name = "name"/>
	<xsl:param name = "description"/>
	<xsl:param name = "value"/>
	<xsl:param name = "source"/> 
Session:         <xsl:value-of select="$session"/>     
Parameter Name:  <xsl:value-of select="$name"/>   
Description:     <xsl:value-of select="$description"/>
Value:           <xsl:value-of select="$value"/>
Source:          <xsl:value-of select="$source"/>
------------------------------------------------------</xsl:template>
	
<xsl:template name="parameters" xmlns:pt="http://www.fnfr.com/schemas/parameterTree">
  <xsl:for-each select="//finalParameters/parameters//*[@pt:source and count(child::*)=0 and count(ancestor::*[name()='profile']) = 0 and count(ancestor::*[name()='testbed']) = 0]">
  	  <xsl:call-template name = "render_parameter" >
		  <xsl:with-param name = "session" select="ancestor::*[name()='profile']/@id" />
		  <xsl:with-param name = "name" select="concat(name(..), '/', name(current()))" />
		  <xsl:with-param name = "description" select="@pt:description" />
		  <xsl:with-param name = "value" select="current()" />
		  <xsl:with-param name = "source" select="@pt:source" />
	  </xsl:call-template> 	     
  </xsl:for-each>
  <xsl:for-each select="//finalParameters/parameters//*[@pt:source and count(child::*)=0 and count(ancestor::*[name()='profile']) > 0]">
  	  <xsl:call-template name = "render_parameter" >
		  <xsl:with-param name = "session" select="ancestor::*[name()='profile']/@id" />
		  <xsl:with-param name = "name" select="concat(name(..), '/', name(current()))" />
		  <xsl:with-param name = "description" select="@pt:description" />
		  <xsl:with-param name = "value" select="current()" />
		  <xsl:with-param name = "source" select="@pt:source" />
	  </xsl:call-template> 	     
  </xsl:for-each>
</xsl:template>
	
<xsl:template name="extractedData">
  <xsl:if test="count(//extractedData/item)>0">
    
    
------------------------------------------------------
-	Extracted Data
    <xsl:for-each select="//extractedData/item">
------------------------------------------------------
Time:                     <xsl:value-of select="time"/>
Test case:                <xsl:value-of select="testCase"/>
Procedure:                <xsl:value-of select="procedure"/>
Step:                     <xsl:value-of select="executedStep"/>
ID:                       <xsl:value-of select="executableStep"/>
Extracted data tag:       <xsl:value-of select="tag"/>
Value(s):                 <xsl:for-each select="data/item">
                          <xsl:text>
                          </xsl:text>
                          <xsl:value-of select="."/> 
           
           </xsl:for-each>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ format time ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template name="time">
    <xsl:param name="time"/>
    <xsl:variable name="seconds" select="$time mod 60"/>
    <xsl:variable name="minutes" select="(floor($time div 60)) mod 60"/>
    <xsl:variable name="hours" select="floor($time div 3600)"/>
    <xsl:value-of select="concat(format-number($hours,'#00'),':', format-number($minutes,'00'),':', format-number($seconds,'00.#'))"/>
  </xsl:template>
  
  
<xsl:template match="/">
  <xsl:variable name="emulation">		
    <xsl:if test="TestReportDocument/emulation = 'true'">(Emulated)</xsl:if>
  </xsl:variable>
  
------------------------------------------------------
-	Test Report <xsl:value-of select="$emulation"/>
------------------------------------------------------

------------------------------------------------------
-	Overview

Test Case:           <xsl:value-of select="uriDecoder:decode(TestReportDocument/testcase,'UTF-8')"/>
Testbed:             <xsl:value-of select="uriDecoder:decode(TestReportDocument/testbed,'UTF-8')"/>
Parameter file:      <xsl:value-of select="uriDecoder:decode(TestReportDocument/parametersFile,'UTF-8')"/>
Owner:               <xsl:value-of select="TestReportDocument/summary/testCaseOwner"/>
Test Case Id:        <xsl:value-of select="TestReportDocument/summary/testCaseDetails/general/rendering/@testCaseId"/>
Test Case Name:      <xsl:value-of select="TestReportDocument/summary/testCaseDetails/general/rendering/@testCaseName"/>
Test Case Namespace: <xsl:value-of select="TestReportDocument/summary/testCaseDetails/general/rendering/@tclNamespace"/>
Execution started:   <xsl:value-of select="dateFormatter:convertIsoDateToLocalDate(TestReportDocument/startTime)"/>
Execution completed: <xsl:value-of select="dateFormatter:convertIsoDateToLocalDate(TestReportDocument/endTime)"/>
Execution duration:  <xsl:call-template name = "time" >
    <xsl:with-param name = "time" select="TestReportDocument/duration" />
  </xsl:call-template> 
Total report items:  <xsl:value-of select="TestReportDocument/totalReportItemCount"/>
Total issues:        <xsl:value-of select="TestReportDocument/executionIssueCount"/>
 - Pass/OK:		 	 <xsl:value-of select="TestReportDocument/issuesPassed"/>
 - Fail/Error:		 <xsl:value-of select="TestReportDocument/issuesFailed"/>
 - Warning:	 	 	 <xsl:value-of select="TestReportDocument/issuesWarned"/>
 - Information:  	 <xsl:value-of select="TestReportDocument/issuesInfo"/>
Status:              <xsl:value-of select="TestReportDocument/result"/>
Report Id:           <xsl:value-of select="TestReportDocument/reportId"/>
Host:                <xsl:value-of select="TestReportDocument/host"/>
Group:               <xsl:value-of select="TestReportDocument/group"/>
SubGroup:            <xsl:value-of select="TestReportDocument/subGroup"/>

Notes:
<xsl:value-of select="TestReportDocument/description"/>

------------------------------------------------------
-	Parameters
	<xsl:call-template name = "parameters" />
	<xsl:call-template name = "extractedData" />
	
</xsl:template>
</xsl:stylesheet>