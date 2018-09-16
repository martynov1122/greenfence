collection @search_results
	attributes  :class_name => :class,  :primary_key  => :id

node :filter_type do |n|
	if n.class_name == "Auditor"
		"Auditor"
	else
		n.class_name.constantize.base_class.name
	end
end

node(:followed_by_current_user) { |n| current_user.following?( n.result ) if n.result.is_a? User or n.result.is_a? Operation or n.result.is_a? Service or n.result.is_a? Product or n.result.is_a? Document  }
node(:connected_status_with_current_user) { |n| current_user.connected_status( n.result ) if n.result.is_a? User }
node(:admin_id) do |obj|
  if obj.result.is_a? User
    obj.result.id
  elsif obj.result.is_a? Operation
    obj.result.company.admin.first.id
  elsif obj.result.is_a? Service
    obj.result.operation.company.admin.first.id
  elsif obj.result.is_a? Document
    obj.result.documentable_owner.id
  end
end

node(:name) { |n| n.stored(:name).first if n.stored(:name) }
node(:verified) { |n| n.stored(:verified) if n.stored(:verified) }
node(:authenticated) { |n| n.stored(:authenticated) if n.stored(:authenticated) }
node(:document_name) { |n| n.stored(:document_name).first if n.stored(:document_name) }
node(:accreditations) { |n| n.stored(:accreditations) if n.stored(:accreditations) }
node(:scheme_types) { |n| n.stored(:scheme_types) if n.stored(:scheme_types) }

node(:profile) { |p| JSON.parse(p.stored(:profile)) unless p.stored(:profile).nil?}

node(:company) { |c|
   c.stored(:company)
   JSON.parse(c.stored(:company).first) unless c.stored(:company).nil?
}

node(:parent) { |c|
   c.stored(:parent)
   JSON.parse(c.stored(:parent).first) unless c.stored(:parent).nil?
}

node(:featured) { |f| f.stored(:featured) if f }
node(:searchable_fields) { |f|
  JSON.parse( f.stored(:searchable_fields).first ) unless f.stored(:searchable_fields).nil?
}

node(:user_results) {@user_results if @user_results}
node(:company_results) {@company_results if @company_results}
node(:operation_results) {@operation_results if @operation_results}
node(:service_results) {@service_results if @service_results}
node(:document_results) {@document_results if @document_results}
node(:auditor_results) {@auditor_results if @auditor_results}

node(:total_pages) {@total_pages}
node(:next_page) {@next_page}
node(:previous_page) {@previous_page}
node(:current_page) {@current_page}
node(:total_count) {@total_count}
