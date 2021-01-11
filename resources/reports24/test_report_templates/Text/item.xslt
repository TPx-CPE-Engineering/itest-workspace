<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

	<!-- The test start timestamp  -->
	<xsl:param name="startTimestamp" select="''"/>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ format time ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="time">
		<xsl:param name="time"/>
		<xsl:variable name="seconds" select="$time mod 60"/>
		<xsl:variable name="minutes" select="(floor($time div 60)) mod 60"/>
		<xsl:variable name="hours" select="floor($time div 3600)"/>
		<xsl:value-of select="concat(format-number($hours,'#00'),':', format-number($minutes,'00'),':', format-number($seconds,'00.#'))"/>
	</xsl:template>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ format timestamp ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="timestamp"
				  xmlns:xs="http://www.w3.org/2001/XMLSchema"
				  xmlns:format="xalan://java.text.SimpleDateFormat"
				  xmlns:date="xalan://java.util.Date">
		<xsl:param name="time_ms"/>
		<xsl:param name="delta_ms"/>
		<xsl:variable name="format" select="'yyyy-MM-dd HH:mm:ss.SSS'" />
		<xsl:value-of select="format:format(format:new($format), date:new(xs:integer($time_ms + $delta_ms)))"/>
	</xsl:template>
		

	<xsl:template match = "ExecutedStep">
------------------------------------------------------
ID: <xsl:value-of select="executableStep/@session"/><xsl:text>.</xsl:text><xsl:value-of select="id"/>
Action: <xsl:value-of select="executableStep/@action"/>
Start Time: <!-- 
~~~~~~~~~~~ Uncomment to print time elapsed since test case execution started ~~~~~~~~~~~  
--><xsl:call-template name = "time" >
				<xsl:with-param name = "time" select="startOffset" />
			</xsl:call-template><!-- 
~~~~~~~~~~~ Uncomment to print system time the individual step began ~~~~~~~~~~~  
--><!-- <xsl:call-template name="timestamp">
				<xsl:with-param name="time_ms" select="$startTimestamp"/>
				<xsl:with-param name="delta_ms" select="startOffset*1000"/>
			</xsl:call-template> --> 
Duration: 	<xsl:call-template name = "time" >
				<xsl:with-param name = "time" select="executionDuration" />
			</xsl:call-template> 
Command: <xsl:choose>
			<xsl:when test="string-length(executableStep/command/body)=0">
				<xsl:value-of select="executableStep/@target"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="executableStep/command/body"/>
			</xsl:otherwise>
		</xsl:choose>
Manual: <xsl:value-of select="manual"/>
Issues: <xsl:for-each select="result/response/issues/item">
	
	Severity:	<xsl:value-of select="@severity"/>
	Originator:	<xsl:value-of select="@originator"/>
	Message: 	<xsl:value-of select="message"/>
	Location:	<xsl:value-of select="@documentLocation"/>

	</xsl:for-each>
	
	<xsl:variable name="emulation">		
		<xsl:if test="emulated = 'true'">(emulated)</xsl:if>
	</xsl:variable>
	
	Response: <xsl:value-of select="$emulation"/>
<xsl:value-of select="result/response/body"/>

</xsl:template>

</xsl:stylesheet>