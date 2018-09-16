object @thread

attributes :id, :message_text, :is_read, :thread_id

node(:updated_at) { |thread| thread.time_of_message_in_words }
node(:attachment_url) { |thread| thread.attachment.url }

child :from => :from do |from|
  attributes :id, :first_name, :last_name
  node(:name) { from.id == current_user.id ? "you" : from.name }
  node(:photo_url) { from.user_profile.image.url }
end

child :to => :to do |to|
  if to.is_a? User
    attributes :id, :first_name, :last_name
    node(:name) { to.id == current_user.id ? "you" : to.name }
    node(:photo_url) { to.user_profile.image.url }
    node(:type) { 'User' }
  elsif to.is_a? Group
    attributes :id, :privacy_type, :name
    node(:type) { 'Group' }
  end
end

child :replies => :replies do |replies|
  extends('communications/message')
end

