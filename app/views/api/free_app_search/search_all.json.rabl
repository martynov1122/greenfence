object false

child @search_results => "results" do |c|
  attributes  :class_name => :class,  :primary_key  => :id 

  node(:type) {|n| n.class_name.constantize.base_class.name}
  node(:name) {|n| n.stored(:name).first}
  node do |n| 
   {n.class_name.constantize.base_class.name => "true"}
  end

  node("profile") { |p|  
    JSON.parse(p.stored(:profile))
  }
  node("company") {|c|
   c.stored(:company) 
   JSON.parse(c.stored(:company).first) unless c.stored(:company).nil?
  }
end

node(:total_pages) {@total_pages}
node(:next_page) {@next_page}
node(:previous_page) {@previous_page}
node(:current_page) {@current_page}