<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<xsl:template match="/">
Capture Report

Overview

Capture started: <xsl:value-of select="substring-before(translate(CaptureReportSummary/startTime, 'T', ' '), '.')"/>
Capture ended: <xsl:value-of select="substring-before(translate(CaptureReportSummary/endTime, 'T', ' '), '.')"/>
Total actions: <xsl:value-of select="CaptureReportSummary/totalActions"/>
<xsl:text>

</xsl:text>

</xsl:template>
</xsl:stylesheet>