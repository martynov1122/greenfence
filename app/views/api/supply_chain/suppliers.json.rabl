collection @collection

attributes :sellable_id , :sellable_type
node(:id) {|obj| @prefix + obj.sellable_id.to_s}
node(:compliance_status) {|obj| obj.sellable.gfsi_status}
node(:icon) {|obj| "/assets/#{obj.sellable_type}_#{obj.sellable.gfsi_status}.png"}

node(:text) { |obj| obj.sellable.name }  if @filter == 'Company'

node(:text) { |obj| (obj.sellable_type == 'Facility')  ? obj.sellable.name + " (#{obj.sellable.company.name})" : "(Unspecified Facility) #{obj.sellable.name}" } if @filter == 'Facility'

node(:children) {true}
node(:parent_id) {@entity_id}
