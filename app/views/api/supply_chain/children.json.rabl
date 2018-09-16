collection @entity.downstreams

attributes :sellable_id , :sellable_type
node(:id) {|obj| obj.sellable_id.to_s + obj.sellable_type}
node(:icon) {|obj| obj.sellable_type}
node(:text) { |obj| obj.sellable.name }
node(:children) {true}
node(:parent_id) {|obj| obj.buyable_id}