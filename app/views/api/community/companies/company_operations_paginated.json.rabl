object false

child @company_operations => 'company_operations' do
	attributes :id, :name, :uuid
	node(:type) {|obj| obj.class.name }
	node(:parent) { |obj| obj.company.name if obj.class.name == "Operation" }
end

node (:items) { @company_operations_count if @company_operations_count }