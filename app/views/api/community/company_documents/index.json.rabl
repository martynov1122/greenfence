object false

child @documents => 'documents' do
  attributes :id, :document_name, :authenticated, :description, :requires_authentication, :expiration_date, :document_definition_id, :definition_value, :featured, :documentable_id, :documentable_type, :test_result
  node(:access_level){|obj| I18n.t(obj.access_level)}

  child :document_definition do
    attributes :document_type, :id, :definition
  end

  child :document_files do
    attributes :id, :file_name
  end

  node :shared_records_count do |obj|
    obj.shared_records.length
  end
end

node (:items) { @documents_count if @documents_count }