class FilledByCompliantStatusJob < Struct.new(:supply_chain_requirement_id)
	def perform
		requirement = SupplyChainRequirement.find_by_id(supply_chain_requirement_id)
		if requirement.supplier_providing_document_definition.blank? && (requirement.filled_by <= Time.zone.today)
			requirement.set_requirement_compliance!(requirement.supplier_document)
			requirement.send_requirement_not_fullfilled_in_time_notification
		end
	end
end