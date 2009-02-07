<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="html" />
	
	<xsl:template name="header">

		<h1><xsl:element name='a'><xsl:attribute name='href'>/recipes/html/index.html</xsl:attribute>rz2</xsl:element></h1>
		<hr />
		
	</xsl:template>

	<xsl:template name="footer">

		<hr />
		<div>
 			&#169; 2009 Optional LLC
		</div>
		
	</xsl:template>
	
</xsl:stylesheet>
