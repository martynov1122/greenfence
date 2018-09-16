object false

child @buyers => "buyers" do
  attributes :id
  node(:name) do |obj|
  	name = obj.buyable_type.constantize.find(obj.buyable_id).name
  	if obj.buyable_type == 'Operation'
  		name = name + " (O) "
  	else
  		name = name + " (C) "
  	end
  	name = name + " customer of " + obj.sellable_type.constantize.find(obj.sellable_id).name
  end
end