collection @activities

extends "api/shared/collections/activity"

node(:message_json) { |obj|
	Activity.message_json obj
}
node(:activator_company) {|obj| 
  if(obj.activator_type != "Company" && obj.activator_type != "Product")
    obj.activator.company.try(:name)
  elsif(obj.activator_type == "Product")
    obj.subject.company.try(:name)
  end
}
node(:subject_name) { |obj| obj.subject.try(:name) }
node(:custom_name) {  |obj| obj.try(:subject_name) }
node(:time_difference) { |obj| obj.distance_of_time_in_words(Time.now, obj.created_at)}
node(:activator_image) {  |obj|
	if(obj.activator_type == "User")
		obj.activator.user_profile.image.thumb.url
	end
}

node(:total_records) {@total_records}
node(:image) {|obj|
	if(obj.subject_type == "Certificate")
		obj.try(:subject).try(:document).thumb.url
	end
}
node(:current_user_image) {|obj|
  current_user.user_profile.image.thumb.url
}
