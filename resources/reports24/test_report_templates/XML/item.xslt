<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
  
  <!-- The images folder URL -->
  <xsl:param name="imagesFolder" select="''"/>
  
	<!-- The test start timestamp  -->
	<xsl:param name="startTimestamp" select="''"/>

  <xsl:template match="ExecutedStep">
    <xsl:element name="ExecutedStep">
      <xsl:attribute name="emulated">
        <xsl:choose>
          <xsl:when test="emulated = 'true'">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="manual">
        <xsl:choose>
          <xsl:when test="manual = 'true'">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:call-template name="executedStepId"/>
      <xsl:element name="testCaseURL">
        <xsl:value-of select="testCaseURL"/>
      </xsl:element>
      <!-- Step number and procedure name -->
      <xsl:element name="procedure">
        <xsl:attribute name="name">
          <xsl:value-of select="procedureName"/>
        </xsl:attribute>
        <xsl:attribute name="step">
          <xsl:value-of select="executableStepId"/>
        </xsl:attribute>
      </xsl:element>
      <xsl:element name="baseApplication">
        <xsl:value-of select="baseApplication"/>
      </xsl:element>
      <xsl:apply-templates select="executableStep"/>
      <xsl:apply-templates select="result"/>
      <xsl:element name="startOffset">
<!-- Uncomment to print time elapsed since test case execution started ~~~~~~~~~~~~~~-->
        <xsl:value-of select="startOffset"/>
<!-- Uncomment to print system time the individual step began ~~~~~~~~~~~~~~~~~~~~~~~-->
<!-- 		<xsl:call-template name="timestamp">
			<xsl:with-param name="time_ms" select="$startTimestamp"/>
			<xsl:with-param name="delta_ms" select="startOffset*1000"/>
		</xsl:call-template> -->
      </xsl:element>
      <xsl:element name="executionDuration">
        <xsl:value-of select="executionDuration"/>
      </xsl:element>
      <xsl:element name="totalDuration">
        <xsl:value-of select="totalDuration"/>
      </xsl:element>
      <xsl:element name="executionState">
        <xsl:value-of select="executionState"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="executedStepId">
    <xsl:element name="executedStepId">
      <xsl:choose>
        <xsl:when test="id">
          <xsl:value-of select="id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="executableStep">
    <xsl:element name="executableStep">
      <xsl:attribute name="action">
        <xsl:value-of select="@action"/>
      </xsl:attribute>
      <xsl:if test="@session">
        <xsl:attribute name="session">
          <xsl:value-of select="@session"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@context">
        <xsl:attribute name="context">
          <xsl:value-of select="@context"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@target">
        <xsl:attribute name="target">
          <xsl:value-of select="@target"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:element name="rawCommand">
        <xsl:value-of select="command/body"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="result"> 
    <xsl:element name="interpretedCommand">
      <xsl:value-of select="action/command/body"/>
    </xsl:element>
    <xsl:apply-templates select="response"/>
  </xsl:template>
  
  <xsl:template match="response">
    <xsl:element name="response">
      <xsl:element name="body">
        <xsl:copy-of select="body/*[self::issue | text()]"/>
      </xsl:element>
      <xsl:for-each select="issues/item">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:if test="images">
        <xsl:call-template name="responseImages">
          <xsl:with-param name="imagesNode" select="images"/>
          <xsl:with-param name="imageNames" select="imageNames"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <!-- NOTE: Any changes here must be copied in issue.xslt (why doesn't import work?) -->
  <!-- Recreate the items of interest from the execution issue -->
  <xsl:template match="item">
    <xsl:element name="item">
      <xsl:if test="@documentLocation">
        <xsl:attribute name="documentLocation">
          <xsl:value-of select="@documentLocation"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@executableStepId">
        <xsl:attribute name="executableStepId">
          <xsl:value-of select="@executableStepId"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@executedStepId">
        <xsl:attribute name="executedStepId">
          <xsl:value-of select="@executedStepId"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@file">
        <xsl:attribute name="file">
          <xsl:value-of select="@file"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@issueIndex">
        <xsl:attribute name="issueIndex">
          <xsl:value-of select="@issueIndex"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@originator">
        <xsl:attribute name="originator">
          <xsl:value-of select="@originator"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@procedureName">
        <xsl:attribute name="procedureName">
          <xsl:value-of select="@procedureName"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@sessionId">
        <xsl:attribute name="sessionId">
          <xsl:value-of select="@sessionId"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@severity">
        <xsl:attribute name="severity">
          <xsl:value-of select="@severity"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="message"/>
      <xsl:apply-templates select="bodyLocation"/>
    </xsl:element>
  </xsl:template>
  
  
  <xsl:template match="message">
    <xsl:element name="message">
      <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="bodyLocation">
    <xsl:element name="bodyLocation">
      <xsl:if test="@endCol">
        <xsl:attribute name="endCol">
          <xsl:value-of select="@endCol"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@line">
        <xsl:attribute name="line">
          <xsl:value-of select="@line"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@lineCount">
        <xsl:attribute name="lineCount">
          <xsl:value-of select="@lineCount"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@startCol">
        <xsl:attribute name="startCol">
          <xsl:value-of select="@startCol"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="responseImages">
    <!-- Output a reference to the associated image files -->
    <!-- NOTE: The file name must match that used by iTest when saving the image to file -->
    <xsl:param name="imagesNode"/>
    <xsl:param name="imageNames"/>
    <xsl:variable name="stepId" select="$imagesNode/ancestor::*[3]/id"/>
    
    <xsl:element name="images">
      <xsl:for-each select="$imagesNode/item">
		<xsl:variable name="pos"
		  select="position()"/>
	    <xsl:variable name="imageName"
			select="$imageNames/item[$pos]"/>
        <xsl:element name="image">
          <xsl:value-of select="concat($imagesFolder, '/step', $stepId, '_image_', $imageName, '.png')"/>
        </xsl:element>    
      </xsl:for-each>
    </xsl:element>
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
	
</xsl:stylesheet>