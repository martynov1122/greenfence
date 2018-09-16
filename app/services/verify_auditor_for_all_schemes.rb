class VerifyAuditorForAllSchemes

  def self.verify_auditor(auditor_to_verify, verifying_auditor)
		SchemeType.all.each do |scheme_type|
			AuditorAuthentication.create(auditor_id: auditor_to_verify.id, scheme_id: scheme_type.id, authenticating_auditor_id: verifying_auditor.id)
			AuditorsScheme.create(user_id: auditor_to_verify.id, scheme_type_id: scheme_type.id)
		end
	end
end