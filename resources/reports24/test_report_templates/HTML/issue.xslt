<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" omit-xml-declaration="yes"/>
  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Issues ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template name = "issueItem">
    <xsl:param name = "issueItemNode" />
    <xsl:param name = "indent">0</xsl:param>

    <xsl:call-template name = "render_issueItem" >
      <xsl:with-param name = "stepId" select="$issueItemNode/@executedStepId"/>
      <xsl:with-param name = "severity" select="$issueItemNode/@severity"/>
      <xsl:with-param name = "originator" select="$issueItemNode/@originator"/>
      <xsl:with-param name = "message" select="$issueItemNode/message"/>
      <xsl:with-param name = "documentLocation" select="$issueItemNode/@documentLocation"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name = "render_issueItem">
    <xsl:param name = "stepId"/>
    <xsl:param name = "severity"/>
    <xsl:param name = "originator"/>
    <xsl:param name = "message"/>
    <xsl:param name = "documentLocation"/>
		    <tr>
		      <td width="50">
		      	<a href="#{$stepId}">
		        <xsl:value-of select="$stepId"/>
		        <br/>
		        </a>
		      </td>
		      <td width="50">
		        <span>
		          <xsl:choose>
		            <xsl:when test="$severity='0'">
		              <xsl:attribute name="style">color:green;</xsl:attribute>pass
		            </xsl:when>
		            <xsl:when test="$severity='1'">
		              <xsl:attribute name="style">color:blue;</xsl:attribute>info
		            </xsl:when>
		            <xsl:when test="$severity='2'">
		              <xsl:attribute name="style">color:orange;</xsl:attribute>warning
		            </xsl:when>
		            <xsl:when test="$severity='4'">
		              <xsl:attribute name="style">color:red;</xsl:attribute>fail
		            </xsl:when>
		          </xsl:choose>
		        </span>
		      </td>
		      <td width="50">
		        <xsl:value-of select="$originator"/>
		        <br/>
		      </td>
		      <td width="500">
		        <xsl:value-of select="$message"/>
		        <br/>
		      </td>
		      <td width="100">
		        <xsl:value-of select="$documentLocation"/>
		        <br/>
		      </td>
		    </tr>
  </xsl:template>

  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template match="/">
      <xsl:for-each select="item">
	      <xsl:call-template name = "issueItem" >
		      <xsl:with-param name = "issueItemNode" select="current()" />
	      </xsl:call-template> 	
      </xsl:for-each>
  </xsl:template>	
</xsl:stylesheet>