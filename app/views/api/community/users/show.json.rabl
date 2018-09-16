object @user
  attributes :id, :email, :name, :company_id, :first_name, :last_name, :tags, :mobile_number,:voice_number, :language_preference, :is_welcome_message_closed, :featured, :type,:uuid, :owns_a_company, :verified

child :user_profile => :user_profile_attributes do
  attributes :id, :title, :executive_experience, :image
end

child :user_endorsements => :user_endorsements do
  attributes :tag_name, :user_id, :endorse_count, :endorse_by_users
end

child :address => :address_attributes do
  attributes :id, :city, :state, :country ,:street1, :street2,:postal_code
end

child :connections => :connections_attributes do
  attributes :id, :name, :url
end

child :auditors_schemes => :auditors_schemes do
	attributes :id, :user_id, :scheme_type_id
	node(:scheme_type) { |obj| obj.scheme_type.try(:name) }
end

child (:permissions) { attributes :id, :name, :label }

node (:followed_by_current_user) { current_user.following?(@user)}
node (:connected_status_with_current_user) { current_user.connected_status(@user)}
node (:photo_url) { @user.user_profile.image.url }

node :filter_type do
	"users"
end

node :tags_endorsements do |obj|
	obj.merged_tags_endorsements(current_user)
end

node :tags_endorsements_length do |obj|
	obj.merged_tags_endorsements(current_user).length
end

node (:notifications_list_count) { current_user.only_notifications.count }

node (:messages_list_count) { current_user.in_messages_with_groups.count }

node (:internal_operations_list_count) { current_user.internal_operations_notifications.count }

node (:requests_list_count) { current_user.requests_notifications.count }

node (:sent_list_count) { current_user.sent_messages_count }

node (:groups_list_count) { current_user.groups.count }

child (:groups) { attributes :id, :name }

# for time being we are getting only 5 badges
node (:badges) { |obj| obj.schemes.limit(5).map(&:name) if obj.class.name == "Auditor" }
