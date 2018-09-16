collection @public_documents
	attributes :id, :document_name

node(:document_thumb_image) {|obj| obj.document_thumb_image(current_user)}