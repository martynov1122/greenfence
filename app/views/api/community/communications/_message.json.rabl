object @message

attributes :id, :message_text, :is_read, :thread_id

node(:updated_at) { |message| message.updated_at_in_words }
node(:attachment_url) { |message| message.attachment.url }

child :from => :from do |reply_from|
  attributes :id, :first_name, :last_name
  node(:name) { reply_from.id == current_user.id ? "you" : reply_from.name }
  node(:photo_url) { reply_from.user_profile.image.url }
end

child :to => :to do |reply_to|
  if reply_to.is_a? User
    attributes :id, :first_name, :last_name
    node(:name) { reply_to.id == current_user.id ? "you" : reply_to.name }
    node(:photo_url) { reply_to.user_profile.image.url }
    node(:type) { 'User' }
  elsif reply_to.is_a? Group
    attributes :id, :privacy_type, :name
    node(:type) { 'Group' }
  end
end