class DocumentServices
  class << self
    def associate_document_with_requirement document_id
      document = Document.find_by_id(document_id)
      supply_chain_requirement = SupplyChainRequirement.find_by_buyer_demanding_document_definition_id_and_supplier_id_and_supplier_type(document.document_definition_id, document.documentable_id, document.documentable_type)
      if !supply_chain_requirement.nil?
        supply_chain_requirement.update_attributes(supplier_document_id: document.id, supplier_providing_document_definition_id: document.document_definition_id)
        supply_chain_requirement.set_requirement_compliance! document
      end
    end

    handle_asynchronously :associate_document_with_requirement
  end
end