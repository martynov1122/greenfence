object @notification

attributes *(Notification.column_names - ["updated_at"])

# node(:updated_at) { |notification| notification.updated_at_in_words }

child :sender => :sender do |sender|
  attributes :id, :first_name, :last_name
  node(:name) { sender.name }
  node(:photo_url) { sender.user_profile.image.url }
end

child :object => :object do |object|
  if object.is_a? GroupMember

    attributes *object.class.column_names

    child :group => :group do |group|
      attributes *group.class.column_names
    end

  elsif object.is_a? Communication

    attributes *object.class.column_names

    if object.to.is_a? Group
      child :to => :to do |to|
        attributes *object.to.class.column_names
      end
    end

  else
    attributes *object.class.column_names
  end
end

child :recipient => :recipient do |recipient|
  attributes :id, :first_name, :last_name
  node(:name) { recipient.name }
  node(:photo_url) { recipient.photo.url }
end

child :notification_type => :notification_type do |n|
  attributes :message_format, :placeholder_count, :has_actions 
end