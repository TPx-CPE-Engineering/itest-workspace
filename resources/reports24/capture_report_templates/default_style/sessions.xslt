<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CSS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template name="CSS" >
    <style type="text/css">
      body {
      font-family: Arial; font-size: 12;
      }
      table {
      font-family: Arial; font-size: 12;
      vertical-align:top; align:left;
      }
      td {
      padding-left: 5; padding-right: 5;
      }
      .header {
      background-color: #EEEEEE; color:#666666;
      }
      .heading {
      color: 0066CC; align:right
      }
      .border-bottom {
      border-bottom-width:1; border-bottom-style:solid; border-bottom-color:#C0C0C0;
      }
      .border-left {
      border-left-width:1; border-left-style:solid; border-left-color:#C0C0C0;
      }
      .border-right {
      border-right-width:1; border-right-style:solid; border-right-color:#C0C0C0;
      }
      .border-box {
      border-width:1; border-style:solid; border-color:#CCCCCC;
      }
      .border-left-bottom-right {
      border-bottom-width:1; border-bottom-style:solid; border-bottom-color:#C0C0C0;
      border-left-width:1; border-left-style:solid; border-left-color:#C0C0C0;
      border-right-width:1; border-right-style:solid; border-right-color:#C0C0C0;
      }
      .border-bottom-right {
      border-bottom-width:1; border-bottom-style:solid; border-bottom-color:#C0C0C0;
      border-right-width:1; border-right-style:solid; border-right-color:#C0C0C0;
      }
    </style>
  </xsl:template>

  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template match="/">
    <xsl:call-template name = "CSS"/>
	  <html>
	  <body>
		  <table border = "0" cellspacing = "0" width = "750" class="border-left-bottom-right">
			  <tr align="left" valign="top">
				  <td width = "100" class="border-right">
					  <xsl:value-of select="SessionDescription/sessionId"/>
					  <br/>
				  </td>
				  <td width = "150" class="border-right">
					  <xsl:value-of select="substring-after(SessionDescription/baseApplication, 'com.fnfr.svt.applications.')"/>
					  <br/>
				  </td>
				  <td width = "200" class="border-right">
					  <xsl:value-of select="substring-before(SessionDescription/sessionTemplate, 'about:blank')"/>
					  <br/>
				  </td>
				  <td width = "300">
					  <xsl:value-of select="substring-before(translate(SessionDescription/timestamp, 'T', ' '), '.')"/>
					  <br/>
				  </td>
			  </tr>
		  </table>
	  </body>
	  </html>
  </xsl:template>
</xsl:stylesheet>