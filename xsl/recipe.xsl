<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="html" />
	
	<xsl:key name="unitid" match="unit" use="@id"/>

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
	
	<xsl:template match="/food">
		<xsl:param name="qty"/>
		<xsl:choose>
			<xsl:when test="$qty = 1"><xsl:value-of select="name_s"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="name"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="unit_display">
		<xsl:param name="uid"/>
		<xsl:param name="qtyhi"/>
		<xsl:for-each select="document('../xml/docs/units.xml')">
			<xsl:variable name="unitelem" select="key('unitid',$uid)"/>
			<xsl:choose>
				<xsl:when test="$qtyhi &gt; '1'"><xsl:value-of select="$unitelem/@plural"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$unitelem/@singular"/></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="format_number">
		<xsl:param name="n"/>
		<xsl:variable name="n_frac"  select="$n * 100 mod 100"/>
		<xsl:variable name="n_whole" select="($n * 100 - $n_frac) div 100"/>
		<xsl:if test="$n_whole != '0'">
			<xsl:value-of select="$n_whole"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$n_frac &gt;= 75">&#190;</xsl:when><!-- 3/4 -->
			<xsl:when test="$n_frac &gt;= 50">&#189;</xsl:when><!-- 1/2 -->
			<xsl:when test="$n_frac &gt;= 25">&#188;</xsl:when><!-- 1/4 -->
			<xsl:when test="$n_frac &gt;= 12"><sup>1</sup>/8</xsl:when>
			<xsl:when test="$n_frac &gt;= 6"><sup>1</sup>/16</xsl:when>
			<xsl:when test="$n_frac = 0"></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	
	<xsl:template match="ingredients">
		<div>
			<xsl:for-each select="ing">
				<div>
					<xsl:if test="@unit != 41"><!-- 41 is 'to taste' -->
						<xsl:call-template name="format_number">
							<xsl:with-param name="n" select="@qty"/>
						</xsl:call-template>
					
						<xsl:if test="@qtyhi &gt; @qty">
							to 
							<xsl:call-template name="format_number">
								<xsl:with-param name="n" select="@qtyhi"/>
							</xsl:call-template>
						</xsl:if>
					
						<xsl:text> </xsl:text>
					
						<xsl:if test="@qty_cont != 0">
							(<xsl:call-template name="format_number">
								<xsl:with-param name="n" select="@qty_cont"/>
							</xsl:call-template>
							<xsl:text> </xsl:text>
							<xsl:call-template name="unit_display">
								<xsl:with-param name="uid" select="@unit_cont"/>
								<xsl:with-param name="qtyhi" select="@qty_cont"/>
							</xsl:call-template>)
							<xsl:text> </xsl:text>
						</xsl:if>
					
						<xsl:if test="@unit != '0'">
							<xsl:call-template name="unit_display">
								<xsl:with-param name="uid" select="@unit"/>
								<xsl:with-param name="qtyhi" select="@qtyhi"/>
							</xsl:call-template>
							<xsl:text> </xsl:text>
						</xsl:if>
					</xsl:if>
						
					<xsl:value-of select="preprep"/><xsl:text> </xsl:text>
					
					<xsl:apply-templates select="document(concat('../xml/docs/foods/',@food_id,'.xml'))">
						<xsl:with-param name="qty" select="@qtyhi"/>
					</xsl:apply-templates>
					
					<xsl:if test="string-length(prep)">, <xsl:value-of select="prep"/></xsl:if>
					<xsl:if test="string-length(notes) &gt; 0"><xsl:text> </xsl:text>(<xsl:value-of select="notes"/>)</xsl:if>
					<xsl:if test="@optional!='0'"> (optional)</xsl:if>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="steps">
		<div>
			<xsl:for-each select="step">
				<div>
					<xsl:value-of select="position()"/>.<xsl:text> </xsl:text><xsl:value-of select="."/>
				</div>
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

				<xsl:apply-templates select="ingredients"/>
				<xsl:apply-templates select="steps"/>
					
				<xsl:apply-templates select="document(concat('../xml/meta/recipes/',ID,'.xml'))" mode="meta"/>
				
			</body>
		</html>

		
	</xsl:template>
	
</xsl:stylesheet>

