attributes\
  :gfsi_state_description,
  :gfsi_status,
  :id,
  :full_address,
  :latitude_degrees,
  :longitude_degrees,
  :manager_email,
  :manager_phone_number,
  :manager_full_name,
  :name,
  :type,
  :restricted
  
node :facility_manager_email do |f|
  f.facility_manager.email if f.facility_manager.present?
end

node :facility_manager_name do |f|
  f.facility_manager.name if f.facility_manager.present?
end

node :mobile_number do |f|
  f.facility_manager.mobile_number if f.facility_manager.present?
end

node :url do |f|
  url_for([current_namespace, f])
end

node :unread do |f|
  f.is_a?(Facility) && f.non_compliant? && f.non_compliance_unread?(current_user)
end

node :facility_manager1_email do |f|
  f.facility_manager1.email if f.facility_manager1.present?
end

node :facility_manager1_name do |f|
  f.facility_manager1.name if f.facility_manager1.present?
end

node :facility_manager1_mobile_number do |f|
  f.facility_manager1.mobile_number if f.facility_manager1.present?
end