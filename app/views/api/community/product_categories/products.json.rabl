collection @products
	attributes :id, :name, :uuid

node(:product_category) { |obj| obj.product_category.name }