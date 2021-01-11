<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:dateFormatter="xalan://com.fnfr.foundation.xslt.DateFormatter"
  extension-element-prefixes="dateFormatter">  
  
  <xsl:output method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- Creates the top-level start tag (end tag supplied by reportFooter) -->
  <!-- Also creates the test report summary -->
  <xsl:template match="/">
    <xsl:text disable-output-escaping="yes">&lt;iTestTestReport version="1.0"&gt;&#xd;</xsl:text>
    <xsl:apply-templates select="TestReportDocument"/>
  </xsl:template>
  
  <!-- Strip all namespaces -->
  <xsl:template match="*">
    <xsl:element name="{local-name(  )}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <!-- Excude all attributes -->
  <xsl:template match="@*">
  </xsl:template>
    
  <xsl:template match="TestReportDocument">
    <xsl:element name="reportSummary">
      <xsl:element name="startTime">
        <xsl:value-of select="dateFormatter:convertIsoDateToLocalDate(startTime/text())"/>
      </xsl:element>
      <xsl:element name="endTime">
        <xsl:value-of select="dateFormatter:convertIsoDateToLocalDate(endTime/text())"/>
      </xsl:element>
      <xsl:element name="duration">
        <xsl:value-of select="duration/text()"/>
      </xsl:element>
      <xsl:element name="description">
        <xsl:value-of select="description/text()"/>
      </xsl:element>
      <xsl:element name="testcase">
        <xsl:value-of select="testcase/text()"/>
      </xsl:element>
      <xsl:element name="testbed">
        <xsl:value-of select="testbed/text()"/>
      </xsl:element>
      <xsl:element name="parameterFile">
        <xsl:value-of select="parametersFile/text()"/>
      </xsl:element>
      <xsl:element name="result">
        <xsl:attribute name="emulation">
          <xsl:choose>
            <xsl:when test="emulation = 'true'">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="result/text()"/>
      </xsl:element>
      <xsl:element name="executionIssueCount">
        <xsl:value-of select="executionIssueCount/text()"/>
      </xsl:element>
      <xsl:element name="totalReportItemCount">
        <xsl:value-of select="totalReportItemCount/text()"/>
      </xsl:element>
      <xsl:element name="reportId">
        <xsl:value-of select="reportId/text()"/>
      </xsl:element>
      <xsl:element name="host">
        <xsl:value-of select="host/text()"/>
      </xsl:element>
      <xsl:element name="group">
        <xsl:value-of select="group/text()"/>
      </xsl:element>
      <xsl:element name="subGroup">
        <xsl:value-of select="subGroup/text()"/>
      </xsl:element>
      <xsl:apply-templates select="summary/finalParameters"/>
      <xsl:apply-templates select="summary/testCaseDetails"/>
      <xsl:apply-templates select="summary/extractedData"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="finalParameters">
    <xsl:element name="parameters">
      <xsl:call-template name="sessionParameters"/>
      <xsl:call-template name="globalParameters"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="sessionParameters">
    <xsl:for-each select="parameters/profiles/profile">
      <xsl:element name="session">
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:for-each select="document/parameters/parameters/parameters/*">
          <!-- Output all profile parameters (strip namespace) -->
          <xsl:call-template name="copyParameter"/>
          <!-- Alternative that copies everytrhing 
          <xsl:apply-templates select="."/>              
          -->
        </xsl:for-each>
        <xsl:text disable-output-escaping="yes">&#xd;</xsl:text>
      </xsl:element>        
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="globalParameters">
    <xsl:element name="global">
      <xsl:for-each select="parameters/*[not(self::profiles) and not(self::testbed)]">
        <!-- Output all global parameters (strip namespace) -->
        <xsl:call-template name="copyParameter"/>
        <!-- Alternative that copies everytrhing 
          <xsl:apply-templates select="."/>              
        -->
      </xsl:for-each>
      <xsl:text disable-output-escaping="yes">&#xd;</xsl:text>
    </xsl:element>        
  </xsl:template>
  
  <!-- Copy parameter elements, support nested parameters -->
  <xsl:template name="copyParameter">
    <!-- FIXME: Can xsl:element be used here? -->
    <xsl:text disable-output-escaping="yes">&#xd;&lt;</xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
    <xsl:value-of select="text()"/>
    <xsl:for-each select="*">
      <xsl:call-template name="copyParameter"/>
    </xsl:for-each>
    <xsl:if test="count(*) > 0">
      <xsl:text disable-output-escaping="yes">&#xd;</xsl:text>      
    </xsl:if>
    <xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
  </xsl:template>
  
  <xsl:template match="testCaseDetails">
    <xsl:element name="testCaseDetails">
      <xsl:attribute name="entryPoint">
        <xsl:value-of select="@entryPoint"/>
      </xsl:attribute>
      <xsl:element name="rendering">
        <xsl:attribute name="tclNamespace">
          <xsl:value-of select="general/rendering/@tclNamespace"/>
        </xsl:attribute>
        <xsl:attribute name="testCaseId">
          <xsl:value-of select="general/rendering/@testCaseId"/>
        </xsl:attribute>
        <xsl:attribute name="testCaseName">
          <xsl:value-of select="general/rendering/@testCaseName"/>
        </xsl:attribute>
        <xsl:value-of select="general/rendering/text()"/>
      </xsl:element>
      <xsl:element name="referencedTestCases">
        <xsl:value-of select="general/referencedTestCases/text()"/>        
      </xsl:element>
      <xsl:element name="documentation">
        <xsl:value-of select="general/documentation/text()"/>        
      </xsl:element>
      <xsl:element name="notes">
        <xsl:value-of select="general/notes/text()"/>        
      </xsl:element>
      <xsl:element name="owner">
        <xsl:value-of select="general/owner/text()"/>        
      </xsl:element>
      <xsl:element name="execution">
        <xsl:attribute name="executionTimeout">
          <xsl:value-of select="execution/@executionTimeout"/>
        </xsl:attribute>
        <xsl:attribute name="defaultStepTimeout">
          <xsl:value-of select="execution/@defaultStepTimeout"/>
        </xsl:attribute>
        <xsl:value-of select="execution/text()"/>        
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="extractedData">
    <xsl:element name="extractedData">
      <xsl:for-each select="item">
        <xsl:element name="item">
          <xsl:element name="testCase">
            <xsl:value-of select="testCase/text()"/>
          </xsl:element>
          <xsl:element name="procedure">
            <xsl:value-of select="procedure/text()"/>        
          </xsl:element>
          <xsl:element name="id">
            <xsl:value-of select="executableStep/text()"/>        
          </xsl:element>
          <xsl:element name="step">
            <xsl:value-of select="executedStep/text()"/>        
          </xsl:element>
          <xsl:element name="time">
            <xsl:value-of select="time/text()"/>        
          </xsl:element>
          <xsl:element name="tag">
            <xsl:value-of select="tag/text()"/>        
          </xsl:element>
          <xsl:element name="data">
            <xsl:for-each select="data/item">
              <xsl:element name="item">
                <xsl:value-of select="./text()"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  
  <xsl:template match="execution">
    <xsl:element name="execution">
      <xsl:attribute name="executionTimeout">
        <xsl:value-of select="@executionTimeout"/>
      </xsl:attribute>
      <xsl:attribute name="defaultStepTimeout">
        <xsl:value-of select="@defaultStepTimeout"/>
      </xsl:attribute>
    </xsl:element>    
  </xsl:template>
  
</xsl:stylesheet>