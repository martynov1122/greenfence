object @company
	attributes :id, :name, :logo, :operations_count, :products_count, :services_count, :employees_count, :documents_count

node(:type) { |obj| obj.type.titleize if obj }
node(:employees_count) { |obj| obj.users.count if obj }

child :company_profile => :company_profile_attributes do
  attributes :id, :summary, :phone, :website, :email
end

child :address => :address_attributes do
  attributes :id, :street1, :city, :state, :country
end

child :connections => :connections_attributes do
  attributes :id, :name, :url
end