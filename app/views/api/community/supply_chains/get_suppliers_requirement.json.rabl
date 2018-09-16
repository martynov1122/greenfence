object false

child @requirements => "requirements" do
	attributes :id, :warning, :compliant, :non_compliant, :document_type
	node(:suppliers_count) {|obj| obj.warning + obj.compliant + obj.non_compliant}
end

node (:items) { @total_requirements if @total_requirements }