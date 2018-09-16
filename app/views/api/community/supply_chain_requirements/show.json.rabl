object @requirement
	attributes :id, :supplier_id, :supplier_type, :compliant_status, :certificate_not_expired, :lab_report_positive, :compliant_description, :filled_by, :supplier_document_id, :buyer_demanding_document_definition_id, :supplier_providing_document_definition_id, :authentication_by

	child :buyer => :buyer do
	  	attributes :id, :name
	  	node(:image_url) do |obj|
	  		if obj.type == nil
	  			obj.profile_picture.url(:thumb)
	  		else
	  			obj.logo.url(:thumb)
	  		end
	  	end
	end

	child :supplier_document => :document do
	  	attributes :id, :document_name, :requires_authentication
	end

	child :supplier_providing_document_definition => :supplied_document do
	  	attributes :id, :document_type
	end

	child :buyer_demanding_document_definition => :demanded_document do
	  	attributes :id, :document_type
	end

	child :activity_comments => :activity_comments do
	  	attributes :id, :text, :created_at
	  	node (:user) do |obj|
	  		{ name: obj.user.name, image_url: obj.user.user_profile.image.url(:thumb), title: obj.user.user_profile.title } if obj.user
	  	end
	end