<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" omit-xml-declaration="yes"/>
	
	<!-- The images folder URL -->
	<xsl:param name="imagesFolder" select="''"/>

	<!-- The test start timestamp  -->
	<xsl:param name="startTimestamp" select="''"/>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Issues ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="issues">
		<xsl:if test="count(result/response/issues/item)">
			<tr>
				<td colspan="5" style="color: #666666;" class="border-top">Issues:</td>
			</tr>
			<tr>
				<td colspan="5" style="padding: 1;">
					<table>
						<xsl:for-each select="result/response/issues/item">
							<xsl:call-template name="issueItem">
								<xsl:with-param name="issueItemNode" select="current()"/>
							</xsl:call-template>
						</xsl:for-each>
					</table>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template name="issueItem">
		<xsl:param name="issueItemNode"/>
		<xsl:param name="indent">0</xsl:param>

		<xsl:call-template name="render_issueItem">
			<xsl:with-param name="severity" select="$issueItemNode/@severity"/>
			<xsl:with-param name="originator" select="$issueItemNode/@originator"/>
			<xsl:with-param name="message" select="$issueItemNode/message"/>
			<xsl:with-param name="documentLocation" select="$issueItemNode/@documentLocation"/>
		</xsl:call-template>
		<xsl:for-each select="$issueItemNode/issues/item">
			<xsl:call-template name="issueItem">
				<xsl:with-param name="issueItemNode" select="current()"/>
				<xsl:with-param name="indent" select="$indent+1"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="render_issueItem">
		<xsl:param name="severity"/>
		<xsl:param name="originator"/>
		<xsl:param name="message"/>
		<xsl:param name="documentLocation"/>
		<tr valign="top">
			<td width="50">
				<a name=""/>
				<span>
					<xsl:choose>
						<xsl:when test="$severity='0'">
							<xsl:attribute name="style">color:green;</xsl:attribute>pass
						</xsl:when>
						<xsl:when test="$severity='1'">
							<xsl:attribute name="style">color:blue;</xsl:attribute>info
						</xsl:when>
						<xsl:when test="$severity='2'">
							<xsl:attribute name="style">color:orange;</xsl:attribute>warning
						</xsl:when>
						<xsl:when test="$severity='4'">
							<xsl:attribute name="style">color:red;</xsl:attribute>fail
						</xsl:when>
						<xsl:when test="$severity='1000'">
							<xsl:attribute name="style">color:orange;</xsl:attribute>text added
						</xsl:when>
						<xsl:when test="$severity='1001'">
							<xsl:attribute name="style">color:orange;</xsl:attribute>text removed
						</xsl:when>
						<xsl:when test="$severity='1002'">
							<xsl:attribute name="style">color:orange;</xsl:attribute>text changed
						</xsl:when>
						<xsl:when test="$severity='1010'">
							<xsl:attribute name="style">color:orange;</xsl:attribute>structure added
						</xsl:when>
						<xsl:when test="$severity='1011'">
							<xsl:attribute name="style">color:orange;</xsl:attribute>structure removed
						</xsl:when>
						<xsl:when test="$severity='1012'">
							<xsl:attribute name="style">color:orange;</xsl:attribute>structure changed
						</xsl:when>
						<xsl:when test="$severity='1020'">
							<xsl:attribute name="style">color:orange;</xsl:attribute>query added
						</xsl:when>
						<xsl:when test="$severity='1021'">
							<xsl:attribute name="style">color:orange;</xsl:attribute>query removed
						</xsl:when>
						<xsl:when test="$severity='1022'">
							<xsl:attribute name="style">color:orange;</xsl:attribute>query changed
						</xsl:when>
					</xsl:choose>
				</span>
			</td>
			<td width="50">
				<xsl:value-of select="$originator"/>
				<br/>
			</td>
			<td width="548">
				<xsl:value-of select="$message"/>
				<br/>
			</td>
			<td width="100">
				<xsl:value-of select="$documentLocation"/>
				<br/>
			</td>
		</tr>
	</xsl:template>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Images ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<!-- NOTE: The imageUrl must match that used by iTest when saving the image to file -->
	<xsl:template name="render_images">
		<xsl:param name="imagesNode"/>
		<xsl:param name="imageNames"/>
		<xsl:param name="stepId"/>
		<!-- The maximum pixel height of the thumbnail images -->
		<xsl:variable name="maxHeight" select="100"/>
		<xsl:if test="$imagesNode">
			<tr>
				<td colspan="5" style="color: #666666;" class="border-top">Images:</td>
			</tr>
			<tr>
				<td colspan="5" style="padding: 1;">
					<table>
						<tr align="left" valign="top">
							<xsl:for-each select="$imagesNode/item">
							    <xsl:variable name="pos"
									select="position()"/>
							    <xsl:variable name="imageName"
									select="$imageNames/item[$pos]"/>
								<xsl:variable name="imageUrl"
									select="concat($imagesFolder, '/step', $stepId, '_image_', $imageName, '.png')"/>
								<td>
									<a href="{$imageUrl}">
										<xsl:choose>
											<xsl:when test="@height > $maxHeight">
												<IMG HEIGHT="{$maxHeight}" src="{$imageUrl}"/>
											</xsl:when>
											<xsl:otherwise>
												<IMG src="{$imageUrl}"/>
											</xsl:otherwise>
										</xsl:choose>
									</a>
								</td>
							</xsl:for-each>
						</tr>
					</table>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Response ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="render_response">
		<xsl:param name="responseNode"/>
		<xsl:param name="emulation"/>

		<xsl:variable name="emulate">		
			<xsl:if test="$emulation = 'true'"> (emulated)</xsl:if>
		</xsl:variable>
		
		<xsl:if test="string-length($responseNode/body) &gt; 0">
			<tr>
				<td colspan="5" style="color: #666666;" class="border-top">Response:<xsl:value-of
						select="$emulate"/></td>
			</tr>
			<tr>
				<td colspan="5" style="padding: 1;">
					<div id="overflow">
						<xsl:call-template name="formatText">
							<xsl:with-param name="responseBodyNode" select="$responseNode/body"/>
						</xsl:call-template>
					</div>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~ create html hyperlinks ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="hyperlink">
   		<xsl:param name="string" select="string(.)" />
   		<xsl:analyze-string select="$string"
                       regex="((https?|ftp|smb|file)://)([\-\w\.]+)+(:\d*)?(/([\w/_\.]*(\?\S+)?)?)?">
     		<xsl:matching-substring>
       			<a href="{.}">
         			<xsl:value-of select="." />
       			</a>
     		</xsl:matching-substring>
     		<xsl:non-matching-substring>
       			<xsl:value-of select="." />
     		</xsl:non-matching-substring>
   		</xsl:analyze-string>
 	</xsl:template>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Command ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="render_command">
		<xsl:param name="commandNode"/>
		<xsl:if test="string-length($commandNode/body) &gt; 0">
			<tr>
				<td style="color: #666666;" class="border-top">Command:</td>
				<td colspan="4" class="border-top">
					<pre>
        				<font>
							<xsl:call-template name="hyperlink">
								<xsl:with-param name="string" select="$commandNode/body"/>
							</xsl:call-template>
						</font>
					</pre>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Context ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="render_context">
		<xsl:param name="context"/>
		<xsl:if test="string-length($context)">
			<tr>
				<td style="color: #666666;" class="border-top">Context:</td>
				<td colspan="4" class="border-top">
					<xsl:value-of select="$context"/>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Target ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="render_target">
		<xsl:param name="target"/>
		<xsl:if test="string-length($target)">
			<tr>
				<td style="color: #666666;" class="border-top">Target:</td>
				<td colspan="4" class="border-top">
					<xsl:value-of select="$target"/>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Step ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="step">
		<xsl:param name="stepNode"/>

		<xsl:call-template name="render_step">
			<xsl:with-param name="session" select="$stepNode/executableStep/@session"/>
			<xsl:with-param name="id" select="$stepNode/id"/>
			<xsl:with-param name="action" select="$stepNode/executableStep/@action"/>
			<xsl:with-param name="startOffset" select="$stepNode/startOffset"/>
			<xsl:with-param name="startTime" select="$startTimestamp"/>
			<xsl:with-param name="duration" select="$stepNode/executionDuration"/>
			<xsl:with-param name="manual" select="$stepNode/manual"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="render_step">
		<xsl:param name="session"/>
		<xsl:param name="id"/>
		<xsl:param name="action"/>
		<xsl:param name="startOffset"/>
		<xsl:param name="startTime"/>
		<xsl:param name="duration"/>
		<xsl:param name="manual"/>
		
		<xsl:variable name="manualFlag">
   			<xsl:choose>
     			<xsl:when test="$manual">
        			<xsl:value-of select="'manual'"/>
     			</xsl:when>
     			 <xsl:otherwise>non-manual</xsl:otherwise>
   			</xsl:choose>
		</xsl:variable>
		
		<tr class="header {$manualFlag}" valign="top">
			<td width="10%" class="border-top-right">
				<a name="{$id}">
					<b>
						<xsl:value-of select="$id"/>
						<br/>
					</b>
				</a>
			</td>
			<td width="25%" class="border-top-right">
				<b>
					<xsl:value-of select="$action"/>
					<br/>
				</b>
			</td>
			<td width="25%" class="border-top-right">
				<b>
					<xsl:value-of select="$session"/>
					<br/>
				</b>
			</td>
			<td width="20%" class="border-top-right">
				<b>
<!-- Uncomment to print time elapsed since test case execution started ~~~~~~~~~~~~~~-->
					<xsl:call-template name="time">
						<xsl:with-param name="time" select="$startOffset"/>
					</xsl:call-template>
<!-- Uncomment to print system time the individual step began ~~~~~~~~~~~~~~~~~~~~~~~-->
					<!--
					<xsl:call-template name="timestamp">
						<xsl:with-param name="time_ms" select="$startTimestamp"/>
						<xsl:with-param name="delta_ms" select="$startOffset*1000"/>
					</xsl:call-template>
					-->
					<br/>
				</b>
			</td>
			<td width="20%" class="border-top">
				<b>
					<xsl:call-template name="time">
						<xsl:with-param name="time" select="$duration"/>
					</xsl:call-template>
					<br/>
				</b>
			</td>
		</tr>
	</xsl:template>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Post Processing ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="post_processing">
		<xsl:if test="count(postProcessingItems/item) > 0 and (executableStep/@action != 'call' or executableStep/command/body != 'main')">
			<tr>
				<td colspan="5" style="color: #666666;" class="border-top">Post-Processing:</td>
			</tr>
			<tr>
				<td colspan="5" style="padding: 1;">
					<table>
						<xsl:for-each select="postProcessingItems/item">
							<xsl:call-template name="postProcessingItem">
								<xsl:with-param name="postProcessingItemNode" select="current()"/>
							</xsl:call-template>
						</xsl:for-each>
					</table>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template name="postProcessingItem">
		<xsl:param name="postProcessingItemNode"/>
		<xsl:call-template name="render_postProcessingItem">
			<xsl:with-param name="action" select="$postProcessingItemNode/@action"/>
			<xsl:with-param name="description" select="$postProcessingItemNode/description"/>
		</xsl:call-template>
		<xsl:for-each select="postProcessingItems/item">
			<xsl:call-template name="postProcessingItem">
				<xsl:with-param name="postProcessingItemNode" select="current()"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="render_postProcessingItem">
		<xsl:param name="action"/>
		<xsl:param name="description"/>
	    <xsl:choose>
	      <xsl:when test="$action = 'analyze' or $action = 'responseFilter' or $action = 'storeResponse'" >
	        <tr valign="top">
	          <td>
	            <xsl:value-of select="$action"/>
	            <br/>
	          </td>
	          <td> </td>
	          <td>
	            <xsl:value-of select="$description"/>
	            <br/>
	          </td>
	        </tr>
	      </xsl:when>
	      <xsl:otherwise>
	        <tr valign="top">
	          <td> </td>	        
	          <td>
	            <xsl:value-of select="$action"/>
	            <br/>
	          </td>
	          <td>
	            <xsl:value-of select="$description"/>
	            <br/>
	          </td>
	        </tr>
	      </xsl:otherwise>
	    </xsl:choose>
  	</xsl:template>
	
	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ format time ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="time">
		<xsl:param name="time"/>
		<xsl:variable name="seconds" select="$time mod 60"/>
		<xsl:variable name="minutes" select="(floor($time div 60)) mod 60"/>
		<xsl:variable name="hours" select="floor($time div 3600)"/>
		<xsl:value-of select="concat(format-number($hours,'#00'),':', format-number($minutes,'00'),':', format-number($seconds,'00.#'))"/>
	</xsl:template>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ format timestamp ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="timestamp"
				  xmlns:xs="http://www.w3.org/2001/XMLSchema"
				  xmlns:format="xalan://java.text.SimpleDateFormat"
				  xmlns:date="xalan://java.util.Date">
		<xsl:param name="time_ms"/>
		<xsl:param name="delta_ms"/>
		<xsl:variable name="format" select="'yyyy-MM-dd HH:mm:ss.SSS'" />
		<xsl:value-of select="format:format(format:new($format), date:new(xs:integer($time_ms + $delta_ms)))"/>
	</xsl:template>
	
	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~ format response ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template name="formatText">
		<xsl:param name="responseBodyNode"/>
		<pre>
      <xsl:for-each select="$responseBodyNode/issue">
       <xsl:variable name="style">
	    <xsl:choose>
          <xsl:when test="@severity=0">background-color: #00FF00; color: #000000;</xsl:when> <!--pass-->
          <xsl:when test="@severity=1">background-color: #0000FF; color: #FFFFFF;</xsl:when> <!--info-->
          <xsl:when test="@severity=2">background-color: #FFFF00; color: #000000;</xsl:when> <!--warning-->
          <xsl:when test="@severity=4">background-color: #FF0000; color: #FFFFFF;</xsl:when> <!--error-->
          <xsl:when test="@severity=1000">background-color: #FFFF00; color: #000000;</xsl:when> <!--text added-->
          <xsl:when test="@severity=1001">background-color: #FFFF00; color: #000000;</xsl:when> <!--text removed-->
          <xsl:when test="@severity=1002">background-color: #FFFF00; color: #000000;</xsl:when> <!--text changed-->
          <xsl:when test="@severity=1010">background-color: #FFFF00; color: #000000;</xsl:when> <!--structure added-->
          <xsl:when test="@severity=1011">background-color: #FFFF00; color: #000000;</xsl:when> <!--structure removed-->
          <xsl:when test="@severity=1012">background-color: #FFFF00; color: #000000;</xsl:when> <!--structure changed-->
          <xsl:when test="@severity=1020">background-color: #FFFF00; color: #000000;</xsl:when> <!--query added-->
          <xsl:when test="@severity=1021">background-color: #FFFF00; color: #000000;</xsl:when> <!--query removed-->
          <xsl:when test="@severity=1022">background-color: #FFFF00; color: #000000;</xsl:when> <!--query changed-->
	    <xsl:otherwise>background-color: #FFFFFF; color: #000000;</xsl:otherwise>
	    </xsl:choose>
        </xsl:variable>
        <font style="{$style}">
          <xsl:call-template name="hyperlink">
			<xsl:with-param name="string" select="current()"/>
		  </xsl:call-template>
        </font> 
      </xsl:for-each> 
	  </pre>
	</xsl:template>

	<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~ main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
	<xsl:template match="ExecutedStep">
		<xsl:call-template name="step">
			<xsl:with-param name="stepNode" select="."/>
		</xsl:call-template>
		<xsl:call-template name="render_command">
			<xsl:with-param name="commandNode" select="executableStep/command"/>
		</xsl:call-template>
		<xsl:call-template name="render_context">
			<xsl:with-param name="context" select="executableStep/@context"/>
		</xsl:call-template>
		<xsl:call-template name="render_target">
			<xsl:with-param name="target" select="executableStep/@target"/>
		</xsl:call-template>
		<xsl:call-template name="issues"/>
		<xsl:call-template name="render_images">
			<xsl:with-param name="imagesNode" select="result/response/images"/>
			<xsl:with-param name="imageNames" select="result/response/imageNames"/>
			<xsl:with-param name="stepId" select="id"/>
		</xsl:call-template>
		<xsl:call-template name="render_response">
			<xsl:with-param name="responseNode" select="result/response"/>
			<xsl:with-param name="emulation" select="emulated"/>
		</xsl:call-template>
		<xsl:call-template name="post_processing"/>
	</xsl:template>

</xsl:stylesheet>