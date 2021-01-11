<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">  
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

  <!-- NOTE: Any changes here must be copied in item.xslt (why doesn't import work?) -->
  <!-- Recreate the items of interest from the execution issue -->
   <xsl:template match="artifactLink"> 
    <xsl:element name="artifactLink">
      <xsl:if test="@description">
    	<xsl:attribute name="description">
          <xsl:value-of select="@description"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="link"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="link">
    <xsl:element name="link">
      <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>