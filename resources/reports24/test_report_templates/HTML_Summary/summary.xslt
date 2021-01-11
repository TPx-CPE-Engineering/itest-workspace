<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dateFormatter="xalan://com.fnfr.foundation.xslt.DateFormatter"
  extension-element-prefixes="dateFormatter">  
  <xsl:output method="html" omit-xml-declaration="yes"/>
  
  <!-- The images folder URL -->
  <xsl:param name="imagesFolder" select="''"/>
	
  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CSS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template name="CSS" >
    <style type="text/css">
      body {
      font-family: Arial; font-size: 12;
      }
      table {
      font-family: Arial; font-size: 12;
      vertical-align:top; align:left;
      }
      td {
      padding-left: 5; padding-right: 5;
      }
      .header {
      background-color: #EEEEEE; color:#666666;
      }
      .heading {
      color: 0066CC; align:right
      }
      .border-bottom {
      border-bottom-width:1; border-bottom-style:solid; border-bottom-color:#C0C0C0;
      }
      .border-left {
      border-left-width:1; border-left-style:solid; border-left-color:#C0C0C0;
      }
      .border-right {
      border-right-width:1; border-right-style:solid; border-right-color:#C0C0C0;
      }
      .border-box {
      border-width:1; border-style:solid; border-color:#CCCCCC;
      }
      .border-top {
      border-top-width:1; border-top-style:solid; border-top-color:#C0C0C0; 
      }
      .border-top-right { 
      border-top-width:1; border-top-style:solid;	border-top-color:#C0C0C0; border-right-width:1; border-right-style:solid; border-right-color:#C0C0C0; 
      } 
    </style>
  </xsl:template>
  
  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Summary ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template name = "summary">
    <xsl:param name = "summaryNode" />
    <xsl:call-template name = "render_summary" >
      <xsl:with-param name = "testCase" select="$summaryNode/testcase" />
        <xsl:with-param name = "executionStarted" select="dateFormatter:convertIsoDateToLocalDate($summaryNode/startTime)"/>
        <xsl:with-param name = "executionCompleted" select="dateFormatter:convertIsoDateToLocalDate($summaryNode/endTime)"/>
      <xsl:with-param name = "executionDuration" select="$summaryNode/duration"/>
      <xsl:with-param name = "testbed" select="$summaryNode/testbed" />
      <xsl:with-param name = "parametersFile" select="$summaryNode/parametersFile" />
      <xsl:with-param name = "status" select="$summaryNode/result"/>
      <xsl:with-param name = "emulation" select="$summaryNode/emulation"/>
	  <xsl:with-param name = "imagesNode" select="$summaryNode/summary/topologyImages"/>
	  <xsl:with-param name = "topologyURI" select="$summaryNode/summary/topologyURI"/>
    </xsl:call-template> 
  </xsl:template>

  <xsl:template name = "render_parameter">
    <xsl:param name = "session"/>
    <xsl:param name = "name"/>
    <xsl:param name = "description"/>
    <xsl:param name = "value"/>
    <xsl:param name = "source"/>
    <tr valign="top">
      <td>
        <xsl:value-of select="$session"/>
        <br/>
      </td>
      <td>
        <xsl:value-of select="$name"/>
        <br/>
      </td>
      <td>
        <xsl:value-of select="$description"/>
        <br/>
      </td>
      <td>
        <xsl:value-of select="$value"/>
        <br/>
      </td>
      <td>
        <xsl:value-of select="$source"/>
        <br/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name = "render_summary" xmlns:pt="http://www.fnfr.com/schemas/parameterTree">
    <xsl:param name = "testCase" />
    <xsl:param name = "testbed" />
    <xsl:param name = "parametersFile" />
    <xsl:param name = "testCaseOwner" />
    <xsl:param name = "testCaseId" />
    <xsl:param name = "testCaseName" />
    <xsl:param name = "testCaseNamespace" />
    <xsl:param name = "executionStarted" />
    <xsl:param name = "executionCompleted" />
    <xsl:param name = "executionDuration" />
    <xsl:param name = "reportId" />
    <xsl:param name = "host" />
    <xsl:param name = "group" />
    <xsl:param name = "subGroup" />
    <xsl:param name = "totalItems" />
    <xsl:param name = "totalIssues" />
    <xsl:param name = "issuesPassed" />
    <xsl:param name = "issuesFailed" />
    <xsl:param name = "issuesWarned" />
    <xsl:param name = "issuesInfo" />
    <xsl:param name = "status" />
    <xsl:param name = "emulation" />
	<xsl:param name = "imagesNode"/>
	<xsl:param name = "topologyURI"/>

    <xsl:variable name="emulate">		
      <xsl:if test="$emulation = 'true'">(Emulated)</xsl:if>
    </xsl:variable>
    
    <table width = "600" border = "0" cellspacing = "0">
      <tr>
        <td align="center">
          <h3>Test Report <xsl:value-of select="$emulate"/></h3>              
        </td>
      </tr>
      <tr>
        <td>
          <h5>File generated at: <xsl:value-of select="dateFormatter:getLocalDateTime()"/></h5>              
        </td>
      </tr>
    </table>
    <table border="0" cellspacing="0" width = "600">
      <tr>
        <td width = "150" class="heading">Test case:</td>
        <td width = "450"><xsl:value-of select="$testCase"/></td>
      </tr>
      <tr>
        <td class="heading">Execution started:</td>
            <td>
          <xsl:value-of select="$executionStarted"/>
            </td>
      </tr>
      <tr>
        <td class="heading">Execution duration:</td>
        <td>
          <xsl:call-template name = "time" >
            <xsl:with-param name = "time" select="$executionDuration" />
          </xsl:call-template> 
        </td>
      </tr>
      <tr>
        <td class="heading">Testbed:</td>
        <td><xsl:value-of select="$testbed"/></td>
      </tr>
      <tr>
        <td class="heading">Parameters file:</td>
        <td><xsl:value-of select="$parametersFile"/></td>
      </tr>
      <tr>
        <td class="heading">Result:</td>
        <td>
          <span>
          <xsl:choose>
            <xsl:when test="$status='Pass'">
              <xsl:attribute name="style">color:green;</xsl:attribute>
            </xsl:when>
            <xsl:when test="$status='Fail'">
              <xsl:attribute name="style">color:red;</xsl:attribute>
            </xsl:when>
            <xsl:when test="$status='Abort'">
              <xsl:attribute name="style">color:red;</xsl:attribute>
            </xsl:when>
            <xsl:when test="$status='Indeterminate'">
              <xsl:attribute name="style">color:orange;</xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <b>            
          <xsl:value-of select="$status"/>
          </b>
          </span>
        </td>
      </tr>
    </table>
  
    <br/>
<!--
    <b>Parameters</b>
    <br/>
    <br/>
    <table cellspacing="0" class="border-box" width = "750">
      <tr class="header">
        <td><b>Session</b></td>
        <td><b>Parameter Name</b></td>
        <td><b>Description</b></td>
        <td><b>Value</b></td>
        <td><b>Source</b></td>
      </tr>
      <xsl:for-each select="//finalParameters/parameters//*[@pt:source and count(child::*)=0 and count(ancestor::*[name()='profile']) = 0 and count(ancestor::*[name()='testbed']) = 0]">
        <xsl:variable name="name">
          <xsl:for-each select="ancestor::*">
            <xsl:if test="./ancestor::*[name()='parameters'] and ./ancestor::*[name()='finalParameters']">              
              <xsl:value-of select="concat(name(.), '/')"/>
            </xsl:if>
          </xsl:for-each>
          <xsl:value-of select="name(current())"/>
        </xsl:variable>
        <xsl:call-template name = "render_parameter" >
        <xsl:with-param name = "session" select="ancestor::*[name()='profile']/@id" />
          <xsl:with-param name = "name" select="$name" />
        <xsl:with-param name = "description" select="@pt:description" />
        <xsl:with-param name = "value" select="current()" />
        <xsl:with-param name = "source" select="@pt:source" />
      </xsl:call-template>       
    </xsl:for-each>
      <xsl:for-each select="//finalParameters/parameters//*[@pt:source and count(child::*)=0 and count(ancestor::*[name()='profile']) > 0 and count(ancestor::*[name()='document']) = 0]">
        <xsl:variable name="name">
          <xsl:for-each select="ancestor::*">
            <xsl:if test="./ancestor::*[name()='profile'] and ./ancestor::*[name()='profiles']">              
              <xsl:value-of select="concat(name(.), '/')"/>
            </xsl:if>
          </xsl:for-each>
          <xsl:value-of select="name(current())"/>
        </xsl:variable>
        <xsl:call-template name = "render_parameter" >
        <xsl:with-param name = "session" select="ancestor::*[name()='profile']/@id" />
        <xsl:with-param name = "name" select="$name" />
        <xsl:with-param name = "description" select="@pt:description" />
        <xsl:with-param name = "value" select="current()" />
        <xsl:with-param name = "source" select="@pt:source" />
      </xsl:call-template>       
    </xsl:for-each>
    </table>
    <br/>
    -->
    <xsl:if test="count(//extractedData/item)>0">
      <br/>
      <br/>
      <b>Extracted Data</b>
      <br/>
      <br/>
      <table cellspacing="0" class="border-box" width = "750">
        <tr class="header">
          <td><b>Time</b></td>
          <td><b>Test Case</b></td>
          <td><b>Procedure</b></td>
          <td><b>Step</b></td>
          <td><b>ID</b></td>
          <td><b>Extracted Data Tag</b></td>
          <td><b>Value(s)</b></td>
        </tr>
        <xsl:for-each select="//extractedData/item">
          <tr valign="top">
            <td><xsl:value-of select="time"/><br/></td>
            <td><xsl:value-of select="testCase"/><br/></td>
            <td><xsl:value-of select="procedure"/><br/></td>
            <td><xsl:value-of select="executedStep"/><br/></td>
            <td><xsl:value-of select="executableStep"/><br/></td>
            <td><xsl:value-of select="tag"/><br/></td>
            <td>
              <xsl:for-each select="data/item">
                <xsl:value-of select="."/><br/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:for-each>
      </table>
      <br/>
      <br/><br/>
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
  
  
  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template match="/">
  <xsl:text disable-output-escaping="yes">
&lt;html&gt;
  &lt;head&gt;
  </xsl:text>
    <xsl:call-template name = "CSS"/>
  <xsl:text disable-output-escaping="yes">
  &lt;/head&gt;
  &lt;body&gt;
  </xsl:text>
        <xsl:call-template name = "summary" >
          <xsl:with-param name = "summaryNode" select="TestReportDocument" />
        </xsl:call-template> 
  </xsl:template>
</xsl:stylesheet>