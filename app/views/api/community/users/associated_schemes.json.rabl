collection @auditors_schemes
	attributes :id, :user_id, :scheme_type_id

node(:scheme_type) { |obj| obj.scheme_type.try(:name) }