<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dateFormatter="xalan://com.fnfr.foundation.xslt.DateFormatter"
  extension-element-prefixes="dateFormatter">

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
      .border-left-bottom-right {
      border-bottom-width:1; border-bottom-style:solid; border-bottom-color:#C0C0C0;
      border-left-width:1; border-left-style:solid; border-left-color:#C0C0C0;
      border-right-width:1; border-right-style:solid; border-right-color:#C0C0C0;
      }
      .border-bottom-right {
      border-bottom-width:1; border-bottom-style:solid; border-bottom-color:#C0C0C0;
      border-right-width:1; border-right-style:solid; border-right-color:#C0C0C0;
      }
    </style>
  </xsl:template>


<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ summary ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
<xsl:template name = "summary">
	<xsl:call-template name = "render_summary" >
		<xsl:with-param name = "startTime" 	select="substring-before(translate(CaptureReportSummary/startTime, 'T', ' '), '.')"/>
		<xsl:with-param name = "endTime" 	select="substring-before(translate(CaptureReportSummary/endTime, 'T', ' '), '.')"/>
		<xsl:with-param name = "totalActions" select="CaptureReportSummary/totalActions"/>
	</xsl:call-template> 
</xsl:template>

<xsl:template name = "render_summary">
	<xsl:param name = "startTime"/>
	<xsl:param name = "endTime"/>
	<xsl:param name = "totalActions"/>
	<table border="0" cellspacing="0" width = "500">
		<tr>
			<td width = "120" class="heading">
				Capture started:
			</td>
			<td width = "380">
				<xsl:value-of select="$startTime"/>
			</td>
		</tr>
		<tr>
			<td class="heading">
        Capture ended:
      </td>
			<td>
				<xsl:value-of select="$endTime"/>
			</td>
		</tr>
		<tr>
			<td class="heading">
        Total actions:
      </td>
			<td>
				<xsl:value-of select="$totalActions"/>
			</td>
		</tr>
	</table>
</xsl:template>


<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
<xsl:template match="/">
  <xsl:call-template name = "CSS"/>
	<html>
	<body>
    <table width = "600" border = "0" cellspacing = "0">
      <tr>
        <td align="center">
          <h3>Capture Report</h3>
        </td>
      </tr>
      <tr>
        <td>
          <h5>File generated at: <xsl:value-of select="dateFormatter:getLocalDateTime()"/></h5>              
        </td>
      </tr>
    </table>
    <br/>
		<b>Overview</b>
    <br/><br/>
		<xsl:call-template name = "summary" />
		<br/>
		
		<br/>
		<b>Sessions</b>
    	<br/><br/>
		<table border = "0" cellspacing = "0" width = "750" class="border-box">
			<tr class="header">
				<td width = "100" class="border-right">
					<b>Session Id</b>
					<br/>
				</td>
				<td width = "150" class="border-right">
					<b>Session Type</b>
					<br/>
				</td>
				<td width = "200" class="border-right">
					<b>Session Profile</b>
					<br/>
				</td>
				<td width = "300">
					<b>Session Start Time</b>
					<br/>
				</td>
			</tr>
		</table>
		
	</body>
	</html>
</xsl:template>
</xsl:stylesheet>