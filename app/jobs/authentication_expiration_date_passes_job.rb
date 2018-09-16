class AuthenticationExpirationDatePassesJob < Struct.new(:document_id)
	def perform
		doc = Document.find_by_id(document_id)
		doc.update_attributes(is_authenticated_third_party: false, status_detail: "authentication_expired")
		# send notification to document followers and owner
		doc.send_document_notification(nil,doc.document_notifiers,'document_authentication_expired')
	end
end