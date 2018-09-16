object false


node("Region") do
  @regions.map {|r|
    {value: r.code, display: r.name}
  }
end

node("Compliance") do
  compliance_filter_options
end
