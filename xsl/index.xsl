<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="xml" />

	<xsl:template match="/">
		<html>
			<head></head>	
			<body>
			
				<h1>rz2</h1>
				
				<h2>Recent recipes</h2>
				
				<div>
					<xsl:for-each select="document('../xml/meta/site/most_recent_recipes.xml')">
						<xsl:for-each select="/recipes/recipe">
							<xsl:if test="position() &lt;= 10">
								<div>
									<div>
										<xsl:element name='a'>
											<xsl:attribute name='href'>recipes/<xsl:value-of select="ID"/>.html</xsl:attribute>
											<xsl:value-of select="Title"/>
										</xsl:element>
									</div>
									<div><xsl:value-of select="description"/></div>
								</div>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each>
				</div>
				<div>
					<xsl:element name="a">
						<xsl:attribute name="href">by_date/recipes/</xsl:attribute>
						See more recent recipes
					</xsl:element>
				</div>
				
				<h2>Recent chefs</h2>
				
				<div>
					<xsl:for-each select="document('../xml/meta/site/most_recent_chefs.xml')">
						<xsl:for-each select="/chefs/chef">
							<xsl:if test="position() &lt;= 10">
								<div>
									<div>
										<xsl:element name='a'>
											<xsl:attribute name='href'>recipes/<xsl:value-of select="ID"/>.html</xsl:attribute>
											<xsl:value-of select="Title"/>
										</xsl:element>
									</div>
									<div><xsl:value-of select="description"/></div>
								</div>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each>
				</div>
				<div>
					<xsl:element name="a">
						<xsl:attribute name="href">by_date/chefs/</xsl:attribute>
						See more recent chefs
					</xsl:element>
				</div>
				
				<h2>Recent reviews</h2>

				<div>
					<xsl:for-each select="document('../xml/meta/site/most_recent_reviews.xml')">
						<xsl:for-each select="/reviews/review">
							<xsl:if test="position() &lt;= 10">
								<div>
									<div>
										<xsl:element name='a'>
											<xsl:attribute name='href'>recipes/<xsl:value-of select="ID"/>.html</xsl:attribute>
											<xsl:value-of select="Title"/>
										</xsl:element>
									</div>
									<div><xsl:value-of select="description"/></div>
								</div>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each>
				</div>
				<div>
					<xsl:element name="a">
						<xsl:attribute name="href">by_date/reviews/</xsl:attribute>
						See more recent reviews
					</xsl:element>
				</div>
		
			</body>
		</html>
	</xsl:template>
	
</xsl:stylesheet>
