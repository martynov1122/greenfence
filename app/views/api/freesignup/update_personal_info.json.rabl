object false
child(@user) do
  attributes :first_name, :last_name
  child :roles do
    attributes :name, :resource_id, :resource_types
  end
end
child(@token) do
  attributes :created_at, :device, :user_id, :value
end