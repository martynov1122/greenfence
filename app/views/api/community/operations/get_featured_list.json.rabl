object @featured
 attributes :id, :name

node (:products_count) { |obj| obj.products.count if obj.class.name == "Operation" }
node (:services_count) { |obj| obj.services.count if obj.class.name == "Operation" }
node (:documents_count) { |obj| obj.documents.public.count if obj.class.name == "Operation" }

node (:company) { |obj| obj.company.name if obj.class.name == "Service"}
node (:documentable) { |obj| obj.documentable.name if obj.class.name == "CompanyDocument" }

node (:profile_picture) { |obj|  obj.profile_picture if (obj.class.name == "Service" || obj.class.name == "CompanyDocument") }
node (:description) { |obj| obj.description }

node :filter_type do |obj|
  if obj
    if obj.class.superclass.name != "ActiveRecord::Base"
    	obj.class.superclass.name.pluralize.downcase
    else
  		obj.class.name.pluralize.downcase
  	end
  end
end

node (:featured_count) { @featured_count }