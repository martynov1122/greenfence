object @supply_chain_node
	attributes :compliant_status, :downstream_compliance_status, :compliant_description

	child (:products) { attributes :id, :name, :profile_picture, :uuid }

	node (:name) { |obj| obj.sellable.name if obj }

	node (:parent) { |obj| obj.sellable.company.name if obj && obj.sellable_type == 'Operation' }

	node :thumb_url do |obj|
		if obj && obj.sellable_type == 'Company'
			obj.sellable.logo.url(:thumb)
		else
			obj.sellable.profile_picture.url(:thumb)
		end
	end

	node (:admin_id) { |m| @admin.id }

	node (:admin_name) { |m| @admin.name }

	node (:admin_thumb_url) { |m| @admin.user_profile.image.url }