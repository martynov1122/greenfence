#object false

#node :total_pages do
#  @products.total_pages
#end

#node :current_page do
#  @products.current_page
#end

#child @products => "products" do
#  extends "api/shared/collections/product"

# node(:subscription) { |obj| obj.subscription_options(current_user) }
#end

collection @products => :company_products
  #attributes :id, :name, :image, :description
  extends "api/shared/collections/product"
