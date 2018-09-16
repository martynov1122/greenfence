node(:is_authenticated) { @auditor_authentications.length > 0 ? true : false if @auditor_authentications}

child @auditor_authentications => "auditor_authentications" do
	attributes :id
		node(:auditor) {|obj| obj.auditor}

		node :authenticating_auditor do |obj| 
			{ id: obj.authenticating_auditor.id, name:  obj.authenticating_auditor.name, image_url: obj.authenticating_auditor.user_profile.image.thumb.url, featured: obj.authenticating_auditor.featured } if obj
		end

		node(:scheme) {|obj| obj.scheme if obj}

		node(:document) {|obj| obj.document if obj}

		node(:authentication_expiration_date) {|obj| obj.document.document_authentication_requests.last.authentication_expiration_date.strftime("%Y-%m-%d") if obj && obj.document}
end