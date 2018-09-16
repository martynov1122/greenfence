object @service
attributes :id, :name, :description, :profile_picture, :operation_id, :uploaded_files, :featured, :operation

child(:operation) do
  attributes :id, :name
  child company: :company do
    attributes :id, :name, :logo
  end
end


