<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:schold="http://www.ascc.net/xml/schematron" 
	xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
	xmlns:saxon="http://saxon.sf.net/" 
	xmlns:xhtml="http://www.w3.org/1999/xhtml" 
	xmlns:gm="http://xmls.skatteverket.se/se/skatteverket/ai/gemensamt/infoForBeskattning/7.0" 
	xmlns:ku="http://xmls.skatteverket.se/se/skatteverket/ai/komponent/infoForBeskattning/7.0" 
	xmlns:kuin="http://xmls.skatteverket.se/se/skatteverket/ai/instans/infoForBeskattning/7.0" 
	xmlns:dp="http://www.dpawson.co.uk/ns#" version="2.0">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible.   -->
<xsl:param name="archiveDirParameter"/>
<xsl:param name="archiveNameParameter"/>
<xsl:param name="fileNameParameter"/>
<xsl:param name="fileDirParameter"/>
<xsl:variable name="document-uri"/>

<!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>

<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
<xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
<xsl:text>/</xsl:text>
<xsl:choose>
<xsl:when test="namespace-uri()=''">
<xsl:value-of select="name()"/>
</xsl:when>
<xsl:otherwise>
<xsl:text>*:</xsl:text>
<xsl:value-of select="local-name()"/>
<xsl:text>[namespace-uri()='</xsl:text>
<xsl:value-of select="namespace-uri()"/>
<xsl:text>']</xsl:text>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
<xsl:text>[</xsl:text>
<xsl:value-of select="1+ $preceding"/>
<xsl:text>]</xsl:text>
</xsl:template>
<xsl:template match="@*" mode="schematron-get-full-path">
<xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
<xsl:text>/</xsl:text>
<xsl:choose>
<xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
</xsl:when>
<xsl:otherwise>
<xsl:text>@*[local-name()='</xsl:text>
<xsl:value-of select="local-name()"/>
<xsl:text>' and namespace-uri()='</xsl:text>
<xsl:value-of select="namespace-uri()"/>
<xsl:text>']</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
<xsl:for-each select="ancestor-or-self::*">
<xsl:text>/</xsl:text>
<xsl:value-of select="name(.)"/>
<xsl:if test="preceding-sibling::*[name(.)=name(current())]">
<xsl:text>[</xsl:text>
<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
<xsl:text>]</xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:if test="not(self::*)">
<xsl:text/>/@<xsl:value-of select="name(.)"/>
</xsl:if>
</xsl:template>
<!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
<xsl:for-each select="ancestor-or-self::*">
<xsl:text>/</xsl:text>
<xsl:value-of select="name(.)"/>
<xsl:if test="parent::*">
<xsl:text>[</xsl:text>
<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
<xsl:text>]</xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:if test="not(self::*)">
<xsl:text/>/@<xsl:value-of select="name(.)"/>
</xsl:if>
</xsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path"/>
<xsl:template match="text()" mode="generate-id-from-path">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
<xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
</xsl:template>
<xsl:template match="comment()" mode="generate-id-from-path">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
<xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
</xsl:template>
<xsl:template match="processing-instruction()" mode="generate-id-from-path">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
<xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
</xsl:template>
<xsl:template match="@*" mode="generate-id-from-path">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
<xsl:value-of select="concat('.@', name())"/>
</xsl:template>
<xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
<xsl:text>.</xsl:text>
<xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
</xsl:template>

<!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
<xsl:template match="*" mode="generate-id-2" priority="2">
<xsl:text>U</xsl:text>
<xsl:number level="multiple" count="*"/>
</xsl:template>
<xsl:template match="node()" mode="generate-id-2">
<xsl:text>U.</xsl:text>
<xsl:number level="multiple" count="*"/>
<xsl:text>n</xsl:text>
<xsl:number count="node()"/>
</xsl:template>
<xsl:template match="@*" mode="generate-id-2">
<xsl:text>U.</xsl:text>
<xsl:number level="multiple" count="*"/>
<xsl:text>_</xsl:text>
<xsl:value-of select="string-length(local-name(.))"/>
<xsl:text>_</xsl:text>
<xsl:value-of select="translate(name(),':','.')"/>
</xsl:template>
<!--Strip characters-->
<xsl:template match="text()" priority="-1"/>

<!--SCHEMA SETUP-->
<xsl:template match="/">
<svrl:schematron-output title="Kontrolluppgifter regler" schemaVersion="ISO19757-3" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
<xsl:comment>
<xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
</xsl:comment>
<svrl:ns-prefix-in-attribute-values uri="http://xmls.skatteverket.se/se/skatteverket/ai/gemensamt/infoForBeskattning/7.0" prefix="gm"/>
<svrl:ns-prefix-in-attribute-values uri="http://xmls.skatteverket.se/se/skatteverket/ai/komponent/infoForBeskattning/7.0" prefix="ku"/>
<svrl:ns-prefix-in-attribute-values uri="http://xmls.skatteverket.se/se/skatteverket/ai/instans/infoForBeskattning/7.0" prefix="kuin"/>
<svrl:ns-prefix-in-attribute-values uri="http://www.dpawson.co.uk/ns#" prefix="dp"/>
<svrl:active-pattern>
<xsl:attribute name="document">
<value-of select="document-uri(/)"/>
</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M5"/>
</svrl:schematron-output>
</xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Kontrolluppgifter regler</svrl:text>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="ku:Blankett" priority="1032" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:Blankett"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Arendeinformation/ku:Arendeagare) or (((number(substring(ku:Arendeinformation/ku:Arendeagare,3,1))*2) mod 9 + (floor(number(substring(ku:Arendeinformation/ku:Arendeagare,3,1)) div 9)*9) + (number(substring(ku:Arendeinformation/ku:Arendeagare,4,1))) + (number(substring(ku:Arendeinformation/ku:Arendeagare,5,1))*2) mod 9 + (floor(number(substring(ku:Arendeinformation/ku:Arendeagare,5,1)) div 9)*9) + (number(substring(ku:Arendeinformation/ku:Arendeagare,6,1))) + (number(substring(ku:Arendeinformation/ku:Arendeagare,7,1))*2) mod 9 + (floor(number(substring(ku:Arendeinformation/ku:Arendeagare,7,1)) div 9)*9) + (number(substring(ku:Arendeinformation/ku:Arendeagare,8,1))) + (number(substring(ku:Arendeinformation/ku:Arendeagare,9,1))*2) mod 9 + (floor(number(substring(ku:Arendeinformation/ku:Arendeagare,9,1)) div 9)*9) + (number(substring(ku:Arendeinformation/ku:Arendeagare,10,1))) + (number(substring(ku:Arendeinformation/ku:Arendeagare,11,1))*2) mod 9 + (floor(number(substring(ku:Arendeinformation/ku:Arendeagare,11,1)) div 9)*9) + (number(substring(ku:Arendeinformation/ku:Arendeagare,12,1)))) mod 10 = 0)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Arendeinformation/ku:Arendeagare) or (((number(substring(ku:Arendeinformation/ku:Arendeagare,3,1))*2) mod 9 + (floor(number(substring(ku:Arendeinformation/ku:Arendeagare,3,1)) div 9)*9) + (number(substring(ku:Arendeinformation/ku:Arendeagare,4,1))) + (number(substring(ku:Arendeinformation/ku:Arendeagare,5,1))*2) mod 9 + (floor(number(substring(ku:Arendeinformation/ku:Arendeagare,5,1)) div 9)*9) + (number(substring(ku:Arendeinformation/ku:Arendeagare,6,1))) + (number(substring(ku:Arendeinformation/ku:Arendeagare,7,1))*2) mod 9 + (floor(number(substring(ku:Arendeinformation/ku:Arendeagare,7,1)) div 9)*9) + (number(substring(ku:Arendeinformation/ku:Arendeagare,8,1))) + (number(substring(ku:Arendeinformation/ku:Arendeagare,9,1))*2) mod 9 + (floor(number(substring(ku:Arendeinformation/ku:Arendeagare,9,1)) div 9)*9) + (number(substring(ku:Arendeinformation/ku:Arendeagare,10,1))) + (number(substring(ku:Arendeinformation/ku:Arendeagare,11,1))*2) mod 9 + (floor(number(substring(ku:Arendeinformation/ku:Arendeagare,11,1)) div 9)*9) + (number(substring(ku:Arendeinformation/ku:Arendeagare,12,1)))) mod 10 = 0)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>1000#Person-/organisationsnummer för ärendeägaren (fältet Arendeagare) är inte formellt korrekt</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId) or (((number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,3,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,3,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,4,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,5,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,5,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,6,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,7,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,7,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,8,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,9,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,9,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,10,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,11,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,11,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,12,1)))) mod 10 = 0)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId) or (((number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,3,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,3,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,4,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,5,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,5,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,6,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,7,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,7,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,8,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,9,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,9,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,10,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,11,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,11,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId,12,1)))) mod 10 = 0)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>1001#Person-/organisationsnummer för uppgiftslämnaren (fältet UppgiftslamnarId) är inte formellt korrekt</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare) or (((number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,3,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,3,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,4,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,5,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,5,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,6,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,7,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,7,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,8,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,9,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,9,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,10,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,11,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,11,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,12,1)))) mod 10 = 0)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare) or (((number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,3,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,3,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,4,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,5,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,5,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,6,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,7,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,7,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,8,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,9,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,9,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,10,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,11,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,11,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Inkomsttagare')]/ku:Inkomsttagare,12,1)))) mod 10 = 0)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>1002#Person-/organisationsnummer för den KU:n avser (fältet Inkomsttagare) är inte formellt korrekt</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((@nummer = '2300' and ku:Blankettinnehall/ku:KU10) or (@nummer = '2340' and ku:Blankettinnehall/ku:KU13) or (@nummer = '2303' and ku:Blankettinnehall/ku:KU14) or (@nummer = '2306' and ku:Blankettinnehall/ku:KU16) or (@nummer = '2307' and ku:Blankettinnehall/ku:KU17) or (@nummer = '2310' and ku:Blankettinnehall/ku:KU18) or (@nummer = '2341' and ku:Blankettinnehall/ku:KU19) or (@nummer = '2323' and ku:Blankettinnehall/ku:KU20) or (@nummer = '2320' and ku:Blankettinnehall/ku:KU21) or (@nummer = '2336' and ku:Blankettinnehall/ku:KU25) or (@nummer = '2337' and ku:Blankettinnehall/ku:KU26) or (@nummer = '2335' and ku:Blankettinnehall/ku:KU28) or (@nummer = '2312' and ku:Blankettinnehall/ku:KU30) or (@nummer = '2322' and ku:Blankettinnehall/ku:KU31) or (@nummer = '2318' and ku:Blankettinnehall/ku:KU32) or (@nummer = '2315' and ku:Blankettinnehall/ku:KU34) or (@nummer = '2325' and ku:Blankettinnehall/ku:KU35) or (@nummer = '2339' and ku:Blankettinnehall/ku:KU40) or (@nummer = '2313' and ku:Blankettinnehall/ku:KU41) or (@nummer = '2338' and ku:Blankettinnehall/ku:KU50) or (@nummer = '2327' and ku:Blankettinnehall/ku:KU52) or (@nummer = '2351' and ku:Blankettinnehall/ku:KU53) or (@nummer = '2324' and ku:Blankettinnehall/ku:KU55) or (@nummer = '2314' and ku:Blankettinnehall/ku:KU65) or (@nummer = '2350' and ku:Blankettinnehall/ku:KU66) or (@nummer = '2326' and ku:Blankettinnehall/ku:KU67) or (@nummer = '2316' and ku:Blankettinnehall/ku:KU70) or (@nummer = '2319' and ku:Blankettinnehall/ku:KU71) or (@nummer = '2321' and ku:Blankettinnehall/ku:KU72) or (@nummer = '2317' and ku:Blankettinnehall/ku:KU73) or (@nummer = '2329' and ku:Blankettinnehall/ku:KU80) or (@nummer = '2328' and ku:Blankettinnehall/ku:KU81) or (@nummer = '3715' and ku:Blankettinnehall/ku:KupongS))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((@nummer = '2300' and ku:Blankettinnehall/ku:KU10) or (@nummer = '2340' and ku:Blankettinnehall/ku:KU13) or (@nummer = '2303' and ku:Blankettinnehall/ku:KU14) or (@nummer = '2306' and ku:Blankettinnehall/ku:KU16) or (@nummer = '2307' and ku:Blankettinnehall/ku:KU17) or (@nummer = '2310' and ku:Blankettinnehall/ku:KU18) or (@nummer = '2341' and ku:Blankettinnehall/ku:KU19) or (@nummer = '2323' and ku:Blankettinnehall/ku:KU20) or (@nummer = '2320' and ku:Blankettinnehall/ku:KU21) or (@nummer = '2336' and ku:Blankettinnehall/ku:KU25) or (@nummer = '2337' and ku:Blankettinnehall/ku:KU26) or (@nummer = '2335' and ku:Blankettinnehall/ku:KU28) or (@nummer = '2312' and ku:Blankettinnehall/ku:KU30) or (@nummer = '2322' and ku:Blankettinnehall/ku:KU31) or (@nummer = '2318' and ku:Blankettinnehall/ku:KU32) or (@nummer = '2315' and ku:Blankettinnehall/ku:KU34) or (@nummer = '2325' and ku:Blankettinnehall/ku:KU35) or (@nummer = '2339' and ku:Blankettinnehall/ku:KU40) or (@nummer = '2313' and ku:Blankettinnehall/ku:KU41) or (@nummer = '2338' and ku:Blankettinnehall/ku:KU50) or (@nummer = '2327' and ku:Blankettinnehall/ku:KU52) or (@nummer = '2351' and ku:Blankettinnehall/ku:KU53) or (@nummer = '2324' and ku:Blankettinnehall/ku:KU55) or (@nummer = '2314' and ku:Blankettinnehall/ku:KU65) or (@nummer = '2350' and ku:Blankettinnehall/ku:KU66) or (@nummer = '2326' and ku:Blankettinnehall/ku:KU67) or (@nummer = '2316' and ku:Blankettinnehall/ku:KU70) or (@nummer = '2319' and ku:Blankettinnehall/ku:KU71) or (@nummer = '2321' and ku:Blankettinnehall/ku:KU72) or (@nummer = '2317' and ku:Blankettinnehall/ku:KU73) or (@nummer = '2329' and ku:Blankettinnehall/ku:KU80) or (@nummer = '2328' and ku:Blankettinnehall/ku:KU81) or (@nummer = '3715' and ku:Blankettinnehall/ku:KupongS))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>1003#Angiven KU-typ (element ku:KUxx) motsvarar inte angivet blankettnummer (attribut till element ku:Blankett)</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:Inkomstar = ku:Arendeinformation/ku:Period"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:Inkomstar = ku:Arendeinformation/ku:Period">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>1004#Fältet &lt;Inkomstar&gt; (203) måste ha samma värde som Period</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId = ku:Arendeinformation/ku:Arendeagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Blankettinnehall/*[starts-with(local-name(),'K')]/*[starts-with(local-name(),'Uppgiftslamnare')]/ku:UppgiftslamnarId = ku:Arendeinformation/ku:Arendeagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>1005#Fältet &lt;UppgiftslamnarID&gt; (201) måste ha samma värde som Arendeagare</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr) or (((number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,3,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,3,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,4,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,5,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,5,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,6,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,7,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,7,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,8,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,9,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,9,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,10,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,11,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,11,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,12,1)))) mod 10 = 0)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr) or (((number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,3,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,3,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,4,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,5,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,5,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,6,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,7,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,7,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,8,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,9,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,9,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,10,1))) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,11,1))*2) mod 9 + (floor(number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,11,1)) div 9)*9) + (number(substring(ku:Blankettinnehall/*[starts-with(local-name(),'K')]/ku:SvensktRegNr,12,1)))) mod 10 = 0)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>1006#Fältet &lt;SvensktRegNr&gt; (683) är inte formellt korrekt</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU10" priority="1031" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU10"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or ku:AndraKostnadsers or ku:ErsMEgenavgifter or ku:Tjanstepension or ku:ErsEjSocAvg or ku:ErsEjSocAvgEjJobbavd or ku:Forskarskattenamnden or ku:Hyresersattning or ku:Bilersattning or ku:Traktamente or ku:KontantBruttolonMm"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or ku:AndraKostnadsers or ku:ErsMEgenavgifter or ku:Tjanstepension or ku:ErsEjSocAvg or ku:ErsEjSocAvgEjJobbavd or ku:Forskarskattenamnden or ku:Hyresersattning or ku:Bilersattning or ku:Traktamente or ku:KontantBruttolonMm">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>010#Kontrolluppgiften saknar helt ersättningar. Utan dessa är den alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:KontantBruttolonMm and not(ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:KontantBruttolonMm and not(ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>183#Fält 011 används enbart för ersättning där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe. Obs! Ersättningar som inte är underlag för arbetsgivaravgifter, t.ex. ersättningar under 1 000 kr redovisar du i fält 031</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:FormanUtomBilDrivmedel or ku:ErsEjSocAvg or ku:ErsMEgenavgifter or (not(ku:BostadSmahus) and not(ku:BostadEjSmahus))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:FormanUtomBilDrivmedel or ku:ErsEjSocAvg or ku:ErsMEgenavgifter or (not(ku:BostadSmahus) and not(ku:BostadEjSmahus))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>015#Du har markerat något eller båda av fält 041 och 043. Du ska då också fylla i ett belopp i fält där förmån redovisas</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:FormanUtomBilDrivmedel or ku:ErsEjSocAvg or ku:ErsMEgenavgifter or (not(ku:UnderlagRutarbete) and not(ku:UnderlagRotarbete))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:FormanUtomBilDrivmedel or ku:ErsEjSocAvg or ku:ErsMEgenavgifter or (not(ku:UnderlagRutarbete) and not(ku:UnderlagRotarbete))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>017#Du har fyllt i underlag för skattereduktion för rut-/rotarbete, fält 021 - 022. Du ska då också fylla i ett belopp i fält där förmån redovisas</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:FormanUtomBilDrivmedel and not(ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:FormanUtomBilDrivmedel and not(ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>184#Fält 012 används enbart för förmån där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:BilformanUtomDrivmedel and not(ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:BilformanUtomDrivmedel and not(ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>185#Fält 013 används enbart för förmån där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:DrivmedelVidBilforman and not (ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:DrivmedelVidBilforman and not (ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>186#Fält 018 används enbart för förmån där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:SocialAvgiftsAvtal) or not(ku:ErsMEgenavgifter)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:SocialAvgiftsAvtal) or not(ku:ErsMEgenavgifter)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>139#Du har markerat Socialavgiftsavtal finns, fält 093, dvs. ett avtal finns om att den anställde ska redovisa och betala arbetsgivaravgifterna i arbetsgivarens ställe. Du kan därför inte också fylla i fält 025 som gäller ersättningar till personer, som utan att vara näringsidkare ändå ska betala egenavgifter</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or not(ku:FormanHarJusterats) or ku:ErsEjSocAvg or ku:ErsMEgenavgifter"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or not(ku:FormanHarJusterats) or ku:ErsEjSocAvg or ku:ErsMEgenavgifter">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>038#Du har markerat Förmån har justerats, fält 048. Du ska då också fylla i ett belopp i fält där förmån redovisas</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or not(ku:FormanSomPension)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or not(ku:FormanSomPension)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>040#Du har markerat Förmån som pension, fält 049. Du ska då också fylla i ett belopp i Skattepliktiga förmåner utom bilförmån och drivmedel vid bilförmån, fält 012, eller Skattepliktig bilförmån utom drivmedel, fält 013</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU10/ku:TIN) or ku:InkomsttagareKU10/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU10/ku:TIN) or ku:InkomsttagareKU10/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU10/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU10/ku:Inkomsttagare) or ku:UppgiftslamnareKU10/ku:UppgiftslamnarId != ku:InkomsttagareKU10/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU10/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU10/ku:Inkomsttagare) or ku:UppgiftslamnareKU10/ku:UppgiftslamnarId != ku:InkomsttagareKU10/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU10/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU10/ku:Inkomsttagare) + count(ku:InkomsttagareKU10/ku:Fodelsetid) + count(ku:InkomsttagareKU10/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU10/*) + count(//ku:InkomsttagareKU10/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU10/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU10/ku:Inkomsttagare) + count(ku:InkomsttagareKU10/ku:Fodelsetid) + count(ku:InkomsttagareKU10/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU10/*) + count(//ku:InkomsttagareKU10/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:Fodelsetid or ku:InkomsttagareKU10/ku:AnnatIDNr or ku:InkomsttagareKU10/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:Fodelsetid or ku:InkomsttagareKU10/ku:AnnatIDNr or ku:InkomsttagareKU10/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU10/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU10/ku:Inkomsttagare) != 12) or not(number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,1,2)) = 16) or ((not(ku:KontantBruttolonMm) or number(ku:KontantBruttolonMm) = 0) and (not(ku:FormanUtomBilDrivmedel) or number(ku:FormanUtomBilDrivmedel) = 0) and (not(ku:BilformanUtomDrivmedel) or number(ku:BilformanUtomDrivmedel) = 0) and (not(ku:ErsMEgenavgifter) or number(ku:ErsMEgenavgifter) = 0))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU10/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU10/ku:Inkomsttagare) != 12) or not(number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,1,2)) = 16) or ((not(ku:KontantBruttolonMm) or number(ku:KontantBruttolonMm) = 0) and (not(ku:FormanUtomBilDrivmedel) or number(ku:FormanUtomBilDrivmedel) = 0) and (not(ku:BilformanUtomDrivmedel) or number(ku:BilformanUtomDrivmedel) = 0) and (not(ku:ErsMEgenavgifter) or number(ku:ErsMEgenavgifter) = 0))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>173#Du har fyllt i ersättning i form av lön m.m., fält 011 eller fält 025, eller förmån, fält 012 eller 013, när kontrolluppgiften avser en juridisk person. Ersättning till en juridisk person ska redovisas i fältet Ersättningar som inte är underlag för socialavgifter, fält 031</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:Fornamn or not(ku:InkomsttagareKU10/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:Fornamn or not(ku:InkomsttagareKU10/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU10/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU10/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU10/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU10/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:Efternamn or not(ku:InkomsttagareKU10/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:Efternamn or not(ku:InkomsttagareKU10/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU10/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU10/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU10/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU10/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:Gatuadress or not(ku:InkomsttagareKU10/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU10/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:Gatuadress or not(ku:InkomsttagareKU10/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU10/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU10/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU10/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU10/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU10/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU10/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU10/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:Gatuadress or not(ku:InkomsttagareKU10/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU10/ku:Inkomsttagare or ku:InkomsttagareKU10/ku:Fodelsetid or ku:InkomsttagareKU10/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:Gatuadress or not(ku:InkomsttagareKU10/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU10/ku:Inkomsttagare or ku:InkomsttagareKU10/ku:Fodelsetid or ku:InkomsttagareKU10/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:Postnummer or not(ku:InkomsttagareKU10/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU10/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:Postnummer or not(ku:InkomsttagareKU10/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU10/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU10/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU10/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU10/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU10/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU10/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU10/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:Postnummer or not(ku:InkomsttagareKU10/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU10/ku:Inkomsttagare or ku:InkomsttagareKU10/ku:Fodelsetid or ku:InkomsttagareKU10/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:Postnummer or not(ku:InkomsttagareKU10/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU10/ku:Inkomsttagare or ku:InkomsttagareKU10/ku:Fodelsetid or ku:InkomsttagareKU10/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:Postort or not(ku:InkomsttagareKU10/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU10/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:Postort or not(ku:InkomsttagareKU10/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU10/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU10/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU10/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU10/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU10/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU10/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU10/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:Postort or not(ku:InkomsttagareKU10/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU10/ku:Inkomsttagare or ku:InkomsttagareKU10/ku:Fodelsetid or ku:InkomsttagareKU10/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:Postort or not(ku:InkomsttagareKU10/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU10/ku:Inkomsttagare or ku:InkomsttagareKU10/ku:Fodelsetid or ku:InkomsttagareKU10/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU10/ku:FriAdress) or ku:InkomsttagareKU10/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU10/ku:FriAdress) or ku:InkomsttagareKU10/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU10/ku:Inkomsttagare) or not(ku:InkomsttagareKU10/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU10/ku:Inkomsttagare) or not(ku:InkomsttagareKU10/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU10/ku:OrgNamn) or (not(ku:InkomsttagareKU10/ku:Fodelsetid) and (not(ku:InkomsttagareKU10/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU10/ku:Fornamn) and not(ku:InkomsttagareKU10/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU10/ku:OrgNamn) or (not(ku:InkomsttagareKU10/ku:Fodelsetid) and (not(ku:InkomsttagareKU10/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU10/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU10/ku:Fornamn) and not(ku:InkomsttagareKU10/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU10/ku:OrgNamn or not(ku:InkomsttagareKU10/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU10/ku:Inkomsttagare or ku:InkomsttagareKU10/ku:Fornamn or ku:InkomsttagareKU10/ku:Efternamn or ku:InkomsttagareKU10/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU10/ku:OrgNamn or not(ku:InkomsttagareKU10/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU10/ku:Inkomsttagare or ku:InkomsttagareKU10/ku:Fornamn or ku:InkomsttagareKU10/ku:Efternamn or ku:InkomsttagareKU10/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU10/ku:LandskodTIN) or ku:InkomsttagareKU10/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU10/ku:LandskodTIN) or ku:InkomsttagareKU10/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU13" priority="1030" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU13"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or ku:Tjanstepension or ku:ErsEjSocAvg or ku:ErsFormanBostadMmSINK or ku:KontantBruttolonMm"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or ku:Tjanstepension or ku:ErsEjSocAvg or ku:ErsFormanBostadMmSINK or ku:KontantBruttolonMm">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>011#Kontrolluppgiften saknar helt ersättningar. Utan dessa är den alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:KontantBruttolonMm and not(ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:KontantBruttolonMm and not(ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>183#Fält 011 används enbart för ersättning där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe. Obs! Ersättningar som inte är underlag för arbetsgivaravgifter, t.ex. ersättningar under 1 000 kr redovisar du i fält 031</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:FormanUtomBilDrivmedel or ku:ErsEjSocAvg or (not(ku:BostadSmahus) and not(ku:BostadEjSmahus))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:FormanUtomBilDrivmedel or ku:ErsEjSocAvg or (not(ku:BostadSmahus) and not(ku:BostadEjSmahus))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>016#Du har markerat något eller båda av fält 041 och 043. Du ska då också fylla i ett belopp i fält där förmån redovisas</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:FormanUtomBilDrivmedel and not(ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:FormanUtomBilDrivmedel and not(ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>184#Fält 012 används enbart för förmån där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:BilformanUtomDrivmedel and not(ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:BilformanUtomDrivmedel and not(ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>185#Fält 013 används enbart för förmån där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:DrivmedelVidBilforman and not (ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:DrivmedelVidBilforman and not (ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>186#Fält 018 används enbart för förmån där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or not(ku:FormanHarJusterats) or ku:ErsEjSocAvg"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or not(ku:FormanHarJusterats) or ku:ErsEjSocAvg">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>039#Du har markerat Förmån har justerats, fält 048. Du ska då också fylla i ett belopp i fält där förmån redovisas</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU13/ku:TIN) or ku:InkomsttagareKU13/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU13/ku:TIN) or ku:InkomsttagareKU13/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:MedborgarskapEjSvenskt) or ku:LandskodMedborgare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:MedborgarskapEjSvenskt) or ku:LandskodMedborgare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>048#Felet förekommer ej på fil</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU13/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU13/ku:Inkomsttagare) or ku:UppgiftslamnareKU13/ku:UppgiftslamnarId != ku:InkomsttagareKU13/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU13/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU13/ku:Inkomsttagare) or ku:UppgiftslamnareKU13/ku:UppgiftslamnarId != ku:InkomsttagareKU13/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU13/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU13/ku:Inkomsttagare) + count(ku:InkomsttagareKU13/ku:Fodelsetid) + count(ku:InkomsttagareKU13/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU13/*) + count(//ku:InkomsttagareKU13/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU13/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU13/ku:Inkomsttagare) + count(ku:InkomsttagareKU13/ku:Fodelsetid) + count(ku:InkomsttagareKU13/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU13/*) + count(//ku:InkomsttagareKU13/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:Fodelsetid or ku:InkomsttagareKU13/ku:AnnatIDNr or ku:InkomsttagareKU13/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:Fodelsetid or ku:InkomsttagareKU13/ku:AnnatIDNr or ku:InkomsttagareKU13/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:Fornamn or not(ku:InkomsttagareKU13/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:Fornamn or not(ku:InkomsttagareKU13/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU13/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU13/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU13/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU13/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:Efternamn or not(ku:InkomsttagareKU13/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:Efternamn or not(ku:InkomsttagareKU13/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU13/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU13/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU13/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU13/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:Gatuadress or not(ku:InkomsttagareKU13/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU13/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:Gatuadress or not(ku:InkomsttagareKU13/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU13/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU13/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU13/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU13/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU13/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU13/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU13/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:Gatuadress or not(ku:InkomsttagareKU13/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU13/ku:Inkomsttagare or ku:InkomsttagareKU13/ku:Fodelsetid or ku:InkomsttagareKU13/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:Gatuadress or not(ku:InkomsttagareKU13/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU13/ku:Inkomsttagare or ku:InkomsttagareKU13/ku:Fodelsetid or ku:InkomsttagareKU13/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:Postnummer or not(ku:InkomsttagareKU13/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU13/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:Postnummer or not(ku:InkomsttagareKU13/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU13/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU13/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU13/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU13/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU13/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU13/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU13/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:Postnummer or not(ku:InkomsttagareKU13/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU13/ku:Inkomsttagare or ku:InkomsttagareKU13/ku:Fodelsetid or ku:InkomsttagareKU13/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:Postnummer or not(ku:InkomsttagareKU13/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU13/ku:Inkomsttagare or ku:InkomsttagareKU13/ku:Fodelsetid or ku:InkomsttagareKU13/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:Postort or not(ku:InkomsttagareKU13/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU13/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:Postort or not(ku:InkomsttagareKU13/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU13/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU13/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU13/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU13/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU13/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU13/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU13/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:Postort or not(ku:InkomsttagareKU13/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU13/ku:Inkomsttagare or ku:InkomsttagareKU13/ku:Fodelsetid or ku:InkomsttagareKU13/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:Postort or not(ku:InkomsttagareKU13/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU13/ku:Inkomsttagare or ku:InkomsttagareKU13/ku:Fodelsetid or ku:InkomsttagareKU13/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU13/ku:FriAdress) or ku:InkomsttagareKU13/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU13/ku:FriAdress) or ku:InkomsttagareKU13/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU13/ku:Inkomsttagare) or not(ku:InkomsttagareKU13/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU13/ku:Inkomsttagare) or not(ku:InkomsttagareKU13/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU13/ku:OrgNamn) or (not(ku:InkomsttagareKU13/ku:Fodelsetid) and (not(ku:InkomsttagareKU13/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU13/ku:Fornamn) and not(ku:InkomsttagareKU13/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU13/ku:OrgNamn) or (not(ku:InkomsttagareKU13/ku:Fodelsetid) and (not(ku:InkomsttagareKU13/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU13/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU13/ku:Fornamn) and not(ku:InkomsttagareKU13/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU13/ku:OrgNamn or not(ku:InkomsttagareKU13/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU13/ku:Inkomsttagare or ku:InkomsttagareKU13/ku:Fornamn or ku:InkomsttagareKU13/ku:Efternamn or ku:InkomsttagareKU13/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU13/ku:OrgNamn or not(ku:InkomsttagareKU13/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU13/ku:Inkomsttagare or ku:InkomsttagareKU13/ku:Fornamn or ku:InkomsttagareKU13/ku:Efternamn or ku:InkomsttagareKU13/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU13/ku:LandskodTIN) or ku:InkomsttagareKU13/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU13/ku:LandskodTIN) or ku:InkomsttagareKU13/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU14" priority="1029" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU14"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or ku:AndraKostnadsers or ku:ErsMEgenavgifter or ku:Tjanstepension or ku:ErsEjSocAvg or ku:Forskarskattenamnden or ku:Bilersattning or ku:Traktamente or ku:KontantBruttolonMm"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or ku:AndraKostnadsers or ku:ErsMEgenavgifter or ku:Tjanstepension or ku:ErsEjSocAvg or ku:Forskarskattenamnden or ku:Bilersattning or ku:Traktamente or ku:KontantBruttolonMm">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>012#Kontrolluppgiften saknar helt ersättningar. Utan dessa är den alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:KontantBruttolonMm and not(ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:KontantBruttolonMm and not(ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>183#Fält 011 används enbart för ersättning där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe. Obs! Ersättningar som inte är underlag för arbetsgivaravgifter, t.ex. ersättningar under 1 000 kr redovisar du i fält 031</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:FormanUtomBilDrivmedel or ku:ErsEjSocAvg or ku:ErsMEgenavgifter or (not(ku:BostadSmahus) and not(ku:BostadEjSmahus))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:FormanUtomBilDrivmedel or ku:ErsEjSocAvg or ku:ErsMEgenavgifter or (not(ku:BostadSmahus) and not(ku:BostadEjSmahus))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>015#Du har markerat något eller båda av fält 041 och 043. Du ska då också fylla i ett belopp i fält där förmån redovisas</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:FormanUtomBilDrivmedel or ku:ErsEjSocAvg or ku:ErsMEgenavgifter or (not(ku:UnderlagRutarbete) and not(ku:UnderlagRotarbete))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:FormanUtomBilDrivmedel or ku:ErsEjSocAvg or ku:ErsMEgenavgifter or (not(ku:UnderlagRutarbete) and not(ku:UnderlagRotarbete))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>017#Du har fyllt i underlag för skattereduktion för rut-/rotarbete, fält 021 - 022. Du ska då också fylla i ett belopp i fält där förmån redovisas</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:FormanUtomBilDrivmedel and not(ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:FormanUtomBilDrivmedel and not(ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>184#Fält 012 används enbart för förmån där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:BilformanUtomDrivmedel and not(ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:BilformanUtomDrivmedel and not(ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>185#Fält 013 används enbart för förmån där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:DrivmedelVidBilforman and not (ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:DrivmedelVidBilforman and not (ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>186#Fält 018 används enbart för förmån där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:SocialAvgiftsAvtal) or not(ku:ErsMEgenavgifter)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:SocialAvgiftsAvtal) or not(ku:ErsMEgenavgifter)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>139#Du har markerat Socialavgiftsavtal finns, fält 093, dvs. ett avtal finns om att den anställde ska redovisa och betala arbetsgivaravgifterna i arbetsgivarens ställe. Du kan därför inte också fylla i fält 025 som gäller ersättningar till personer, som utan att vara näringsidkare ändå ska betala egenavgifter</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or not(ku:FormanHarJusterats) or ku:ErsEjSocAvg or ku:ErsMEgenavgifter"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or not(ku:FormanHarJusterats) or ku:ErsEjSocAvg or ku:ErsMEgenavgifter">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>038#Du har markerat Förmån har justerats, fält 048. Du ska då också fylla i ett belopp i fält där förmån redovisas</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or not(ku:FormanSomPension)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:FormanUtomBilDrivmedel or ku:BilformanUtomDrivmedel or not(ku:FormanSomPension)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>040#Du har markerat Förmån som pension, fält 049. Du ska då också fylla i ett belopp i Skattepliktiga förmåner utom bilförmån och drivmedel vid bilförmån, fält 012, eller Skattepliktig bilförmån utom drivmedel, fält 013</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU14/ku:TIN) or ku:InkomsttagareKU14/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU14/ku:TIN) or ku:InkomsttagareKU14/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:MedborgarskapEjSvenskt) or ku:LandskodMedborgare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:MedborgarskapEjSvenskt) or ku:LandskodMedborgare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>048#Felet förekommer ej på fil</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Arbetsland) or ku:LandskodArbetsland"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Arbetsland) or ku:LandskodArbetsland">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>049#Felet förekommer ej på fil</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Kategori or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Kategori or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>050#Kategori, Ett av alternativen A - F, fält 092, ska alltid anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU14/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU14/ku:Inkomsttagare) or ku:UppgiftslamnareKU14/ku:UppgiftslamnarId != ku:InkomsttagareKU14/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU14/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU14/ku:Inkomsttagare) or ku:UppgiftslamnareKU14/ku:UppgiftslamnarId != ku:InkomsttagareKU14/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU14/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU14/ku:Inkomsttagare) + count(ku:InkomsttagareKU14/ku:Fodelsetid) + count(ku:InkomsttagareKU14/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU14/*) + count(//ku:InkomsttagareKU14/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU14/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU14/ku:Inkomsttagare) + count(ku:InkomsttagareKU14/ku:Fodelsetid) + count(ku:InkomsttagareKU14/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU14/*) + count(//ku:InkomsttagareKU14/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:Fodelsetid or ku:InkomsttagareKU14/ku:AnnatIDNr or ku:InkomsttagareKU14/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:Fodelsetid or ku:InkomsttagareKU14/ku:AnnatIDNr or ku:InkomsttagareKU14/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:Fornamn or not(ku:InkomsttagareKU14/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:Fornamn or not(ku:InkomsttagareKU14/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU14/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU14/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU14/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU14/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:Efternamn or not(ku:InkomsttagareKU14/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:Efternamn or not(ku:InkomsttagareKU14/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU14/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU14/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU14/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU14/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:Gatuadress or not(ku:InkomsttagareKU14/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU14/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:Gatuadress or not(ku:InkomsttagareKU14/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU14/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU14/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU14/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU14/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU14/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU14/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU14/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:Gatuadress or not(ku:InkomsttagareKU14/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU14/ku:Inkomsttagare or ku:InkomsttagareKU14/ku:Fodelsetid or ku:InkomsttagareKU14/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:Gatuadress or not(ku:InkomsttagareKU14/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU14/ku:Inkomsttagare or ku:InkomsttagareKU14/ku:Fodelsetid or ku:InkomsttagareKU14/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:Postnummer or not(ku:InkomsttagareKU14/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU14/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:Postnummer or not(ku:InkomsttagareKU14/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU14/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU14/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU14/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU14/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU14/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU14/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU14/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:Postnummer or not(ku:InkomsttagareKU14/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU14/ku:Inkomsttagare or ku:InkomsttagareKU14/ku:Fodelsetid or ku:InkomsttagareKU14/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:Postnummer or not(ku:InkomsttagareKU14/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU14/ku:Inkomsttagare or ku:InkomsttagareKU14/ku:Fodelsetid or ku:InkomsttagareKU14/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:Postort or not(ku:InkomsttagareKU14/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU14/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:Postort or not(ku:InkomsttagareKU14/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU14/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU14/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU14/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU14/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU14/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU14/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU14/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:Postort or not(ku:InkomsttagareKU14/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU14/ku:Inkomsttagare or ku:InkomsttagareKU14/ku:Fodelsetid or ku:InkomsttagareKU14/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:Postort or not(ku:InkomsttagareKU14/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU14/ku:Inkomsttagare or ku:InkomsttagareKU14/ku:Fodelsetid or ku:InkomsttagareKU14/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU14/ku:FriAdress) or ku:InkomsttagareKU14/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU14/ku:FriAdress) or ku:InkomsttagareKU14/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU14/ku:Inkomsttagare) or not(ku:InkomsttagareKU14/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU14/ku:Inkomsttagare) or not(ku:InkomsttagareKU14/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU14/ku:OrgNamn) or (not(ku:InkomsttagareKU14/ku:Fodelsetid) and (not(ku:InkomsttagareKU14/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU14/ku:Fornamn) and not(ku:InkomsttagareKU14/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU14/ku:OrgNamn) or (not(ku:InkomsttagareKU14/ku:Fodelsetid) and (not(ku:InkomsttagareKU14/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU14/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU14/ku:Fornamn) and not(ku:InkomsttagareKU14/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU14/ku:OrgNamn or not(ku:InkomsttagareKU14/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU14/ku:Inkomsttagare or ku:InkomsttagareKU14/ku:Fornamn or ku:InkomsttagareKU14/ku:Efternamn or ku:InkomsttagareKU14/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU14/ku:OrgNamn or not(ku:InkomsttagareKU14/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU14/ku:Inkomsttagare or ku:InkomsttagareKU14/ku:Fornamn or ku:InkomsttagareKU14/ku:Efternamn or ku:InkomsttagareKU14/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU14/ku:LandskodTIN) or ku:InkomsttagareKU14/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU14/ku:LandskodTIN) or ku:InkomsttagareKU14/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU16" priority="1028" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU16"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:FormanUtomBilDrivmedel or ku:AndraKostnadsers or ku:ErsEjSocAvg or ku:Traktamente or ku:KontantBruttolonMm"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:FormanUtomBilDrivmedel or ku:AndraKostnadsers or ku:ErsEjSocAvg or ku:Traktamente or ku:KontantBruttolonMm">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>013#Kontrolluppgiften saknar helt ersättningar. Utan dessa är den alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:KontantBruttolonMm and not(ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:KontantBruttolonMm and not(ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>183#Fält 011 används enbart för ersättning där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe. Obs! Ersättningar som inte är underlag för arbetsgivaravgifter, t.ex. ersättningar under 1 000 kr redovisar du i fält 031</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:FormanUtomBilDrivmedel and not(ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:FormanUtomBilDrivmedel and not(ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>184#Fält 012 används enbart för förmån där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Fartygssignal"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Fartygssignal">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>031#Fartygssignal, fält 026, ska alltid fyllas i</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:AntalDagarSjoinkomst"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:AntalDagarSjoinkomst">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>032#Antal dagar med sjöinkomst, fält 027, ska alltid fyllas i</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:NarfartFjarrfart"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:NarfartFjarrfart">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>033#Närfart/Fjärrfart, fält 028, ska alltid anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU16/ku:TIN) or ku:InkomsttagareKU16/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU16/ku:TIN) or ku:InkomsttagareKU16/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU16/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU16/ku:Inkomsttagare) or ku:UppgiftslamnareKU16/ku:UppgiftslamnarId != ku:InkomsttagareKU16/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU16/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU16/ku:Inkomsttagare) or ku:UppgiftslamnareKU16/ku:UppgiftslamnarId != ku:InkomsttagareKU16/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU16/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU16/ku:Inkomsttagare) + count(ku:InkomsttagareKU16/ku:Fodelsetid) + count(ku:InkomsttagareKU16/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU16/*) + count(//ku:InkomsttagareKU16/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU16/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU16/ku:Inkomsttagare) + count(ku:InkomsttagareKU16/ku:Fodelsetid) + count(ku:InkomsttagareKU16/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU16/*) + count(//ku:InkomsttagareKU16/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:Fodelsetid or ku:InkomsttagareKU16/ku:AnnatIDNr or ku:InkomsttagareKU16/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:Fodelsetid or ku:InkomsttagareKU16/ku:AnnatIDNr or ku:InkomsttagareKU16/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:Fornamn or not(ku:InkomsttagareKU16/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:Fornamn or not(ku:InkomsttagareKU16/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU16/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU16/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU16/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU16/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:Efternamn or not(ku:InkomsttagareKU16/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:Efternamn or not(ku:InkomsttagareKU16/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU16/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU16/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU16/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU16/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:Gatuadress or not(ku:InkomsttagareKU16/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU16/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:Gatuadress or not(ku:InkomsttagareKU16/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU16/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU16/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU16/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU16/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU16/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU16/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU16/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:Gatuadress or not(ku:InkomsttagareKU16/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU16/ku:Inkomsttagare or ku:InkomsttagareKU16/ku:Fodelsetid or ku:InkomsttagareKU16/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:Gatuadress or not(ku:InkomsttagareKU16/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU16/ku:Inkomsttagare or ku:InkomsttagareKU16/ku:Fodelsetid or ku:InkomsttagareKU16/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:Postnummer or not(ku:InkomsttagareKU16/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU16/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:Postnummer or not(ku:InkomsttagareKU16/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU16/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU16/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU16/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU16/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU16/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU16/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU16/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:Postnummer or not(ku:InkomsttagareKU16/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU16/ku:Inkomsttagare or ku:InkomsttagareKU16/ku:Fodelsetid or ku:InkomsttagareKU16/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:Postnummer or not(ku:InkomsttagareKU16/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU16/ku:Inkomsttagare or ku:InkomsttagareKU16/ku:Fodelsetid or ku:InkomsttagareKU16/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:Postort or not(ku:InkomsttagareKU16/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU16/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:Postort or not(ku:InkomsttagareKU16/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU16/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU16/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU16/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU16/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU16/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU16/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU16/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:Postort or not(ku:InkomsttagareKU16/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU16/ku:Inkomsttagare or ku:InkomsttagareKU16/ku:Fodelsetid or ku:InkomsttagareKU16/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:Postort or not(ku:InkomsttagareKU16/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU16/ku:Inkomsttagare or ku:InkomsttagareKU16/ku:Fodelsetid or ku:InkomsttagareKU16/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU16/ku:FriAdress) or ku:InkomsttagareKU16/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU16/ku:FriAdress) or ku:InkomsttagareKU16/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU16/ku:Inkomsttagare) or not(ku:InkomsttagareKU16/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU16/ku:Inkomsttagare) or not(ku:InkomsttagareKU16/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:FartygetsNamn"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:FartygetsNamn">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>064#Fältet Fartygets namn, fält 223, ska alltid fyllas i</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU16/ku:OrgNamn) or (not(ku:InkomsttagareKU16/ku:Fodelsetid) and (not(ku:InkomsttagareKU16/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU16/ku:Fornamn) and not(ku:InkomsttagareKU16/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU16/ku:OrgNamn) or (not(ku:InkomsttagareKU16/ku:Fodelsetid) and (not(ku:InkomsttagareKU16/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU16/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU16/ku:Fornamn) and not(ku:InkomsttagareKU16/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU16/ku:OrgNamn or not(ku:InkomsttagareKU16/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU16/ku:Inkomsttagare or ku:InkomsttagareKU16/ku:Fornamn or ku:InkomsttagareKU16/ku:Efternamn or ku:InkomsttagareKU16/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU16/ku:OrgNamn or not(ku:InkomsttagareKU16/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU16/ku:Inkomsttagare or ku:InkomsttagareKU16/ku:Fornamn or ku:InkomsttagareKU16/ku:Efternamn or ku:InkomsttagareKU16/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU16/ku:LandskodTIN) or ku:InkomsttagareKU16/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU16/ku:LandskodTIN) or ku:InkomsttagareKU16/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU17" priority="1027" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU17"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:FormanUtomBilDrivmedel or ku:ErsEjSocAvg or ku:KontantBruttolonMm"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:FormanUtomBilDrivmedel or ku:ErsEjSocAvg or ku:KontantBruttolonMm">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>014#Kontrolluppgiften saknar helt ersättningar. Utan dessa är den alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:KontantBruttolonMm and not(ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:KontantBruttolonMm and not(ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>183#Fält 011 används enbart för ersättning där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe. Obs! Ersättningar som inte är underlag för arbetsgivaravgifter, t.ex. ersättningar under 1 000 kr redovisar du i fält 031</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:FormanUtomBilDrivmedel and not(ku:SocialAvgiftsAvtal))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:FormanUtomBilDrivmedel and not(ku:SocialAvgiftsAvtal))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>184#Fält 012 används enbart för förmån där socialavgiftsavtal tecknats (fält 093) dvs. du är en utländsk arbetsgivare som tecknat avtal om att den anställde ska redovisa och betala arbetsgivaravgifter i arbetsgivarens ställe</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Fartygssignal"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Fartygssignal">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>031#Fartygssignal, fält 026, ska alltid fyllas i</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:AntalDagarSjoinkomst"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:AntalDagarSjoinkomst">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>032#Antal dagar med sjöinkomst, fält 027, ska alltid fyllas i</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:NarfartFjarrfart"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:NarfartFjarrfart">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>033#Närfart/Fjärrfart, fält 028, ska alltid anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU17/ku:TIN) or ku:InkomsttagareKU17/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU17/ku:TIN) or ku:InkomsttagareKU17/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:MedborgarskapEjSvenskt) or ku:LandskodMedborgare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:MedborgarskapEjSvenskt) or ku:LandskodMedborgare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>048#Felet förekommer ej på fil</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU17/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU17/ku:Inkomsttagare) or ku:UppgiftslamnareKU17/ku:UppgiftslamnarId != ku:InkomsttagareKU17/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU17/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU17/ku:Inkomsttagare) or ku:UppgiftslamnareKU17/ku:UppgiftslamnarId != ku:InkomsttagareKU17/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU17/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU17/ku:Inkomsttagare) + count(ku:InkomsttagareKU17/ku:Fodelsetid) + count(ku:InkomsttagareKU17/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU17/*) + count(//ku:InkomsttagareKU17/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU17/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU17/ku:Inkomsttagare) + count(ku:InkomsttagareKU17/ku:Fodelsetid) + count(ku:InkomsttagareKU17/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU17/*) + count(//ku:InkomsttagareKU17/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:Fodelsetid or ku:InkomsttagareKU17/ku:AnnatIDNr or ku:InkomsttagareKU17/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:Fodelsetid or ku:InkomsttagareKU17/ku:AnnatIDNr or ku:InkomsttagareKU17/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:Fornamn or not(ku:InkomsttagareKU17/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:Fornamn or not(ku:InkomsttagareKU17/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU17/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU17/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU17/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU17/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:Efternamn or not(ku:InkomsttagareKU17/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:Efternamn or not(ku:InkomsttagareKU17/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU17/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU17/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU17/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU17/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:Gatuadress or not(ku:InkomsttagareKU17/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU17/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:Gatuadress or not(ku:InkomsttagareKU17/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU17/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU17/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU17/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU17/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU17/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU17/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU17/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:Gatuadress or not(ku:InkomsttagareKU17/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU17/ku:Inkomsttagare or ku:InkomsttagareKU17/ku:Fodelsetid or ku:InkomsttagareKU17/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:Gatuadress or not(ku:InkomsttagareKU17/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU17/ku:Inkomsttagare or ku:InkomsttagareKU17/ku:Fodelsetid or ku:InkomsttagareKU17/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:Postnummer or not(ku:InkomsttagareKU17/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU17/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:Postnummer or not(ku:InkomsttagareKU17/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU17/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU17/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU17/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU17/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU17/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU17/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU17/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:Postnummer or not(ku:InkomsttagareKU17/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU17/ku:Inkomsttagare or ku:InkomsttagareKU17/ku:Fodelsetid or ku:InkomsttagareKU17/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:Postnummer or not(ku:InkomsttagareKU17/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU17/ku:Inkomsttagare or ku:InkomsttagareKU17/ku:Fodelsetid or ku:InkomsttagareKU17/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:Postort or not(ku:InkomsttagareKU17/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU17/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:Postort or not(ku:InkomsttagareKU17/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU17/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU17/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU17/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU17/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU17/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU17/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU17/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:Postort or not(ku:InkomsttagareKU17/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU17/ku:Inkomsttagare or ku:InkomsttagareKU17/ku:Fodelsetid or ku:InkomsttagareKU17/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:Postort or not(ku:InkomsttagareKU17/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU17/ku:Inkomsttagare or ku:InkomsttagareKU17/ku:Fodelsetid or ku:InkomsttagareKU17/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU17/ku:FriAdress) or ku:InkomsttagareKU17/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU17/ku:FriAdress) or ku:InkomsttagareKU17/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU17/ku:Inkomsttagare) or not(ku:InkomsttagareKU17/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU17/ku:Inkomsttagare) or not(ku:InkomsttagareKU17/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:FartygetsNamn"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:FartygetsNamn">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>064#Fältet Fartygets namn, fält 223, ska alltid fyllas i</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU17/ku:OrgNamn) or (not(ku:InkomsttagareKU17/ku:Fodelsetid) and (not(ku:InkomsttagareKU17/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU17/ku:Fornamn) and not(ku:InkomsttagareKU17/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU17/ku:OrgNamn) or (not(ku:InkomsttagareKU17/ku:Fodelsetid) and (not(ku:InkomsttagareKU17/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU17/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU17/ku:Fornamn) and not(ku:InkomsttagareKU17/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU17/ku:OrgNamn or not(ku:InkomsttagareKU17/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU17/ku:Inkomsttagare or ku:InkomsttagareKU17/ku:Fornamn or ku:InkomsttagareKU17/ku:Efternamn or ku:InkomsttagareKU17/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU17/ku:OrgNamn or not(ku:InkomsttagareKU17/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU17/ku:Inkomsttagare or ku:InkomsttagareKU17/ku:Fornamn or ku:InkomsttagareKU17/ku:Efternamn or ku:InkomsttagareKU17/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU17/ku:LandskodTIN) or ku:InkomsttagareKU17/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU17/ku:LandskodTIN) or ku:InkomsttagareKU17/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU18" priority="1026" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU18"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:AvdragenSkatt or ku:Borttag or ku:Ersattningskod or ku:ErsattningBelopp"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:AvdragenSkatt or ku:Borttag or ku:Ersattningskod or ku:ErsattningBelopp">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>001#Kontrolluppgiften saknar såväl ersättningar som avdragen skatt. Utan dessa värden är den alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:ErsattningBelopp) or ku:Ersattningskod"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:ErsattningBelopp) or ku:Ersattningskod">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>007#Om du har fyllt i ett ersättningsbelopp ska du också ange vad ersättningen avser</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Ersattningskod) or ku:ErsattningBelopp"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Ersattningskod) or ku:ErsattningBelopp">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>008#Du har angett en typ av ersättning. Du behöver också fylla i ett ersättningsbelopp</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU18/ku:TIN) or ku:InkomsttagareKU18/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU18/ku:TIN) or ku:InkomsttagareKU18/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU18/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU18/ku:Inkomsttagare) or ku:UppgiftslamnareKU18/ku:UppgiftslamnarId != ku:InkomsttagareKU18/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU18/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU18/ku:Inkomsttagare) or ku:UppgiftslamnareKU18/ku:UppgiftslamnarId != ku:InkomsttagareKU18/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU18/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU18/ku:Inkomsttagare) + count(ku:InkomsttagareKU18/ku:Fodelsetid) + count(ku:InkomsttagareKU18/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU18/*) + count(//ku:InkomsttagareKU18/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU18/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU18/ku:Inkomsttagare) + count(ku:InkomsttagareKU18/ku:Fodelsetid) + count(ku:InkomsttagareKU18/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU18/*) + count(//ku:InkomsttagareKU18/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:Fodelsetid or ku:InkomsttagareKU18/ku:AnnatIDNr or ku:InkomsttagareKU18/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:Fodelsetid or ku:InkomsttagareKU18/ku:AnnatIDNr or ku:InkomsttagareKU18/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:Fornamn or not(ku:InkomsttagareKU18/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:Fornamn or not(ku:InkomsttagareKU18/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU18/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU18/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU18/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU18/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:Efternamn or not(ku:InkomsttagareKU18/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:Efternamn or not(ku:InkomsttagareKU18/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU18/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU18/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU18/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU18/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:Gatuadress or not(ku:InkomsttagareKU18/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU18/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:Gatuadress or not(ku:InkomsttagareKU18/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU18/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU18/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU18/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU18/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU18/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU18/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU18/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:Gatuadress or not(ku:InkomsttagareKU18/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU18/ku:Inkomsttagare or ku:InkomsttagareKU18/ku:Fodelsetid or ku:InkomsttagareKU18/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:Gatuadress or not(ku:InkomsttagareKU18/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU18/ku:Inkomsttagare or ku:InkomsttagareKU18/ku:Fodelsetid or ku:InkomsttagareKU18/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:Postnummer or not(ku:InkomsttagareKU18/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU18/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:Postnummer or not(ku:InkomsttagareKU18/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU18/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU18/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU18/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU18/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU18/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU18/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU18/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:Postnummer or not(ku:InkomsttagareKU18/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU18/ku:Inkomsttagare or ku:InkomsttagareKU18/ku:Fodelsetid or ku:InkomsttagareKU18/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:Postnummer or not(ku:InkomsttagareKU18/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU18/ku:Inkomsttagare or ku:InkomsttagareKU18/ku:Fodelsetid or ku:InkomsttagareKU18/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:Postort or not(ku:InkomsttagareKU18/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU18/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:Postort or not(ku:InkomsttagareKU18/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU18/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU18/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU18/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU18/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU18/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU18/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU18/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:Postort or not(ku:InkomsttagareKU18/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU18/ku:Inkomsttagare or ku:InkomsttagareKU18/ku:Fodelsetid or ku:InkomsttagareKU18/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:Postort or not(ku:InkomsttagareKU18/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU18/ku:Inkomsttagare or ku:InkomsttagareKU18/ku:Fodelsetid or ku:InkomsttagareKU18/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU18/ku:FriAdress) or ku:InkomsttagareKU18/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU18/ku:FriAdress) or ku:InkomsttagareKU18/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU18/ku:Inkomsttagare) or not(ku:InkomsttagareKU18/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU18/ku:Inkomsttagare) or not(ku:InkomsttagareKU18/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU18/ku:OrgNamn) or (not(ku:InkomsttagareKU18/ku:Fodelsetid) and (not(ku:InkomsttagareKU18/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU18/ku:Fornamn) and not(ku:InkomsttagareKU18/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU18/ku:OrgNamn) or (not(ku:InkomsttagareKU18/ku:Fodelsetid) and (not(ku:InkomsttagareKU18/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU18/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU18/ku:Fornamn) and not(ku:InkomsttagareKU18/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU18/ku:OrgNamn or not(ku:InkomsttagareKU18/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU18/ku:Inkomsttagare or ku:InkomsttagareKU18/ku:Fornamn or ku:InkomsttagareKU18/ku:Efternamn or ku:InkomsttagareKU18/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU18/ku:OrgNamn or not(ku:InkomsttagareKU18/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU18/ku:Inkomsttagare or ku:InkomsttagareKU18/ku:Fornamn or ku:InkomsttagareKU18/ku:Efternamn or ku:InkomsttagareKU18/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU18/ku:LandskodTIN) or ku:InkomsttagareKU18/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU18/ku:LandskodTIN) or ku:InkomsttagareKU18/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU19" priority="1025" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU19"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:AvdragenSkatt or ku:Borttag or ku:Ersattningskod or ku:ErsattningBelopp"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:AvdragenSkatt or ku:Borttag or ku:Ersattningskod or ku:ErsattningBelopp">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>001#Kontrolluppgiften saknar såväl ersättningar som avdragen skatt. Utan dessa värden är den alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:ErsattningBelopp) or ku:Ersattningskod"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:ErsattningBelopp) or ku:Ersattningskod">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>007#Om du har fyllt i ett ersättningsbelopp ska du också ange vad ersättningen avser</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Ersattningskod) or ku:ErsattningBelopp"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Ersattningskod) or ku:ErsattningBelopp">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>008#Du har angett en typ av ersättning. Du behöver också fylla i ett ersättningsbelopp</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU19/ku:TIN) or ku:InkomsttagareKU19/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU19/ku:TIN) or ku:InkomsttagareKU19/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:MedborgarskapEjSvenskt) or ku:LandskodMedborgare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:MedborgarskapEjSvenskt) or ku:LandskodMedborgare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>048#Felet förekommer ej på fil</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU19/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU19/ku:Inkomsttagare) or ku:UppgiftslamnareKU19/ku:UppgiftslamnarId != ku:InkomsttagareKU19/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU19/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU19/ku:Inkomsttagare) or ku:UppgiftslamnareKU19/ku:UppgiftslamnarId != ku:InkomsttagareKU19/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU19/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU19/ku:Inkomsttagare) + count(ku:InkomsttagareKU19/ku:Fodelsetid) + count(ku:InkomsttagareKU19/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU19/*) + count(//ku:InkomsttagareKU19/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU19/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU19/ku:Inkomsttagare) + count(ku:InkomsttagareKU19/ku:Fodelsetid) + count(ku:InkomsttagareKU19/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU19/*) + count(//ku:InkomsttagareKU19/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:Fodelsetid or ku:InkomsttagareKU19/ku:AnnatIDNr or ku:InkomsttagareKU19/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:Fodelsetid or ku:InkomsttagareKU19/ku:AnnatIDNr or ku:InkomsttagareKU19/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:Fornamn or not(ku:InkomsttagareKU19/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:Fornamn or not(ku:InkomsttagareKU19/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU19/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU19/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU19/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU19/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:Efternamn or not(ku:InkomsttagareKU19/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:Efternamn or not(ku:InkomsttagareKU19/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU19/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU19/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU19/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU19/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:Gatuadress or not(ku:InkomsttagareKU19/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU19/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:Gatuadress or not(ku:InkomsttagareKU19/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU19/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU19/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU19/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU19/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU19/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU19/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU19/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:Gatuadress or not(ku:InkomsttagareKU19/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU19/ku:Inkomsttagare or ku:InkomsttagareKU19/ku:Fodelsetid or ku:InkomsttagareKU19/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:Gatuadress or not(ku:InkomsttagareKU19/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU19/ku:Inkomsttagare or ku:InkomsttagareKU19/ku:Fodelsetid or ku:InkomsttagareKU19/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:Postnummer or not(ku:InkomsttagareKU19/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU19/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:Postnummer or not(ku:InkomsttagareKU19/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU19/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU19/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU19/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU19/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU19/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU19/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU19/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:Postnummer or not(ku:InkomsttagareKU19/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU19/ku:Inkomsttagare or ku:InkomsttagareKU19/ku:Fodelsetid or ku:InkomsttagareKU19/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:Postnummer or not(ku:InkomsttagareKU19/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU19/ku:Inkomsttagare or ku:InkomsttagareKU19/ku:Fodelsetid or ku:InkomsttagareKU19/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:Postort or not(ku:InkomsttagareKU19/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU19/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:Postort or not(ku:InkomsttagareKU19/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU19/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU19/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU19/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU19/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU19/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU19/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU19/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:Postort or not(ku:InkomsttagareKU19/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU19/ku:Inkomsttagare or ku:InkomsttagareKU19/ku:Fodelsetid or ku:InkomsttagareKU19/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:Postort or not(ku:InkomsttagareKU19/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU19/ku:Inkomsttagare or ku:InkomsttagareKU19/ku:Fodelsetid or ku:InkomsttagareKU19/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU19/ku:FriAdress) or ku:InkomsttagareKU19/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU19/ku:FriAdress) or ku:InkomsttagareKU19/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU19/ku:Inkomsttagare) or not(ku:InkomsttagareKU19/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU19/ku:Inkomsttagare) or not(ku:InkomsttagareKU19/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU19/ku:OrgNamn) or (not(ku:InkomsttagareKU19/ku:Fodelsetid) and (not(ku:InkomsttagareKU19/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU19/ku:Fornamn) and not(ku:InkomsttagareKU19/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU19/ku:OrgNamn) or (not(ku:InkomsttagareKU19/ku:Fodelsetid) and (not(ku:InkomsttagareKU19/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU19/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU19/ku:Fornamn) and not(ku:InkomsttagareKU19/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU19/ku:OrgNamn or not(ku:InkomsttagareKU19/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU19/ku:Inkomsttagare or ku:InkomsttagareKU19/ku:Fornamn or ku:InkomsttagareKU19/ku:Efternamn or ku:InkomsttagareKU19/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU19/ku:OrgNamn or not(ku:InkomsttagareKU19/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU19/ku:Inkomsttagare or ku:InkomsttagareKU19/ku:Fornamn or ku:InkomsttagareKU19/ku:Efternamn or ku:InkomsttagareKU19/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU19/ku:LandskodTIN) or ku:InkomsttagareKU19/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU19/ku:LandskodTIN) or ku:InkomsttagareKU19/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU20" priority="1024" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU20"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU20/ku:TIN) or ku:InkomsttagareKU20/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU20/ku:TIN) or ku:InkomsttagareKU20/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU20/ku:Fodelseort) or ku:InkomsttagareKU20/ku:LandskodFodelseort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU20/ku:Fodelseort) or ku:InkomsttagareKU20/ku:LandskodFodelseort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>046#Du har angett Födelseort, fält 077. Då ska du också ange i vilket land födelseorten ligger i fält 078</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU20/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU20/ku:Inkomsttagare) or ku:UppgiftslamnareKU20/ku:UppgiftslamnarId != ku:InkomsttagareKU20/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU20/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU20/ku:Inkomsttagare) or ku:UppgiftslamnareKU20/ku:UppgiftslamnarId != ku:InkomsttagareKU20/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU20/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU20/ku:Inkomsttagare) + count(ku:InkomsttagareKU20/ku:Fodelsetid) + count(ku:InkomsttagareKU20/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU20/*) + count(//ku:InkomsttagareKU20/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU20/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU20/ku:Inkomsttagare) + count(ku:InkomsttagareKU20/ku:Fodelsetid) + count(ku:InkomsttagareKU20/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU20/*) + count(//ku:InkomsttagareKU20/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:Fodelsetid or ku:InkomsttagareKU20/ku:AnnatIDNr or ku:InkomsttagareKU20/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:Fodelsetid or ku:InkomsttagareKU20/ku:AnnatIDNr or ku:InkomsttagareKU20/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:Fornamn or not(ku:InkomsttagareKU20/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:Fornamn or not(ku:InkomsttagareKU20/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU20/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU20/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU20/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU20/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:Efternamn or not(ku:InkomsttagareKU20/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:Efternamn or not(ku:InkomsttagareKU20/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU20/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU20/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU20/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU20/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:Gatuadress or not(ku:InkomsttagareKU20/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU20/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:Gatuadress or not(ku:InkomsttagareKU20/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU20/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU20/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU20/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU20/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU20/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU20/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU20/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:Gatuadress or not(ku:InkomsttagareKU20/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU20/ku:Inkomsttagare or ku:InkomsttagareKU20/ku:Fodelsetid or ku:InkomsttagareKU20/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:Gatuadress or not(ku:InkomsttagareKU20/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU20/ku:Inkomsttagare or ku:InkomsttagareKU20/ku:Fodelsetid or ku:InkomsttagareKU20/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:Postnummer or not(ku:InkomsttagareKU20/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU20/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:Postnummer or not(ku:InkomsttagareKU20/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU20/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU20/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU20/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU20/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU20/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU20/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU20/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:Postnummer or not(ku:InkomsttagareKU20/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU20/ku:Inkomsttagare or ku:InkomsttagareKU20/ku:Fodelsetid or ku:InkomsttagareKU20/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:Postnummer or not(ku:InkomsttagareKU20/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU20/ku:Inkomsttagare or ku:InkomsttagareKU20/ku:Fodelsetid or ku:InkomsttagareKU20/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:Postort or not(ku:InkomsttagareKU20/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU20/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:Postort or not(ku:InkomsttagareKU20/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU20/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU20/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU20/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU20/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU20/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU20/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU20/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:Postort or not(ku:InkomsttagareKU20/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU20/ku:Inkomsttagare or ku:InkomsttagareKU20/ku:Fodelsetid or ku:InkomsttagareKU20/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:Postort or not(ku:InkomsttagareKU20/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU20/ku:Inkomsttagare or ku:InkomsttagareKU20/ku:Fodelsetid or ku:InkomsttagareKU20/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU20/ku:FriAdress) or ku:InkomsttagareKU20/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU20/ku:FriAdress) or ku:InkomsttagareKU20/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU20/ku:Inkomsttagare) or not(ku:InkomsttagareKU20/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU20/ku:Inkomsttagare) or not(ku:InkomsttagareKU20/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU20/ku:OrgNamn) or (not(ku:InkomsttagareKU20/ku:Fodelsetid) and (not(ku:InkomsttagareKU20/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU20/ku:Fornamn) and not(ku:InkomsttagareKU20/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU20/ku:OrgNamn) or (not(ku:InkomsttagareKU20/ku:Fodelsetid) and (not(ku:InkomsttagareKU20/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU20/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU20/ku:Fornamn) and not(ku:InkomsttagareKU20/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU20/ku:OrgNamn or not(ku:InkomsttagareKU20/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU20/ku:Inkomsttagare or ku:InkomsttagareKU20/ku:Fornamn or ku:InkomsttagareKU20/ku:Efternamn or ku:InkomsttagareKU20/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU20/ku:OrgNamn or not(ku:InkomsttagareKU20/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU20/ku:Inkomsttagare or ku:InkomsttagareKU20/ku:Fornamn or ku:InkomsttagareKU20/ku:Efternamn or ku:InkomsttagareKU20/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU20/ku:LandskodTIN) or ku:InkomsttagareKU20/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU20/ku:LandskodTIN) or ku:InkomsttagareKU20/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:AvdragenSkatt or ku:RanteinkomstEjKonto or ku:AnnanInkomst or ku:Ranteinkomst"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:AvdragenSkatt or ku:RanteinkomstEjKonto or ku:AnnanInkomst or ku:Ranteinkomst">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>070#Kontrolluppgiften saknar både inkomster och avdragen skatt. Utan dessa värden är den alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Forfogarkonto) or (not(ku:RanteinkomstEjKonto) and not(ku:AnnanInkomst))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Forfogarkonto) or (not(ku:RanteinkomstEjKonto) and not(ku:AnnanInkomst))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>071#Du har angett att kontrolluppgiften avser ett förfogarkonto. Du kan då inte ha värden i fälten Ränteinkomst, ej konto, fält 503, eller Annan inkomst, fält 504</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU21" priority="1023" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU21"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU21/ku:TIN) or ku:InkomsttagareKU21/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU21/ku:TIN) or ku:InkomsttagareKU21/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU21/ku:Fodelseort) or ku:InkomsttagareKU21/ku:LandskodFodelseort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU21/ku:Fodelseort) or ku:InkomsttagareKU21/ku:LandskodFodelseort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>046#Du har angett Födelseort, fält 077. Då ska du också ange i vilket land födelseorten ligger i fält 078</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU21/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU21/ku:Inkomsttagare) or ku:UppgiftslamnareKU21/ku:UppgiftslamnarId != ku:InkomsttagareKU21/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU21/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU21/ku:Inkomsttagare) or ku:UppgiftslamnareKU21/ku:UppgiftslamnarId != ku:InkomsttagareKU21/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU21/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU21/ku:Inkomsttagare) + count(ku:InkomsttagareKU21/ku:Fodelsetid) + count(ku:InkomsttagareKU21/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU21/*) + count(//ku:InkomsttagareKU21/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU21/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU21/ku:Inkomsttagare) + count(ku:InkomsttagareKU21/ku:Fodelsetid) + count(ku:InkomsttagareKU21/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU21/*) + count(//ku:InkomsttagareKU21/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:Fodelsetid or ku:InkomsttagareKU21/ku:AnnatIDNr or ku:InkomsttagareKU21/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:Fodelsetid or ku:InkomsttagareKU21/ku:AnnatIDNr or ku:InkomsttagareKU21/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:Fornamn or not(ku:InkomsttagareKU21/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:Fornamn or not(ku:InkomsttagareKU21/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU21/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU21/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU21/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU21/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:Efternamn or not(ku:InkomsttagareKU21/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:Efternamn or not(ku:InkomsttagareKU21/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU21/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU21/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU21/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU21/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:Gatuadress or not(ku:InkomsttagareKU21/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU21/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:Gatuadress or not(ku:InkomsttagareKU21/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU21/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU21/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU21/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU21/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU21/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU21/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU21/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:Gatuadress or not(ku:InkomsttagareKU21/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU21/ku:Inkomsttagare or ku:InkomsttagareKU21/ku:Fodelsetid or ku:InkomsttagareKU21/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:Gatuadress or not(ku:InkomsttagareKU21/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU21/ku:Inkomsttagare or ku:InkomsttagareKU21/ku:Fodelsetid or ku:InkomsttagareKU21/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:Postnummer or not(ku:InkomsttagareKU21/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU21/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:Postnummer or not(ku:InkomsttagareKU21/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU21/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU21/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU21/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU21/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU21/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU21/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU21/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:Postnummer or not(ku:InkomsttagareKU21/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU21/ku:Inkomsttagare or ku:InkomsttagareKU21/ku:Fodelsetid or ku:InkomsttagareKU21/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:Postnummer or not(ku:InkomsttagareKU21/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU21/ku:Inkomsttagare or ku:InkomsttagareKU21/ku:Fodelsetid or ku:InkomsttagareKU21/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:Postort or not(ku:InkomsttagareKU21/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU21/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:Postort or not(ku:InkomsttagareKU21/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU21/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU21/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU21/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU21/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU21/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU21/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU21/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:Postort or not(ku:InkomsttagareKU21/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU21/ku:Inkomsttagare or ku:InkomsttagareKU21/ku:Fodelsetid or ku:InkomsttagareKU21/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:Postort or not(ku:InkomsttagareKU21/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU21/ku:Inkomsttagare or ku:InkomsttagareKU21/ku:Fodelsetid or ku:InkomsttagareKU21/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU21/ku:FriAdress) or ku:InkomsttagareKU21/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU21/ku:FriAdress) or ku:InkomsttagareKU21/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU21/ku:Inkomsttagare) or not(ku:InkomsttagareKU21/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU21/ku:Inkomsttagare) or not(ku:InkomsttagareKU21/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU21/ku:OrgNamn) or (not(ku:InkomsttagareKU21/ku:Fodelsetid) and (not(ku:InkomsttagareKU21/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU21/ku:Fornamn) and not(ku:InkomsttagareKU21/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU21/ku:OrgNamn) or (not(ku:InkomsttagareKU21/ku:Fodelsetid) and (not(ku:InkomsttagareKU21/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU21/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU21/ku:Fornamn) and not(ku:InkomsttagareKU21/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU21/ku:OrgNamn or not(ku:InkomsttagareKU21/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU21/ku:Inkomsttagare or ku:InkomsttagareKU21/ku:Fornamn or ku:InkomsttagareKU21/ku:Efternamn or ku:InkomsttagareKU21/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU21/ku:OrgNamn or not(ku:InkomsttagareKU21/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU21/ku:Inkomsttagare or ku:InkomsttagareKU21/ku:Fornamn or ku:InkomsttagareKU21/ku:Efternamn or ku:InkomsttagareKU21/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU21/ku:LandskodTIN) or ku:InkomsttagareKU21/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU21/ku:LandskodTIN) or ku:InkomsttagareKU21/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:RantaFordringsratter or ku:Borttag or ku:AvdragenSkatt or ku:UtbetaltIVissaFall or ku:AnnanInkomst or ku:ErhallenRantekompensation or ku:OkandVarde"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:RantaFordringsratter or ku:Borttag or ku:AvdragenSkatt or ku:UtbetaltIVissaFall or ku:AnnanInkomst or ku:ErhallenRantekompensation or ku:OkandVarde">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>075#Kontrolluppgiften saknar både inkomster och avdragen skatt. Utan dessa värden är den alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:OkandVarde) or not(ku:UtbetaltIVissaFall)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:OkandVarde) or not(ku:UtbetaltIVissaFall)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>167#När man fyllt i Utbetalt belopp i vissa fall, fält 522, kan man inte samtidigt ha Okänt värde, fält 599 markerat</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:AndelAvDepan) or ku:Depanummer"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:AndelAvDepan) or ku:Depanummer">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>076#Du har angett Andel av depån, fält 524. Du ska då också ange Depånummer, fält 523</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:VPNamn or ku:ISIN or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:VPNamn or ku:ISIN or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>085#Du har inte angett något ISIN, fält 572. Då ska du fylla i Namn på aktien/andelen, fält 571</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:VPNamn or (not(ku:ISIN) or (string-length(ku:ISIN) &gt;= 2 and substring(ku:ISIN,1,2) = 'SE') or number(ku:UppgiftslamnareKU21/ku:UppgiftslamnarId) = 165561128074)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:VPNamn or (not(ku:ISIN) or (string-length(ku:ISIN) &gt;= 2 and substring(ku:ISIN,1,2) = 'SE') or number(ku:UppgiftslamnareKU21/ku:UppgiftslamnarId) = 165561128074)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>170#Du har angett ett utländskt nummer (börjar inte på SE) i ISIN, fält 572. Då ska du också fylla i Namn på aktien/andelen, fält 571</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:AvyttradTillISK) or ku:UtbetaltIVissaFall"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:AvyttradTillISK) or ku:UtbetaltIVissaFall">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>086#Det är endast när Utbetalt belopp i vissa fall, fält 522, är ifyllt som Avyttrad till investeringssparkonto, fält 573 kan vara markerat</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU25" priority="1022" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU25"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU25/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU25/ku:Inkomsttagare) or ku:UppgiftslamnareKU25/ku:UppgiftslamnarId != ku:InkomsttagareKU25/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU25/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU25/ku:Inkomsttagare) or ku:UppgiftslamnareKU25/ku:UppgiftslamnarId != ku:InkomsttagareKU25/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU25/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU25/ku:Inkomsttagare) + count(ku:InkomsttagareKU25/ku:Fodelsetid) + count(ku:InkomsttagareKU25/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU25/*) + count(//ku:InkomsttagareKU25/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU25/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU25/ku:Inkomsttagare) + count(ku:InkomsttagareKU25/ku:Fodelsetid) + count(ku:InkomsttagareKU25/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU25/*) + count(//ku:InkomsttagareKU25/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:Fodelsetid or ku:InkomsttagareKU25/ku:AnnatIDNr or ku:InkomsttagareKU25/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:Fodelsetid or ku:InkomsttagareKU25/ku:AnnatIDNr or ku:InkomsttagareKU25/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:Fornamn or not(ku:InkomsttagareKU25/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:Fornamn or not(ku:InkomsttagareKU25/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU25/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU25/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU25/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU25/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:Efternamn or not(ku:InkomsttagareKU25/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:Efternamn or not(ku:InkomsttagareKU25/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU25/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU25/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU25/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU25/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:Gatuadress or not(ku:InkomsttagareKU25/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU25/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:Gatuadress or not(ku:InkomsttagareKU25/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU25/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU25/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU25/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU25/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU25/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU25/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU25/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:Gatuadress or not(ku:InkomsttagareKU25/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU25/ku:Inkomsttagare or ku:InkomsttagareKU25/ku:Fodelsetid or ku:InkomsttagareKU25/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:Gatuadress or not(ku:InkomsttagareKU25/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU25/ku:Inkomsttagare or ku:InkomsttagareKU25/ku:Fodelsetid or ku:InkomsttagareKU25/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:Postnummer or not(ku:InkomsttagareKU25/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU25/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:Postnummer or not(ku:InkomsttagareKU25/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU25/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU25/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU25/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU25/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU25/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU25/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU25/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:Postnummer or not(ku:InkomsttagareKU25/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU25/ku:Inkomsttagare or ku:InkomsttagareKU25/ku:Fodelsetid or ku:InkomsttagareKU25/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:Postnummer or not(ku:InkomsttagareKU25/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU25/ku:Inkomsttagare or ku:InkomsttagareKU25/ku:Fodelsetid or ku:InkomsttagareKU25/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:Postort or not(ku:InkomsttagareKU25/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU25/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:Postort or not(ku:InkomsttagareKU25/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU25/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU25/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU25/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU25/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU25/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU25/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU25/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:Postort or not(ku:InkomsttagareKU25/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU25/ku:Inkomsttagare or ku:InkomsttagareKU25/ku:Fodelsetid or ku:InkomsttagareKU25/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:Postort or not(ku:InkomsttagareKU25/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU25/ku:Inkomsttagare or ku:InkomsttagareKU25/ku:Fodelsetid or ku:InkomsttagareKU25/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU25/ku:FriAdress) or ku:InkomsttagareKU25/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU25/ku:FriAdress) or ku:InkomsttagareKU25/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU25/ku:Inkomsttagare) or not(ku:InkomsttagareKU25/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU25/ku:Inkomsttagare) or not(ku:InkomsttagareKU25/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU25/ku:OrgNamn) or (not(ku:InkomsttagareKU25/ku:Fodelsetid) and (not(ku:InkomsttagareKU25/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU25/ku:Fornamn) and not(ku:InkomsttagareKU25/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU25/ku:OrgNamn) or (not(ku:InkomsttagareKU25/ku:Fodelsetid) and (not(ku:InkomsttagareKU25/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU25/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU25/ku:Fornamn) and not(ku:InkomsttagareKU25/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU25/ku:OrgNamn or not(ku:InkomsttagareKU25/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU25/ku:Inkomsttagare or ku:InkomsttagareKU25/ku:Fornamn or ku:InkomsttagareKU25/ku:Efternamn or ku:InkomsttagareKU25/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU25/ku:OrgNamn or not(ku:InkomsttagareKU25/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU25/ku:Inkomsttagare or ku:InkomsttagareKU25/ku:Fornamn or ku:InkomsttagareKU25/ku:Efternamn or ku:InkomsttagareKU25/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:AvdragsgillRanta or ku:Borttag or ku:TotaltInbetaldRanta or ku:BetaldRantekompensation"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:AvdragsgillRanta or ku:Borttag or ku:TotaltInbetaldRanta or ku:BetaldRantekompensation">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>081#Kontrolluppgiften saknar helt uppgifter om betald ränta. Utan dessa värden är den alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:TotaltInbetaldRanta) or (number(ku:TotaltInbetaldRanta) = 0) or not(ku:AvdragsgillRanta) or (ku:AvdragsgillRanta and number(ku:TotaltInbetaldRanta) &gt;= number(ku:AvdragsgillRanta))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:TotaltInbetaldRanta) or (number(ku:TotaltInbetaldRanta) = 0) or not(ku:AvdragsgillRanta) or (ku:AvdragsgillRanta and number(ku:TotaltInbetaldRanta) &gt;= number(ku:AvdragsgillRanta))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>082#Du har fyllt i ett lägre belopp i Totalt inbetald ränta, fält 541, än i Betald och för året avdragsgill ränta, fält 540. Totalt inbetald ränta, fält 541, måste, om det fylls i, alltid vara ett högre belopp</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU26" priority="1021" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU26"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU26/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU26/ku:Inkomsttagare) or ku:UppgiftslamnareKU26/ku:UppgiftslamnarId != ku:InkomsttagareKU26/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU26/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU26/ku:Inkomsttagare) or ku:UppgiftslamnareKU26/ku:UppgiftslamnarId != ku:InkomsttagareKU26/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU26/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU26/ku:Inkomsttagare) + count(ku:InkomsttagareKU26/ku:Fodelsetid) + count(ku:InkomsttagareKU26/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU26/*) + count(//ku:InkomsttagareKU26/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU26/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU26/ku:Inkomsttagare) + count(ku:InkomsttagareKU26/ku:Fodelsetid) + count(ku:InkomsttagareKU26/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU26/*) + count(//ku:InkomsttagareKU26/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:Fodelsetid or ku:InkomsttagareKU26/ku:AnnatIDNr or ku:InkomsttagareKU26/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:Fodelsetid or ku:InkomsttagareKU26/ku:AnnatIDNr or ku:InkomsttagareKU26/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:Fornamn or not(ku:InkomsttagareKU26/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:Fornamn or not(ku:InkomsttagareKU26/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU26/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU26/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU26/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU26/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:Efternamn or not(ku:InkomsttagareKU26/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:Efternamn or not(ku:InkomsttagareKU26/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU26/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU26/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU26/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU26/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:Gatuadress or not(ku:InkomsttagareKU26/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU26/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:Gatuadress or not(ku:InkomsttagareKU26/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU26/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU26/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU26/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU26/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU26/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU26/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU26/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:Gatuadress or not(ku:InkomsttagareKU26/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU26/ku:Inkomsttagare or ku:InkomsttagareKU26/ku:Fodelsetid or ku:InkomsttagareKU26/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:Gatuadress or not(ku:InkomsttagareKU26/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU26/ku:Inkomsttagare or ku:InkomsttagareKU26/ku:Fodelsetid or ku:InkomsttagareKU26/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:Postnummer or not(ku:InkomsttagareKU26/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU26/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:Postnummer or not(ku:InkomsttagareKU26/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU26/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU26/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU26/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU26/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU26/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU26/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU26/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:Postnummer or not(ku:InkomsttagareKU26/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU26/ku:Inkomsttagare or ku:InkomsttagareKU26/ku:Fodelsetid or ku:InkomsttagareKU26/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:Postnummer or not(ku:InkomsttagareKU26/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU26/ku:Inkomsttagare or ku:InkomsttagareKU26/ku:Fodelsetid or ku:InkomsttagareKU26/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:Postort or not(ku:InkomsttagareKU26/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU26/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:Postort or not(ku:InkomsttagareKU26/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU26/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU26/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU26/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU26/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU26/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU26/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU26/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:Postort or not(ku:InkomsttagareKU26/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU26/ku:Inkomsttagare or ku:InkomsttagareKU26/ku:Fodelsetid or ku:InkomsttagareKU26/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:Postort or not(ku:InkomsttagareKU26/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU26/ku:Inkomsttagare or ku:InkomsttagareKU26/ku:Fodelsetid or ku:InkomsttagareKU26/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU26/ku:FriAdress) or ku:InkomsttagareKU26/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU26/ku:FriAdress) or ku:InkomsttagareKU26/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU26/ku:Inkomsttagare) or not(ku:InkomsttagareKU26/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU26/ku:Inkomsttagare) or not(ku:InkomsttagareKU26/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU26/ku:OrgNamn) or (not(ku:InkomsttagareKU26/ku:Fodelsetid) and (not(ku:InkomsttagareKU26/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU26/ku:Fornamn) and not(ku:InkomsttagareKU26/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU26/ku:OrgNamn) or (not(ku:InkomsttagareKU26/ku:Fodelsetid) and (not(ku:InkomsttagareKU26/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU26/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU26/ku:Fornamn) and not(ku:InkomsttagareKU26/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU26/ku:OrgNamn or not(ku:InkomsttagareKU26/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU26/ku:Inkomsttagare or ku:InkomsttagareKU26/ku:Fornamn or ku:InkomsttagareKU26/ku:Efternamn or ku:InkomsttagareKU26/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU26/ku:OrgNamn or not(ku:InkomsttagareKU26/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU26/ku:Inkomsttagare or ku:InkomsttagareKU26/ku:Fornamn or ku:InkomsttagareKU26/ku:Efternamn or ku:InkomsttagareKU26/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:BetaldTomtrattsavgald"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:BetaldTomtrattsavgald">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>083#Betald tomträttsavgäld, fält 560, ska alltid fyllas i</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Fastighetsbeteckning"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Fastighetsbeteckning">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>084#Fastighetsbeteckning, fält 561, ska alltid fyllas i</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU28" priority="1020" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU28"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU28/ku:TIN) or ku:InkomsttagareKU28/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU28/ku:TIN) or ku:InkomsttagareKU28/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU28/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU28/ku:Inkomsttagare) or ku:UppgiftslamnareKU28/ku:UppgiftslamnarId != ku:InkomsttagareKU28/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU28/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU28/ku:Inkomsttagare) or ku:UppgiftslamnareKU28/ku:UppgiftslamnarId != ku:InkomsttagareKU28/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU28/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU28/ku:Inkomsttagare) + count(ku:InkomsttagareKU28/ku:Fodelsetid) + count(ku:InkomsttagareKU28/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU28/*) + count(//ku:InkomsttagareKU28/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU28/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU28/ku:Inkomsttagare) + count(ku:InkomsttagareKU28/ku:Fodelsetid) + count(ku:InkomsttagareKU28/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU28/*) + count(//ku:InkomsttagareKU28/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:Fodelsetid or ku:InkomsttagareKU28/ku:AnnatIDNr or ku:InkomsttagareKU28/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:Fodelsetid or ku:InkomsttagareKU28/ku:AnnatIDNr or ku:InkomsttagareKU28/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:Fornamn or not(ku:InkomsttagareKU28/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:Fornamn or not(ku:InkomsttagareKU28/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU28/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU28/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU28/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU28/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:Efternamn or not(ku:InkomsttagareKU28/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:Efternamn or not(ku:InkomsttagareKU28/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU28/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU28/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU28/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU28/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:Gatuadress or not(ku:InkomsttagareKU28/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU28/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:Gatuadress or not(ku:InkomsttagareKU28/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU28/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU28/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU28/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU28/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU28/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU28/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU28/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:Gatuadress or not(ku:InkomsttagareKU28/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU28/ku:Inkomsttagare or ku:InkomsttagareKU28/ku:Fodelsetid or ku:InkomsttagareKU28/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:Gatuadress or not(ku:InkomsttagareKU28/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU28/ku:Inkomsttagare or ku:InkomsttagareKU28/ku:Fodelsetid or ku:InkomsttagareKU28/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:Postnummer or not(ku:InkomsttagareKU28/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU28/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:Postnummer or not(ku:InkomsttagareKU28/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU28/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU28/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU28/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU28/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU28/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU28/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU28/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:Postnummer or not(ku:InkomsttagareKU28/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU28/ku:Inkomsttagare or ku:InkomsttagareKU28/ku:Fodelsetid or ku:InkomsttagareKU28/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:Postnummer or not(ku:InkomsttagareKU28/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU28/ku:Inkomsttagare or ku:InkomsttagareKU28/ku:Fodelsetid or ku:InkomsttagareKU28/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:Postort or not(ku:InkomsttagareKU28/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU28/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:Postort or not(ku:InkomsttagareKU28/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU28/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU28/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU28/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU28/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU28/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU28/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU28/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:Postort or not(ku:InkomsttagareKU28/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU28/ku:Inkomsttagare or ku:InkomsttagareKU28/ku:Fodelsetid or ku:InkomsttagareKU28/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:Postort or not(ku:InkomsttagareKU28/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU28/ku:Inkomsttagare or ku:InkomsttagareKU28/ku:Fodelsetid or ku:InkomsttagareKU28/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU28/ku:FriAdress) or ku:InkomsttagareKU28/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU28/ku:FriAdress) or ku:InkomsttagareKU28/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU28/ku:Inkomsttagare) or not(ku:InkomsttagareKU28/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU28/ku:Inkomsttagare) or not(ku:InkomsttagareKU28/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU28/ku:OrgNamn) or (not(ku:InkomsttagareKU28/ku:Fodelsetid) and (not(ku:InkomsttagareKU28/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU28/ku:Fornamn) and not(ku:InkomsttagareKU28/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU28/ku:OrgNamn) or (not(ku:InkomsttagareKU28/ku:Fodelsetid) and (not(ku:InkomsttagareKU28/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU28/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU28/ku:Fornamn) and not(ku:InkomsttagareKU28/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU28/ku:OrgNamn or not(ku:InkomsttagareKU28/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU28/ku:Inkomsttagare or ku:InkomsttagareKU28/ku:Fornamn or ku:InkomsttagareKU28/ku:Efternamn or ku:InkomsttagareKU28/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU28/ku:OrgNamn or not(ku:InkomsttagareKU28/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU28/ku:Inkomsttagare or ku:InkomsttagareKU28/ku:Fornamn or ku:InkomsttagareKU28/ku:Efternamn or ku:InkomsttagareKU28/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU28/ku:LandskodTIN) or ku:InkomsttagareKU28/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU28/ku:LandskodTIN) or ku:InkomsttagareKU28/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:TotUnderlagInvesteraravdrag) or ku:UnderlagForInvesteraravdrag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:TotUnderlagInvesteraravdrag) or ku:UnderlagForInvesteraravdrag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>077#Du har fyllt i Totalt underlag för investeraravdrag, fält 529. Du behöver också fylla i Underlag för investeraravdrag, fält 528</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UnderlagForInvesteraravdrag) or not(ku:TotUnderlagInvesteraravdrag) or ku:TotUnderlagInvesteraravdrag &gt;= ku:UnderlagForInvesteraravdrag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UnderlagForInvesteraravdrag) or not(ku:TotUnderlagInvesteraravdrag) or ku:TotUnderlagInvesteraravdrag &gt;= ku:UnderlagForInvesteraravdrag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>135#Du har fyllt i ett högre belopp i Underlag för investeraravdrag, fält 528, än i Totalt underlag för investeraravdrag, fält 529. Underlag för investeraravdrag, fält 528, måste alltid vara ett lägre belopp</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UnderlagForInvesteraravdrag) or ku:TotUnderlagInvesteraravdrag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UnderlagForInvesteraravdrag) or ku:TotUnderlagInvesteraravdrag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>136#Du har fyllt i Underlag för investeraravdrag, fält 528. Du ska då också fylla i Totalt underlag för investeraravdrag, fält 529.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Betalningsar) or ku:UnderlagForInvesteraravdrag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Betalningsar) or ku:UnderlagForInvesteraravdrag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>164#Du har fyllt i Inbetalning gjord året före inkomståret, fält 530. Du ska då också fylla i Underlag för investeraravdrag, fält 528</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:AterforingAvyttring) or not(ku:UnderlagForInvesteraravdrag)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:AterforingAvyttring) or not(ku:UnderlagForInvesteraravdrag)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>080#När du markerat Återföring på grund av avyttring, fält 531, kan du inte fylla i Underlag för investeraravdrag, fält 528 på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:AterforingAvyttring) or not(ku:TotUnderlagInvesteraravdrag)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:AterforingAvyttring) or not(ku:TotUnderlagInvesteraravdrag)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>078#När du markerat Återföring på grund av avyttring, fält 531, kan du inte fylla i Totalt underlag för investeraravdrag, fält 529 på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:AterforingAvyttring) or not(ku:Betalningsar)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:AterforingAvyttring) or not(ku:Betalningsar)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>079#När du markerat Återföring på grund av avyttring, fält 531, kan du inte markera Inbetalning gjord året före inkomståret, fält 530 på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UnderlagForInvesteraravdrag) or not(ku:AterforingUtflyttning)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UnderlagForInvesteraravdrag) or not(ku:AterforingUtflyttning)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>147#När du markerat Återföring på grund av utflyttning, fält 532, kan du inte fylla i Underlag för investeraravdrag, fält 528 på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:TotUnderlagInvesteraravdrag) or not(ku:AterforingUtflyttning)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:TotUnderlagInvesteraravdrag) or not(ku:AterforingUtflyttning)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>155#När du markerat Återföring på grund av utflyttning, fält 532, kan du inte fylla i Totalt underlag för investeraravdrag, fält 529 på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Betalningsar) or not(ku:AterforingUtflyttning)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Betalningsar) or not(ku:AterforingUtflyttning)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>158#När du markerat Återföring på grund av utflyttning, fält 532, kan du inte markera Inbetalning gjord året före inkomståret, fält 530 på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UnderlagForInvesteraravdrag) or not(ku:AterforingHogVardeoverforing)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UnderlagForInvesteraravdrag) or not(ku:AterforingHogVardeoverforing)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>148#När du markerat Återföring på grund av för hög värdeöverföring, fält 533, kan du inte fylla i Underlag för investeraravdrag, fält 528 på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:TotUnderlagInvesteraravdrag) or not(ku:AterforingHogVardeoverforing)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:TotUnderlagInvesteraravdrag) or not(ku:AterforingHogVardeoverforing)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>156#När du markerat Återföring på grund av för hög värdeöverföring, fält 533, kan du inte fylla i Totalt underlag för investeraravdrag, fält 529  på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Betalningsar) or not(ku:AterforingHogVardeoverforing)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Betalningsar) or not(ku:AterforingHogVardeoverforing)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>159#När du markerat Återföring på grund av för hög värdeöverföring, fält 533, kan du inte markera Inbetalning gjord året före inkomståret, fält 530 på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UnderlagForInvesteraravdrag) or not(ku:AterforingInternaForvarv)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UnderlagForInvesteraravdrag) or not(ku:AterforingInternaForvarv)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>149#När du markerat Återföring på grund av vissa interna förvärv, fält 534, kan du inte fylla i Underlag för investeraravdrag, fält 528 på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:TotUnderlagInvesteraravdrag) or not(ku:AterforingInternaForvarv)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:TotUnderlagInvesteraravdrag) or not(ku:AterforingInternaForvarv)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>157#När du markerat Återföring på grund av vissa interna förvärv, fält 534, kan du inte fylla i Totalt underlag för investeraravdrag, fält 529  på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Betalningsar) or not(ku:AterforingInternaForvarv)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Betalningsar) or not(ku:AterforingInternaForvarv)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>160#När du markerat Återföring på grund av vissa interna förvärv, fält 534, kan du inte markera Inbetalning gjord året före inkomståret, fält 530 på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UnderlagForInvesteraravdrag) or ku:DatumForvarv"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UnderlagForInvesteraravdrag) or ku:DatumForvarv">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>187#Du har fyllt i Underlag för investeraravdrag, fält 528. Du ska då också fylla i Datum när andelarna förvärvades, fält 535.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UnderlagForInvesteraravdrag) or ku:Region"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UnderlagForInvesteraravdrag) or ku:Region">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>188#Du har fyllt i Underlag för investeraravdrag, fält 528. Du ska då också fylla i Region där företaget finns, fält 536.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UnderlagForInvesteraravdrag) or ku:Verksamhetsomrade"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UnderlagForInvesteraravdrag) or ku:Verksamhetsomrade">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>189#Du har fyllt i Underlag för investeraravdrag, fält 528. Du ska då också fylla i Företagets verksamhetsområde, fält 537.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU30" priority="1019" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU30"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU30/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU30/ku:Inkomsttagare) or ku:UppgiftslamnareKU30/ku:UppgiftslamnarId != ku:InkomsttagareKU30/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU30/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU30/ku:Inkomsttagare) or ku:UppgiftslamnareKU30/ku:UppgiftslamnarId != ku:InkomsttagareKU30/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU30/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU30/ku:Inkomsttagare) + count(ku:InkomsttagareKU30/ku:Fodelsetid) + count(ku:InkomsttagareKU30/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU30/*) + count(//ku:InkomsttagareKU30/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU30/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU30/ku:Inkomsttagare) + count(ku:InkomsttagareKU30/ku:Fodelsetid) + count(ku:InkomsttagareKU30/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU30/*) + count(//ku:InkomsttagareKU30/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:Fodelsetid or ku:InkomsttagareKU30/ku:AnnatIDNr or ku:InkomsttagareKU30/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:Fodelsetid or ku:InkomsttagareKU30/ku:AnnatIDNr or ku:InkomsttagareKU30/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:Fornamn or not(ku:InkomsttagareKU30/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:Fornamn or not(ku:InkomsttagareKU30/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU30/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU30/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU30/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU30/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:Efternamn or not(ku:InkomsttagareKU30/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:Efternamn or not(ku:InkomsttagareKU30/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU30/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU30/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU30/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU30/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:Gatuadress or not(ku:InkomsttagareKU30/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU30/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:Gatuadress or not(ku:InkomsttagareKU30/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU30/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU30/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU30/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU30/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU30/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU30/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU30/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:Gatuadress or not(ku:InkomsttagareKU30/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU30/ku:Inkomsttagare or ku:InkomsttagareKU30/ku:Fodelsetid or ku:InkomsttagareKU30/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:Gatuadress or not(ku:InkomsttagareKU30/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU30/ku:Inkomsttagare or ku:InkomsttagareKU30/ku:Fodelsetid or ku:InkomsttagareKU30/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:Postnummer or not(ku:InkomsttagareKU30/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU30/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:Postnummer or not(ku:InkomsttagareKU30/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU30/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU30/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU30/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU30/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU30/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU30/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU30/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:Postnummer or not(ku:InkomsttagareKU30/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU30/ku:Inkomsttagare or ku:InkomsttagareKU30/ku:Fodelsetid or ku:InkomsttagareKU30/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:Postnummer or not(ku:InkomsttagareKU30/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU30/ku:Inkomsttagare or ku:InkomsttagareKU30/ku:Fodelsetid or ku:InkomsttagareKU30/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:Postort or not(ku:InkomsttagareKU30/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU30/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:Postort or not(ku:InkomsttagareKU30/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU30/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU30/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU30/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU30/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU30/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU30/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU30/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:Postort or not(ku:InkomsttagareKU30/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU30/ku:Inkomsttagare or ku:InkomsttagareKU30/ku:Fodelsetid or ku:InkomsttagareKU30/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:Postort or not(ku:InkomsttagareKU30/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU30/ku:Inkomsttagare or ku:InkomsttagareKU30/ku:Fodelsetid or ku:InkomsttagareKU30/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU30/ku:FriAdress) or ku:InkomsttagareKU30/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU30/ku:FriAdress) or ku:InkomsttagareKU30/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU30/ku:Inkomsttagare) or not(ku:InkomsttagareKU30/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU30/ku:Inkomsttagare) or not(ku:InkomsttagareKU30/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU30/ku:OrgNamn) or (not(ku:InkomsttagareKU30/ku:Fodelsetid) and (not(ku:InkomsttagareKU30/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU30/ku:Fornamn) and not(ku:InkomsttagareKU30/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU30/ku:OrgNamn) or (not(ku:InkomsttagareKU30/ku:Fodelsetid) and (not(ku:InkomsttagareKU30/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU30/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU30/ku:Fornamn) and not(ku:InkomsttagareKU30/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU30/ku:OrgNamn or not(ku:InkomsttagareKU30/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU30/ku:Inkomsttagare or ku:InkomsttagareKU30/ku:Fornamn or ku:InkomsttagareKU30/ku:Efternamn or ku:InkomsttagareKU30/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU30/ku:OrgNamn or not(ku:InkomsttagareKU30/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU30/ku:Inkomsttagare or ku:InkomsttagareKU30/ku:Fornamn or ku:InkomsttagareKU30/ku:Efternamn or ku:InkomsttagareKU30/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Schablonintakt"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Schablonintakt">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>133#Du har inte fyllt i Schablonintäkt, fält 815</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU31" priority="1018" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU31"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:AvdragenUtlandskSkatt) or (not(ku:UtbetaldUtdelning) and (number(ku:AvdragenUtlandskSkatt) &lt;= number(ku:AnnanInkomst))) or (not(ku:AnnanInkomst) and (number(ku:AvdragenUtlandskSkatt) &lt;= number(ku:UtbetaldUtdelning))) or (number(ku:AvdragenUtlandskSkatt) &lt;= (number(ku:UtbetaldUtdelning) + number(ku:AnnanInkomst)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:AvdragenUtlandskSkatt) or (not(ku:UtbetaldUtdelning) and (number(ku:AvdragenUtlandskSkatt) &lt;= number(ku:AnnanInkomst))) or (not(ku:AnnanInkomst) and (number(ku:AvdragenUtlandskSkatt) &lt;= number(ku:UtbetaldUtdelning))) or (number(ku:AvdragenUtlandskSkatt) &lt;= (number(ku:UtbetaldUtdelning) + number(ku:AnnanInkomst)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>005#Du har angett ett större belopp för Avdragen utländsk skatt, fält 002, än Utbetald utdelning m.m., fält 574, och/eller Annan inkomst, fält 504. Det går inte att dra av mer i skatt än vad som delats ut</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UtbetaldUtdelning) or not(ku:AvdragenKupongskatt) or ku:AvdragenKupongskatt &lt;= ku:UtbetaldUtdelning"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UtbetaldUtdelning) or not(ku:AvdragenKupongskatt) or ku:AvdragenKupongskatt &lt;= ku:UtbetaldUtdelning">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>006#Du har angett ett större belopp för Innehållen svensk kupongskatt, fält 003, än Utbetald utdelning m.m., fält 574. Det går inte att hålla inne mer i skatt än vad som delats ut</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:AvdragenKupongskatt) or (not(ku:AvdragenSkatt) and not(ku:AvdragenUtlandskSkatt))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:AvdragenKupongskatt) or (not(ku:AvdragenSkatt) and not(ku:AvdragenUtlandskSkatt))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>134#Du har angett ett belopp i fältet Innehållen svensk kupongskatt, fält 003. Du kan därför inte också fylla i Avdragen skatt, fält 001, eller Avdragen utländsk skatt, fält 002</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:AnnanKupongErsattning) or not(ku:AvdragenKupongskatt) or ku:AvdragenKupongskatt &lt;= ku:AnnanKupongErsattning"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:AnnanKupongErsattning) or not(ku:AvdragenKupongskatt) or ku:AvdragenKupongskatt &lt;= ku:AnnanKupongErsattning">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>150#Du har angett ett större belopp för Innehållen svensk kupongskatt, fält 003, än Annan kupongskattepliktig ersättning än utdelning, fält 581. Det går inte att hålla inne mer i skatt än vad som delats ut</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU31/ku:TIN) or ku:InkomsttagareKU31/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU31/ku:TIN) or ku:InkomsttagareKU31/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU31/ku:Fodelseort) or ku:InkomsttagareKU31/ku:LandskodFodelseort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU31/ku:Fodelseort) or ku:InkomsttagareKU31/ku:LandskodFodelseort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>046#Du har angett Födelseort, fält 077. Då ska du också ange i vilket land födelseorten ligger i fält 078</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Hemviststat) or ku:LandskodHemvist"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Hemviststat) or ku:LandskodHemvist">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>047#Felet förekommer ej på fil</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU31/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU31/ku:Inkomsttagare) or ku:UppgiftslamnareKU31/ku:UppgiftslamnarId != ku:InkomsttagareKU31/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU31/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU31/ku:Inkomsttagare) or ku:UppgiftslamnareKU31/ku:UppgiftslamnarId != ku:InkomsttagareKU31/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU31/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU31/ku:Inkomsttagare) + count(ku:InkomsttagareKU31/ku:Fodelsetid) + count(ku:InkomsttagareKU31/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU31/*) + count(//ku:InkomsttagareKU31/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU31/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU31/ku:Inkomsttagare) + count(ku:InkomsttagareKU31/ku:Fodelsetid) + count(ku:InkomsttagareKU31/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU31/*) + count(//ku:InkomsttagareKU31/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:Fodelsetid or ku:InkomsttagareKU31/ku:AnnatIDNr or ku:InkomsttagareKU31/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:Fodelsetid or ku:InkomsttagareKU31/ku:AnnatIDNr or ku:InkomsttagareKU31/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:Fornamn or not(ku:InkomsttagareKU31/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:Fornamn or not(ku:InkomsttagareKU31/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU31/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU31/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU31/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU31/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:Efternamn or not(ku:InkomsttagareKU31/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:Efternamn or not(ku:InkomsttagareKU31/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU31/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU31/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU31/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU31/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:Gatuadress or not(ku:InkomsttagareKU31/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU31/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:Gatuadress or not(ku:InkomsttagareKU31/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU31/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU31/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU31/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU31/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU31/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU31/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU31/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:Gatuadress or not(ku:InkomsttagareKU31/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU31/ku:Inkomsttagare or ku:InkomsttagareKU31/ku:Fodelsetid or ku:InkomsttagareKU31/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:Gatuadress or not(ku:InkomsttagareKU31/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU31/ku:Inkomsttagare or ku:InkomsttagareKU31/ku:Fodelsetid or ku:InkomsttagareKU31/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:Postnummer or not(ku:InkomsttagareKU31/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU31/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:Postnummer or not(ku:InkomsttagareKU31/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU31/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU31/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU31/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU31/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU31/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU31/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU31/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:Postnummer or not(ku:InkomsttagareKU31/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU31/ku:Inkomsttagare or ku:InkomsttagareKU31/ku:Fodelsetid or ku:InkomsttagareKU31/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:Postnummer or not(ku:InkomsttagareKU31/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU31/ku:Inkomsttagare or ku:InkomsttagareKU31/ku:Fodelsetid or ku:InkomsttagareKU31/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:Postort or not(ku:InkomsttagareKU31/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU31/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:Postort or not(ku:InkomsttagareKU31/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU31/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU31/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU31/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU31/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU31/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU31/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU31/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:Postort or not(ku:InkomsttagareKU31/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU31/ku:Inkomsttagare or ku:InkomsttagareKU31/ku:Fodelsetid or ku:InkomsttagareKU31/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:Postort or not(ku:InkomsttagareKU31/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU31/ku:Inkomsttagare or ku:InkomsttagareKU31/ku:Fodelsetid or ku:InkomsttagareKU31/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU31/ku:FriAdress) or ku:InkomsttagareKU31/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU31/ku:FriAdress) or ku:InkomsttagareKU31/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU31/ku:Inkomsttagare) or not(ku:InkomsttagareKU31/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU31/ku:Inkomsttagare) or not(ku:InkomsttagareKU31/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU31/ku:OrgNamn) or (not(ku:InkomsttagareKU31/ku:Fodelsetid) and (not(ku:InkomsttagareKU31/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU31/ku:Fornamn) and not(ku:InkomsttagareKU31/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU31/ku:OrgNamn) or (not(ku:InkomsttagareKU31/ku:Fodelsetid) and (not(ku:InkomsttagareKU31/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU31/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU31/ku:Fornamn) and not(ku:InkomsttagareKU31/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU31/ku:OrgNamn or not(ku:InkomsttagareKU31/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU31/ku:Inkomsttagare or ku:InkomsttagareKU31/ku:Fornamn or ku:InkomsttagareKU31/ku:Efternamn or ku:InkomsttagareKU31/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU31/ku:OrgNamn or not(ku:InkomsttagareKU31/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU31/ku:Inkomsttagare or ku:InkomsttagareKU31/ku:Fornamn or ku:InkomsttagareKU31/ku:Efternamn or ku:InkomsttagareKU31/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU31/ku:LandskodTIN) or ku:InkomsttagareKU31/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU31/ku:LandskodTIN) or ku:InkomsttagareKU31/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:AndelAvDepan) or ku:Depanummer"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:AndelAvDepan) or ku:Depanummer">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>076#Du har angett Andel av depån, fält 524. Du ska då också ange Depånummer, fält 523</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:VPNamn or ku:ISIN or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:VPNamn or ku:ISIN or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>085#Du har inte angett något ISIN, fält 572. Då ska du fylla i Namn på aktien/andelen, fält 571</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:VPNamn or (not(ku:ISIN) or (string-length(ku:ISIN) &gt;= 2 and substring(ku:ISIN,1,2) = 'SE') or number(ku:UppgiftslamnareKU31/ku:UppgiftslamnarId) = 165561128074)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:VPNamn or (not(ku:ISIN) or (string-length(ku:ISIN) &gt;= 2 and substring(ku:ISIN,1,2) = 'SE') or number(ku:UppgiftslamnareKU31/ku:UppgiftslamnarId) = 165561128074)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>170#Du har angett ett utländskt nummer (börjar inte på SE) i ISIN, fält 572. Då ska du också fylla i Namn på aktien/andelen, fält 571</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:UtbetaldUtdelning or ku:Borttag or ku:AvdragenSkatt or ku:AnnanInkomst or ku:AnnanKupongErsattning or ku:OkandVarde"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:UtbetaldUtdelning or ku:Borttag or ku:AvdragenSkatt or ku:AnnanInkomst or ku:AnnanKupongErsattning or ku:OkandVarde">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>088#Du har varken angett Utdelning, fält 574, Avdragen skatt, fält 001, Annan inkomst, fält 504, Annan kupongskattepliktig ersättning, fält 581 eller Okänt värde, fält 599. Kontrolluppgiften är därför alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:OkandVarde) or not(ku:UtbetaldUtdelning)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:OkandVarde) or not(ku:UtbetaldUtdelning)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>168#När man fyllt i Utbetald utdelning m.m., fält 574, kan man inte samtidigt ha Okänt värde, fält 599 markerat</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UtbetaldUtdelning) or not(ku:AnnanKupongErsattning)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UtbetaldUtdelning) or not(ku:AnnanKupongErsattning)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>092#Du har angett både Annan kupongskattepliktig ersättning än utdelning, fält 581, och Utbetald utdelning m.m., fält 574. Dessa ersättningar kan inte redovisas på samma kontrolluppgift utan måste delas upp på olika kontrolluppgifter</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU32" priority="1017" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU32"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU32/ku:TIN) or ku:InkomsttagareKU32/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU32/ku:TIN) or ku:InkomsttagareKU32/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU32/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU32/ku:Inkomsttagare) or ku:UppgiftslamnareKU32/ku:UppgiftslamnarId != ku:InkomsttagareKU32/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU32/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU32/ku:Inkomsttagare) or ku:UppgiftslamnareKU32/ku:UppgiftslamnarId != ku:InkomsttagareKU32/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU32/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU32/ku:Inkomsttagare) + count(ku:InkomsttagareKU32/ku:Fodelsetid) + count(ku:InkomsttagareKU32/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU32/*) + count(//ku:InkomsttagareKU32/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU32/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU32/ku:Inkomsttagare) + count(ku:InkomsttagareKU32/ku:Fodelsetid) + count(ku:InkomsttagareKU32/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU32/*) + count(//ku:InkomsttagareKU32/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:Fodelsetid or ku:InkomsttagareKU32/ku:AnnatIDNr or ku:InkomsttagareKU32/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:Fodelsetid or ku:InkomsttagareKU32/ku:AnnatIDNr or ku:InkomsttagareKU32/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:Fornamn or not(ku:InkomsttagareKU32/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:Fornamn or not(ku:InkomsttagareKU32/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU32/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU32/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU32/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU32/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:Efternamn or not(ku:InkomsttagareKU32/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:Efternamn or not(ku:InkomsttagareKU32/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU32/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU32/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU32/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU32/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:Gatuadress or not(ku:InkomsttagareKU32/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU32/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:Gatuadress or not(ku:InkomsttagareKU32/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU32/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU32/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU32/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU32/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU32/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU32/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU32/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:Gatuadress or not(ku:InkomsttagareKU32/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU32/ku:Inkomsttagare or ku:InkomsttagareKU32/ku:Fodelsetid or ku:InkomsttagareKU32/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:Gatuadress or not(ku:InkomsttagareKU32/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU32/ku:Inkomsttagare or ku:InkomsttagareKU32/ku:Fodelsetid or ku:InkomsttagareKU32/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:Postnummer or not(ku:InkomsttagareKU32/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU32/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:Postnummer or not(ku:InkomsttagareKU32/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU32/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU32/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU32/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU32/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU32/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU32/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU32/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:Postnummer or not(ku:InkomsttagareKU32/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU32/ku:Inkomsttagare or ku:InkomsttagareKU32/ku:Fodelsetid or ku:InkomsttagareKU32/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:Postnummer or not(ku:InkomsttagareKU32/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU32/ku:Inkomsttagare or ku:InkomsttagareKU32/ku:Fodelsetid or ku:InkomsttagareKU32/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:Postort or not(ku:InkomsttagareKU32/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU32/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:Postort or not(ku:InkomsttagareKU32/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU32/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU32/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU32/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU32/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU32/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU32/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU32/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:Postort or not(ku:InkomsttagareKU32/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU32/ku:Inkomsttagare or ku:InkomsttagareKU32/ku:Fodelsetid or ku:InkomsttagareKU32/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:Postort or not(ku:InkomsttagareKU32/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU32/ku:Inkomsttagare or ku:InkomsttagareKU32/ku:Fodelsetid or ku:InkomsttagareKU32/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU32/ku:FriAdress) or ku:InkomsttagareKU32/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU32/ku:FriAdress) or ku:InkomsttagareKU32/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU32/ku:Inkomsttagare) or not(ku:InkomsttagareKU32/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU32/ku:Inkomsttagare) or not(ku:InkomsttagareKU32/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU32/ku:OrgNamn) or (not(ku:InkomsttagareKU32/ku:Fodelsetid) and (not(ku:InkomsttagareKU32/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU32/ku:Fornamn) and not(ku:InkomsttagareKU32/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU32/ku:OrgNamn) or (not(ku:InkomsttagareKU32/ku:Fodelsetid) and (not(ku:InkomsttagareKU32/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU32/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU32/ku:Fornamn) and not(ku:InkomsttagareKU32/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU32/ku:OrgNamn or not(ku:InkomsttagareKU32/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU32/ku:Inkomsttagare or ku:InkomsttagareKU32/ku:Fornamn or ku:InkomsttagareKU32/ku:Efternamn or ku:InkomsttagareKU32/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU32/ku:OrgNamn or not(ku:InkomsttagareKU32/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU32/ku:Inkomsttagare or ku:InkomsttagareKU32/ku:Fornamn or ku:InkomsttagareKU32/ku:Efternamn or ku:InkomsttagareKU32/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU32/ku:LandskodTIN) or ku:InkomsttagareKU32/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU32/ku:LandskodTIN) or ku:InkomsttagareKU32/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:AndelAvDepan) or ku:Depanummer"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:AndelAvDepan) or ku:Depanummer">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>076#Du har angett Andel av depån, fält 524. Du ska då också ange Depånummer, fält 523</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:VPNamn or ku:ISIN or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:VPNamn or ku:ISIN or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>085#Du har inte angett något ISIN, fält 572. Då ska du fylla i Namn på aktien/andelen, fält 571</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:VPNamn or (not(ku:ISIN) or (string-length(ku:ISIN) &gt;= 2 and substring(ku:ISIN,1,2) = 'SE') or number(ku:UppgiftslamnareKU32/ku:UppgiftslamnarId) = 165561128074)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:VPNamn or (not(ku:ISIN) or (string-length(ku:ISIN) &gt;= 2 and substring(ku:ISIN,1,2) = 'SE') or number(ku:UppgiftslamnareKU32/ku:UppgiftslamnarId) = 165561128074)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>170#Du har angett ett utländskt nummer (börjar inte på SE) i ISIN, fält 572. Då ska du också fylla i Namn på aktien/andelen, fält 571</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:AntalAvyttrade"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:AntalAvyttrade">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>089#Du har inte fyllt i Antal avyttrade, fält 576</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:ErhallenErsattning or ku:OkandVarde"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:ErhallenErsattning or ku:OkandVarde">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>090#Du har inte fyllt i Erhållen ersättning, fält 810</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:OkandVarde) or not(ku:ErhallenErsattning)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:OkandVarde) or not(ku:ErhallenErsattning)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>169#När man fyllt i Erhållen ersättning, fält 810, kan man inte samtidigt ha Okänt värde, fält 599 markerat</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU34" priority="1016" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU34"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU34/ku:TIN) or ku:InkomsttagareKU34/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU34/ku:TIN) or ku:InkomsttagareKU34/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU34/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU34/ku:Inkomsttagare) or ku:UppgiftslamnareKU34/ku:UppgiftslamnarId != ku:InkomsttagareKU34/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU34/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU34/ku:Inkomsttagare) or ku:UppgiftslamnareKU34/ku:UppgiftslamnarId != ku:InkomsttagareKU34/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU34/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU34/ku:Inkomsttagare) + count(ku:InkomsttagareKU34/ku:Fodelsetid) + count(ku:InkomsttagareKU34/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU34/*) + count(//ku:InkomsttagareKU34/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU34/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU34/ku:Inkomsttagare) + count(ku:InkomsttagareKU34/ku:Fodelsetid) + count(ku:InkomsttagareKU34/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU34/*) + count(//ku:InkomsttagareKU34/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:Fodelsetid or ku:InkomsttagareKU34/ku:AnnatIDNr or ku:InkomsttagareKU34/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:Fodelsetid or ku:InkomsttagareKU34/ku:AnnatIDNr or ku:InkomsttagareKU34/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:Fornamn or not(ku:InkomsttagareKU34/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:Fornamn or not(ku:InkomsttagareKU34/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU34/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU34/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU34/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU34/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:Efternamn or not(ku:InkomsttagareKU34/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:Efternamn or not(ku:InkomsttagareKU34/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU34/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU34/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU34/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU34/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:Gatuadress or not(ku:InkomsttagareKU34/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU34/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:Gatuadress or not(ku:InkomsttagareKU34/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU34/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU34/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU34/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU34/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU34/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU34/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU34/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:Gatuadress or not(ku:InkomsttagareKU34/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU34/ku:Inkomsttagare or ku:InkomsttagareKU34/ku:Fodelsetid or ku:InkomsttagareKU34/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:Gatuadress or not(ku:InkomsttagareKU34/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU34/ku:Inkomsttagare or ku:InkomsttagareKU34/ku:Fodelsetid or ku:InkomsttagareKU34/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:Postnummer or not(ku:InkomsttagareKU34/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU34/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:Postnummer or not(ku:InkomsttagareKU34/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU34/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU34/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU34/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU34/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU34/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU34/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU34/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:Postnummer or not(ku:InkomsttagareKU34/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU34/ku:Inkomsttagare or ku:InkomsttagareKU34/ku:Fodelsetid or ku:InkomsttagareKU34/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:Postnummer or not(ku:InkomsttagareKU34/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU34/ku:Inkomsttagare or ku:InkomsttagareKU34/ku:Fodelsetid or ku:InkomsttagareKU34/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:Postort or not(ku:InkomsttagareKU34/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU34/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:Postort or not(ku:InkomsttagareKU34/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU34/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU34/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU34/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU34/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU34/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU34/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU34/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:Postort or not(ku:InkomsttagareKU34/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU34/ku:Inkomsttagare or ku:InkomsttagareKU34/ku:Fodelsetid or ku:InkomsttagareKU34/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:Postort or not(ku:InkomsttagareKU34/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU34/ku:Inkomsttagare or ku:InkomsttagareKU34/ku:Fodelsetid or ku:InkomsttagareKU34/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU34/ku:FriAdress) or ku:InkomsttagareKU34/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU34/ku:FriAdress) or ku:InkomsttagareKU34/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU34/ku:Inkomsttagare) or not(ku:InkomsttagareKU34/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU34/ku:Inkomsttagare) or not(ku:InkomsttagareKU34/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU34/ku:OrgNamn) or (not(ku:InkomsttagareKU34/ku:Fodelsetid) and (not(ku:InkomsttagareKU34/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU34/ku:Fornamn) and not(ku:InkomsttagareKU34/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU34/ku:OrgNamn) or (not(ku:InkomsttagareKU34/ku:Fodelsetid) and (not(ku:InkomsttagareKU34/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU34/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU34/ku:Fornamn) and not(ku:InkomsttagareKU34/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU34/ku:OrgNamn or not(ku:InkomsttagareKU34/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU34/ku:Inkomsttagare or ku:InkomsttagareKU34/ku:Fornamn or ku:InkomsttagareKU34/ku:Efternamn or ku:InkomsttagareKU34/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU34/ku:OrgNamn or not(ku:InkomsttagareKU34/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU34/ku:Inkomsttagare or ku:InkomsttagareKU34/ku:Fornamn or ku:InkomsttagareKU34/ku:Efternamn or ku:InkomsttagareKU34/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU34/ku:LandskodTIN) or ku:InkomsttagareKU34/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU34/ku:LandskodTIN) or ku:InkomsttagareKU34/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:AndelAvDepan) or ku:Depanummer"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:AndelAvDepan) or ku:Depanummer">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>076#Du har angett Andel av depån, fält 524. Du ska då också ange Depånummer, fält 523</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:VPNamn or ku:ISIN or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:VPNamn or ku:ISIN or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>085#Du har inte angett något ISIN, fält 572. Då ska du fylla i Namn på aktien/andelen, fält 571</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:VPNamn or (not(ku:ISIN) or (string-length(ku:ISIN) &gt;= 2 and substring(ku:ISIN,1,2) = 'SE') or number(ku:UppgiftslamnareKU34/ku:UppgiftslamnarId) = 165561128074)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:VPNamn or (not(ku:ISIN) or (string-length(ku:ISIN) &gt;= 2 and substring(ku:ISIN,1,2) = 'SE') or number(ku:UppgiftslamnareKU34/ku:UppgiftslamnarId) = 165561128074)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>170#Du har angett ett utländskt nummer (börjar inte på SE) i ISIN, fält 572. Då ska du också fylla i Namn på aktien/andelen, fält 571</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:OptionenForfallen) or not(ku:AvyttradTillISK)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:OptionenForfallen) or not(ku:AvyttradTillISK)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>087#När man markerat Optionen förfallen, fält 813, kan man inte markera Avyttrad till investeringssparkonto, fält 573</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:AntalKontrakt"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:AntalKontrakt">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>091#Du har inte fyllt i Antal kontrakt, fält 578</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:ErhallenErsattning or ku:Borttag or ku:OptionenForfallen or ku:OkandVarde"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:ErhallenErsattning or ku:Borttag or ku:OptionenForfallen or ku:OkandVarde">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>128#Du har varken fyllt i Erhållen ersättning, fält 810, Optionen förfallen, fält 813 eller Okänt värde, fält 599. Kontrolluppgiften är därför alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:OkandVarde) or not(ku:ErhallenErsattning)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:OkandVarde) or not(ku:ErhallenErsattning)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>169#När man fyllt i Erhållen ersättning, fält 810, kan man inte samtidigt ha Okänt värde, fält 599 markerat</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:TypAvOption"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:TypAvOption">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>130#Du har inte fyllt i Typ av option, fält 812</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:ErhallenErsattning) or not(ku:OptionenForfallen)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:ErhallenErsattning) or not(ku:OptionenForfallen)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>131#Du har fyllt i både Erhållen ersättning, fält 810, och Optionen förfallen, fält 813. Båda kan inte vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:OkandVarde) or not(ku:OptionenForfallen)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:OkandVarde) or not(ku:OptionenForfallen)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>172#När man fyllt i Optionen förfallen, fält 813, kan man inte samtidigt ha Okänt värde, fält 599 markerat</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU35" priority="1015" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU35"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU35/ku:TIN) or ku:InkomsttagareKU35/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU35/ku:TIN) or ku:InkomsttagareKU35/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU35/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU35/ku:Inkomsttagare) or ku:UppgiftslamnareKU35/ku:UppgiftslamnarId != ku:InkomsttagareKU35/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU35/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU35/ku:Inkomsttagare) or ku:UppgiftslamnareKU35/ku:UppgiftslamnarId != ku:InkomsttagareKU35/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU35/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU35/ku:Inkomsttagare) + count(ku:InkomsttagareKU35/ku:Fodelsetid) + count(ku:InkomsttagareKU35/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU35/*) + count(//ku:InkomsttagareKU35/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU35/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU35/ku:Inkomsttagare) + count(ku:InkomsttagareKU35/ku:Fodelsetid) + count(ku:InkomsttagareKU35/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU35/*) + count(//ku:InkomsttagareKU35/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:Fodelsetid or ku:InkomsttagareKU35/ku:AnnatIDNr or ku:InkomsttagareKU35/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:Fodelsetid or ku:InkomsttagareKU35/ku:AnnatIDNr or ku:InkomsttagareKU35/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:Fornamn or not(ku:InkomsttagareKU35/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:Fornamn or not(ku:InkomsttagareKU35/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU35/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU35/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU35/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU35/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:Efternamn or not(ku:InkomsttagareKU35/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:Efternamn or not(ku:InkomsttagareKU35/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU35/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU35/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU35/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU35/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:Gatuadress or not(ku:InkomsttagareKU35/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU35/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:Gatuadress or not(ku:InkomsttagareKU35/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU35/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU35/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU35/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU35/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU35/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU35/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU35/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:Gatuadress or not(ku:InkomsttagareKU35/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU35/ku:Inkomsttagare or ku:InkomsttagareKU35/ku:Fodelsetid or ku:InkomsttagareKU35/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:Gatuadress or not(ku:InkomsttagareKU35/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU35/ku:Inkomsttagare or ku:InkomsttagareKU35/ku:Fodelsetid or ku:InkomsttagareKU35/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:Postnummer or not(ku:InkomsttagareKU35/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU35/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:Postnummer or not(ku:InkomsttagareKU35/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU35/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU35/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU35/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU35/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU35/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU35/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU35/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:Postnummer or not(ku:InkomsttagareKU35/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU35/ku:Inkomsttagare or ku:InkomsttagareKU35/ku:Fodelsetid or ku:InkomsttagareKU35/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:Postnummer or not(ku:InkomsttagareKU35/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU35/ku:Inkomsttagare or ku:InkomsttagareKU35/ku:Fodelsetid or ku:InkomsttagareKU35/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:Postort or not(ku:InkomsttagareKU35/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU35/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:Postort or not(ku:InkomsttagareKU35/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU35/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU35/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU35/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU35/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU35/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU35/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU35/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:Postort or not(ku:InkomsttagareKU35/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU35/ku:Inkomsttagare or ku:InkomsttagareKU35/ku:Fodelsetid or ku:InkomsttagareKU35/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:Postort or not(ku:InkomsttagareKU35/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU35/ku:Inkomsttagare or ku:InkomsttagareKU35/ku:Fodelsetid or ku:InkomsttagareKU35/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU35/ku:FriAdress) or ku:InkomsttagareKU35/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU35/ku:FriAdress) or ku:InkomsttagareKU35/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU35/ku:Inkomsttagare) or not(ku:InkomsttagareKU35/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU35/ku:Inkomsttagare) or not(ku:InkomsttagareKU35/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU35/ku:OrgNamn) or (not(ku:InkomsttagareKU35/ku:Fodelsetid) and (not(ku:InkomsttagareKU35/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU35/ku:Fornamn) and not(ku:InkomsttagareKU35/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU35/ku:OrgNamn) or (not(ku:InkomsttagareKU35/ku:Fodelsetid) and (not(ku:InkomsttagareKU35/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU35/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU35/ku:Fornamn) and not(ku:InkomsttagareKU35/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU35/ku:OrgNamn or not(ku:InkomsttagareKU35/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU35/ku:Inkomsttagare or ku:InkomsttagareKU35/ku:Fornamn or ku:InkomsttagareKU35/ku:Efternamn or ku:InkomsttagareKU35/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU35/ku:OrgNamn or not(ku:InkomsttagareKU35/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU35/ku:Inkomsttagare or ku:InkomsttagareKU35/ku:Fornamn or ku:InkomsttagareKU35/ku:Efternamn or ku:InkomsttagareKU35/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU35/ku:LandskodTIN) or ku:InkomsttagareKU35/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU35/ku:LandskodTIN) or ku:InkomsttagareKU35/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:AndelAvDepan) or ku:Depanummer"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:AndelAvDepan) or ku:Depanummer">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>076#Du har angett Andel av depån, fält 524. Du ska då också ange Depånummer, fält 523</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:VPNamn or ku:ISIN or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:VPNamn or ku:ISIN or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>085#Du har inte angett något ISIN, fält 572. Då ska du fylla i Namn på aktien/andelen, fält 571</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:VPNamn or (not(ku:ISIN) or (string-length(ku:ISIN) &gt;= 2 and substring(ku:ISIN,1,2) = 'SE') or number(ku:UppgiftslamnareKU35/ku:UppgiftslamnarId) = 165561128074)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:VPNamn or (not(ku:ISIN) or (string-length(ku:ISIN) &gt;= 2 and substring(ku:ISIN,1,2) = 'SE') or number(ku:UppgiftslamnareKU35/ku:UppgiftslamnarId) = 165561128074)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>170#Du har angett ett utländskt nummer (börjar inte på SE) i ISIN, fält 572. Då ska du också fylla i Namn på aktien/andelen, fält 571</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:AntalKontrakt"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:AntalKontrakt">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>091#Du har inte fyllt i Antal kontrakt, fält 578</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:ErhallenErsattning or ku:Borttag or ku:ErlagdErsattning"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:ErhallenErsattning or ku:Borttag or ku:ErlagdErsattning">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>129#Du har varken fyllt i Erhållen ersättning, fält 810, eller Erlagd ersättning, fält 811. Kontrolluppgiften är därför alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:OkandVarde) or not(ku:ErhallenErsattning)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:OkandVarde) or not(ku:ErhallenErsattning)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>169#När man fyllt i Erhållen ersättning, fält 810, kan man inte samtidigt ha Okänt värde, fält 599 markerat</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Redovisningsmetod"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Redovisningsmetod">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>132#Du har inte fyllt i Redovisningsmetod, fält 814</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU40" priority="1014" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU40"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU40/ku:TIN) or ku:InkomsttagareKU40/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU40/ku:TIN) or ku:InkomsttagareKU40/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU40/ku:Fodelseort) or ku:InkomsttagareKU40/ku:LandskodFodelseort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU40/ku:Fodelseort) or ku:InkomsttagareKU40/ku:LandskodFodelseort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>046#Du har angett Födelseort, fält 077. Då ska du också ange i vilket land födelseorten ligger i fält 078</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU40/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU40/ku:Inkomsttagare) or ku:UppgiftslamnareKU40/ku:UppgiftslamnarId != ku:InkomsttagareKU40/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU40/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU40/ku:Inkomsttagare) or ku:UppgiftslamnareKU40/ku:UppgiftslamnarId != ku:InkomsttagareKU40/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU40/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU40/ku:Inkomsttagare) + count(ku:InkomsttagareKU40/ku:Fodelsetid) + count(ku:InkomsttagareKU40/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU40/*) + count(//ku:InkomsttagareKU40/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU40/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU40/ku:Inkomsttagare) + count(ku:InkomsttagareKU40/ku:Fodelsetid) + count(ku:InkomsttagareKU40/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU40/*) + count(//ku:InkomsttagareKU40/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:Fodelsetid or ku:InkomsttagareKU40/ku:AnnatIDNr or ku:InkomsttagareKU40/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:Fodelsetid or ku:InkomsttagareKU40/ku:AnnatIDNr or ku:InkomsttagareKU40/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:Fornamn or not(ku:InkomsttagareKU40/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:Fornamn or not(ku:InkomsttagareKU40/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU40/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU40/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU40/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU40/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:Efternamn or not(ku:InkomsttagareKU40/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:Efternamn or not(ku:InkomsttagareKU40/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU40/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU40/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU40/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU40/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:Gatuadress or not(ku:InkomsttagareKU40/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU40/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:Gatuadress or not(ku:InkomsttagareKU40/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU40/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU40/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU40/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU40/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU40/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU40/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU40/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:Gatuadress or not(ku:InkomsttagareKU40/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU40/ku:Inkomsttagare or ku:InkomsttagareKU40/ku:Fodelsetid or ku:InkomsttagareKU40/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:Gatuadress or not(ku:InkomsttagareKU40/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU40/ku:Inkomsttagare or ku:InkomsttagareKU40/ku:Fodelsetid or ku:InkomsttagareKU40/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:Postnummer or not(ku:InkomsttagareKU40/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU40/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:Postnummer or not(ku:InkomsttagareKU40/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU40/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU40/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU40/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU40/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU40/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU40/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU40/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:Postnummer or not(ku:InkomsttagareKU40/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU40/ku:Inkomsttagare or ku:InkomsttagareKU40/ku:Fodelsetid or ku:InkomsttagareKU40/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:Postnummer or not(ku:InkomsttagareKU40/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU40/ku:Inkomsttagare or ku:InkomsttagareKU40/ku:Fodelsetid or ku:InkomsttagareKU40/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:Postort or not(ku:InkomsttagareKU40/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU40/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:Postort or not(ku:InkomsttagareKU40/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU40/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU40/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU40/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU40/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU40/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU40/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU40/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:Postort or not(ku:InkomsttagareKU40/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU40/ku:Inkomsttagare or ku:InkomsttagareKU40/ku:Fodelsetid or ku:InkomsttagareKU40/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:Postort or not(ku:InkomsttagareKU40/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU40/ku:Inkomsttagare or ku:InkomsttagareKU40/ku:Fodelsetid or ku:InkomsttagareKU40/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU40/ku:FriAdress) or ku:InkomsttagareKU40/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU40/ku:FriAdress) or ku:InkomsttagareKU40/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU40/ku:Inkomsttagare) or not(ku:InkomsttagareKU40/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU40/ku:Inkomsttagare) or not(ku:InkomsttagareKU40/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU40/ku:OrgNamn) or (not(ku:InkomsttagareKU40/ku:Fodelsetid) and (not(ku:InkomsttagareKU40/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU40/ku:Fornamn) and not(ku:InkomsttagareKU40/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU40/ku:OrgNamn) or (not(ku:InkomsttagareKU40/ku:Fodelsetid) and (not(ku:InkomsttagareKU40/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU40/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU40/ku:Fornamn) and not(ku:InkomsttagareKU40/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU40/ku:OrgNamn or not(ku:InkomsttagareKU40/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU40/ku:Inkomsttagare or ku:InkomsttagareKU40/ku:Fornamn or ku:InkomsttagareKU40/ku:Efternamn or ku:InkomsttagareKU40/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU40/ku:OrgNamn or not(ku:InkomsttagareKU40/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU40/ku:Inkomsttagare or ku:InkomsttagareKU40/ku:Fornamn or ku:InkomsttagareKU40/ku:Efternamn or ku:InkomsttagareKU40/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU40/ku:LandskodTIN) or ku:InkomsttagareKU40/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU40/ku:LandskodTIN) or ku:InkomsttagareKU40/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:VPNamn or ku:ISIN or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:VPNamn or ku:ISIN or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>085#Du har inte angett något ISIN, fält 572. Då ska du fylla i Namn på aktien/andelen, fält 571</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:VPNamn or (not(ku:ISIN) or (string-length(ku:ISIN) &gt;= 2 and substring(ku:ISIN,1,2) = 'SE') or number(ku:UppgiftslamnareKU40/ku:UppgiftslamnarId) = 165561128074)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:VPNamn or (not(ku:ISIN) or (string-length(ku:ISIN) &gt;= 2 and substring(ku:ISIN,1,2) = 'SE') or number(ku:UppgiftslamnareKU40/ku:UppgiftslamnarId) = 165561128074)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>170#Du har angett ett utländskt nummer (börjar inte på SE) i ISIN, fält 572. Då ska du också fylla i Namn på aktien/andelen, fält 571</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Kapitalvinst or ku:Borttag or ku:Kapitalforlust or ku:ErhallenErsattning"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Kapitalvinst or ku:Borttag or ku:Kapitalforlust or ku:ErhallenErsattning">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>093#Du har inte angett varken någon Kapitalvinst, fält 600, någon Kapitalförlust, fält 601, eller någon Erhållen ersättning, fält 810. Kontrolluppgiften är därför alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:ErhallenErsattning) or (not(ku:Kapitalvinst) and not(ku:Kapitalforlust))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:ErhallenErsattning) or (not(ku:Kapitalvinst) and not(ku:Kapitalforlust))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>094#När man fyllt i Erhållen ersättning, fält 810, kan man inte samtidigt ha Kapitalvinst, fält 600, eller Kapitalförlust, fält 601 ifylld</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU41" priority="1013" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU41"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU41/ku:TIN) or ku:InkomsttagareKU41/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU41/ku:TIN) or ku:InkomsttagareKU41/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU41/ku:Fodelseort) or ku:InkomsttagareKU41/ku:LandskodFodelseort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU41/ku:Fodelseort) or ku:InkomsttagareKU41/ku:LandskodFodelseort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>046#Du har angett Födelseort, fält 077. Då ska du också ange i vilket land födelseorten ligger i fält 078</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU41/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU41/ku:Inkomsttagare) or ku:UppgiftslamnareKU41/ku:UppgiftslamnarId != ku:InkomsttagareKU41/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU41/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU41/ku:Inkomsttagare) or ku:UppgiftslamnareKU41/ku:UppgiftslamnarId != ku:InkomsttagareKU41/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU41/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU41/ku:Inkomsttagare) + count(ku:InkomsttagareKU41/ku:Fodelsetid) + count(ku:InkomsttagareKU41/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU41/*) + count(//ku:InkomsttagareKU41/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU41/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU41/ku:Inkomsttagare) + count(ku:InkomsttagareKU41/ku:Fodelsetid) + count(ku:InkomsttagareKU41/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU41/*) + count(//ku:InkomsttagareKU41/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:Fodelsetid or ku:InkomsttagareKU41/ku:AnnatIDNr or ku:InkomsttagareKU41/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:Fodelsetid or ku:InkomsttagareKU41/ku:AnnatIDNr or ku:InkomsttagareKU41/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:Fornamn or not(ku:InkomsttagareKU41/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:Fornamn or not(ku:InkomsttagareKU41/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU41/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU41/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU41/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU41/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:Efternamn or not(ku:InkomsttagareKU41/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:Efternamn or not(ku:InkomsttagareKU41/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU41/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU41/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU41/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU41/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:Gatuadress or not(ku:InkomsttagareKU41/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU41/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:Gatuadress or not(ku:InkomsttagareKU41/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU41/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU41/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU41/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU41/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU41/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU41/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU41/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:Gatuadress or not(ku:InkomsttagareKU41/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU41/ku:Inkomsttagare or ku:InkomsttagareKU41/ku:Fodelsetid or ku:InkomsttagareKU41/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:Gatuadress or not(ku:InkomsttagareKU41/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU41/ku:Inkomsttagare or ku:InkomsttagareKU41/ku:Fodelsetid or ku:InkomsttagareKU41/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:Postnummer or not(ku:InkomsttagareKU41/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU41/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:Postnummer or not(ku:InkomsttagareKU41/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU41/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU41/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU41/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU41/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU41/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU41/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU41/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:Postnummer or not(ku:InkomsttagareKU41/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU41/ku:Inkomsttagare or ku:InkomsttagareKU41/ku:Fodelsetid or ku:InkomsttagareKU41/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:Postnummer or not(ku:InkomsttagareKU41/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU41/ku:Inkomsttagare or ku:InkomsttagareKU41/ku:Fodelsetid or ku:InkomsttagareKU41/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:Postort or not(ku:InkomsttagareKU41/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU41/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:Postort or not(ku:InkomsttagareKU41/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU41/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU41/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU41/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU41/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU41/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU41/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU41/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:Postort or not(ku:InkomsttagareKU41/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU41/ku:Inkomsttagare or ku:InkomsttagareKU41/ku:Fodelsetid or ku:InkomsttagareKU41/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:Postort or not(ku:InkomsttagareKU41/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU41/ku:Inkomsttagare or ku:InkomsttagareKU41/ku:Fodelsetid or ku:InkomsttagareKU41/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU41/ku:FriAdress) or ku:InkomsttagareKU41/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU41/ku:FriAdress) or ku:InkomsttagareKU41/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU41/ku:Inkomsttagare) or not(ku:InkomsttagareKU41/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU41/ku:Inkomsttagare) or not(ku:InkomsttagareKU41/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU41/ku:OrgNamn) or (not(ku:InkomsttagareKU41/ku:Fodelsetid) and (not(ku:InkomsttagareKU41/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU41/ku:Fornamn) and not(ku:InkomsttagareKU41/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU41/ku:OrgNamn) or (not(ku:InkomsttagareKU41/ku:Fodelsetid) and (not(ku:InkomsttagareKU41/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU41/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU41/ku:Fornamn) and not(ku:InkomsttagareKU41/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU41/ku:OrgNamn or not(ku:InkomsttagareKU41/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU41/ku:Inkomsttagare or ku:InkomsttagareKU41/ku:Fornamn or ku:InkomsttagareKU41/ku:Efternamn or ku:InkomsttagareKU41/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU41/ku:OrgNamn or not(ku:InkomsttagareKU41/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU41/ku:Inkomsttagare or ku:InkomsttagareKU41/ku:Fornamn or ku:InkomsttagareKU41/ku:Efternamn or ku:InkomsttagareKU41/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU41/ku:LandskodTIN) or ku:InkomsttagareKU41/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU41/ku:LandskodTIN) or ku:InkomsttagareKU41/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:VPNamn or ku:ISIN or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:VPNamn or ku:ISIN or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>085#Du har inte angett något ISIN, fält 572. Då ska du fylla i Namn på aktien/andelen, fält 571</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:VPNamn or (not(ku:ISIN) or (string-length(ku:ISIN) &gt;= 2 and substring(ku:ISIN,1,2) = 'SE') or number(ku:UppgiftslamnareKU41/ku:UppgiftslamnarId) = 165561128074)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:VPNamn or (not(ku:ISIN) or (string-length(ku:ISIN) &gt;= 2 and substring(ku:ISIN,1,2) = 'SE') or number(ku:UppgiftslamnareKU41/ku:UppgiftslamnarId) = 165561128074)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>170#Du har angett ett utländskt nummer (börjar inte på SE) i ISIN, fält 572. Då ska du också fylla i Namn på aktien/andelen, fält 571</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Schablonintakt"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Schablonintakt">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>133#Du har inte fyllt i Schablonintäkt, fält 815</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU50" priority="1012" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU50"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU50/ku:ULUtlandsktOrgnr) or ku:UppgiftslamnareKU50/ku:LandskodUL"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU50/ku:ULUtlandsktOrgnr) or ku:UppgiftslamnareKU50/ku:LandskodUL">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>043#Du har fyllt i Utländskt organisationsnummer, fält 506. Du ska då också ange Land, fält 075</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU50/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU50/ku:Inkomsttagare) or ku:UppgiftslamnareKU50/ku:UppgiftslamnarId != ku:InkomsttagareKU50/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU50/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU50/ku:Inkomsttagare) or ku:UppgiftslamnareKU50/ku:UppgiftslamnarId != ku:InkomsttagareKU50/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU50/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU50/ku:Inkomsttagare) + count(ku:InkomsttagareKU50/ku:Fodelsetid) + count(ku:InkomsttagareKU50/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU50/*) + count(//ku:InkomsttagareKU50/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU50/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU50/ku:Inkomsttagare) + count(ku:InkomsttagareKU50/ku:Fodelsetid) + count(ku:InkomsttagareKU50/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU50/*) + count(//ku:InkomsttagareKU50/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:Fodelsetid or ku:InkomsttagareKU50/ku:AnnatIDNr or ku:InkomsttagareKU50/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:Fodelsetid or ku:InkomsttagareKU50/ku:AnnatIDNr or ku:InkomsttagareKU50/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:Fornamn or not(ku:InkomsttagareKU50/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:Fornamn or not(ku:InkomsttagareKU50/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU50/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU50/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU50/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU50/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:Efternamn or not(ku:InkomsttagareKU50/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:Efternamn or not(ku:InkomsttagareKU50/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU50/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU50/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU50/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU50/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:Gatuadress or not(ku:InkomsttagareKU50/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU50/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:Gatuadress or not(ku:InkomsttagareKU50/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU50/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU50/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU50/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU50/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU50/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU50/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU50/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:Gatuadress or not(ku:InkomsttagareKU50/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU50/ku:Inkomsttagare or ku:InkomsttagareKU50/ku:Fodelsetid or ku:InkomsttagareKU50/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:Gatuadress or not(ku:InkomsttagareKU50/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU50/ku:Inkomsttagare or ku:InkomsttagareKU50/ku:Fodelsetid or ku:InkomsttagareKU50/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:Postnummer or not(ku:InkomsttagareKU50/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU50/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:Postnummer or not(ku:InkomsttagareKU50/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU50/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU50/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU50/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU50/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU50/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU50/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU50/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:Postnummer or not(ku:InkomsttagareKU50/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU50/ku:Inkomsttagare or ku:InkomsttagareKU50/ku:Fodelsetid or ku:InkomsttagareKU50/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:Postnummer or not(ku:InkomsttagareKU50/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU50/ku:Inkomsttagare or ku:InkomsttagareKU50/ku:Fodelsetid or ku:InkomsttagareKU50/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:Postort or not(ku:InkomsttagareKU50/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU50/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:Postort or not(ku:InkomsttagareKU50/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU50/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU50/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU50/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU50/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU50/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU50/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU50/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:Postort or not(ku:InkomsttagareKU50/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU50/ku:Inkomsttagare or ku:InkomsttagareKU50/ku:Fodelsetid or ku:InkomsttagareKU50/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:Postort or not(ku:InkomsttagareKU50/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU50/ku:Inkomsttagare or ku:InkomsttagareKU50/ku:Fodelsetid or ku:InkomsttagareKU50/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU50/ku:FriAdress) or ku:InkomsttagareKU50/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU50/ku:FriAdress) or ku:InkomsttagareKU50/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU50/ku:Inkomsttagare) or not(ku:InkomsttagareKU50/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU50/ku:Inkomsttagare) or not(ku:InkomsttagareKU50/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU50/ku:OrgNamn) or (not(ku:InkomsttagareKU50/ku:Fodelsetid) and (not(ku:InkomsttagareKU50/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU50/ku:Fornamn) and not(ku:InkomsttagareKU50/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU50/ku:OrgNamn) or (not(ku:InkomsttagareKU50/ku:Fodelsetid) and (not(ku:InkomsttagareKU50/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU50/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU50/ku:Fornamn) and not(ku:InkomsttagareKU50/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU50/ku:OrgNamn or not(ku:InkomsttagareKU50/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU50/ku:Inkomsttagare or ku:InkomsttagareKU50/ku:Fornamn or ku:InkomsttagareKU50/ku:Efternamn or ku:InkomsttagareKU50/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU50/ku:OrgNamn or not(ku:InkomsttagareKU50/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU50/ku:Inkomsttagare or ku:InkomsttagareKU50/ku:Fornamn or ku:InkomsttagareKU50/ku:Efternamn or ku:InkomsttagareKU50/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU50/ku:LandskodUL) or ku:UppgiftslamnareKU50/ku:ULUtlandsktOrgnr"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU50/ku:LandskodUL) or ku:UppgiftslamnareKU50/ku:ULUtlandsktOrgnr">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>072#Du har angett ett land i fältet Land, fält 075, dvs ett land för ett utländskt organisationsnummer. Du behöver också ange Utländskt organisationsnummer, fält 506</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:BetaldPremie"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:BetaldPremie">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>095#Du har inte fyllt i Betald premie i aktuell valuta/Inbetalning på pensionssparkonto, fält 620</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU52" priority="1011" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU52"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or (ku:LandskodUL or ku:UppgiftslamnareKU52/ku:LandskodUL)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or (ku:LandskodUL or ku:UppgiftslamnareKU52/ku:LandskodUL)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>044#Land, fält 075, ska alltid anges på denna kontrolluppgiftstyp</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU52/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU52/ku:Inkomsttagare) or ku:UppgiftslamnareKU52/ku:UppgiftslamnarId != ku:InkomsttagareKU52/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU52/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU52/ku:Inkomsttagare) or ku:UppgiftslamnareKU52/ku:UppgiftslamnarId != ku:InkomsttagareKU52/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU52/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU52/ku:Inkomsttagare) + count(ku:InkomsttagareKU52/ku:Fodelsetid) + count(ku:InkomsttagareKU52/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU52/*) + count(//ku:InkomsttagareKU52/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU52/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU52/ku:Inkomsttagare) + count(ku:InkomsttagareKU52/ku:Fodelsetid) + count(ku:InkomsttagareKU52/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU52/*) + count(//ku:InkomsttagareKU52/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:Fodelsetid or ku:InkomsttagareKU52/ku:AnnatIDNr or ku:InkomsttagareKU52/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:Fodelsetid or ku:InkomsttagareKU52/ku:AnnatIDNr or ku:InkomsttagareKU52/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:Fornamn or not(ku:InkomsttagareKU52/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:Fornamn or not(ku:InkomsttagareKU52/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU52/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU52/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU52/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU52/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:Efternamn or not(ku:InkomsttagareKU52/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:Efternamn or not(ku:InkomsttagareKU52/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU52/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU52/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU52/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU52/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:Gatuadress or not(ku:InkomsttagareKU52/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU52/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:Gatuadress or not(ku:InkomsttagareKU52/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU52/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU52/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU52/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU52/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU52/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU52/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU52/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:Gatuadress or not(ku:InkomsttagareKU52/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU52/ku:Inkomsttagare or ku:InkomsttagareKU52/ku:Fodelsetid or ku:InkomsttagareKU52/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:Gatuadress or not(ku:InkomsttagareKU52/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU52/ku:Inkomsttagare or ku:InkomsttagareKU52/ku:Fodelsetid or ku:InkomsttagareKU52/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:Postnummer or not(ku:InkomsttagareKU52/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU52/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:Postnummer or not(ku:InkomsttagareKU52/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU52/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU52/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU52/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU52/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU52/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU52/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU52/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:Postnummer or not(ku:InkomsttagareKU52/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU52/ku:Inkomsttagare or ku:InkomsttagareKU52/ku:Fodelsetid or ku:InkomsttagareKU52/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:Postnummer or not(ku:InkomsttagareKU52/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU52/ku:Inkomsttagare or ku:InkomsttagareKU52/ku:Fodelsetid or ku:InkomsttagareKU52/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:Postort or not(ku:InkomsttagareKU52/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU52/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:Postort or not(ku:InkomsttagareKU52/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU52/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU52/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU52/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU52/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU52/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU52/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU52/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:Postort or not(ku:InkomsttagareKU52/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU52/ku:Inkomsttagare or ku:InkomsttagareKU52/ku:Fodelsetid or ku:InkomsttagareKU52/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:Postort or not(ku:InkomsttagareKU52/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU52/ku:Inkomsttagare or ku:InkomsttagareKU52/ku:Fodelsetid or ku:InkomsttagareKU52/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU52/ku:FriAdress) or ku:InkomsttagareKU52/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU52/ku:FriAdress) or ku:InkomsttagareKU52/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU52/ku:Inkomsttagare) or not(ku:InkomsttagareKU52/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU52/ku:Inkomsttagare) or not(ku:InkomsttagareKU52/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU52/ku:OrgNamn) or (not(ku:InkomsttagareKU52/ku:Fodelsetid) and (not(ku:InkomsttagareKU52/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU52/ku:Fornamn) and not(ku:InkomsttagareKU52/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU52/ku:OrgNamn) or (not(ku:InkomsttagareKU52/ku:Fodelsetid) and (not(ku:InkomsttagareKU52/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU52/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU52/ku:Fornamn) and not(ku:InkomsttagareKU52/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU52/ku:OrgNamn or not(ku:InkomsttagareKU52/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU52/ku:Inkomsttagare or ku:InkomsttagareKU52/ku:Fornamn or ku:InkomsttagareKU52/ku:Efternamn or ku:InkomsttagareKU52/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU52/ku:OrgNamn or not(ku:InkomsttagareKU52/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU52/ku:Inkomsttagare or ku:InkomsttagareKU52/ku:Fornamn or ku:InkomsttagareKU52/ku:Efternamn or ku:InkomsttagareKU52/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or (ku:ULUtlandsktOrgnr or ku:UppgiftslamnareKU52/ku:ULUtlandsktOrgnr)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or (ku:ULUtlandsktOrgnr or ku:UppgiftslamnareKU52/ku:ULUtlandsktOrgnr)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>073#Fältet Utländskt organisationsnummer, fält 506, ska alltid fyllas i på denna kontrolluppgiftstyp</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:TypForsakring) or ku:TypForsakring != 'P' or ku:Forsakringsavtalsnummer"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:TypForsakring) or ku:TypForsakring != 'P' or ku:Forsakringsavtalsnummer">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>074#Försäkringsavtalsnummer, fält 507, måste alltid fyllas i när man angett att Typ av försäkring, fält 654, är Pensionsförsäkring</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Kapitalunderlag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Kapitalunderlag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>107#Du har inte fyllt i Kapitalunderlag, fält 652</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:TypForsakring"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:TypForsakring">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>108#Du har inte angett Typ av försäkring, fält 654</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU53" priority="1010" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU53"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or (ku:LandskodUL or ku:UppgiftslamnareKU53/ku:LandskodUL)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or (ku:LandskodUL or ku:UppgiftslamnareKU53/ku:LandskodUL)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>044#Land, fält 075, ska alltid anges på denna kontrolluppgiftstyp</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU53/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU53/ku:Inkomsttagare) or ku:UppgiftslamnareKU53/ku:UppgiftslamnarId != ku:InkomsttagareKU53/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU53/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU53/ku:Inkomsttagare) or ku:UppgiftslamnareKU53/ku:UppgiftslamnarId != ku:InkomsttagareKU53/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU53/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU53/ku:Inkomsttagare) + count(ku:InkomsttagareKU53/ku:Fodelsetid) + count(ku:InkomsttagareKU53/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU53/*) + count(//ku:InkomsttagareKU53/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU53/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU53/ku:Inkomsttagare) + count(ku:InkomsttagareKU53/ku:Fodelsetid) + count(ku:InkomsttagareKU53/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU53/*) + count(//ku:InkomsttagareKU53/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:Fodelsetid or ku:InkomsttagareKU53/ku:AnnatIDNr or ku:InkomsttagareKU53/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:Fodelsetid or ku:InkomsttagareKU53/ku:AnnatIDNr or ku:InkomsttagareKU53/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:Fornamn or not(ku:InkomsttagareKU53/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:Fornamn or not(ku:InkomsttagareKU53/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU53/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU53/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU53/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU53/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:Efternamn or not(ku:InkomsttagareKU53/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:Efternamn or not(ku:InkomsttagareKU53/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU53/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU53/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU53/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU53/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:Gatuadress or not(ku:InkomsttagareKU53/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU53/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:Gatuadress or not(ku:InkomsttagareKU53/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU53/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU53/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU53/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU53/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU53/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU53/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU53/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:Gatuadress or not(ku:InkomsttagareKU53/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU53/ku:Inkomsttagare or ku:InkomsttagareKU53/ku:Fodelsetid or ku:InkomsttagareKU53/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:Gatuadress or not(ku:InkomsttagareKU53/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU53/ku:Inkomsttagare or ku:InkomsttagareKU53/ku:Fodelsetid or ku:InkomsttagareKU53/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:Postnummer or not(ku:InkomsttagareKU53/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU53/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:Postnummer or not(ku:InkomsttagareKU53/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU53/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU53/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU53/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU53/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU53/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU53/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU53/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:Postnummer or not(ku:InkomsttagareKU53/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU53/ku:Inkomsttagare or ku:InkomsttagareKU53/ku:Fodelsetid or ku:InkomsttagareKU53/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:Postnummer or not(ku:InkomsttagareKU53/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU53/ku:Inkomsttagare or ku:InkomsttagareKU53/ku:Fodelsetid or ku:InkomsttagareKU53/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:Postort or not(ku:InkomsttagareKU53/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU53/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:Postort or not(ku:InkomsttagareKU53/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU53/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU53/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU53/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU53/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU53/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU53/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU53/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:Postort or not(ku:InkomsttagareKU53/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU53/ku:Inkomsttagare or ku:InkomsttagareKU53/ku:Fodelsetid or ku:InkomsttagareKU53/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:Postort or not(ku:InkomsttagareKU53/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU53/ku:Inkomsttagare or ku:InkomsttagareKU53/ku:Fodelsetid or ku:InkomsttagareKU53/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU53/ku:FriAdress) or ku:InkomsttagareKU53/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU53/ku:FriAdress) or ku:InkomsttagareKU53/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU53/ku:Inkomsttagare) or not(ku:InkomsttagareKU53/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU53/ku:Inkomsttagare) or not(ku:InkomsttagareKU53/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU53/ku:OrgNamn) or (not(ku:InkomsttagareKU53/ku:Fodelsetid) and (not(ku:InkomsttagareKU53/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU53/ku:Fornamn) and not(ku:InkomsttagareKU53/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU53/ku:OrgNamn) or (not(ku:InkomsttagareKU53/ku:Fodelsetid) and (not(ku:InkomsttagareKU53/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU53/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU53/ku:Fornamn) and not(ku:InkomsttagareKU53/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU53/ku:OrgNamn or not(ku:InkomsttagareKU53/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU53/ku:Inkomsttagare or ku:InkomsttagareKU53/ku:Fornamn or ku:InkomsttagareKU53/ku:Efternamn or ku:InkomsttagareKU53/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU53/ku:OrgNamn or not(ku:InkomsttagareKU53/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU53/ku:Inkomsttagare or ku:InkomsttagareKU53/ku:Fornamn or ku:InkomsttagareKU53/ku:Efternamn or ku:InkomsttagareKU53/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or (ku:ULUtlandsktOrgnr or ku:UppgiftslamnareKU53/ku:ULUtlandsktOrgnr)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or (ku:ULUtlandsktOrgnr or ku:UppgiftslamnareKU53/ku:ULUtlandsktOrgnr)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>073#Fältet Utländskt organisationsnummer, fält 506, ska alltid fyllas i på denna kontrolluppgiftstyp</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:SvensktRegNr or ku:NamnForsakrGivare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:SvensktRegNr or ku:NamnForsakrGivare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>115#Du har inte angett utländsk försäkringsgivares Namn, fält 680. Det måste alltid fyllas i när Svenskt registreringsnummer, fält 683, inte angetts</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:SvensktRegNr or ku:AdrForsakrGivare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:SvensktRegNr or ku:AdrForsakrGivare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>116#Du har inte angett utländsk försäkringsgivares Adress, fält 681. Det måste alltid fyllas i när Svenskt registreringsnummer, fält 683, inte angetts</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:SvensktRegNr or ku:PostadrForsakrGivare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:SvensktRegNr or ku:PostadrForsakrGivare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>117#Du har inte angett utländsk försäkringsgivares Postadress, fält 682. Det måste alltid fyllas i när Svenskt registreringsnummer, fält 683, inte angetts</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU55" priority="1009" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU55"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU55/ku:TIN) or ku:InkomsttagareKU55/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU55/ku:TIN) or ku:InkomsttagareKU55/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU55/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU55/ku:Inkomsttagare) or ku:UppgiftslamnareKU55/ku:UppgiftslamnarId != ku:InkomsttagareKU55/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU55/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU55/ku:Inkomsttagare) or ku:UppgiftslamnareKU55/ku:UppgiftslamnarId != ku:InkomsttagareKU55/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU55/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU55/ku:Inkomsttagare) + count(ku:InkomsttagareKU55/ku:Fodelsetid) + count(ku:InkomsttagareKU55/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU55/*) + count(//ku:InkomsttagareKU55/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU55/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU55/ku:Inkomsttagare) + count(ku:InkomsttagareKU55/ku:Fodelsetid) + count(ku:InkomsttagareKU55/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU55/*) + count(//ku:InkomsttagareKU55/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:Fodelsetid or ku:InkomsttagareKU55/ku:AnnatIDNr or ku:InkomsttagareKU55/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:Fodelsetid or ku:InkomsttagareKU55/ku:AnnatIDNr or ku:InkomsttagareKU55/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:Fornamn or not(ku:InkomsttagareKU55/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:Fornamn or not(ku:InkomsttagareKU55/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU55/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU55/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU55/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU55/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:Efternamn or not(ku:InkomsttagareKU55/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:Efternamn or not(ku:InkomsttagareKU55/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU55/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU55/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU55/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU55/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:Gatuadress or not(ku:InkomsttagareKU55/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU55/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:Gatuadress or not(ku:InkomsttagareKU55/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU55/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU55/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU55/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU55/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU55/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU55/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU55/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:Gatuadress or not(ku:InkomsttagareKU55/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU55/ku:Inkomsttagare or ku:InkomsttagareKU55/ku:Fodelsetid or ku:InkomsttagareKU55/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:Gatuadress or not(ku:InkomsttagareKU55/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU55/ku:Inkomsttagare or ku:InkomsttagareKU55/ku:Fodelsetid or ku:InkomsttagareKU55/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:Postnummer or not(ku:InkomsttagareKU55/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU55/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:Postnummer or not(ku:InkomsttagareKU55/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU55/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU55/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU55/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU55/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU55/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU55/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU55/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:Postnummer or not(ku:InkomsttagareKU55/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU55/ku:Inkomsttagare or ku:InkomsttagareKU55/ku:Fodelsetid or ku:InkomsttagareKU55/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:Postnummer or not(ku:InkomsttagareKU55/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU55/ku:Inkomsttagare or ku:InkomsttagareKU55/ku:Fodelsetid or ku:InkomsttagareKU55/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:Postort or not(ku:InkomsttagareKU55/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU55/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:Postort or not(ku:InkomsttagareKU55/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU55/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU55/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU55/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU55/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU55/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU55/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU55/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:Postort or not(ku:InkomsttagareKU55/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU55/ku:Inkomsttagare or ku:InkomsttagareKU55/ku:Fodelsetid or ku:InkomsttagareKU55/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:Postort or not(ku:InkomsttagareKU55/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU55/ku:Inkomsttagare or ku:InkomsttagareKU55/ku:Fodelsetid or ku:InkomsttagareKU55/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU55/ku:FriAdress) or ku:InkomsttagareKU55/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU55/ku:FriAdress) or ku:InkomsttagareKU55/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU55/ku:Inkomsttagare) or not(ku:InkomsttagareKU55/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU55/ku:Inkomsttagare) or not(ku:InkomsttagareKU55/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU55/ku:OrgNamn) or (not(ku:InkomsttagareKU55/ku:Fodelsetid) and (not(ku:InkomsttagareKU55/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU55/ku:Fornamn) and not(ku:InkomsttagareKU55/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU55/ku:OrgNamn) or (not(ku:InkomsttagareKU55/ku:Fodelsetid) and (not(ku:InkomsttagareKU55/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU55/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU55/ku:Fornamn) and not(ku:InkomsttagareKU55/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU55/ku:OrgNamn or not(ku:InkomsttagareKU55/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU55/ku:Inkomsttagare or ku:InkomsttagareKU55/ku:Fornamn or ku:InkomsttagareKU55/ku:Efternamn or ku:InkomsttagareKU55/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU55/ku:OrgNamn or not(ku:InkomsttagareKU55/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU55/ku:Inkomsttagare or ku:InkomsttagareKU55/ku:Fornamn or ku:InkomsttagareKU55/ku:Efternamn or ku:InkomsttagareKU55/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU55/ku:LandskodTIN) or ku:InkomsttagareKU55/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU55/ku:LandskodTIN) or ku:InkomsttagareKU55/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:BostRattBeteckning"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:BostRattBeteckning">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>097#Du har inte angett Bostadsrättens/lägenhetens beteckning, fält 630</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Overlatelsedatum"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Overlatelsedatum">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>098#Du har inte angett Överlåtelsedatum, fält 631</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Overlatelsedatum) or (number(substring(ku:Overlatelsedatum,1,4)) &lt;= number(ku:Inkomstar))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Overlatelsedatum) or (number(substring(ku:Overlatelsedatum,1,4)) &lt;= number(ku:Inkomstar))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>099#Du har angett ett Överlåtelsedatum, fält 631, som är efter inkomståret</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:OverlatelseArvBodeln) or not(ku:Tillaggskopeskilling)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:OverlatelseArvBodeln) or not(ku:Tillaggskopeskilling)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>100#Du har angett att Överlåtelsen har skett genom arv, gåva, bodelning eller liknande, fält 633, och Tilläggsköpeskilling, fält 639. När man redovisar tilläggsköpeskilling kan man inte samtidigt ange att överlåtelsen skett genom gåva m.m.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Overlatelsepris or ku:Borttag or ku:OverlatelseArvBodeln or ku:Tillaggskopeskilling"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Overlatelsepris or ku:Borttag or ku:OverlatelseArvBodeln or ku:Tillaggskopeskilling">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>101#Du har inte angett varken Överlåtelsepris, fält 634, att Överlåtelsen har skett genom arv, gåva, bodelning eller liknande, fält 633, eller Tilläggsköpeskilling, fält 639</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Forvarvsdatum"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Forvarvsdatum">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>102#Du har inte angett Förvärvsdatum, fält 640</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Overlatelsedatum) or not(ku:Forvarvsdatum) or (number(ku:Forvarvsdatum) &lt;= number(ku:Overlatelsedatum))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Overlatelsedatum) or not(ku:Forvarvsdatum) or (number(ku:Forvarvsdatum) &lt;= number(ku:Overlatelsedatum))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>103#Du har angett Förvärvsdatum, fält 640, med ett senare datum än Överlåtelsedatum, fält 631</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:OverlatelseArvBodeln or ku:Tillaggskopeskilling or ku:ForvarvArvBodeln or ku:AndelBRFFormogenhet1974 or not(number(ku:Forvarvsdatum) &gt; 19831231) or ku:Forvarvspris"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:OverlatelseArvBodeln or ku:Tillaggskopeskilling or ku:ForvarvArvBodeln or ku:AndelBRFFormogenhet1974 or not(number(ku:Forvarvsdatum) &gt; 19831231) or ku:Forvarvspris">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>104#Du har varken angett Förvärvspris (bruttobelopp), fält 643, Förvärvet har helt eller delvis skett genom arv, gåva, bodelning eller liknande, fält 642, eller Bostadsrättens andel av föreningens behållna förmögenhet den 1 januari 1974, fält 645. Något av dessa fält ska alltid anges om bostadsrätten förvärvats efter 1983 (inte vid tilläggsköpeskilling eller avyttring genom arv, gåva eller bodelning)</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:GemensamIndividuell"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:GemensamIndividuell">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>106#Du har inte angett om Uppgifterna i denna blankett är gemensamma eller individuella, fält 646</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU65" priority="1008" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU65"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU65/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU65/ku:Inkomsttagare) or ku:UppgiftslamnareKU65/ku:UppgiftslamnarId != ku:InkomsttagareKU65/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU65/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU65/ku:Inkomsttagare) or ku:UppgiftslamnareKU65/ku:UppgiftslamnarId != ku:InkomsttagareKU65/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU65/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU65/ku:Inkomsttagare) + count(ku:InkomsttagareKU65/ku:Fodelsetid) + count(ku:InkomsttagareKU65/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU65/*) + count(//ku:InkomsttagareKU65/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU65/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU65/ku:Inkomsttagare) + count(ku:InkomsttagareKU65/ku:Fodelsetid) + count(ku:InkomsttagareKU65/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU65/*) + count(//ku:InkomsttagareKU65/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:Fodelsetid or ku:InkomsttagareKU65/ku:AnnatIDNr or ku:InkomsttagareKU65/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:Fodelsetid or ku:InkomsttagareKU65/ku:AnnatIDNr or ku:InkomsttagareKU65/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:Fornamn or not(ku:InkomsttagareKU65/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:Fornamn or not(ku:InkomsttagareKU65/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU65/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU65/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU65/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU65/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:Efternamn or not(ku:InkomsttagareKU65/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:Efternamn or not(ku:InkomsttagareKU65/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU65/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU65/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU65/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU65/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:Gatuadress or not(ku:InkomsttagareKU65/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU65/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:Gatuadress or not(ku:InkomsttagareKU65/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU65/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU65/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU65/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU65/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU65/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU65/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU65/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:Gatuadress or not(ku:InkomsttagareKU65/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU65/ku:Inkomsttagare or ku:InkomsttagareKU65/ku:Fodelsetid or ku:InkomsttagareKU65/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:Gatuadress or not(ku:InkomsttagareKU65/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU65/ku:Inkomsttagare or ku:InkomsttagareKU65/ku:Fodelsetid or ku:InkomsttagareKU65/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:Postnummer or not(ku:InkomsttagareKU65/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU65/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:Postnummer or not(ku:InkomsttagareKU65/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU65/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU65/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU65/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU65/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU65/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU65/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU65/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:Postnummer or not(ku:InkomsttagareKU65/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU65/ku:Inkomsttagare or ku:InkomsttagareKU65/ku:Fodelsetid or ku:InkomsttagareKU65/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:Postnummer or not(ku:InkomsttagareKU65/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU65/ku:Inkomsttagare or ku:InkomsttagareKU65/ku:Fodelsetid or ku:InkomsttagareKU65/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:Postort or not(ku:InkomsttagareKU65/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU65/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:Postort or not(ku:InkomsttagareKU65/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU65/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU65/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU65/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU65/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU65/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU65/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU65/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:Postort or not(ku:InkomsttagareKU65/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU65/ku:Inkomsttagare or ku:InkomsttagareKU65/ku:Fodelsetid or ku:InkomsttagareKU65/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:Postort or not(ku:InkomsttagareKU65/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU65/ku:Inkomsttagare or ku:InkomsttagareKU65/ku:Fodelsetid or ku:InkomsttagareKU65/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU65/ku:FriAdress) or ku:InkomsttagareKU65/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU65/ku:FriAdress) or ku:InkomsttagareKU65/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU65/ku:Inkomsttagare) or not(ku:InkomsttagareKU65/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU65/ku:Inkomsttagare) or not(ku:InkomsttagareKU65/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU65/ku:OrgNamn) or (not(ku:InkomsttagareKU65/ku:Fodelsetid) and (not(ku:InkomsttagareKU65/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU65/ku:Fornamn) and not(ku:InkomsttagareKU65/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU65/ku:OrgNamn) or (not(ku:InkomsttagareKU65/ku:Fodelsetid) and (not(ku:InkomsttagareKU65/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU65/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU65/ku:Fornamn) and not(ku:InkomsttagareKU65/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU65/ku:OrgNamn or not(ku:InkomsttagareKU65/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU65/ku:Inkomsttagare or ku:InkomsttagareKU65/ku:Fornamn or ku:InkomsttagareKU65/ku:Efternamn or ku:InkomsttagareKU65/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU65/ku:OrgNamn or not(ku:InkomsttagareKU65/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU65/ku:Inkomsttagare or ku:InkomsttagareKU65/ku:Fornamn or ku:InkomsttagareKU65/ku:Efternamn or ku:InkomsttagareKU65/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:MottagetGavobelopp"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:MottagetGavobelopp">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>096#Du har inte fyllt i Mottaget gåvobelopp, fält 621</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU66" priority="1007" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU66"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU66/ku:TIN) or ku:InkomsttagareKU66/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU66/ku:TIN) or ku:InkomsttagareKU66/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU66/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU66/ku:Inkomsttagare) or ku:UppgiftslamnareKU66/ku:UppgiftslamnarId != ku:InkomsttagareKU66/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU66/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU66/ku:Inkomsttagare) or ku:UppgiftslamnareKU66/ku:UppgiftslamnarId != ku:InkomsttagareKU66/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU66/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU66/ku:Inkomsttagare) + count(ku:InkomsttagareKU66/ku:Fodelsetid) + count(ku:InkomsttagareKU66/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU66/*) + count(//ku:InkomsttagareKU66/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU66/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU66/ku:Inkomsttagare) + count(ku:InkomsttagareKU66/ku:Fodelsetid) + count(ku:InkomsttagareKU66/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU66/*) + count(//ku:InkomsttagareKU66/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:Fodelsetid or ku:InkomsttagareKU66/ku:AnnatIDNr or ku:InkomsttagareKU66/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:Fodelsetid or ku:InkomsttagareKU66/ku:AnnatIDNr or ku:InkomsttagareKU66/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:Fornamn or not(ku:InkomsttagareKU66/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:Fornamn or not(ku:InkomsttagareKU66/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU66/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU66/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU66/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU66/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:Efternamn or not(ku:InkomsttagareKU66/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:Efternamn or not(ku:InkomsttagareKU66/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU66/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU66/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU66/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU66/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:Gatuadress or not(ku:InkomsttagareKU66/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU66/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:Gatuadress or not(ku:InkomsttagareKU66/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU66/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU66/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU66/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU66/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU66/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU66/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU66/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:Gatuadress or not(ku:InkomsttagareKU66/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU66/ku:Inkomsttagare or ku:InkomsttagareKU66/ku:Fodelsetid or ku:InkomsttagareKU66/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:Gatuadress or not(ku:InkomsttagareKU66/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU66/ku:Inkomsttagare or ku:InkomsttagareKU66/ku:Fodelsetid or ku:InkomsttagareKU66/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:Postnummer or not(ku:InkomsttagareKU66/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU66/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:Postnummer or not(ku:InkomsttagareKU66/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU66/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU66/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU66/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU66/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU66/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU66/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU66/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:Postnummer or not(ku:InkomsttagareKU66/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU66/ku:Inkomsttagare or ku:InkomsttagareKU66/ku:Fodelsetid or ku:InkomsttagareKU66/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:Postnummer or not(ku:InkomsttagareKU66/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU66/ku:Inkomsttagare or ku:InkomsttagareKU66/ku:Fodelsetid or ku:InkomsttagareKU66/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:Postort or not(ku:InkomsttagareKU66/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU66/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:Postort or not(ku:InkomsttagareKU66/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU66/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU66/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU66/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU66/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU66/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU66/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU66/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:Postort or not(ku:InkomsttagareKU66/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU66/ku:Inkomsttagare or ku:InkomsttagareKU66/ku:Fodelsetid or ku:InkomsttagareKU66/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:Postort or not(ku:InkomsttagareKU66/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU66/ku:Inkomsttagare or ku:InkomsttagareKU66/ku:Fodelsetid or ku:InkomsttagareKU66/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU66/ku:FriAdress) or ku:InkomsttagareKU66/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU66/ku:FriAdress) or ku:InkomsttagareKU66/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU66/ku:Inkomsttagare) or not(ku:InkomsttagareKU66/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU66/ku:Inkomsttagare) or not(ku:InkomsttagareKU66/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU66/ku:OrgNamn) or (not(ku:InkomsttagareKU66/ku:Fodelsetid) and (not(ku:InkomsttagareKU66/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU66/ku:Fornamn) and not(ku:InkomsttagareKU66/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU66/ku:OrgNamn) or (not(ku:InkomsttagareKU66/ku:Fodelsetid) and (not(ku:InkomsttagareKU66/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU66/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU66/ku:Fornamn) and not(ku:InkomsttagareKU66/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU66/ku:OrgNamn or not(ku:InkomsttagareKU66/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU66/ku:Inkomsttagare or ku:InkomsttagareKU66/ku:Fornamn or ku:InkomsttagareKU66/ku:Efternamn or ku:InkomsttagareKU66/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU66/ku:OrgNamn or not(ku:InkomsttagareKU66/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU66/ku:Inkomsttagare or ku:InkomsttagareKU66/ku:Fornamn or ku:InkomsttagareKU66/ku:Efternamn or ku:InkomsttagareKU66/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU66/ku:LandskodTIN) or ku:InkomsttagareKU66/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU66/ku:LandskodTIN) or ku:InkomsttagareKU66/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:KWhMatatsIn"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:KWhMatatsIn">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>067#Fältet Antal kwh som matats in i anslutningspunkten under året, fält 270, ska alltid fyllas i</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:KWhTagitsUt"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:KWhTagitsUt">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>068#Fältet Antal kwh som tagits ut från anslutningspunkten under året, fält 271, ska alltid fyllas i</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:AnlaggningsID"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:AnlaggningsID">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>069#Fältet AnläggningsID, fält 272, ska alltid fyllas i</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU70" priority="1006" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU70"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU70/ku:TIN) or ku:InkomsttagareKU70/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU70/ku:TIN) or ku:InkomsttagareKU70/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU70/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU70/ku:Inkomsttagare) or ku:UppgiftslamnareKU70/ku:UppgiftslamnarId != ku:InkomsttagareKU70/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU70/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU70/ku:Inkomsttagare) or ku:UppgiftslamnareKU70/ku:UppgiftslamnarId != ku:InkomsttagareKU70/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU70/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU70/ku:Inkomsttagare) + count(ku:InkomsttagareKU70/ku:Fodelsetid) + count(ku:InkomsttagareKU70/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU70/*) + count(//ku:InkomsttagareKU70/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU70/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU70/ku:Inkomsttagare) + count(ku:InkomsttagareKU70/ku:Fodelsetid) + count(ku:InkomsttagareKU70/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU70/*) + count(//ku:InkomsttagareKU70/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:Fodelsetid or ku:InkomsttagareKU70/ku:AnnatIDNr or ku:InkomsttagareKU70/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:Fodelsetid or ku:InkomsttagareKU70/ku:AnnatIDNr or ku:InkomsttagareKU70/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:Fornamn or not(ku:InkomsttagareKU70/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:Fornamn or not(ku:InkomsttagareKU70/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU70/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU70/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU70/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU70/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:Efternamn or not(ku:InkomsttagareKU70/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:Efternamn or not(ku:InkomsttagareKU70/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU70/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU70/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU70/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU70/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:Gatuadress or not(ku:InkomsttagareKU70/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU70/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:Gatuadress or not(ku:InkomsttagareKU70/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU70/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU70/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU70/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU70/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU70/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU70/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU70/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:Gatuadress or not(ku:InkomsttagareKU70/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU70/ku:Inkomsttagare or ku:InkomsttagareKU70/ku:Fodelsetid or ku:InkomsttagareKU70/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:Gatuadress or not(ku:InkomsttagareKU70/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU70/ku:Inkomsttagare or ku:InkomsttagareKU70/ku:Fodelsetid or ku:InkomsttagareKU70/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:Postnummer or not(ku:InkomsttagareKU70/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU70/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:Postnummer or not(ku:InkomsttagareKU70/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU70/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU70/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU70/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU70/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU70/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU70/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU70/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:Postnummer or not(ku:InkomsttagareKU70/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU70/ku:Inkomsttagare or ku:InkomsttagareKU70/ku:Fodelsetid or ku:InkomsttagareKU70/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:Postnummer or not(ku:InkomsttagareKU70/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU70/ku:Inkomsttagare or ku:InkomsttagareKU70/ku:Fodelsetid or ku:InkomsttagareKU70/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:Postort or not(ku:InkomsttagareKU70/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU70/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:Postort or not(ku:InkomsttagareKU70/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU70/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU70/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU70/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU70/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU70/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU70/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU70/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:Postort or not(ku:InkomsttagareKU70/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU70/ku:Inkomsttagare or ku:InkomsttagareKU70/ku:Fodelsetid or ku:InkomsttagareKU70/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:Postort or not(ku:InkomsttagareKU70/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU70/ku:Inkomsttagare or ku:InkomsttagareKU70/ku:Fodelsetid or ku:InkomsttagareKU70/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU70/ku:FriAdress) or ku:InkomsttagareKU70/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU70/ku:FriAdress) or ku:InkomsttagareKU70/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU70/ku:Inkomsttagare) or not(ku:InkomsttagareKU70/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU70/ku:Inkomsttagare) or not(ku:InkomsttagareKU70/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU70/ku:OrgNamn) or (not(ku:InkomsttagareKU70/ku:Fodelsetid) and (not(ku:InkomsttagareKU70/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU70/ku:Fornamn) and not(ku:InkomsttagareKU70/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU70/ku:OrgNamn) or (not(ku:InkomsttagareKU70/ku:Fodelsetid) and (not(ku:InkomsttagareKU70/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU70/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU70/ku:Fornamn) and not(ku:InkomsttagareKU70/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU70/ku:OrgNamn or not(ku:InkomsttagareKU70/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU70/ku:Inkomsttagare or ku:InkomsttagareKU70/ku:Fornamn or ku:InkomsttagareKU70/ku:Efternamn or ku:InkomsttagareKU70/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU70/ku:OrgNamn or not(ku:InkomsttagareKU70/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU70/ku:Inkomsttagare or ku:InkomsttagareKU70/ku:Fornamn or ku:InkomsttagareKU70/ku:Efternamn or ku:InkomsttagareKU70/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU70/ku:LandskodTIN) or ku:InkomsttagareKU70/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU70/ku:LandskodTIN) or ku:InkomsttagareKU70/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Royalty) or not(ku:Naringsbidrag)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Royalty) or not(ku:Naringsbidrag)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>118#Du har fyllt i både Näringsbidrag - Belopp som utbetalats/eftergetts, fält 716, och Royalty - Utbetalt belopp, fält 717. Båda kan inte vara ifyllda på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Royalty or ku:Borttag or ku:Naringsbidrag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Royalty or ku:Borttag or ku:Naringsbidrag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>119#Du har inte angett varken Näringsbidrag - Belopp som utbetalats/eftergetts, fält 716, eller Royalty - Utbetalt belopp, fält 717. Kontrolluppgiften är därför alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU71" priority="1005" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU71"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU71/ku:TIN) or ku:InkomsttagareKU71/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU71/ku:TIN) or ku:InkomsttagareKU71/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU71/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU71/ku:Inkomsttagare) or ku:UppgiftslamnareKU71/ku:UppgiftslamnarId != ku:InkomsttagareKU71/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU71/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU71/ku:Inkomsttagare) or ku:UppgiftslamnareKU71/ku:UppgiftslamnarId != ku:InkomsttagareKU71/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU71/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU71/ku:Inkomsttagare) + count(ku:InkomsttagareKU71/ku:Fodelsetid) + count(ku:InkomsttagareKU71/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU71/*) + count(//ku:InkomsttagareKU71/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU71/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU71/ku:Inkomsttagare) + count(ku:InkomsttagareKU71/ku:Fodelsetid) + count(ku:InkomsttagareKU71/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU71/*) + count(//ku:InkomsttagareKU71/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:Fodelsetid or ku:InkomsttagareKU71/ku:AnnatIDNr or ku:InkomsttagareKU71/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:Fodelsetid or ku:InkomsttagareKU71/ku:AnnatIDNr or ku:InkomsttagareKU71/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:Fornamn or not(ku:InkomsttagareKU71/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:Fornamn or not(ku:InkomsttagareKU71/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU71/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU71/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU71/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU71/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:Efternamn or not(ku:InkomsttagareKU71/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:Efternamn or not(ku:InkomsttagareKU71/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU71/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU71/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU71/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU71/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:Gatuadress or not(ku:InkomsttagareKU71/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU71/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:Gatuadress or not(ku:InkomsttagareKU71/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU71/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU71/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU71/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU71/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU71/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU71/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU71/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:Gatuadress or not(ku:InkomsttagareKU71/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU71/ku:Inkomsttagare or ku:InkomsttagareKU71/ku:Fodelsetid or ku:InkomsttagareKU71/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:Gatuadress or not(ku:InkomsttagareKU71/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU71/ku:Inkomsttagare or ku:InkomsttagareKU71/ku:Fodelsetid or ku:InkomsttagareKU71/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:Postnummer or not(ku:InkomsttagareKU71/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU71/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:Postnummer or not(ku:InkomsttagareKU71/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU71/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU71/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU71/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU71/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU71/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU71/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU71/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:Postnummer or not(ku:InkomsttagareKU71/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU71/ku:Inkomsttagare or ku:InkomsttagareKU71/ku:Fodelsetid or ku:InkomsttagareKU71/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:Postnummer or not(ku:InkomsttagareKU71/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU71/ku:Inkomsttagare or ku:InkomsttagareKU71/ku:Fodelsetid or ku:InkomsttagareKU71/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:Postort or not(ku:InkomsttagareKU71/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU71/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:Postort or not(ku:InkomsttagareKU71/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU71/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU71/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU71/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU71/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU71/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU71/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU71/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:Postort or not(ku:InkomsttagareKU71/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU71/ku:Inkomsttagare or ku:InkomsttagareKU71/ku:Fodelsetid or ku:InkomsttagareKU71/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:Postort or not(ku:InkomsttagareKU71/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU71/ku:Inkomsttagare or ku:InkomsttagareKU71/ku:Fodelsetid or ku:InkomsttagareKU71/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU71/ku:FriAdress) or ku:InkomsttagareKU71/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU71/ku:FriAdress) or ku:InkomsttagareKU71/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU71/ku:Inkomsttagare) or not(ku:InkomsttagareKU71/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU71/ku:Inkomsttagare) or not(ku:InkomsttagareKU71/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU71/ku:OrgNamn) or (not(ku:InkomsttagareKU71/ku:Fodelsetid) and (not(ku:InkomsttagareKU71/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU71/ku:Fornamn) and not(ku:InkomsttagareKU71/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU71/ku:OrgNamn) or (not(ku:InkomsttagareKU71/ku:Fodelsetid) and (not(ku:InkomsttagareKU71/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU71/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU71/ku:Fornamn) and not(ku:InkomsttagareKU71/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU71/ku:OrgNamn or not(ku:InkomsttagareKU71/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU71/ku:Inkomsttagare or ku:InkomsttagareKU71/ku:Fornamn or ku:InkomsttagareKU71/ku:Efternamn or ku:InkomsttagareKU71/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU71/ku:OrgNamn or not(ku:InkomsttagareKU71/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU71/ku:Inkomsttagare or ku:InkomsttagareKU71/ku:Fornamn or ku:InkomsttagareKU71/ku:Efternamn or ku:InkomsttagareKU71/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU71/ku:LandskodTIN) or ku:InkomsttagareKU71/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU71/ku:LandskodTIN) or ku:InkomsttagareKU71/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Kontoslag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Kontoslag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>124#Du har inte angett Kontrolluppgiften avser uttag från, fält 740</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:UtbetaltBelopp"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:UtbetaltBelopp">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>125#Du har inte fyllt i Utbetalt belopp, fält 744</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU72" priority="1004" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU72"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU72/ku:TIN) or ku:InkomsttagareKU72/ku:LandskodTIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU72/ku:TIN) or ku:InkomsttagareKU72/ku:LandskodTIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>045#Du har angett Utländskt skatteregistreringsnummer (TIN), fält 252. Då ska du också ange vilket land det gäller i TIN-land, fält 076</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU72/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU72/ku:Inkomsttagare) or ku:UppgiftslamnareKU72/ku:UppgiftslamnarId != ku:InkomsttagareKU72/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU72/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU72/ku:Inkomsttagare) or ku:UppgiftslamnareKU72/ku:UppgiftslamnarId != ku:InkomsttagareKU72/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU72/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU72/ku:Inkomsttagare) + count(ku:InkomsttagareKU72/ku:Fodelsetid) + count(ku:InkomsttagareKU72/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU72/*) + count(//ku:InkomsttagareKU72/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU72/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU72/ku:Inkomsttagare) + count(ku:InkomsttagareKU72/ku:Fodelsetid) + count(ku:InkomsttagareKU72/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU72/*) + count(//ku:InkomsttagareKU72/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:Fodelsetid or ku:InkomsttagareKU72/ku:AnnatIDNr or ku:InkomsttagareKU72/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:Fodelsetid or ku:InkomsttagareKU72/ku:AnnatIDNr or ku:InkomsttagareKU72/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:Fornamn or not(ku:InkomsttagareKU72/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:Fornamn or not(ku:InkomsttagareKU72/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU72/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU72/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU72/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU72/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:Efternamn or not(ku:InkomsttagareKU72/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:Efternamn or not(ku:InkomsttagareKU72/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU72/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU72/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU72/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU72/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:Gatuadress or not(ku:InkomsttagareKU72/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU72/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:Gatuadress or not(ku:InkomsttagareKU72/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU72/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU72/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU72/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU72/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU72/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU72/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU72/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:Gatuadress or not(ku:InkomsttagareKU72/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU72/ku:Inkomsttagare or ku:InkomsttagareKU72/ku:Fodelsetid or ku:InkomsttagareKU72/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:Gatuadress or not(ku:InkomsttagareKU72/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU72/ku:Inkomsttagare or ku:InkomsttagareKU72/ku:Fodelsetid or ku:InkomsttagareKU72/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:Postnummer or not(ku:InkomsttagareKU72/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU72/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:Postnummer or not(ku:InkomsttagareKU72/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU72/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU72/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU72/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU72/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU72/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU72/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU72/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:Postnummer or not(ku:InkomsttagareKU72/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU72/ku:Inkomsttagare or ku:InkomsttagareKU72/ku:Fodelsetid or ku:InkomsttagareKU72/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:Postnummer or not(ku:InkomsttagareKU72/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU72/ku:Inkomsttagare or ku:InkomsttagareKU72/ku:Fodelsetid or ku:InkomsttagareKU72/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:Postort or not(ku:InkomsttagareKU72/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU72/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:Postort or not(ku:InkomsttagareKU72/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU72/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU72/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU72/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU72/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU72/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU72/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU72/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:Postort or not(ku:InkomsttagareKU72/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU72/ku:Inkomsttagare or ku:InkomsttagareKU72/ku:Fodelsetid or ku:InkomsttagareKU72/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:Postort or not(ku:InkomsttagareKU72/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU72/ku:Inkomsttagare or ku:InkomsttagareKU72/ku:Fodelsetid or ku:InkomsttagareKU72/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU72/ku:FriAdress) or ku:InkomsttagareKU72/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU72/ku:FriAdress) or ku:InkomsttagareKU72/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU72/ku:Inkomsttagare) or not(ku:InkomsttagareKU72/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU72/ku:Inkomsttagare) or not(ku:InkomsttagareKU72/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU72/ku:OrgNamn) or (not(ku:InkomsttagareKU72/ku:Fodelsetid) and (not(ku:InkomsttagareKU72/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU72/ku:Fornamn) and not(ku:InkomsttagareKU72/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU72/ku:OrgNamn) or (not(ku:InkomsttagareKU72/ku:Fodelsetid) and (not(ku:InkomsttagareKU72/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU72/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU72/ku:Fornamn) and not(ku:InkomsttagareKU72/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU72/ku:OrgNamn or not(ku:InkomsttagareKU72/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU72/ku:Inkomsttagare or ku:InkomsttagareKU72/ku:Fornamn or ku:InkomsttagareKU72/ku:Efternamn or ku:InkomsttagareKU72/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU72/ku:OrgNamn or not(ku:InkomsttagareKU72/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU72/ku:Inkomsttagare or ku:InkomsttagareKU72/ku:Fornamn or ku:InkomsttagareKU72/ku:Efternamn or ku:InkomsttagareKU72/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU72/ku:LandskodTIN) or ku:InkomsttagareKU72/ku:TIN"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU72/ku:LandskodTIN) or ku:InkomsttagareKU72/ku:TIN">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>066#Du har angett TIN-land, fält 076, dvs ett land för vilket ett utländskt skatteregistreringsnummer ska gälla. Du behöver också ange Utländskt skatteregistreringsnummer (TIN), fält 252</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Kontoslag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Kontoslag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>124#Du har inte angett Kontrolluppgiften avser uttag från, fält 740</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InsattBelopp or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InsattBelopp or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>141#Du har inte fyllt i Insatt belopp, fält 745</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:DatumInsattning"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:DatumInsattning">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>126#Du har inte fyllt i Datum för insättning, fält 746</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:DatumInsattning) or not(ku:Inkomstar) or ((number(concat(ku:Inkomstar,'0101')) &lt;= number(ku:DatumInsattning)) and (number(ku:DatumInsattning) &lt; number(concat(number(ku:Inkomstar) + 1,'0701'))))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:DatumInsattning) or not(ku:Inkomstar) or ((number(concat(ku:Inkomstar,'0101')) &lt;= number(ku:DatumInsattning)) and (number(ku:DatumInsattning) &lt; number(concat(number(ku:Inkomstar) + 1,'0701'))))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>127#Du har fyllt i ett datum i Datum för insättning, fält 746, som inte är inom inkomståret och inte heller före 1 juli året närmast efter inkomståret</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU73" priority="1003" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU73"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:UppgiftslamnareKU73/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU73/ku:Inkomsttagare) or ku:UppgiftslamnareKU73/ku:UppgiftslamnarId != ku:InkomsttagareKU73/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:UppgiftslamnareKU73/ku:UppgiftslamnarId) or not(ku:InkomsttagareKU73/ku:Inkomsttagare) or ku:UppgiftslamnareKU73/ku:UppgiftslamnarId != ku:InkomsttagareKU73/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>053#Du har angett samma person-/organisationsnummer för den kontrolluppgiften avser i Person-/organisationsnummer, fält 215, som du angett som uppgiftslämnare. Det kan aldrig vara samma person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU73/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU73/ku:Inkomsttagare) + count(ku:InkomsttagareKU73/ku:Fodelsetid) + count(ku:InkomsttagareKU73/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU73/*) + count(//ku:InkomsttagareKU73/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU73/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU73/ku:Inkomsttagare) + count(ku:InkomsttagareKU73/ku:Fodelsetid) + count(ku:InkomsttagareKU73/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU73/*) + count(//ku:InkomsttagareKU73/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:Fodelsetid or ku:InkomsttagareKU73/ku:AnnatIDNr or ku:InkomsttagareKU73/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:Fodelsetid or ku:InkomsttagareKU73/ku:AnnatIDNr or ku:InkomsttagareKU73/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>056#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222, eller Annat ID-nummer (för juridiska personer), fält 224. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:Fornamn or not(ku:InkomsttagareKU73/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:Fornamn or not(ku:InkomsttagareKU73/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU73/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU73/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU73/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU73/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:Efternamn or not(ku:InkomsttagareKU73/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:Efternamn or not(ku:InkomsttagareKU73/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU73/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU73/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU73/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU73/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:Gatuadress or not(ku:InkomsttagareKU73/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU73/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:Gatuadress or not(ku:InkomsttagareKU73/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU73/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU73/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU73/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU73/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU73/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU73/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU73/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:Gatuadress or not(ku:InkomsttagareKU73/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU73/ku:Inkomsttagare or ku:InkomsttagareKU73/ku:Fodelsetid or ku:InkomsttagareKU73/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:Gatuadress or not(ku:InkomsttagareKU73/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU73/ku:Inkomsttagare or ku:InkomsttagareKU73/ku:Fodelsetid or ku:InkomsttagareKU73/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>152#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:Postnummer or not(ku:InkomsttagareKU73/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU73/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:Postnummer or not(ku:InkomsttagareKU73/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU73/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU73/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU73/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU73/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU73/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU73/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU73/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:Postnummer or not(ku:InkomsttagareKU73/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU73/ku:Inkomsttagare or ku:InkomsttagareKU73/ku:Fodelsetid or ku:InkomsttagareKU73/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:Postnummer or not(ku:InkomsttagareKU73/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU73/ku:Inkomsttagare or ku:InkomsttagareKU73/ku:Fodelsetid or ku:InkomsttagareKU73/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>153#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:Postort or not(ku:InkomsttagareKU73/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU73/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:Postort or not(ku:InkomsttagareKU73/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU73/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU73/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU73/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU73/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU73/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU73/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU73/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:Postort or not(ku:InkomsttagareKU73/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU73/ku:Inkomsttagare or ku:InkomsttagareKU73/ku:Fodelsetid or ku:InkomsttagareKU73/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:Postort or not(ku:InkomsttagareKU73/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU73/ku:Inkomsttagare or ku:InkomsttagareKU73/ku:Fodelsetid or ku:InkomsttagareKU73/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>154#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU73/ku:FriAdress) or ku:InkomsttagareKU73/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU73/ku:FriAdress) or ku:InkomsttagareKU73/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU73/ku:Inkomsttagare) or not(ku:InkomsttagareKU73/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU73/ku:Inkomsttagare) or not(ku:InkomsttagareKU73/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU73/ku:OrgNamn) or (not(ku:InkomsttagareKU73/ku:Fodelsetid) and (not(ku:InkomsttagareKU73/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU73/ku:Fornamn) and not(ku:InkomsttagareKU73/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU73/ku:OrgNamn) or (not(ku:InkomsttagareKU73/ku:Fodelsetid) and (not(ku:InkomsttagareKU73/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU73/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU73/ku:Fornamn) and not(ku:InkomsttagareKU73/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU73/ku:OrgNamn or not(ku:InkomsttagareKU73/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU73/ku:Inkomsttagare or ku:InkomsttagareKU73/ku:Fornamn or ku:InkomsttagareKU73/ku:Efternamn or ku:InkomsttagareKU73/ku:Fodelsetid"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU73/ku:OrgNamn or not(ku:InkomsttagareKU73/ku:AnnatIDNr) or ku:Borttag or ku:InkomsttagareKU73/ku:Inkomsttagare or ku:InkomsttagareKU73/ku:Fornamn or ku:InkomsttagareKU73/ku:Efternamn or ku:InkomsttagareKU73/ku:Fodelsetid">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>151#Du har angett Annat ID-nummer, fält 224. Du ska då också ange Organisationsnamn, fält 226, för juridisk person eller För- och efternamn, fält 216 - 217, för fysisk person</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:TillgodoUtdelning or ku:Borttag or ku:SkplDelKapital"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:TillgodoUtdelning or ku:Borttag or ku:SkplDelKapital">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>120#Du har varken angett Tillgodoräknad utdelning, fält 730, eller Delägarens skattepliktiga andel i samfällighetens inkomster som är avkastning på kapital, fält 732. Kontrolluppgiften är därför alltför ofullständig för att skickas in</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:SkplDelKapital) or not(ku:DelUtdelnSkog)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:SkplDelKapital) or not(ku:DelUtdelnSkog)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>121#Du har fyllt i både Del av utdelningen som kommer från intäkt av skogsbruk, fält 731, och Delägarens skattepliktiga andel i samfällighetens inkomster som är avkastning på kapital, fält 732. Båda kan inte vara ifyllda på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:DelUtdelnSkog) or not(ku:TillgodoUtdelning) or ku:DelUtdelnSkog &lt;= ku:TillgodoUtdelning"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:DelUtdelnSkog) or not(ku:TillgodoUtdelning) or ku:DelUtdelnSkog &lt;= ku:TillgodoUtdelning">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>122#Du har fyllt i ett högre belopp i Del av utdelningen som kommer från intäkt av skogsbruk, fält 731, än i Tillgodoräknad utdelning, fält 730. Del av utdelningen som kommer från intäkt av skogsbruk, fält 731, måste, om det fylls i, alltid vara ett lägre belopp</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:TillgodoUtdelning) or not(ku:SkplDelKapital)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:TillgodoUtdelning) or not(ku:SkplDelKapital)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>123#Du har fyllt i både Tillgodoräknad utdelning, fält 730, och Delägarens skattepliktiga andel i samfällighetens inkomster som är avkastning på kapital, fält 732. Båda kan inte vara ifyllda på samma kontrolluppgift</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU80" priority="1002" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU80"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU80/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU80/ku:Inkomsttagare) + count(ku:InkomsttagareKU80/ku:Fodelsetid) + count(ku:InkomsttagareKU80/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU80/*) + count(//ku:InkomsttagareKU80/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU80/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU80/ku:Inkomsttagare) + count(ku:InkomsttagareKU80/ku:Fodelsetid) + count(ku:InkomsttagareKU80/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU80/*) + count(//ku:InkomsttagareKU80/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU80/ku:Fodelsetid or ku:InkomsttagareKU80/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU80/ku:Fodelsetid or ku:InkomsttagareKU80/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>181#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU80/ku:Fornamn or not(ku:InkomsttagareKU80/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU80/ku:Fornamn or not(ku:InkomsttagareKU80/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU80/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU80/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU80/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU80/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU80/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU80/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU80/ku:Efternamn or not(ku:InkomsttagareKU80/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU80/ku:Efternamn or not(ku:InkomsttagareKU80/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU80/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU80/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU80/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU80/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU80/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU80/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU80/ku:Gatuadress or not(ku:InkomsttagareKU80/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU80/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU80/ku:Gatuadress or not(ku:InkomsttagareKU80/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU80/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU80/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU80/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU80/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU80/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU80/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU80/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU80/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU80/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU80/ku:Postnummer or not(ku:InkomsttagareKU80/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU80/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU80/ku:Postnummer or not(ku:InkomsttagareKU80/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU80/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU80/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU80/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU80/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU80/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU80/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU80/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU80/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU80/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU80/ku:Postort or not(ku:InkomsttagareKU80/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU80/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU80/ku:Postort or not(ku:InkomsttagareKU80/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU80/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU80/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU80/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU80/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU80/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU80/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU80/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU80/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU80/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU80/ku:FriAdress) or ku:InkomsttagareKU80/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU80/ku:FriAdress) or ku:InkomsttagareKU80/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU80/ku:Inkomsttagare) or not(ku:InkomsttagareKU80/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU80/ku:Inkomsttagare) or not(ku:InkomsttagareKU80/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU80/ku:OrgNamn) or (not(ku:InkomsttagareKU80/ku:Fodelsetid) and (not(ku:InkomsttagareKU80/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU80/ku:Fornamn) and not(ku:InkomsttagareKU80/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU80/ku:OrgNamn) or (not(ku:InkomsttagareKU80/ku:Fodelsetid) and (not(ku:InkomsttagareKU80/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU80/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU80/ku:Fornamn) and not(ku:InkomsttagareKU80/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Belopp"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Belopp">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>109#Du har inte fyllt i Belopp i den aktuella valutan, fält 660</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:LandskodBetalning"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:LandskodBetalning">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>111#Du har inte angett Land, fält 662, i avsnittet Betalning till utlandet</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Betalningsdatum"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Betalningsdatum">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>112#Du har inte angett Betalningsdatum, fält 663</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Inkomstar) or not(ku:Betalningsdatum) or (string-length(ku:Betalningsdatum) &gt;=4 and substring(ku:Betalningsdatum,1,4) = ku:Inkomstar)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Inkomstar) or not(ku:Betalningsdatum) or (string-length(ku:Betalningsdatum) &gt;=4 and substring(ku:Betalningsdatum,1,4) = ku:Inkomstar)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>138#Du har fyllt i ett datum utanför inkomståret i Betalningsdatum, fält 663</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Valutakod"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Valutakod">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>113#Du har inte angett Valutakod, fält 664</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KU81" priority="1001" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KU81"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU81/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU81/ku:Inkomsttagare) + count(ku:InkomsttagareKU81/ku:Fodelsetid) + count(ku:InkomsttagareKU81/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU81/*) + count(//ku:InkomsttagareKU81/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKU81/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:Specifikationsnummer) + count(ku:InkomsttagareKU81/ku:Inkomsttagare) + count(ku:InkomsttagareKU81/ku:Fodelsetid) + count(ku:InkomsttagareKU81/ku:AnnatIDNr) = count(*) - 2 + count(//ku:UppgiftslamnareKU81/*) + count(//ku:InkomsttagareKU81/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>055#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, Specifikationsnummer, fält 570, Inkomsttagare, fält 215, Fodelsetid, fält 222 och AnnatIdNr, fält 224) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU81/ku:Fodelsetid or ku:InkomsttagareKU81/ku:Inkomsttagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU81/ku:Fodelsetid or ku:InkomsttagareKU81/ku:Inkomsttagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>181#Du har inte angett Person-/organisationsnummer, fält 215, och inte heller Födelsetid, fält 222. Någon av dessa ska anges</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU81/ku:Fornamn or not(ku:InkomsttagareKU81/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU81/ku:Fornamn or not(ku:InkomsttagareKU81/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>057#Du har angett Födelsetid, fält 222. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU81/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU81/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU81/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU81/ku:Fornamn or ku:Borttag or not(ku:InkomsttagareKU81/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU81/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>142#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Förnamn, fält 216</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU81/ku:Efternamn or not(ku:InkomsttagareKU81/ku:Fodelsetid) or ku:Borttag"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU81/ku:Efternamn or not(ku:InkomsttagareKU81/ku:Fodelsetid) or ku:Borttag">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>058#Du har angett Födelsetid, fält 222. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU81/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU81/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU81/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,7,2)) &lt;= 60"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU81/ku:Efternamn or ku:Borttag or not(ku:InkomsttagareKU81/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU81/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,7,2)) &lt;= 60">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>143#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Efternamn, fält 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU81/ku:Gatuadress or not(ku:InkomsttagareKU81/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU81/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU81/ku:Gatuadress or not(ku:InkomsttagareKU81/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU81/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>059#Du har angett Födelsetid, fält 222. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU81/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU81/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU81/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU81/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU81/ku:Gatuadress or ku:Borttag or not(ku:InkomsttagareKU81/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU81/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU81/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>144#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Gatuadress, fält 218</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU81/ku:Postnummer or not(ku:InkomsttagareKU81/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU81/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU81/ku:Postnummer or not(ku:InkomsttagareKU81/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU81/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>060#Du har angett Födelsetid, fält 222. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU81/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU81/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU81/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU81/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU81/ku:Postnummer or ku:Borttag or not(ku:InkomsttagareKU81/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU81/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU81/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>145#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postnummer, fält 219</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU81/ku:Postort or not(ku:InkomsttagareKU81/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU81/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU81/ku:Postort or not(ku:InkomsttagareKU81/ku:Fodelsetid) or ku:Borttag or ku:InkomsttagareKU81/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>061#Du har angett Födelsetid, fält 222. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:InkomsttagareKU81/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU81/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU81/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU81/ku:FriAdress"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:InkomsttagareKU81/ku:Postort or ku:Borttag or not(ku:InkomsttagareKU81/ku:Inkomsttagare) or (string-length(ku:InkomsttagareKU81/ku:Inkomsttagare) != 12) or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,1,4)) &lt;= 1800 or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,7,2)) &lt;= 60 or ku:InkomsttagareKU81/ku:FriAdress">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>146#Du har angett ett s.k. samordningsnummer i fältet Person-/organisationsnummer, fält 215. Du ska då också ange Postort, fält 220</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU81/ku:FriAdress) or ku:InkomsttagareKU81/ku:LandskodPostort"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU81/ku:FriAdress) or ku:InkomsttagareKU81/ku:LandskodPostort">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>166#Du har valt att ange Adress i fritt format, fält 230. Du ska då också ange i vilket land adressen finns i fält 221, Land</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU81/ku:Inkomsttagare) or not(ku:InkomsttagareKU81/ku:Fodelsetid)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU81/ku:Inkomsttagare) or not(ku:InkomsttagareKU81/ku:Fodelsetid)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>063#Födelsetid, fält 222, får inte finnas samtidigt som Inkomsttagare, fält 215</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:InkomsttagareKU81/ku:OrgNamn) or (not(ku:InkomsttagareKU81/ku:Fodelsetid) and (not(ku:InkomsttagareKU81/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU81/ku:Fornamn) and not(ku:InkomsttagareKU81/ku:Efternamn))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:InkomsttagareKU81/ku:OrgNamn) or (not(ku:InkomsttagareKU81/ku:Fodelsetid) and (not(ku:InkomsttagareKU81/ku:Inkomsttagare) or number(substring(ku:InkomsttagareKU81/ku:Inkomsttagare,1,2)) &lt;= 17) and not(ku:InkomsttagareKU81/ku:Fornamn) and not(ku:InkomsttagareKU81/ku:Efternamn))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>065#Du har angett Organisationsnamn, fält 226. Det kan inte kombineras med person- eller samordningsnummer i Person-/organisationsnummer, fält 215, och inte heller med För- och efternamn, fält 216 - 217</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Belopp"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Belopp">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>109#Du har inte fyllt i Belopp i den aktuella valutan, fält 660</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Betalningskod"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Betalningskod">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>110#Du har inte angett Betalningskod, fält 661</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:LandskodBetalning"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:LandskodBetalning">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>111#Du har inte angett Land, fält 662, i avsnittet Betalning till utlandet</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Betalningsdatum"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Betalningsdatum">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>112#Du har inte angett Betalningsdatum, fält 663</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Inkomstar) or not(ku:Betalningsdatum) or (string-length(ku:Betalningsdatum) &gt;=4 and substring(ku:Betalningsdatum,1,4) = ku:Inkomstar)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Inkomstar) or not(ku:Betalningsdatum) or (string-length(ku:Betalningsdatum) &gt;=4 and substring(ku:Betalningsdatum,1,4) = ku:Inkomstar)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>138#Du har fyllt i ett datum utanför inkomståret i Betalningsdatum, fält 663</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:Valutakod"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:Valutakod">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>113#Du har inte angett Valutakod, fält 664</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:NamnBetalningsmottagare"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:NamnBetalningsmottagare">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>114#Du har inte angett Namn på betalningsmottagare, fält 671</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ku:KupongS" priority="1000" mode="M5">
<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ku:KupongS"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKupongS/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:ISIN) + count(ku:Redovisningsnummer) + count(ku:OrgnrUtdelandeBolag) = count(*) - 1 + count(//ku:UppgiftslamnareKupongS/*)))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ku:Borttag) or (ku:Borttag and (count(ku:Borttag) + count(ku:UppgiftslamnareKupongS/ku:UppgiftslamnarId) + count(ku:Inkomstar) + count(ku:ISIN) + count(ku:Redovisningsnummer) + count(ku:OrgnrUtdelandeBolag) = count(*) - 1 + count(//ku:UppgiftslamnareKupongS/*)))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>161#När Borttag, fält 205, är ifyllt får inte några andra fält förutom identifikatorerna (UppgiftslamnarId, fält 201, Inkomstar, fält 203, ISIN, fält 572, Redovisningsnummer, fält 851 och OrgnrUtdelandeBolag, fält 890) vara ifyllda</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((ku:ISIN) and not(ku:OrgnrUtdelandeBolag)) or (not(ku:ISIN) and (ku:OrgnrUtdelandeBolag))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((ku:ISIN) and not(ku:OrgnrUtdelandeBolag)) or (not(ku:ISIN) and (ku:OrgnrUtdelandeBolag))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>165#På en sammanställningen av kupongskatteuppgifter måste antingen ISIN, fält 572, eller Organisationsnummer utdelande bolag, fält 890 fyllas i</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ku:Borttag or ku:UtdelningEjSkSkKSkatt"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ku:Borttag or ku:UtdelningEjSkSkKSkatt">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-select-full-path"/>
</xsl:attribute>
<svrl:text>171#Du har inte angett Utdelning utan skattskyldighet för kupongskatt, fält 860. Fältet ska alltid fyllas i på Redovisning - Kupongskatt i avstämningsbolag</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M5"/>
<xsl:template match="@*|node()" priority="-2" mode="M5">
<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>
</xsl:stylesheet>
