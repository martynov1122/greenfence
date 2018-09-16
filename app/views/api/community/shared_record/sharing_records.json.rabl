object false

child @sharing_records => 'sharing_records' do
	attributes :shareee, :sharable, :sharable_type, :user

	node :sharables do |obj|
		if obj.sharable_type == "Folder"
			obj.sharable.documents.length
		elsif obj.sharable_type == "Document"
			obj.sharable.document_files.length
		end
	end
end

node (:items) { @sharing_records_count if @sharing_records_count }