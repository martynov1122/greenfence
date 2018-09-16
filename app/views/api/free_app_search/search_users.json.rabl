object false

node("users") do
	@users.map {|u| 
  		{label: u.name , id: u.id}
 	}
end