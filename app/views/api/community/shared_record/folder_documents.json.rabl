object false
child @folder_documents => 'folder_documents' do
  attributes :id, :document_name, :description, :authenticated, :requires_authentication, :document_definition_id, :definition_value, :featured, :documentable_id, :documentable_type
  node(:access_level){|obj| I18n.t(obj.access_level)}

  child :document_files do
    attributes :id, :file_name
  end
end
node (:items) { @folder_documents_count if @folder_documents_count }