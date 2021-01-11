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
	  <table border = "0" cellspacing = "0" width = "750" class="border-box">
      <tr class="header" style="font-weight: bold;">
        <td class="border-bottom-right">Id</td>
        <td class="border-bottom-right">Action</td>
        <td class="border-bottom-right">Description</td>
        <td class="border-bottom-right">Start Time</td>
        <td class="border-bottom">Duration</td>
      </tr>
		  <tr>
			  <td width="100" class="border-bottom-right">
				  <xsl:value-of select="$id"/><xsl:text>.</xsl:text><xsl:value-of select="$index"/>
				  <br/>
			  </td>
			  <td width="100" class="border-bottom-right">
				  <xsl:value-of select="$actionType"/>
				  <br/>
			  </td>
			  <td width="250" class="border-bottom-right">
				  <xsl:value-of select="$description"/>
				  <br/>
			  </td>
			  <td width="200" class="border-bottom-right">
				  <xsl:call-template name = "date" >
					  <xsl:with-param name = "date" select="$date" />
				  </xsl:call-template> 
				  <br/>
			  </td>
			  <td width="100" class="border-bottom">
				  <xsl:call-template name = "time" >
					  <xsl:with-param name = "time" select="$time" />
				  </xsl:call-template> 
				  <br/>
			  </td>
		  </tr>
		  <tr>
			  <td colspan = "5" style="padding: 1;">
          <table width = "746" border = "0" cellspacing = "1">
            <tr>
              <td style="color: #666666; padding: 0;">
                Command:
              </td>
            </tr>
            <tr>
              <td class="border-box">
                <pre>
                  <xsl:value-of select="$command"/>
                </pre>
              </td>
            </tr>
            <tr>
              <td>
                Response:
              </td>
            </tr>
            <tr>
              <td class="border-box">
							  <pre>	
								  <xsl:value-of select="$response"/>
							  </pre>
						  </td>
					  </tr>
				  </table>
			  </td>
		  </tr>
	  </table>
  </xsl:template>

  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template match = "/">
    <xsl:call-template name = "CSS"/>
	  <html>
	  <body>
		  <br/>
		  <xsl:call-template name = "captureItem" >
			  <xsl:with-param name = "node" select="ActionItem"/>
		  </xsl:call-template> 
	  </body>
	  </html>
  </xsl:template>

</xsl:stylesheet>