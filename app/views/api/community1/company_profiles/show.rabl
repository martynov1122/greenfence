object @company
  attributes :logo
child @company_profile do
  attributes :id,:summary, :completion, :has_company, :has_address, :has_contact, :contact_percentage, :website, :phone, :email
end

child @address do
  attributes :id, :administrative_area, :country, :locality, :postal_code, :street1,:street2  
end
