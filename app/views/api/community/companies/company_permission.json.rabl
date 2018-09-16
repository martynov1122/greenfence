object false

child @company_permission => "company_permission" do
	attributes :id, :name
    node(:label) {|obj| I18n.t(obj.label) }
end

child @operation_permission => "operation_permission" do
	attributes :id, :name
    node(:label) {|obj| I18n.t(obj.label) }
end
