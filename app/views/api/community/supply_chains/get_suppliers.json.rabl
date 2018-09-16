object false

child @suppliers => "suppliers" do
  attributes :id
  node(:name) do |obj| 
  	name = obj.sellable_type.constantize.find(obj.sellable_id).name
  	if obj.sellable_type == 'Operation'
  		name = name + " (O)"
  	else
  		name = name + " (C)"
  	end
  end
end