object @user_documents 
  attributes :id, :document_name, :description, :access_level, :requires_authentication, :expiration_date, :document_definition_id, :definition_value, :featured, :documentable_id, :documentable_type, :test_result

  child :document_definition do
    attributes :document_type, :id, :definition
  end

  child :document_files do
    attributes :id, :file_name
  end