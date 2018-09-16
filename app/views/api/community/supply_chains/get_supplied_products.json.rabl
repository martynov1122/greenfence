object @products
	attributes :id, :name, :entity_id

	node (:product_category) { |obj| obj.product_category.name }