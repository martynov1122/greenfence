object false

child @buyers => "buyers" do
  attributes :id, :entity_id, :name, :city, :state, :country, :entity_type

  node (:type) do |obj|
  	if obj.class.name == "Graph::Node::OperationNode"
  		"Operation"
  	else
  		"Company"
  	end
  end
end

node (:items) { @total_buyers if @total_buyers }
node (:supplier_id) { @supplier_id if @supplier_id }
node (:supplier_type) { @supplier_type if @supplier_type }