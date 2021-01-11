<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<xsl:template match="/">

<xsl:for-each select="item">

Issue Id: 	<xsl:value-of select="@executedStepId"/>
Severity:	<xsl:value-of select="@severity"/>
Originator:	<xsl:value-of select="@originator"/>
Message: 	<xsl:value-of select="message"/>
Location:	<xsl:value-of select="@documentLocation"/>

</xsl:for-each>

</xsl:template>

</xsl:stylesheet>