attributes\
  :id,
  :created_at,
  :message_format,
  :subject_id,
  :subject_type,
  :activator_id,
  :activator_type,
  :text,
  :alert_level,
  :actionable_path,
  :resolved
  
node(:type) {|obj| obj.try(:type) }
node(:activator_name) {|obj| obj.activator.try(:name) }
child :activity_comments do
  attributes :text
  node(:commentor_path) {|obj| 
    'profile_public?id='+obj.user_id.to_s
  }
  node(:commentor_name) {|obj| User.find_by_id(obj.user_id).name }
  node(:commentor_image) {|obj| User.find_by_id(obj.user_id).user_profile.image.thumb.url }
  node(:comment_time_difference) { |obj| obj.distance_of_time_in_words(Time.now, obj.created_at)}
end