object false
child @audited_documents  => "audited_documents" do
  attributes :id, :access_level, :audit_by, :document_name, :document_id, :posted_date, :document_type, :document_uploader_name, :document_uploader_type, :action

  node(:audit_stage) { |obj| I18n.t(obj.audit_stage)}
end
node(:items) {@audited_documents_count if @audited_documents_count}


