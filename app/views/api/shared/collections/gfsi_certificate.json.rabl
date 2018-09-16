attributes\
  :audit_date,
  :certificate_url,
  :certification_body_auditor_name,
  :expiration_date,
  :level,
  :id,
  :issued_date,
  :name,
  :next_audit_date

node(:benchmarking_category_name) { |obj| obj.benchmarking_category.try(:name) }
node(:benchmarking_category_scope_of_recognition) { |obj| obj.benchmarking_category.try(:scope_of_recognition) }
node(:certification_body_name) { |obj| obj.certification_body.try(:name) }
node(:food_category_names) { |obj| obj.food_categories.map(&:name) }
node(:scheme_owner_name) { |obj| obj.scheme_owner.try(:name) }

node :actions do |obj|
  ["approve", "decline", "suspend", "reinstate", "withdraw"].select do |action|
    current_user.send("can_#{action}?", obj)
  end
end
