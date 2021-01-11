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

<xsl:template name = "parameter">
	<xsl:param name = "parameterNode" />
	<xsl:param name = "parent" />
	<xsl:if test="string-length(name($parameterNode)) &gt; 0">
		<xsl:call-template name = "render_parameter" >
			<xsl:with-param name = "name" select="name($parameterNode)" />
			<xsl:with-param name = "value" select="$parameterNode"/>
			<xsl:with-param name = "parent" select="$parent"/>
		</xsl:call-template> 
	</xsl:if>
	<xsl:for-each select = "$parameterNode/node()" >  
		<xsl:if test="string-length(name(current()))&gt;0">
			<xsl:call-template name = "parameter" >
				<xsl:with-param name = "parameterNode" select="current()" />
				<xsl:with-param name = "parent" select="concat($parent, '/', name($parameterNode))"/>
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
<xsl:template name = "procedureItem">
	<xsl:param name = "itemNode" />
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
	
	<xsl:call-template name = "render_procedureItem" >
		<xsl:with-param name = "step" 		    select="$step" />
		<xsl:with-param name = "action" 		select="$itemNode/@action" />
		<xsl:with-param name = "session" 		select="$itemNode/@session" />
		<xsl:with-param name = "description" 	select="$itemNode/@target | $itemNode/command/body" />
	</xsl:call-template> 

		<!-- Print any nested steps -->
	<xsl:for-each select="$itemNode/nestedSteps/item">
		<xsl:call-template name="procedureItem">
			<xsl:with-param name="itemNode" select="current()"/>
		</xsl:call-template>      
	</xsl:for-each>
</xsl:template>

<xsl:template name = "render_procedureItem">
	<xsl:param name = "step" />
	<xsl:param name = "action" />
	<xsl:param name = "session" />
	<xsl:param name = "description" />
	<xsl:value-of select="$step"/>
		  Action:		<xsl:value-of select="$action"/>
		  Session:		<xsl:value-of select="$session"/>
		  Description:	<xsl:value-of select="$description"/>
--------------------------------------------------------------------------------------
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