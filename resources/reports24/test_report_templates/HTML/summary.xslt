<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dateFormatter="xalan://com.fnfr.foundation.xslt.DateFormatter"
  xmlns:uriDecoder="xalan://java.net.URLDecoder"
  extension-element-prefixes="dateFormatter uriDecoder">

  <xsl:output method="html" omit-xml-declaration="yes"/>
  
  <!-- The images folder URL -->
  <xsl:param name="imagesFolder" select="''"/>
  <xsl:param name="topologyExt" select="'.svg'"/>
	
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
      .header.manual {
      background-color: #B5FDAA; color:#666666;
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
      <xsl:with-param name = "testCase" select="uriDecoder:decode($summaryNode/testcase,'UTF-8')" />
      <xsl:with-param name = "testbed" select="uriDecoder:decode($summaryNode/testbed,'UTF-8')" />
      <xsl:with-param name = "parametersFile" select="uriDecoder:decode($summaryNode/parametersFile,'UTF-8')" />
      <xsl:with-param name = "testCaseOwner" select="$summaryNode/summary/testCaseOwner" />
      <xsl:with-param name = "testCaseId" select="$summaryNode/summary/testCaseDetails/general/rendering/@testCaseId" />
      <xsl:with-param name = "testCaseName" select="$summaryNode/summary/testCaseDetails/general/rendering/@testCaseName" />
      <xsl:with-param name = "testCaseNamespace" select="$summaryNode/summary/testCaseDetails/general/rendering/@tclNamespace" />
        <xsl:with-param name = "executionStarted" select="dateFormatter:convertIsoDateToLocalDate($summaryNode/startTime)"/>
        <xsl:with-param name = "executionCompleted" select="dateFormatter:convertIsoDateToLocalDate($summaryNode/endTime)"/>
      <xsl:with-param name = "executionDuration" select="$summaryNode/duration"/>
      <xsl:with-param name = "reportId" select="$summaryNode/reportId"/>
      <xsl:with-param name = "host" select="$summaryNode/host"/>
      <xsl:with-param name = "group" select="$summaryNode/group"/>
      <xsl:with-param name = "subGroup" select="$summaryNode/subGroup"/>
      <xsl:with-param name = "totalItems" select="$summaryNode/totalReportItemCount"/>
      <xsl:with-param name = "totalIssues" select="$summaryNode/executionIssueCount"/>
      <xsl:with-param name = "issuesPassed" select="$summaryNode/issuesPassed"/>
      <xsl:with-param name = "issuesFailed" select="$summaryNode/issuesFailed"/>
      <xsl:with-param name = "issuesWarned" select="$summaryNode/issuesWarned"/>
      <xsl:with-param name = "issuesInfo" select="$summaryNode/issuesInfo"/>
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
        <td class="heading">Testbed:</td>
        <td><xsl:value-of select="$testbed"/></td>
      </tr>
      <tr>
        <td class="heading">Parameters file:</td>
        <td><xsl:value-of select="$parametersFile"/></td>
      </tr>
      <tr>
        <td width = "150" class="heading">Owner:</td>
            <td width = "450"><xsl:value-of select="$testCaseOwner"/></td>
      </tr>
      <tr>
        <td class="heading">Test case ID:</td>
        <td><xsl:value-of select="$testCaseId"/></td>
      </tr>
      <tr>
        <td class="heading">Test case name:</td>
        <td><xsl:value-of select="$testCaseName"/></td>
      </tr>
      <tr>
        <td class="heading">Test case namespace:</td>
        <td><xsl:value-of select="$testCaseNamespace"/></td>
      </tr>
      <tr>
        <td class="heading">Execution started:</td>
            <td>
          <xsl:value-of select="$executionStarted"/>
            </td>
      </tr>
      <tr>
        <td class="heading">Execution completed:</td>
        <td>
          <xsl:value-of select="$executionCompleted"/>
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
        <td class="heading">Report ID:</td>
        <td><xsl:value-of select="$reportId"/></td>
      </tr>
      <tr>
        <td class="heading">Host:</td>
        <td><xsl:value-of select="$host"/></td>
      </tr>
      <tr>
        <td class="heading">Group:</td>
        <td><xsl:value-of select="$group"/></td>
      </tr>
      <tr>
        <td class="heading">Subgroup:</td>
        <td><xsl:value-of select="$subGroup"/></td>
      </tr>
      <tr>
        <td class="heading">Total report items:</td>
        <td><xsl:value-of select="$totalItems"/></td>
      </tr>
      <tr>
        <td class="heading">Total issues:</td>
        <td><xsl:value-of select="$totalIssues"/></td>
      </tr>
      <tr>
        <td class="heading"><xsl:text>&#xa0;&#xa0;</xsl:text>- Pass/OK:</td>
        <td><xsl:value-of select="$issuesPassed"/></td>
      </tr>
      <tr>
        <td class="heading"><xsl:text>&#xa0;&#xa0;</xsl:text>- Fail/Error:</td>
        <td><xsl:value-of select="$issuesFailed"/></td>
      </tr>
      <tr>
        <td class="heading"><xsl:text>&#xa0;&#xa0;</xsl:text>- Warning:</td>
        <td><xsl:value-of select="$issuesWarned"/></td>
      </tr>
      <tr>
        <td class="heading"><xsl:text>&#xa0;&#xa0;</xsl:text>- Information:</td>
        <td><xsl:value-of select="$issuesInfo"/></td>
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
            <xsl:when test="$status='Cancel'">
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
      
	<!-- The maximum pixel height of the thumbnail images -->
	<xsl:variable name="maxHeight" select="200"/>
	<xsl:if test="$imagesNode/item">
		<br/>
		<b>Topology</b>
		<br/>
		<br/>
		<xsl:text disable-output-escaping="yes">&lt;table width = "750" border = "0" cellspacing = "0" class="border-box"&gt;</xsl:text>
		<tr class="header" style="font-weight: bold">
			<td width="10%" class="border-right">
				<xsl:value-of select="$topologyURI"/>
			</td>
		</tr>
		<tr>
			<td colspan="5" style="color: #666666;" class="border-top">Image:</td>
		</tr>
		<tr>
			<td colspan="5" style="padding: 1;">
				<table>
					<tr align="left" valign="top">
						<xsl:for-each select="$imagesNode/item">
							<xsl:variable name="imageUrl"
								select="concat($imagesFolder, '/topology_image', position(), $topologyExt)"/>
							<td>
								<a href="{$imageUrl}">
									<xsl:choose>
										<xsl:when test="@height > $maxHeight">
											<IMG HEIGHT="{$maxHeight}" src="{$imageUrl}"/>
										</xsl:when>
										<xsl:otherwise>
											<IMG src="{$imageUrl}"/>
										</xsl:otherwise>
									</xsl:choose>
								</a>
							</td>
						</xsl:for-each>
					</tr>
				</table>
			</td>
		</tr>
		<xsl:text disable-output-escaping="yes">&lt;/table&gt;</xsl:text>	 
    	<br/>
	</xsl:if>
    <br/>
  
    <br/>
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
