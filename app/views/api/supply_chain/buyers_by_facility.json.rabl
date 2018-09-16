collection @collection

attributes :buyable_id , :buyable_type
node(:id) {|obj| @prefix + obj.buyable_id.to_s}
node(:compliance_status) {|obj| obj.gfsi_status}
node(:icon) {|obj| "/assets/#{obj.buyable_type}_#{obj.gfsi_status}.png"}

node(:text) { |obj| (obj.buyable_type == 'Facility')  ? obj.name  : obj.name }

node(:children) {true}
node(:parent_id ) {|obj| obj.parent_id  }
