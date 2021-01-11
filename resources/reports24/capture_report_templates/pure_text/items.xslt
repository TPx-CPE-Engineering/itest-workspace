<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ format time ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
<xsl:template name="time">
	<xsl:param name = "time" />
	<xsl:value-of select="substring('00:00:00', 1, 8 - string-length(substring-before($time, '.')))"/>
	<xsl:value-of select="substring-before($time, '.')"/>
	<xsl:text>.</xsl:text>
	<xsl:value-of select="substring(substring-after($time, '.'), 1, 1)"/>
	<xsl:choose>
		<xsl:when test="string-length(substring-after($time, '.'))=0">
			<xsl:text>0</xsl:text>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ format date ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
<xsl:template name="date">
	<xsl:param name = "date" />
	<xsl:value-of select="substring-before(translate($date,'T', ' '), '.')"/>
</xsl:template>

<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ capture item ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
<xsl:template name="captureItem">
	<xsl:param name = "node" />
  <xsl:variable name="description">
    <xsl:choose>
      <xsl:when test="string-length($node/description/action/command/body)=0">
        <xsl:value-of select="$node/description/action/@description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$node/description/action/command/body"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
	<xsl:call-template name = "render_captureItem" >
		<xsl:with-param name = "id" select="$node/@sessionId"/>
		<xsl:with-param name = "index" select="$node/@sessionIndex"/>
		<xsl:with-param name = "actionType" select="$node/description/action/@actionType"/>
    <xsl:with-param name = "description" select="$description"/>
		<xsl:with-param name = "date" select="$node/@start" />
		<xsl:with-param name = "time" select="$node/description/@duration" />
		<xsl:with-param name = "command" select="$node/description/action/command/body"/>
		<xsl:with-param name = "response" select="$node/description/response/body"/>
	</xsl:call-template> 
</xsl:template>

<xsl:template name="render_captureItem">
	<xsl:param name = "id" />
	<xsl:param name = "index" />
	<xsl:param name = "actionType" />
	<xsl:param name = "description" />
	<xsl:param name = "date" />
	<xsl:param name = "time" />
	<xsl:param name = "command" />
	<xsl:param name = "response" />
~~ Capture Item ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Session ID:		<xsl:value-of select="$id"/><xsl:text>.</xsl:text><xsl:value-of select="$index"/>
Action:			<xsl:value-of select="$actionType"/>
Description:	<xsl:value-of select="$description"/>
Start Time:		<xsl:call-template name = "date" >
					<xsl:with-param name = "date" select="$date" />
				</xsl:call-template> 
Duration:		<xsl:call-template name = "time" >
					<xsl:with-param name = "time" select="$time" />
				</xsl:call-template> 
				
Command:		
<xsl:value-of select="$command"/>

Response:
<xsl:value-of select="$response"/>

</xsl:template>

<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->

<xsl:template match = "/">
	<xsl:call-template name = "captureItem" >
		<xsl:with-param name = "node" select="ActionItem"/>
	</xsl:call-template> 
</xsl:template>

</xsl:stylesheet>