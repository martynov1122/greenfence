object false

node("Food Category") do
  @categories.map {|c|
    {value: c.id, display: c.name}
  }
end

node "Company" do
  @producers.map {|p|
    {value: p.id, display: p.name}
  }
end
