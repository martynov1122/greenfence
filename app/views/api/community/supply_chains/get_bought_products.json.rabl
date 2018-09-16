object @bought_products
	attributes :name

	node (:id) { |obj| obj.uuid }

	node (:product_category) { |obj| obj.product_category.name }