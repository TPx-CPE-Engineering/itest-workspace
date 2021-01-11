<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" omit-xml-declaration="yes"/>
  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->

	<xsl:template match="/">
		<br/>
		<b>Steps</b>
		<br/>
		<br/>
		<xsl:text disable-output-escaping="yes">&lt;table width = "750" border = "0" cellspacing = "0" class="border-box"&gt;</xsl:text>
		<tr class="header" style="font-weight: bold">
			<td width="10%" class="border-right">
				<b>Index</b>
			</td>
			<td width="25%" class="border-right">
				<b>Action</b>
			</td>
			<td width="25%" class="border-right">
				<b>Session</b>
			</td>
			<td width="20%" class="border-right">
				<b>Start Time</b>
			</td>
			<td width="20%">
				<b>Duration</b>
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>