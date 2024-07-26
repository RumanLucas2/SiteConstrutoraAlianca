<form role="search" method="get" class="search_with_icon woocommerce-product-search" action="<?php echo esc_url( home_url( '/'  ) ); ?>">
	<input type="search" class="text_input search-field" placeholder="<?php echo esc_attr_x( 'Search Products&hellip;', 'placeholder', 'woocommerce' ); ?>" value="<?php echo get_search_query(); ?>" name="s" title="<?php echo esc_attr_x( 'Search for:', 'label', 'woocommerce' ); ?>" />
	<button type="submit"><span><?php echo esc_attr_x( 'Search', 'submit button', 'woocommerce' ); ?></span></button>
	<input type="hidden" name="post_type" value="product" />
</form>