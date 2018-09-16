#object false

#node :total_pages do
#  @companies.total_pages
#end

#node :current_page do
#  @companies.current_page
#end

#child @companies => "companies" do
#  extends "api/shared/collections/company"

#  child :address do
#    attributes :latitude_degrees, :longitude_degrees
#  end

#  node(:subscription) { |obj| obj.subscription_options(current_user) }
#end

collection @companies
  extends "api/shared/collections/company"
