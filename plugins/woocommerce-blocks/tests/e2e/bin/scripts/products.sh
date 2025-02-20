#!/usr/bin/env bash

###################################################################################################
# Import sample products and regenerate product lookup tables
###################################################################################################
wp import wp-content/plugins/woocommerce/sample-data/sample_products.xml --authors=skip
wp wc tool run regenerate_product_lookup_tables --user=1

# This is a hacky work around to fix product categories not having their parent category correctly assigned.
clothing_category_id=$(wp wc product_cat list --search="Clothing" --field=id --user=1)
tshirts_category_id=$(wp wc product_cat list --search="Tshirts" --field=id --user=1)
hoodies_category_id=$(wp wc product_cat list --search="Hoodies" --field=id --user=1)
wp wc product_cat update $tshirts_category_id --parent=$clothing_category_id --user=1
wp wc product_cat update $hoodies_category_id --parent=$clothing_category_id --user=1

# This is a hacky work around to fix product gallery images not being imported
# This sets up the product Hoodie to have product gallery images for e2e testing
post_id=$(wp post list --post_type=product --field=ID --name="Hoodie" --format=ids)
image1=$(wp post list --post_type=attachment --field=ID --name="hoodie-with-logo-2.jpg" --format=ids)
image2=$(wp post list --post_type=attachment --field=ID --name="hoodie-green-1.jpg" --format=ids)
image3=$(wp post list --post_type=attachment --field=ID --name="hoodie-2.jpg" --format=ids)
wp post meta update $post_id _product_image_gallery "$image1,$image2,$image3"

# This is a non-hacky work around to set up the cross sells product.
product_id=$(wp post list --post_type=product --field=ID --name="Cap" --format=ids)
crossell_id=$(wp post list --post_type=product --field=ID --name="Beanie" --format=ids)
wp post meta update $crossell_id _crosssell_ids "$product_id"