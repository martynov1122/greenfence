object @product

attributes :id, :name 
node(:facility) { |obj| Facility.find_by_id(params[:facility_id]) }
