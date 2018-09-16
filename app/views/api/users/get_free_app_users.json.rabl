object false

child @free_app_users do
  attributes :id, :name, :email
  node(:company_name){|obj| obj.company.name if obj.company}
end