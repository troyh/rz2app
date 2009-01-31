<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="html" />
	
	<xsl:template match="/recipe" mode="meta">
		<div>
			<xsl:element name='a'><xsl:attribute name='href'>../recipes/<xsl:value-of select="ID"/>.html</xsl:attribute><xsl:value-of select="Title"/></xsl:element> (#<xsl:value-of select="ID"/>)
		</div>
	</xsl:template>
	
	<xsl:template match="/chef/recipes" mode="meta">
		<h2><xsl:value-of select="count(/chef/recipes/recipe)"/> Recipes</h2>

		<xsl:for-each select="recipe">
			<xsl:apply-templates select="document(concat('../xml/docs/recipes/',@docid,'.xml'))" mode="meta"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="/member">
		<html>
			<head>
			</head>
			<body>
				
				<h1><xsl:value-of select="name"/> (#<xsl:value-of select="id"/>)</h1>
		
				<div>
					<xsl:value-of select="chefpage_about"/>
				</div>
		
				<xsl:apply-templates select="document(concat('../xml/meta/chefs/',id,'.xml'))" mode="meta"/>
		
			</body>
		</html>
		
	</xsl:template>
	
</xsl:stylesheet>
