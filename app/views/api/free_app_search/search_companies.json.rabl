object false

node("companies") do
@companies.map {|c| 
  {label: c.name , id: c.id}
 }
end