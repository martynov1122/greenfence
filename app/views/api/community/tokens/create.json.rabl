object false
child(@token) do
  attributes :created_at, :device, :user_id, :value
end
child(@user) do
  attributes :company_id, :first_name, :last_name
  child :roles do
    attributes :name, :resource_id, :resource_types
  end
end
