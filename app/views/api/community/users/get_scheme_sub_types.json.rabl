collection @scheme_sub_types
	attributes :id, :name, :scheme_type_id

node(:scheme_type) { |obj| obj.scheme_type.name }