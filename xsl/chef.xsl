<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="html" />

	<xsl:include href="std.xsl"/>
	
	<xsl:template match="/recipe" mode="meta">
		<xsl:param name="rating_avg"/>
		<div>
			<xsl:element name='a'><xsl:attribute name='href'>../recipes/<xsl:value-of select="ID"/>.html</xsl:attribute><xsl:value-of select="Title"/></xsl:element>
			<xsl:if test="string-length($rating_avg) and $rating_avg != 'NaN' and $rating_avg != 0"><xsl:text> </xsl:text><xsl:value-of select="format-number($rating_avg,'#.#')"/> stars</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="/chef/recipes" mode="meta">
		<h2>
			<xsl:value-of select="count(/chef/recipes/recipe)"/> Recipes 
			(<xsl:value-of select="count(/chef/recipes/recipe[@rating_avg!=0])"/> reviewed, average rating: <xsl:value-of select="format-number(sum(/chef/recipes/recipe[@rating_avg &gt; 0]/@rating_avg) div count(/chef/recipes/recipe[@rating_avg != 0]),'#.#')"/>)
		</h2>

		<xsl:for-each select="recipe">
			<xsl:apply-templates select="document(concat('../xml/docs/recipes/',@docid,'.xml'))" mode="meta">
				<xsl:with-param name="rating_avg"><xsl:value-of select="@rating_avg"/></xsl:with-param>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="/member">
		<html>
			<head>
				<title><xsl:value-of select="name"/>&apos;s Chef Page</title>
			</head>
			<body>
				
				<xsl:call-template name="header"/>
				
				<h1><xsl:value-of select="name"/> (#<xsl:value-of select="id"/>)</h1>
		
				<div>
					<xsl:value-of select="chefpage_about"/>
				</div>
		
				<xsl:apply-templates select="document(concat('../xml/meta/chefs/',id,'.xml'))" mode="meta"/>

				<xsl:call-template name="footer"/>
				
			</body>
		</html>
		
	</xsl:template>
	
</xsl:stylesheet>
