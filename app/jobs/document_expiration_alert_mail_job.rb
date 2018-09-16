class DocumentExpirationAlertMailJob < Struct.new(:document_id)
	def perform
		doc = Document.find_by_id(document_id)
		requirements = SupplyChainRequirement.includes(:buyer).where(supplier_document_id:document_id)
		requirements.try(:each) do |requirement|
			admin = if requirement.buyer.is_a?(Company)
				buyer.admin.first
			elsif requirement.buyer.is_a?(Operation)
				buyer.company.admin.first
			end	
			AlertMailer.delay.document_soon_expired_alert(doc,admin)	
		end
		doc_owner = User.find_by_id(doc.created_by)
		AlertMailer.delay.document_soon_expired_alert(doc,doc_owner)
	end	
end