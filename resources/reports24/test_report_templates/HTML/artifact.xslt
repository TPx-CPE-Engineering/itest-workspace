<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" omit-xml-declaration="yes"/>
  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Issues ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template name = "artifactItem">
    <xsl:param name = "artifactItemNode" />
    <xsl:param name = "indent">0</xsl:param>

    <xsl:call-template name = "render_artifactItem" >
      <xsl:with-param name = "link" select="$artifactItemNode/link"/>
      <xsl:with-param name = "description" select="$artifactItemNode/@description"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name = "render_artifactItem">
    <xsl:param name = "link"/>
    <xsl:param name = "description"/>
    	<tr>
		    <td>
		      	<a href="{$link}">
		        	<xsl:value-of select="$description"/>
		        	<br/>
		        </a>
		    </td>
		</tr>
  </xsl:template>

  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template match="/">
      <xsl:for-each select="artifactLink">
	      <xsl:call-template name = "artifactItem" >
		      <xsl:with-param name = "artifactItemNode" select="current()" />
	      </xsl:call-template> 	
      </xsl:for-each>
  </xsl:template>	
</xsl:stylesheet>