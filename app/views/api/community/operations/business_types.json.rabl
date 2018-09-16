object @business_types 
  attributes :id, :name, :operation_definition_id

  child :operation_definition do
    attributes :id, :definition
  end