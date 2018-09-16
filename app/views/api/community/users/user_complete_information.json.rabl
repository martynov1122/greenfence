object @user
  attributes :id, :email, :name, :company_id, :first_name, :last_name, :tags, :mobile_number, :language_preference, :is_welcome_message_closed, :featured, :type, :company, :company_profile,:uuid,:voice_number,:owns_a_company, :verified,:authenticated


child :user_profile => :user_profile_attributes do
  attributes :id, :title, :executive_experience, :image
end

child :user_endorsements => :user_endorsements do
  attributes :tag_name, :user_id, :endorse_count, :endorse_by_users
end

node (:company) do
  partial("companies/show",:object=> @user.company, :company => @user.company)

end

child :address => :address_attributes do
  attributes :id, :city, :state, :country ,:street1, :street2,:postal_code
end

child :connections => :connections_attributes do
  attributes :id, :name, :url
end

node(:operations_count) { |obj| obj.company.operations_count if obj.company }
node(:products_count) { |obj| obj.company.products_count if obj.company }
node(:services_count) { |obj| obj.company.services_count if obj.company }
node(:certificates_count) { |obj| obj.company.certificates_count if obj.company }

child (:permissions) { attributes :id, :name, :label }

node (:followed_by_current_user) { current_user.following?(@user)}
node (:connected_status_with_current_user) { current_user.connected_status(@user)}

node :filter_type do
  "users"
end

node :tags_endorsements do |obj|
	obj.merged_tags_endorsements(current_user)
end

node (:notifications_list_count) { current_user.only_notifications.count }

node (:internal_operations_list_count) { current_user.internal_operations_notifications.count }

node (:requests_list_count) { current_user.requests_notifications.count }

node (:groups_list_count) { current_user.groups.count }

child (:groups) { attributes :id, :name }

# for time being we are getting only 5 badges
node (:badges) { |obj| obj.schemes.limit(5).map(&:name) if obj.class.name == "Auditor" }
