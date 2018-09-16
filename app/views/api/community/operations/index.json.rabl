object @operations 
  attributes :id, :name, :description, :image, :business_type_id, :business_sub_types, :operation_definition_id, :definition_value, :featured

  child :address => :address_attributes do
	attributes :id, :street1,:street2,:city, :state, :country, :postal_code 
  end 

  child :operation_definition do
    attributes :id, :business_type_id, :definition
  end

  child :business_type do
    attributes :id, :name

    child :operation_definition do
      attributes :id, :definition
    end
  end

  child :products do
  	attributes :id, :name, :product_category_id 
  end
