object false

child @free_app_users do
  attributes :id, :name, :title
  node(:image) {|obj| (obj.user_profile.image)}
  node(:user_role) { |obj| (obj.is_of_role?"freeapp_admin")? "Free App Admin": "Free App User" }
  node(:profile_title) { |obj| (obj.user_profile.title)}
  node(:company_name) { |obj| (obj.try(:company).try(:name))}
end
