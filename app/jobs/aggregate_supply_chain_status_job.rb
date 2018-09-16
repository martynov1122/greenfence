class AggregateSupplyChainStatusJob < Struct.new(:supply_chain_id)
	def perform
		supply_chain = SupplyChain.find_by_id(supply_chain_id)
		supply_chain_requirements = supply_chain.supply_chain_requirements.includes(:buyer_demanding_document_definition)
		list = supply_chain_requirements.map(&:compliant_status).compact.uniq
		compliant_status = set_status(list)
		# It is unique list of compliant_description from all supply chain requirements
		description_hash = set_compliant_description(supply_chain, supply_chain_requirements, compliant_status)
		supply_chain.update_attributes(compliant_status: compliant_status, compliant_description: description_hash)
		last_updated = supply_chain.updated_at
		set_supply_chain_status(supply_chain, last_updated)
	end	

	def set_supply_chain_status supply_chain, last_updated
		status = nil
		if supply_chain.buyable.upstreams != [] 
			supply_chain.buyable.upstreams.each do |buyer_chain|
				if buyer_chain.updated_at < last_updated
					buyer_chain.sellable.downstreams.each do |supplier_chain|
						list = [status, supplier_chain.downstream_compliance_status,supplier_chain.compliant_status].compact
						status = set_status(list)
					end
					buyer_chain.downstream_compliance_status = status
					buyer_chain.save
					set_supply_chain_status(buyer_chain, last_updated)
				else
					return
				end
			end 
		end
	end

	def set_compliant_description supply_chain, supply_chain_requirements, compliant_status
		requirement_compliant_description_hash = Hash.new
		supply_chain_requirements.each do |scr|
			if requirement_compliant_description_hash[scr.compliant_description]
				requirement_compliant_description_hash[scr.compliant_description].push(scr.buyer_demanding_document_definition.document_type) unless requirement_compliant_description_hash[scr.compliant_description].include?(scr.buyer_demanding_document_definition.document_type)
			else
				requirement_compliant_description_hash[scr.compliant_description] = [scr.buyer_demanding_document_definition.document_type]
			end
		end		
		# This is done to remove requirement_fulfillment when compliant_status is not green
		if compliant_status != 'compliant'
			requirement_compliant_description_hash.delete('requirement_fulfilled')
		end
		return requirement_compliant_description_hash
	end

	def set_status status_list
		return 'non_compliant' if status_list.include?('non_compliant')
		return 'warning' if status_list.include?('warning')
		return 'compliant' if status_list != []
	end
end