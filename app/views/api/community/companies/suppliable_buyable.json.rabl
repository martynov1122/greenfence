object false 
  child @suppliable_buyable => 'suppliable_buyable' do
  	attributes :id, :name
  	node(:type) {|obj| obj.class.name }
  	node(:parent) { |obj| obj.company.name if obj.class.name == "Operation" }
  end

  node(:suppliable_buyable_count) { @suppliable_buyable_count }
