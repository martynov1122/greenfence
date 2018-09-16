object @certificate

attribute :access_level, :upload_time,:facility_id, :certificate_template_id, :certificate_name, :certification_body_id, :certificate_number, :scope, :product, :score, :audit_date, :issued_date, :expiration_date, :need_verification_from_cb, :verifying_user_id, :document, :auditor_name, :status

node(:auditor) { |obj| User.find_by_id(obj.verifying_user_id) }
node(:cert_body) { |obj| Company.find_by_id(obj.certification_body_id ) }
node(:facility) { |obj| Facility.find_by_id(obj.facility_id ) }
node(:original_source) { |obj| obj.document.url}
node :cert_image do 
	if(@certificate.document.detail != nil)
		@certificate.document.detail.url
	elsif(@certificate.document.thumb != nil)
		@certificate.document.thumb.url
	else
		@certificate.document.url
	end
end

child @certificate_comment_activity do
  extends "api/shared/collections/activity"
end

node(:current_user_image) {|obj|
  current_user.user_profile.image.thumb.url
}

node(:certificate_comment_count) { 
	count = @certificate_comment_activity.try(:activity_comments).try(:count) 
	count == nil ? 0 : count
}

node(:type_of_certificate_category) { |obj| obj.certificate_template.type_of_certificate_category}
node(:type_of_certificate_scheme) { |obj| obj.certificate_template.type_of_certificate_scheme }