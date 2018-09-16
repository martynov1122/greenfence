collection @company_facilities => :company_facilities

attributes :id, :name, :description, :image, :certificates_count

child(:certificates) {attributes :certificate_name}