object false


child @categories => "category" do
  attributes :id, :name  
end
child @products  do
   attributes :id, :name, :product_category_id 
end