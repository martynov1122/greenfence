class NotifyDocumentViewedJob < Struct.new(:document_id,:time,:viewer_id)
	def perform
		document = Document.find_by_id(document_id)
		viewer = User.find_by_id(viewer_id)
		owner = User.find_by_id(document.created_by)
		notifiers = [owner] + User.document_followers(document) - [viewer]
		viewed_before = DocumentView.where('user_id = ? AND updated_at > ? AND document_id = ?',viewer.id,document.updated_at,document.id).exists?
		if viewer.uuid != owner.uuid && !viewed_before 
			DocumentView.create(user_id:viewer.id,document_id:document.id)
			send_view_notification(viewer , owner, document)
			notifiers.uniq.try(:each) do |user|
				AlertMailer.delay.alert_document_viewed(document,viewer,time,user)
			end
		end
	end
	def send_view_notification(sender , receiver , document)
		notification_type = NotificationType.find_by_name("document_viewed")
		values = []
    	values[0] = {param: '1' , name: sender.name, url: "#/user_public_profile/#{sender.id}"} 
    	values[1] = {param: '2' , name: document.document_name, url: "#/user_document/#{document.id}/sharing_record_detail"}
    	actions = []
    	# (sender, recipients, object, source_type,  notification_type, values , actions ) 
		Notification.send_generic_notification(sender, receiver, document, :system, notification_type, values, actions)
	end
end