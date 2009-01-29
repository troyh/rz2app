<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="html" />

	<xsl:template match="/member">
		<h1><xsl:value-of select="name"/></h1>
		
		<div>
			<xsl:value-of select="chefpage_about"/>
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>
