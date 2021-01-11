<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ general section ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name = "general">
		<xsl:param name = "generalNode" />
~~~ Overview: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Owner:          <xsl:value-of select="$generalNode/owner"/>
Headline:  <xsl:value-of select="$generalNode/documentation"/>
Description:          <xsl:value-of select="$generalNode/notes"/>

	</xsl:template>
	
	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ execution parameters ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name = "parametersSection">
		<xsl:param name = "parameterSectionNode" />
		
~~~ Parameters:	(name: value) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		<xsl:for-each select = "$parameterSectionNode/node()" >  
			<xsl:call-template name = "parameter" >
				<xsl:with-param name = "parameterNode" select="current()" />
				<xsl:with-param name = "parent" select="''"/>
			</xsl:call-template> 
		</xsl:for-each>  
		<xsl:text>
			
		</xsl:text>
	</xsl:template>
	

	<xsl:template name="parameter">
		<xsl:param name="parameterNode"/>
		<xsl:param name="parent"/>
		<xsl:if test="string-length(name($parameterNode)) &gt; 0">
			<xsl:call-template name="render_parameter">
				<xsl:with-param name="name" select="name($parameterNode)"/>
				<xsl:with-param name="value" select="$parameterNode"/>
				<xsl:with-param name="parent" select="$parent"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:for-each select="$parameterNode/node()">
			<xsl:if test="string-length(name(current()))&gt;0">
				<xsl:call-template name="parameter">
					<xsl:with-param name="parameterNode" select="current()"/>
					<xsl:with-param name="parent"
						select="concat($parent, '/', name($parameterNode))"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name = "render_parameter">
		<xsl:param name = "name" />
		<xsl:param name = "value" />
		<xsl:param name = "parent" />
		<xsl:text>
		</xsl:text>
		<xsl:value-of select="$parent"/>/<xsl:value-of select="$name"/>: <xsl:value-of select="normalize-space($value)"/>
	</xsl:template>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ procedures ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name = "procedures">
		<xsl:param name = "proceduresNode" />	
~~~ Procedures:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		<xsl:for-each select="$proceduresNode/item">
Procedure <xsl:value-of select="position()"/>:  <xsl:value-of select="@name"/><xsl:text>
======================================================================================		
Step      Details
--------------------------------------------------------------------------------------
</xsl:text>		
			<xsl:for-each select="steps/item">
				<xsl:call-template name = "procedureItem" >
					<xsl:with-param name = "itemNode" select="current()" />
				</xsl:call-template>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ procedure item ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="procedureItem">
		<xsl:param name="itemNode"/>
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="string-length($itemNode/@skip) &gt; 0">
					<xsl:value-of select="$itemNode/@skip"/>
				</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="async">
			<xsl:choose>
				<xsl:when test="string-length($itemNode/@async) &gt; 0">
					<xsl:value-of select="$itemNode/@async"/>
				</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
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
			<xsl:with-param name="description" select="$itemNode/command/body"/>
			<xsl:with-param name="context" select="$itemNode/@context"/>
			<xsl:with-param name="target" select="$itemNode/@target"/>
			<xsl:with-param name="skip" select="$skip"/>
			<xsl:with-param name="async" select="$async"/>
		</xsl:call-template>

		<!-- if there are analysis rules attached with this step, then print it-->
		<xsl:if test="count($itemNode/postProcessing/analysisRules/item) &gt; 0">
			<xsl:call-template name="analysisRule">
				<xsl:with-param name="analysisRuleNode"
					select="$itemNode/postProcessing/analysisRules"/>
			</xsl:call-template>
		</xsl:if>
<xsl:text>
--------------------------------------------------------------------------------------
</xsl:text>		
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
		<xsl:param name="context"/>
		<xsl:param name="target"/>
		<xsl:param name="skip">false</xsl:param>
		<xsl:param name="async">false</xsl:param> 
		<xsl:value-of select="$step"/>
		  Action:		<xsl:value-of select="$action"/>
		  Session: 		<xsl:value-of select="$session"/>
		  Description:	<xsl:value-of select="$description"/>
		  Context: 		<xsl:value-of select="$context"/>
		  Target:		<xsl:value-of select="$target"/>
		  Skipped?: 	<xsl:value-of select="$skip"/>
		  Async?:		<xsl:value-of select="$async"/>
</xsl:template>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ analysis rule ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="analysisRule">
		<xsl:param name="analysisRuleNode"/> 
		<xsl:text>
		&#xa;		  Analysis Rules:</xsl:text><xsl:for-each
			select="$analysisRuleNode/item">
			<xsl:call-template name="analysisRuleItem">
				<xsl:with-param name="analysisRuleItemNode" select="current()"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="analysisRuleItem">
		<xsl:param name="analysisRuleItemNode"/>
		<xsl:call-template name="render_analysisRuleItem">
			<xsl:with-param name="extract_using" select="$analysisRuleItemNode/extractorInfo/@extractorType"/>
			<xsl:with-param name="what_to_extract"
				select="$analysisRuleItemNode/extractorInfo/extractorProperties/*"/>
			<xsl:with-param name="perform" select="$analysisRuleItemNode/processorInfo/@ruleType"/>
			<xsl:with-param name="details" select="$analysisRuleItemNode/processorInfo/ruleProperties/expression"
			/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name = "render_analysisRuleItem">
		<xsl:param name = "extract_using"/>
		<xsl:param name = "what_to_extract"/>
		<xsl:param name = "perform"/>
		<xsl:param name = "details"/>
		
		    Extract using: 		<xsl:value-of select="$extract_using"/>
		    What to extract:	<xsl:value-of select="$what_to_extract"/>
		    Perform:			<xsl:value-of select="$perform"/>
		    Details:			<xsl:value-of select="$details"/>
	</xsl:template>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template match = "/">
	Test Case
		
		<xsl:call-template name = "general" >
			<xsl:with-param name = "generalNode" select="testCase/general" />
		</xsl:call-template> 
		
		<xsl:call-template name = "parametersSection" >
			<xsl:with-param name = "parameterSectionNode" select="testCase/execution/parameters/parameters" />
		</xsl:call-template> 
		
		<xsl:call-template name = "procedures" >
			<xsl:with-param name = "proceduresNode" select="testCase/procedures" />
		</xsl:call-template> 
	</xsl:template>

</xsl:stylesheet>
