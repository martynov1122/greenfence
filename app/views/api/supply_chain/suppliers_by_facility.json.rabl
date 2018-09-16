collection @collection

attributes :sellable_id , :sellable_type
node(:id) {|obj| @prefix + obj.sellable_id.to_s}
node(:compliance_status) {|obj| obj.gfsi_status}
node(:icon) {|obj| "/assets/#{obj.sellable_type}_#{obj.gfsi_status}.png"}

node(:text) { |obj| (obj.sellable_type == 'Facility')  ? obj.name  : obj.name }

node(:children) {true}
node(:parent_id ) {|obj| obj.parent_id  }
