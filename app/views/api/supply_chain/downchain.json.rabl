object false

node :text do
  @entity.name
end

child @entity.downstreams => "children" do
  attributes :sellable_id , :sellable_type
  node(:id) {|obj| obj.sellable_id}
  node(:icon) {|obj| obj.sellable_type}
  node(:text) { |obj| obj.sellable.name }
  node(:children) {true}
end