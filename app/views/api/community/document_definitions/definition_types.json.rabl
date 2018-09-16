collection @definition_types
  attributes :id 
  node(:text) { |obj| obj.document_type }