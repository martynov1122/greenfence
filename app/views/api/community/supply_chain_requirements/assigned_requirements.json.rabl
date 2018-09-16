object false

child @supply_chain_requirements => "supply_chain_requirement" do
  attributes :id, :buyer_demanding_document_definition_id, :supplier_providing_document_definition_id, :supplier_document_id

  node(:document_type) { |obj| DocumentDefinition.find_by_id(obj.buyer_demanding_document_definition_id).document_type if !obj.buyer_demanding_document_definition_id.nil?}

  node(:supplier_document) { |obj| CompanyDocument.find_by_id(obj.supplier_document_id).document_name if !obj.supplier_document_id.nil?}

  node(:supplier_document_definition) { |obj| DocumentDefinition.find_by_id(obj.supplier_providing_document_definition_id).document_type if !obj.supplier_providing_document_definition_id.nil?}

  node(:shared_by_user) { |obj| obj.shared_by_user}
end