
ROOT_DIR=/var/www/recipes

%.html: ../../sh/recipe_html ../../xsl/recipe.xsl ../../xml/meta/recipes/%.xml
	../../sh/recipe_html $(basename $(@F))

$(ROOT_DIR)/html/reviews/recipe/newest/%.html: $(ROOT_DIR)/sh/reviews_recipe_html $(ROOT_DIR)/xsl/reviews/recipe.xsl $(ROOT_DIR)/xml/meta/recipes/%.xml
	$(ROOT_DIR)/sh/reviews_recipe_html $(basename $(@F)) newest

$(ROOT_DIR)/html/reviews/recipe/oldest/%.html: $(ROOT_DIR)/sh/reviews_recipe_html $(ROOT_DIR)/xsl/reviews/recipe.xsl $(ROOT_DIR)/xml/meta/recipes/%.xml
	$(ROOT_DIR)/sh/reviews_recipe_html $(basename $(@F)) oldest

$(ROOT_DIR)/html/reviews/recipe/highest_rated/%.html: $(ROOT_DIR)/sh/reviews_recipe_html $(ROOT_DIR)/xsl/reviews/recipe.xsl $(ROOT_DIR)/xml/meta/recipes/%.xml
	$(ROOT_DIR)/sh/reviews_recipe_html $(basename $(@F)) highest_rated
