object @services
	attributes :id, :name, :description, :profile_picture

node :filter_type do
	"services"
end

node (:followed_by_current_user) { |obj| current_user.following?(obj)}

node (:service_image) { |obj| obj.profile_picture.thumb.url}

node (:company) { |obj| obj.company.name}

node (:service_owner) do |obj|
  owner = obj.operation.company.admin.first
  { :id => owner.id, :name => owner.name, :photo_url => owner.user_profile.image.url }
end