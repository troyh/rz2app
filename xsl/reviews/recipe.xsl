<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="html" />

	<xsl:template match="/member">
		<xsl:element name='a'>
			<xsl:attribute name='href'>/recipes/html/chefs/<xsl:value-of select="id"/>.html</xsl:attribute>		
			<xsl:value-of select="name"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="/recipe">

	<html>
		<head>
			
		</head>
		<body>
				
		<h1>
			<xsl:element name='a'><xsl:attribute name='href'><xsl:value-of select="concat('../../',@id,'.html')"/></xsl:attribute>Recipe #<xsl:value-of select="@id"/></xsl:element>		
		</h1>

		<h2>Newest Reviews</h2>
		
		<xsl:choose>
			<xsl:when test="$orderby='newest'">
				<div id="reviews_orderby">
					See all by:
					Newest
					<xsl:text> </xsl:text>
					<xsl:element name='a'><xsl:attribute name='href'><xsl:value-of select="concat('../../reviews/recipe/',@id,'-oldest.html')"/></xsl:attribute>Oldest</xsl:element>
					<xsl:text> </xsl:text>
					<xsl:element name='a'><xsl:attribute name='href'><xsl:value-of select="concat('../../reviews/recipe/',@id,'-highest-rating.html')"/></xsl:attribute>Highest Rating</xsl:element>
				</div>
				
				<div id="reviews">
					<xsl:for-each select="reviews/review">
						<xsl:sort select="@datetime" order="descending"/>
						<xsl:apply-templates select="document(concat('../../xml/reviews/',@docid,'.xml'))"/>
					</xsl:for-each>
				</div>
				
			</xsl:when>
			<xsl:when test="$orderby='oldest'">
				<div id="reviews_orderby">
					See all by:
					<xsl:element name='a'><xsl:attribute name='href'><xsl:value-of select="concat('../../reviews/recipe/',@id,'-newest.html')"/></xsl:attribute>Newest</xsl:element>
					<xsl:text> </xsl:text>
					Oldest
					<xsl:text> </xsl:text>
					<xsl:element name='a'><xsl:attribute name='href'><xsl:value-of select="concat('../../reviews/recipe/',@id,'-highest-rating.html')"/></xsl:attribute>Highest Rating</xsl:element>
				</div>

				<div id="reviews">
					<xsl:for-each select="reviews/review">
						<xsl:sort select="@datetime" order="ascending"/>
						<xsl:apply-templates select="document(concat('../../xml/reviews/',@docid,'.xml'))"/>
					</xsl:for-each>
				</div>
				
			</xsl:when>
			<xsl:when test="$orderby='highestrating'">
				<div id="reviews_orderby">
					See all by:
					<xsl:element name='a'><xsl:attribute name='href'><xsl:value-of select="concat('../../reviews/recipe/',@id,'-newest.html')"/></xsl:attribute>Newest</xsl:element>
					<xsl:text> </xsl:text>
					<xsl:element name='a'><xsl:attribute name='href'><xsl:value-of select="concat('../../reviews/recipe/',@id,'-oldest.html')"/></xsl:attribute>Oldest</xsl:element>
					<xsl:text> </xsl:text>
					Highest Rating
				</div>
				
				<div id="reviews">
					<xsl:for-each select="reviews/review">
						<xsl:sort select="@rating" order="descending"/>
						<xsl:apply-templates select="document(concat('../../xml/reviews/',@docid,'.xml'))"/>
					</xsl:for-each>
				</div>
				
			</xsl:when>
		</xsl:choose>
		
		</body>
	</html>

	</xsl:template>
	
	<xsl:template match="/review">
		<div>
			<div>
				<xsl:value-of select="rating"/> stars
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="document(concat('../../xml/chefs/',member,'.xml'))"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="time"/>
			</div>
			<div>
				<xsl:value-of select="comments"/>
			</div>
		</div>
	</xsl:template>
	
</xsl:stylesheet>

