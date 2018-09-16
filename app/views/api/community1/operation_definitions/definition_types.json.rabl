collection @definition_types
  attributes :id
  node(:text) { |obj| obj.operation_type }