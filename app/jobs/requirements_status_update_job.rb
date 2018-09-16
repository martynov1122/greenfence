class RequirementsStatusUpdateJob < Struct.new(:document_id)
  def perform
  	document = Document.find_by_id(document_id)
  	requirements_to_update = SupplyChainRequirement.where(supplier_document_id:document_id)
  	requirements_to_update.try(:each) do |requirement|
  		requirement.set_requirement_compliance!(document)
  	end if document.present? 
  end
end