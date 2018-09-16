object @documents
  attributes :id, :document_name, :description, :authenticated, :profile_picture, :expiration_date, :test_result, :documentable

node :filter_type do
  "documents"
end
node (:documentable) { |obj| obj.documentable.name}
node (:followed_by_current_user) { |obj| current_user.following?(obj)}
node (:documentable_owner) do |obj|
  owner = obj.documentable_owner
  { :id => owner.id, :name => owner.name, :photo_url => owner.user_profile.image.url }
end