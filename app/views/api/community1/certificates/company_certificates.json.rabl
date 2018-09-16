collection @certificates => :company_certificates

attributes :facility_id, :certificate_template_id, :certificate_name, :id, :certificate_number, :expiration_date

node(:cert_image) { |obj| obj.document.thumb.url }

node(:cert_cetegory) { |obj| obj.certificate_template.type_of_certificate_category }