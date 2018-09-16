object @activity

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
  
child :activity_comments do
  attributes :text
  node(:commentor_path) {|obj| 
    'profile_public?id='+obj.user_id.to_s
  }
  node(:commentor_name) {|obj| User.find_by_id(obj.user_id).name }
  node(:commentor_image) {|obj| User.find_by_id(obj.user_id).user_profile.image.thumb.url }
  node(:comment_time_difference) { |obj| obj.distance_of_time_in_words(Time.now, obj.created_at)}
end
node(:current_user_image) {|obj|
  current_user.user_profile.image.thumb.url
}

child @activity do
  extends "api/shared/collections/activity"
end