attributes :id, :document_name, :description, :profile_picture, :access_level, :requires_authentication, :expiration_date, :document_definition_id, :definition_value, :featured, :documentable_id, :documentable_type, :test_result, :additional_information, :merged_definition_value

child :document_definition do
  attributes :document_type, :id, :definition
end

child :document_files do
  attributes :id, :file_name
end

node (:document_authentication_request_status) { |obj| obj.document_authentication_requests.last.request_status if obj.document_authentication_requests.last }