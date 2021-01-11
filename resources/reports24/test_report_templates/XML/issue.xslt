<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">  
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

  <!-- NOTE: Any changes here must be copied in item.xslt (why doesn't import work?) -->
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
  
</xsl:stylesheet>