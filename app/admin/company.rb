ActiveAdmin.register Company do
  # actions :index
  config.batch_actions = false
  config.filters = false

  index do
    column :name
    column :phone_number
  end

  form do |f|
  	f.inputs "Company Details" do
      f.input :name
      f.input :phone_number
    end

    f.inputs "Address", :for => [:address, f.object.address || Address.new] do |address|
      address.input :street1
      address.input :locality
      address.input :administrative_area
      address.input :postal_code
      address.input :latitude_degrees
      address.input :longitude_degrees
    end

    f.inputs "Buyers/Sellers" do
      f.input :suppliers, :label => "Buys From", as: :select, :multiple => true
    end
	  f.actions
  end

end
