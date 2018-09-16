object @company
	attributes :id, :name, :logo, :follows_count, :business_types, :type, :other_company_type, :operations_count, :featured_count

	node(:employees_count) { |obj| obj.users.count if obj }
	node(:products_count) { |obj| obj.products.count if obj }
	node(:services_count) { |obj| obj.services.count if obj }
	node(:documents_count) { |obj| Document.company_and_its_operations_documents(obj.id).public.count if obj}

	node :primary_contact_user do |obj| 
		{ id: obj.admin.first.id, name:  obj.admin.first.name, image_url: obj.admin.first.user_profile.image.thumb.url, title: obj.admin.first.user_profile.title} if obj.try(:admin).try(:first)
	end

	node(:type_to_show) do |obj|
		if obj
			if obj.type == "Other"
				type_to_show = obj.other_company_type
			else
				type_to_show = obj.type.try(:titleize)
			end
		end
	end

	child :address => :address_attributes do
	 attributes :id, :street1, :street2, :postal_code, :city, :state, :country
	end

	child :company_profile => :company_profile_attributes do
	  attributes :id, :summary, :phone, :website, :email
	end

	child :connections => :connections_attributes do
	  attributes :id, :name, :url
	end