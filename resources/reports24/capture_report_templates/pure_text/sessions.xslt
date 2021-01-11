<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<xsl:template match="/">

~~ Session ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Session Id: <xsl:value-of select="SessionDescription/sessionId"/>
Session Type: <xsl:value-of select="substring-after(SessionDescription/baseApplication, 'com.fnfr.svt.applications.')"/>
Session Profile: <xsl:value-of select="substring-before(SessionDescription/sessionTemplate, 'about:blank')"/>
Start Time: <xsl:value-of select="substring-before(translate(SessionDescription/timestamp, 'T', ' '), '.')"/>

<xsl:text>


</xsl:text>

</xsl:template>

</xsl:stylesheet>