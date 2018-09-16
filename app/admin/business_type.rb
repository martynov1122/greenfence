ActiveAdmin.register BusinessType, as: "Business Types" do
  config.batch_actions = false
  config.filters = false

  hstore_editor
 
 index do
    column :name
    column :operation_definition
    actions
  end

  form do |f|
    f.inputs "Business Details" do
      f.input :name
    end

    f.inputs "Definition", :for => [:operation_definition, f.object.operation_definition || OperationDefinition.new] do |od|
      od.input :definition , as: :hstore      
    end

   
    f.actions
  end

  controller do
    def new
      redirect_to "/community/admin_operation_definition"
    end
  end
  actions :all
end
