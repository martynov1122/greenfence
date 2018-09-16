object false

child @pending_suppliers => :pending_suppliers do
	attributes :id
	node(:name) { |obj| obj.invited_entity.name}
	node(:profile_image) do |obj| 
		if obj.invited_entity.is_a?(Company)
  			obj.invited_entity.logo.thumb.url
  		elsif obj.invited_entity.is_a?(Operation)
  			obj.invited_entity.profile_picture.thumb.url
  		end
	end
end

node(:pending_suppliers_count) { @pending_suppliers_count }

child @accepted_suppliers => "accepted_suppliers" do
  attributes :id
  node(:name) { |obj| obj.invited_entity.name}
  node(:profile_image) do |obj| 
		if obj.is_a?(Company)
  			obj.logo.thumb.url
  		elsif obj.is_a?(Operation)
  			obj.profile_picture.thumb.url
  		end
	end
end

node(:accepted_suppliers_count) { @accepted_suppliers_count }

child @rejected_suppliers => "rejected_suppliers" do
  attributes :id
  node(:name) { |obj| obj.invited_entity.name}
  node(:profile_image) do |obj| 
    if obj.is_a?(Company)
        obj.logo.thumb.url
      elsif obj.is_a?(Operation)
        obj.profile_picture.thumb.url
      end
  end
end

node(:rejected_suppliers_count) { @rejected_suppliers_count }