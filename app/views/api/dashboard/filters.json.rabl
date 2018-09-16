object false

node("Product Category") do
  @categories.map {|c|
    {value: c.id, display: c.name}
  }
end

node "Product" do
  @products.map {|p|
    {value: p.id, display: p.name}
  }
end

node "Special Product Category" do
  @special_product_categories.map {|p|
    {value: p.id, display: p.name}
  }
end
