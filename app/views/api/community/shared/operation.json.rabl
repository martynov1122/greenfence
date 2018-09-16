attributes :id, :name, :profile_picture, :description, :business_type_id, :business_sub_types, :operation_definition_id, :definition_value, :additional_information, :featured, :featured_count

node(:products_count) { |obj| obj.products.count if obj }
node(:services_count) { |obj| obj.services.count if obj }
node(:documents_count) { |obj| obj.documents.public.count if obj }

node :company_profile_attributes do |obj|
  {email: obj.company.company_profile.email, website: obj.company.company_profile.website, phone: obj.company.company_profile.website} if obj.try(:company).try(:company_profile)
end

node :primary_contact_user do |obj| 
  { id: obj.company.admin.first.id, name:  obj.company.admin.first.name, image_url: obj.company.admin.first.user_profile.image.thumb.url, title: obj.company.admin.first.user_profile.title} if obj.try(:company).try(:admin).try(:first)
end

child :business_type do
  attributes :id, :name
  child :operation_definition do
  attributes :id, :definition
  end
end

child :company => :company do
  attributes :id, :logo, :name
end

child :products do
  attributes :id, :name, :product_category_id
end

child :operation_definition do
  attributes :id, :business_type_id, :definition
end

child :address => :address_attributes do
  attributes :id, :street1, :street2, :city, :state, :country, :postal_code
end if @operation.address.present?