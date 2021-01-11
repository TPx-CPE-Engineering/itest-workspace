<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dateFormatter="xalan://com.fnfr.foundation.xslt.DateFormatter"
  extension-element-prefixes="dateFormatter">

  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CSS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template name="CSS">
    <style type="text/css"> body { font-family: Arial; font-size: 12; } table { font-family: Arial;
      font-size: 12; vertical-align:top; align:left; } td { padding-left: 5; padding-right: 5; }
      .header { background-color: #EEEEEE; color:#666666; } .heading { color: 0066CC; align:right }
      .border-bottom { border-bottom-width:1; border-bottom-style:solid;
      border-bottom-color:#C0C0C0; } .border-left { border-left-width:1; border-left-style:solid;
      border-left-color:#C0C0C0; } .border-right { border-right-width:1; border-right-style:solid;
      border-right-color:#C0C0C0; } .border-box { border-width:1; border-style:solid;
      border-color:#CCCCCC; } .border-left-bottom-right { border-bottom-width:1;
      border-bottom-style:solid; border-bottom-color:#C0C0C0; border-left-width:1;
      border-left-style:solid; border-left-color:#C0C0C0; border-right-width:1;
      border-right-style:solid; border-right-color:#C0C0C0; } .border-bottom-right {
      border-bottom-width:1; border-bottom-style:solid; border-bottom-color:#C0C0C0;
      border-right-width:1; border-right-style:solid; border-right-color:#C0C0C0; } </style>
  </xsl:template>

  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ general section ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template name="general">
    <xsl:param name="generalNode"/>
    <br/>
    <b>Overview:</b>
    <br />
    <table border = "0" cellspacing = "0">
      <tr>
        <td class="heading">Owner:</td>
        <td><xsl:value-of select="$generalNode/owner"/></td>
      </tr>
      <tr>
      	<td class="heading">Headline:</td>
      	<td><xsl:value-of select="$generalNode/documentation"/></td>
      </tr>
      <tr>
      	<td class="heading">Description:</td>
      	<td><xsl:value-of select="$generalNode/notes"/></td>
      </tr>
	  </table>
    <br/>
    <br/>
  </xsl:template>

  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ execution parameters ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template name="parametersSection">
    <xsl:param name="parameterSectionNode"/>
    <br/>
    <br/>
    <b>Parameters:</b>
    <br/>
    <br/>
    <table width="450" border="0" cellspacing="0" class="border-box">
      <tr class="header">
        <td width="200">Name</td>
        <td width="400">Value</td>
      </tr>
      <tr>
        <td>
          <br/>
        </td>
      </tr>
      <xsl:for-each select="$parameterSectionNode/node()">
        <xsl:call-template name="parameter">
          <xsl:with-param name="parameterNode" select="current()"/>
          <xsl:with-param name="indent" select="0"/>
        </xsl:call-template>
      </xsl:for-each>
      <tr>
        <td>
          <br/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="parameter">
    <xsl:param name="parameterNode"/>
    <xsl:param name="indent"/>

    <xsl:call-template name="render_parameter">
      <xsl:with-param name="name" select="name($parameterNode)"/>
      <xsl:with-param name="value" select="$parameterNode"/>
      <xsl:with-param name="indent" select="$indent"/>
    </xsl:call-template>

    <xsl:for-each select="$parameterNode/node()">
      <xsl:if test="not(string-length(name(current()))=0)">
        <xsl:call-template name="parameter">
          <xsl:with-param name="parameterNode" select="current()"/>
          <xsl:with-param name="indent" select="$indent+1"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="render_parameter">
    <xsl:param name="name"/>
    <xsl:param name="value"/>
    <xsl:param name="indent"/>
    <tr>
      <td style="padding-left: {10 + $indent * 20}; padding-right: 5;">
        <xsl:value-of select="$name"/>
      </td>
      <td>
        <xsl:value-of select="$value"/>
      </td>
    </tr>
  </xsl:template>

  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ procedures ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template name="procedures">
    <xsl:param name="proceduresNode"/>
    <br/>
    <br/>
    <b>Procedures:</b>
    <br/>
    <br/>
    <table width="750" border="0" cellspacing="0" class="border-box">
      <tr class="header" style="font-weight:bold;">
        <td width="10%" class="border-bottom-right">Step</td>
        <td width="116" class="border-bottom-right">Action</td>
        <td width="98" class="border-bottom-right">Session</td>
        <td width="536" class="border-bottom">Description</td>
      </tr>
      <xsl:for-each select="$proceduresNode/item">
        <tr>
          <td class="border-bottom-right"><br/></td>
          <td class="border-bottom-right">Procedure</td>
          <td class="border-bottom-right">
            <br/>
          </td>
          <td class="border-bottom">
            <xsl:value-of select="@name"/>
          </td>
        </tr>
        <tr>
          <td/>
        </tr>
        <xsl:for-each select="steps/item">
          <xsl:call-template name="procedureItem">
            <xsl:with-param name="itemNode" select="current()"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ procedure item ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template name="procedureItem">
    <xsl:param name="itemNode"/>
    <xsl:variable name="step">
      <xsl:for-each select="$itemNode/ancestor-or-self::*">
        <xsl:if
          test="name(.) = 'item' and (name(parent::*) = 'steps' or name(parent::*) = 'nestedSteps')">
          <xsl:if test="not(name(parent::*) = 'steps')">
            <xsl:text>.</xsl:text>
          </xsl:if>
          <xsl:value-of select="count(preceding-sibling::item)+1"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:call-template name="render_procedureItem">
      <xsl:with-param name="step" select="$step"/>
      <xsl:with-param name="action" select="$itemNode/@action"/>
      <xsl:with-param name="session" select="$itemNode/@session"/>
      <xsl:with-param name="description" select="$itemNode/@target | $itemNode/command/body"/>
      <xsl:with-param name="skip" select="$itemNode/@skip"/>
    </xsl:call-template>

    <!-- Print any nested steps -->
    <xsl:for-each select="$itemNode/nestedSteps/item">
      <xsl:call-template name="procedureItem">
        <xsl:with-param name="itemNode" select="current()"/>
      </xsl:call-template>      
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="render_procedureItem">
    <xsl:param name="step"/>
    <xsl:param name="action"/>
    <xsl:param name="session"/>
    <xsl:param name="description"/>
    <xsl:param name="skip"/>
    
    <tr>
      <xsl:if test="$skip = 'true'">
        <xsl:attribute name="style">background-color: #EEEEEE; color: #666666;</xsl:attribute>
      </xsl:if>
      <td class="border-bottom-right">
        <xsl:value-of select="$step"/>
        <br/>
      </td>
      <td class="border-bottom-right" style="padding-left: 25;">
        <xsl:value-of select="$action"/>
        <br/>
      </td>
      <td class="border-bottom-right">
        <xsl:value-of select="$session"/>
        <br/>
      </td>
      <td class="border-bottom">
        <xsl:value-of select="$description"/>
        <br/>
      </td>
    </tr>

  </xsl:template>

  <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
  <xsl:template match="/">
    <xsl:call-template name="CSS"/>
    <html>
      <body>
        <table width="600" border="0" cellspacing="0">
          <tr>
            <td align="center">
              <h3>Test Case</h3>
            </td>
          </tr>
          <tr>
            <td>
              <h5>File generated at: <xsl:value-of select="dateFormatter:getLocalDateTime()"/></h5>              
            </td>
          </tr>
        </table>
        <xsl:call-template name="general">
          <xsl:with-param name="generalNode" select="testCase/general"/>
        </xsl:call-template>

        <xsl:call-template name="parametersSection">
          <xsl:with-param name="parameterSectionNode"
            select="testCase/execution/parameters/parameters"/>
        </xsl:call-template>

        <xsl:call-template name="procedures">
          <xsl:with-param name="proceduresNode" select="testCase/procedures"/>
        </xsl:call-template>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
