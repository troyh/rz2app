<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="html" />

	<xsl:template match="/member">
		<xsl:element name='a'>
			<xsl:attribute name='href'>../chefs/<xsl:value-of select="id"/>.html</xsl:attribute>		
			<xsl:value-of select="name"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="/recipe" mode="meta">
		<h2>Newest Reviews</h2>
		
		<div id="reviews_orderby">
			See all <xsl:value-of select="count(reviews/review)"/> ordered by:
			<xsl:element name='a'><xsl:attribute name='href'><xsl:value-of select="concat('../reviews/recipe/newest/',@id,'.html')"/></xsl:attribute>Newest</xsl:element>
			<xsl:text> </xsl:text>
			<xsl:element name='a'><xsl:attribute name='href'><xsl:value-of select="concat('../reviews/recipe/oldest/',@id,'.html')"/></xsl:attribute>Oldest</xsl:element>
			<xsl:text> </xsl:text>
			<xsl:element name='a'><xsl:attribute name='href'><xsl:value-of select="concat('../reviews/recipe/highest_rated/',@id,'.html')"/></xsl:attribute>Highest Rating</xsl:element>
		</div>
		
		<div id="reviews">
			<xsl:for-each select="reviews/review">
				<xsl:sort select="@datetime" order="descending"/>
				<xsl:if test="position() &lt; 6">
				<xsl:apply-templates select="document(concat('../xml/docs/reviews/',@docid,'.xml'))" mode="meta"/>
				</xsl:if>
			</xsl:for-each>
		</div>
	</xsl:template>
	
	<xsl:template match="/review" mode="meta">
		<div>
			<div>
				<xsl:value-of select="rating"/> stars
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="document(concat('../xml/docs/chefs/',member,'.xml'))"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="time"/>
			</div>
			<div>
				<xsl:value-of select="comments"/>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="/recipe">

		<html>
			<head>
				
			</head>
			<body>

				<h1><xsl:value-of select="Title"/> (#<xsl:value-of select="ID"/>)</h1>
		
				by 
		
				<xsl:apply-templates select="document(concat('../xml/docs/chefs/',submitter,'.xml'))"/>

				<div>
					<xsl:value-of select="description"/>
				</div>
				
				<div><xsl:value-of select="submitted"/></div>
				<div>Servings: <xsl:value-of select="servingslo"/>-<xsl:value-of select="servingshi"/></div>
				<div>Yield: <xsl:value-of select="rec_yieldlo"/>-<xsl:value-of select="rec_yieldhi"/> <xsl:value-of select="rec_yieldunits"/></div>
				<div>Cook time: <xsl:value-of select="rec_cooktime"/> minutes</div>
				<div>Prep time: <xsl:value-of select="rec_preptime"/> minutes</div>
				<div>Total time: <xsl:value-of select="rec_totaltime"/> minutes</div>

				<xsl:apply-templates select="document(concat('../xml/meta/recipes/',ID,'.xml'))" mode="meta"/>
				
			</body>
		</html>

		
	</xsl:template>
	
</xsl:stylesheet>

