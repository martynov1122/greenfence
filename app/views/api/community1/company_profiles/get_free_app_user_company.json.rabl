object false

child @free_app_user_company => "company" do
  attribute :logo, :users_count, :products_count, :facilities_count, :certificates_count, :type
  node(:company_id) { |obj| obj.id }
  node(:company_name) { |obj| obj.name }
  node(:company_desc) { |obj| obj.company_profile.summary }
  node(:company_location) { |obj| obj.address.locality if obj.address}
end