object false

child @pending_buyers => "pending_buyers" do
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

node(:pending_buyers_count) { @pending_buyers_count }

child @accepted_buyers => "accepted_buyers" do
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

node(:accepted_buyers_count) { @accepted_buyers_count }

child @rejected_buyers => "rejected_buyers" do
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

node(:rejected_buyers_count) { @rejected_buyers_count }