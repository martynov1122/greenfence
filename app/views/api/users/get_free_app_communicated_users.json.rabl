object false

child @free_app_users do
  attributes :id, :name
  node(:image) {|obj| obj.user_profile.image}
  node(:last_message) {|obj| Communication.find(:last, :conditions => ["from_user = ? AND to_user = ? OR from_user = ? AND to_user = ?", obj.id, current_user.id, current_user.id, obj.id], :order =>'Communications.created_at'  )}
end