object @product_category

attributes :id, :name

child :products do
  attributes :id, :name, :product_category_id 
end

