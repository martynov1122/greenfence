object @operations
	attributes :id, :name, :description, :profile_picture, :products_count, :services_count

node (:company)  { |obj| obj.company.name }
node (:documents_count)  { |obj| obj.documents.public.count }

node :filter_type do
	"operations"
end

node (:followed_by_current_user) { |obj| current_user.following?(obj)}

node (:operation_owner) do |obj|
  owner = obj.company.admin.first
  { :id => owner.id, :name => owner.name, :photo_url => owner.user_profile.image.url }
end