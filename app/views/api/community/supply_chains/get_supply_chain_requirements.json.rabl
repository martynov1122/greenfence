object false

child @requirements => "requirements" do
  attributes :id, :compliant_status, :filled_by, :filled_on, :supply_chain_id, :supplier_document_id

  node (:supplier_name) { |obj| obj.supplier.name if obj && obj.supplier }

  node (:compliant_description) { |obj| I18n.t(obj.compliant_description) }

  node (:required_document_type) { |obj| obj.buyer_demanding_document_definition.document_type if obj.buyer_demanding_document_definition }

  node (:supplied_document_type) { |obj| obj.supplier_providing_document_definition.document_type if obj.supplier_providing_document_definition }

  node (:supplier_document) { |obj| obj.supplier_document.document_name if obj.supplier_document }
  
  node (:authentication_party) { |obj| obj.authentication_by }

end

node (:items) { @total_requirements if @total_requirements }
node (:buyer) { @buyer.name if @buyer }
node (:supplier) { @supplier.name if @supplier }
node (:definition_type) { @definition_type.document_type if @definition_type }