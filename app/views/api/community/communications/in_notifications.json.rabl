collection @in_notifications

node(:updated_at) { |n| n.updated_at_in_words }

node(:activity_key, :if => lambda { |m| m.is_a? Communication }) do |m|
  "new_message"
end

node(false, :if => lambda { |m| m.is_a? Communication }) do |m|
  partial('communications/thread', object: m)
end

node(false, :if => lambda { |m| m.class != Communication }) do |m|
  partial('communications/notification', object: m)
end