<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dateFormatter="xalan://com.fnfr.foundation.xslt.DateFormatter"
    extension-element-prefixes="dateFormatter">

    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CSS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <xsl:template name="CSS">
        <style type="text/css"> body { font-family: Arial; font-size: 12; } table { font-family:
            Arial; font-size: 12; vertical-align:top; align:left; } td { padding-left: 5;
            padding-right: 5; } .header { background-color: #EEEEEE; color:#666666; } .heading {
            color: 0066CC; align:right } .border-bottom { border-bottom-width:1;
            border-bottom-style:solid; border-bottom-color:#C0C0C0; } .border-left {
            border-left-width:1; border-left-style:solid; border-left-color:#C0C0C0; } .border-right
            { border-right-width:1; border-right-style:solid; border-right-color:#C0C0C0; }
            .border-box { border-width:1; border-style:solid; border-color:#CCCCCC; }
            .border-left-bottom-right { border-bottom-width:1; border-bottom-style:solid;
            border-bottom-color:#C0C0C0; border-left-width:1; border-left-style:solid;
            border-left-color:#C0C0C0; border-right-width:1; border-right-style:solid;
            border-right-color:#C0C0C0; } .border-bottom-right { border-bottom-width:1;
            border-bottom-style:solid; border-bottom-color:#C0C0C0; border-right-width:1;
            border-right-style:solid; border-right-color:#C0C0C0; } </style>
    </xsl:template>

    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ general section ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <xsl:template name="general">
        <xsl:param name="generalNode"/>
        <br/>
        <b>Overview:</b>
        <br/>
        <table border="0" cellspacing="0">
            <tr>
                <td class="heading">Owner:</td>
                <td>
                    <xsl:value-of select="$generalNode/owner"/>
                </td>
            </tr>
            <tr>
                <td class="heading">Headline:</td>
                <td>
                    <xsl:value-of select="$generalNode/documentation"/>
                </td>
            </tr>
            <tr>
                <td class="heading">Description:</td>
                <td>
                    <xsl:value-of select="$generalNode/notes"/>
                </td>
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
        <xsl:for-each select="$proceduresNode/item">
            <br/>
            <br/>
            <b>
                <xsl:value-of select="@name"/>
            </b>
            <table width="750" border="0" cellspacing="0" class="border-box">
                <tr class="header" style="font-weight:bold;">
                    <td width="56" class="border-bottom-right">Step</td>
                    <td width="116" class="border-bottom-right">Action</td>
                    <td width="98" class="border-bottom-right">Session</td>
                    <td width="480" class="border-bottom">Description</td>
                </tr>
                <xsl:for-each select="steps/item">
                    <xsl:call-template name="procedureItem">
                        <xsl:with-param name="itemNode" select="current()"/>
                    </xsl:call-template>
                </xsl:for-each>
            </table>
        </xsl:for-each>
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

        <!-- if there are analysis rules attached with this step, then print it-->
        <xsl:if test="count($itemNode/postProcessing/analysisRules/item) &gt; 0">
            <xsl:call-template name="analysisRule">
                <xsl:with-param name="analysisRuleNode"
                    select="$itemNode/postProcessing/analysisRules"/>
            	<xsl:with-param name="skip" select="$itemNode/@skip"/>
            </xsl:call-template>
        </xsl:if>
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
            <td width="40" class="border-bottom-right">
                <xsl:value-of select="$step"/>
                <br/>
            </td>
            <td width="117" class="border-bottom-right">
                <xsl:value-of select="$action"/>
                <br/>
            </td>
            <td width="102" class="border-bottom-right">
                <xsl:value-of select="$session"/>
                <br/>
            </td>
            <td width="469" class="border-bottom">
                <xsl:value-of select="$description"/>
                <br/>
            </td>
        </tr>
    </xsl:template>

    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ analysis rule shading ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->

        <xsl:template name="analysis_header_sytle">
        <xsl:param name="skip"/>
        <xsl:choose>
            <xsl:when test="$skip = 'true'">
                <xsl:attribute name="style">background-color: #EEEEEE; color: #666666;</xsl:attribute>                    
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="style">background-color: #FFE7BD; color: #000000;</xsl:attribute>   
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="analysis_sytle">
        <xsl:param name="skip"/>
        <xsl:choose>
            <xsl:when test="$skip = 'true'">
                <xsl:attribute name="style">background-color: #EEEEEE; color: #666666;</xsl:attribute>                    
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="style">background-color: #FFEFD6; color: #000000;</xsl:attribute>   
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ analysis rule ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <xsl:template name="analysisRule">
        <xsl:param name="analysisRuleNode"/>
        <xsl:param name="skip"/>
        
        <xsl:for-each select="$analysisRuleNode/item">
            <tr class="header">
                <td colspan="4" class="border-bottom">
                    <xsl:call-template name="analysis_header_sytle">
                        <xsl:with-param name="skip" select="$skip"/>
                    </xsl:call-template>
                    analyze</td>
            </tr>
            <xsl:call-template name="analysisRuleItem">
                <xsl:with-param name="analysisRuleItemNode" select="current()"/>
                <xsl:with-param name="skip" select="$skip"/>
            </xsl:call-template>

        </xsl:for-each>
    </xsl:template>

    <xsl:template name="analysisRuleItem">
        <xsl:param name="analysisRuleItemNode"/>
        <xsl:param name="skip"/>
        <xsl:call-template name="extractorItem">
            <xsl:with-param name="extractorInfoNode" select="$analysisRuleItemNode/extractorInfo"/>
            <xsl:with-param name="skip" select="$skip"/>
        </xsl:call-template>
        <xsl:call-template name="processorItem">
            <xsl:with-param name="processorInfoNode" select="$analysisRuleItemNode/processorInfo"/>
            <xsl:with-param name="skip" select="$skip"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="extractorItem">
        <xsl:param name="extractorInfoNode"/>
        <xsl:param name="skip"/>
        <xsl:variable name="extractor" select="$extractorInfoNode/@extractorType"/>
        <xsl:variable name="properties" select="$extractorInfoNode/extractorProperties"/>
        <xsl:choose>
            <xsl:when test="$extractor = 'contains'">
                <xsl:call-template name="render_extractorItem">
                    <xsl:with-param name="extract_using" select="$extractor"/>
                    <xsl:with-param name="what_to_extract" select="$properties/searchString"/>
                    <xsl:with-param name="skip" select="$skip"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$extractor = 'regex'">
                <xsl:call-template name="render_extractorItem">
                    <xsl:with-param name="extract_using" select="$extractor"/>
                    <xsl:with-param name="what_to_extract" select="$properties/regex"/>
                    <xsl:with-param name="skip" select="$skip"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$extractor = 'query'">
                <xsl:call-template name="render_extractorItem">
                    <xsl:with-param name="extract_using" select="$extractor"/>
                    <xsl:with-param name="what_to_extract" select="$properties/query"/>
                    <xsl:with-param name="skip" select="$skip"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($extractor, 'chart')">
                <xsl:call-template name="render_extractorItem">
                    <xsl:with-param name="extract_using" select="$extractor"/>
                    <xsl:with-param name="what_to_extract" select="$properties/expression"/>
                    <xsl:with-param name="skip" select="$skip"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="render_extractorItem">
                    <xsl:with-param name="extract_using" select="$extractor"/>
                    <xsl:with-param name="what_to_extract" select="''"/>
                    <xsl:with-param name="skip" select="$skip"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="processorItem">
        <xsl:param name="processorInfoNode"/>
        <xsl:param name="skip"/>
        <xsl:variable name="ruleType" select="$processorInfoNode/@ruleType"/>
        <xsl:choose>
            <xsl:when test="$ruleType = 'message'">
                <xsl:call-template name="render_processorItem">
                    <xsl:with-param name="perform" select="$ruleType"/>
                    <xsl:with-param name="details"
                        select="$processorInfoNode/ruleProperties/message"/>
                    <xsl:with-param name="skip" select="$skip"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$ruleType = 'store'">
                <xsl:call-template name="render_processorItem">
                    <xsl:with-param name="perform" select="$ruleType"/>
                    <xsl:with-param name="details"
                        select="$processorInfoNode/ruleProperties/storageLocation"/>
                    <xsl:with-param name="skip" select="$skip"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$ruleType = 'writeFile'">
                <xsl:call-template name="render_processorItem">
                    <xsl:with-param name="perform" select="$ruleType"/>
                    <xsl:with-param name="details"
                        select="$processorInfoNode/ruleProperties/fileLocation"/>
                    <xsl:with-param name="skip" select="$skip"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="render_processorItem">
                    <xsl:with-param name="perform" select="$ruleType"/>
                    <xsl:with-param name="details"
                        select="$processorInfoNode/ruleProperties/expression"/>
                    <xsl:with-param name="skip" select="$skip"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="render_extractorItem">
        <xsl:param name="extract_using"/>
        <xsl:param name="what_to_extract"/>
        <xsl:param name="skip"/>
        <tr>
            <xsl:call-template name="analysis_sytle">
                <xsl:with-param name="skip" select="$skip"/>
            </xsl:call-template>
            <td colspan="2" class="border-bottom-right" style="padding-left: 20;">
                <xsl:value-of select="$extract_using"/>
            </td>
            <td colspan="2" class="border-bottom">
                <xsl:value-of select="$what_to_extract"/>
                <br/>                
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="render_processorItem">
        <xsl:param name="perform"/>
        <xsl:param name="details"/>
        <xsl:param name="skip"/>
        <tr>
            <xsl:call-template name="analysis_sytle">
                <xsl:with-param name="skip" select="$skip"/>
            </xsl:call-template>
            <td colspan="2" class="border-bottom-right" style="padding-left: 20;">
                <xsl:value-of select="$perform"/>
            </td>
            <td colspan="2" class="border-bottom">
                <xsl:value-of select="$details"/>
                <br/>                
            </td>
            <xsl:if test="$perform = 'assert'">
                <xsl:call-template name="render_assertActions">
                    <xsl:with-param name="assertProcessorNode" select="current()/processorInfo"/>
                    <xsl:with-param name="skip" select="$skip"/>
                </xsl:call-template>
            </xsl:if>
        </tr>
    </xsl:template>

    <xsl:template name="render_assertActions">
        <xsl:param name="assertProcessorNode"/>
        <xsl:param name="skip"/>
        <tr class="header">
            <xsl:call-template name="analysis_header_sytle">
                <xsl:with-param name="skip" select="$skip"/>
            </xsl:call-template>
            <td colspan="2" class="border-bottom-right" style="padding-left: 30;">When True</td>
            <td colspan="2" class="border-bottom">Details</td>
        </tr>
        <xsl:for-each select="$assertProcessorNode/ruleProperties/actionsWhenTrue/item">
            <xsl:call-template name="analysisRuleAction">
                <xsl:with-param name="analysisRuleActionNode" select="current()"/>
                <xsl:with-param name="skip" select="$skip"/>
            </xsl:call-template>
        </xsl:for-each>
        <tr class="header">
            <xsl:call-template name="analysis_header_sytle">
                <xsl:with-param name="skip" select="$skip"/>
            </xsl:call-template>
            <td colspan="2" class="border-bottom-right" style="padding-left: 30;">When False</td>
            <td colspan="2" class="border-bottom">Details</td>
        </tr>
        <xsl:for-each select="$assertProcessorNode/ruleProperties/actionsWhenFalse/item">
            <xsl:call-template name="analysisRuleAction">
                <xsl:with-param name="analysisRuleActionNode" select="current()"/>
                <xsl:with-param name="skip" select="$skip"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="analysisRuleAction">
        <xsl:param name="analysisRuleActionNode"/>
        <xsl:param name="skip"/>
        <xsl:variable name="actionType" select="$analysisRuleActionNode/@actionId"/>
        <xsl:choose>
            <xsl:when test="$actionType = 'DeclareExecutionIssue'">
                <xsl:call-template name="render_analysisRuleAction">
                    <xsl:with-param name="action" select="$actionType"/>
                    <xsl:with-param name="details"
                        select="$analysisRuleActionNode/actionProperties/message"/>
                    <xsl:with-param name="skip" select="$skip"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$actionType = 'CallProcedure'">
                <xsl:call-template name="render_analysisRuleAction">
                    <xsl:with-param name="action" select="$actionType"/>
                    <xsl:with-param name="details"
                        select="$analysisRuleActionNode/actionProperties/command"/>
                    <xsl:with-param name="skip" select="$skip"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$actionType = 'Eval' or $actionType = 'ScriptEval'">
                <xsl:call-template name="render_analysisRuleAction">
                    <xsl:with-param name="action" select="$actionType"/>
                    <xsl:with-param name="details"
                        select="$analysisRuleActionNode/actionProperties/statement"/>
                    <xsl:with-param name="skip" select="$skip"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="render_analysisRuleAction">
                    <xsl:with-param name="action" select="$actionType"/>
                    <xsl:with-param name="details" select="''"/>
                    <xsl:with-param name="skip" select="$skip"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="render_analysisRuleAction">
        <xsl:param name="action"/>
        <xsl:param name="details"/>
        <xsl:param name="skip"/>
        <tr>
            <xsl:call-template name="analysis_sytle">
                <xsl:with-param name="skip" select="$skip"/>
            </xsl:call-template>
            <td colspan="2" class="border-bottom-right" style="padding-left: 40;">
                <xsl:value-of select="$action"/>
            </td>
            <td colspan="2" class="border-bottom">
                <xsl:value-of select="$details"/>
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