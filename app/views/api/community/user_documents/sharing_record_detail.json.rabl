object false

child @document => "document" do
	attributes :id, :document_name, :description, :profile_picture, :access_level, :type,	:requires_authentication, :featured, :documentable_id, :documentable_type, :document_definition_id,	:definition_value, :user_folder_id,	:document_files_attributes, :merged_definition_value, :status, :status_detail, :authentication_date, :additional_information, :test_result, :created_by

	node (:next_possible_events) { |obj| obj.next_possible_events }

	node (:document_thumb_image) { |obj| obj.document_thumb_image(current_user) }

	child :document_files do
		attributes :id, :file_name
	end

	child :document_definition do
	    attributes :document_type, :id, :definition
	end

	node(:expiration_date) do |obj| 
		if obj.expiration_date.present?  
		  obj.expiration_date.strftime('%Y-%m-%d') 
		end
	end

	node :auditor do |obj| 
		{ id: obj.document_authentication_requests.first.auditor.id, name:  obj.document_authentication_requests.first.auditor.name, image_url: obj.document_authentication_requests.first.auditor.user_profile.image.thumb.url, featured: obj.document_authentication_requests.first.auditor.featured, payment_settings: obj.document_authentication_requests.first.auditor.is_payment_settings_verified?, company_id: obj.document_authentication_requests.first.auditor.company.id, company_name: obj.document_authentication_requests.first.auditor.company.name, authenticated: obj.document_authentication_requests.first.auditor.authenticated  } if obj.document_authentication_requests.first
	end

	node :owner do |obj|
		image_url = if obj.documentable_type == "Company"
						obj.documentable.logo.thumb.url
					elsif obj.documentable_type == "Operation"
						obj.documentable.profile_picture.thumb.url
					else
						obj.documentable.user_profile.image.thumb.url
					end
		{ name: obj.documentable.name, id: obj.documentable.id, type: obj.documentable_type, image_url: image_url }
	end

	child :document_authentication_requests do
		attributes :id, :price_for_auth, :document_id, :doc_owner_id, :auditor_id, :comment, :request_status, :created_at, :payment_done_at
		node(:offer_date_of_auth) do |obj| 
			if obj.offer_date_of_auth.present?  
			  obj.offer_date_of_auth.strftime('%Y-%m-%d') 
			end
		end
		node(:authentication_expiration_date) do |obj| 
			if obj.authentication_expiration_date.present?  
			  obj.authentication_expiration_date.strftime('%Y-%m-%d') 
			end
		end
		node (:next_possible_events) { |obj| obj.next_possible_events }
	end
end

child @document_comment_activity => "document_comment_activity" do
  	attributes :id

  	node(:comments_count) { |obj| obj.activity_comments.count }

  	node(:can_see_document_comment) do |obj|
    	{ can_see: current_user.can_see_document_comments(obj.subject.id) }
  	end

  	child :activity_comments do
    	attributes :text, :user_id

    	node(:created_at) { |obj| obj.created_at }
    	node(:user) do |obj|
      		{ name: obj.user.name, image_url: obj.user.user_profile.image.url(:thumb), title: obj.user.user_profile.title } if obj.user
    	end
  	end
end
	