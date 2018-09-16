collection @collection

attributes :buyable_id , :buyable_type
node(:id) {|obj| @prefix + obj.buyable_id.to_s }
node(:compliance_status) {|obj| obj.buyable.gfsi_status}
node(:icon) {|obj| "/assets/#{obj.buyable_type}_#{obj.buyable.gfsi_status}.png"}
node(:text) { |obj| (obj.buyable_type == 'Facility') ? obj.buyable.name + " (#{obj.buyable.company.name}) " : obj.buyable.name }
node(:children) {true}
node(:parent_id) {@entity_id}