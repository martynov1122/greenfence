attributes\
  :id,
  :name,
  :facilities_count,
  :producers_count

node(:product_category_name) { |obj| obj.product_category.name }
node(:product_category_id) { |obj| obj.product_category.id }