object false
node(:compliant_count) do
  raw_collection.compliant.count
end

node(:non_compliant) do
  raw_collection.non_compliant.count
end

node(:warning) do
  raw_collection.warning.count
end
