object false

node (:document_id) { @id if @id }

child @shared_records => "shared_records" do
	attributes :id, :shareee_id

	child :shareee => 'user' do
		attributes :id, :name, :email
		node (:image) { |obj| obj.user_profile.image }
	end
end