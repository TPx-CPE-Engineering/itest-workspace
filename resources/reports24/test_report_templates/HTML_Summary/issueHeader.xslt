<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" omit-xml-declaration="yes"/>
  <xsl:template match = "/">
	  <br/>
	  <b>Execution Issues</b>
	  <br/><br/>
	<xsl:text disable-output-escaping="yes">
	  &lt;table width = "750" border = "0" cellspacing = "0" class="border-box"&gt;
	</xsl:text>	 
		  <tr class="header">
			  <td width = "50"><b>Index</b></td>
			  <td width = "50"><b>Severity</b></td>
			  <td width = "50"><b>Originator</b></td>
			  <td width = "500"><b>Message</b></td>
			  <td width = "100"><b>Location</b></td>
		  </tr>
  </xsl:template>
</xsl:stylesheet>