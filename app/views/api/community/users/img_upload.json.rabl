object @user
attributes :id, :email, :name, :company_id, :first_name, :last_name, :tags, :mobile_number, :language_preference

child :user_profile => :user_profile_attributes do
  attributes :id, :title, :executive_experience, :image
end

child :address => :address_attributes do
  attributes :id, :city, :state, :country
end

child :connections => :connections_attributes do
  attributes :id, :name, :url
end

child (:permissions) { attributes :id, :name, :label }