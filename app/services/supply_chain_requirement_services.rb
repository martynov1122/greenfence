class SupplyChainRequirementServices
  class << self
    def create_supply_chain_requirements requirements, supply_chains, filled_by, rule, sc_products, custom_message
      scr_ids = []
      requirements.each do |req|
        supply_chains.each do |sc|
          sc_req = SupplyChainRequirement.create({buyer_demanding_document_definition_id: req, supply_chain_id: sc.id, buyer: sc.buyable, supplier: sc.sellable,filled_by:filled_by,filled_on:Time.zone.now}.merge!(rule))
          sc_req.products << sc_products
          scr_ids.push(sc_req.id)
        end
      end
      SupplyChainRequirementServices.associate_document_to_assigned_supply_chain_requirement(scr_ids, custom_message)
      scr_ids
    end

    def associate_document_to_assigned_supply_chain_requirement supply_chain_requirement_ids, custom_message
      arr = []
      supply_chain_requirements = SupplyChainRequirement.where(id: supply_chain_requirement_ids, supplier_document_id: nil, supplier_providing_document_definition_id: nil)
      if supply_chain_requirements.length > 0
        supply_chain_requirements.each do |sc_req|
          merged_json = {}
          # sc_req = SupplyChainRequirement.find_by_id(scr_id)
          supplier_document = sc_req.supplier.documents.find_by_document_definition_id(sc_req.buyer_demanding_document_definition_id)
          notification_type = nil

          if !supplier_document.nil?
            if is_authenticated(sc_req.authenticated_by, supplier_document)
              merged_json[:action_type] = "1"
              # merged_json[:comment] = "Requirement is associated with document successfully."
              merged_json[:comment] = "Requirement fulfilled."
              notification_type = "requirement_fulfilled"
            else
              merged_json[:action_type] = "2"
              merged_json[:comment] = "Requirement fulfilled but need document authentication."
              notification_type = "requirement_fulfilled_need_document_authentication"
              # merged_json[:comment] = "Requirement is associated with document successfully. However, document is supposed to be authenticated by "+authentication_by(sc_req.authenticated_by)
            end


            sc_req.update_attributes(supplier_document_id: supplier_document.id, supplier_providing_document_definition_id: supplier_document.document_definition_id)
            sc_req.set_requirement_compliance! supplier_document

          else
            merged_json[:action_type] = "3"
            merged_json[:comment] = "Requirement need fulfillement."
            notification_type = "requirement_need_fulfillment"
            # merged_json[:requirement_name] = sc_req.buyer_demanding_document_definition.document_type
            # merged_json[:action] = "/community/#/company_documents"
          end
          merged_json[:requirement_name] = sc_req.buyer_demanding_document_definition.document_type
          merged_json[:action] = "#/requirement/#{sc_req.id}"
          sc_req.send_document_association_notification(sc_req.supplier, sc_req.buyer, notification_type)
          arr.push(merged_json)
        end
        send_supply_chain_requirement_assignment_mail(supply_chain_requirement_ids,custom_message, arr)
      end
    end

    def is_authenticated authenticated_by, document
      authenticated = false
      case authenticated_by
      # for third party authentication
      when 1
        authenticated = document.is_authenticated_third_party == true
      # for second party authentication
      when 2
        authenticated = (document.is_authenticated_second_party == true || document.is_authenticated_third_party == true)
      # for first party authentication
      when 3
        authenticated = (document.is_authenticated_second_party == true || document.is_authenticated_third_party == true || document.is_authenticated_first_party == true)
      # case when authentication is not required
      else
        authenticated = true
      end

      authenticated
    end

    def authentication_by authenticated_by
      case authenticated_by
      when 3
        'First Party'
      when 2
        'Second Party'
      when 1
        'Third Party'
      else
        'Not required'
      end
    end

    def send_supply_chain_requirement_assignment_mail supply_chain_requirement_ids,custom_message, arr
      supply_chain_requirement_objects = SupplyChainRequirement.where(id: supply_chain_requirement_ids)
      supply_chain_objects = SupplyChain.where(id: supply_chain_requirement_objects.map(&:supply_chain_id))
      # supply_chain_objects = SupplyChain.where(id: supply_chains)
    	supply_chain_objects.each do |sc|
        supplier = sc.sellable
  	    buyer = sc.buyable
        requirements = supply_chain_requirement_objects.map(&:buyer_demanding_document_definition)
  	    # requirements = DocumentDefinition.find_all_by_id(requirements)
  	    AlertMailer.delay.supply_chain_requirement_assignment_mail(supplier, buyer, requirements, sc,custom_message, arr)
      end
    end

    # handle_asynchronously :send_supply_chain_requirement_assignment_mail
    handle_asynchronously :associate_document_to_assigned_supply_chain_requirement
  end
end