object @suppliers
    attributes :id, :name

    node(:supply_chain_requirements_count) do |obj|
        sellable_type = if obj.type
            "Company"
        else
            "Operation"
        end
        supply_chain_req_count = SupplyChain.find_by_sellable_id_and_sellable_type_and_buyable_id_and_buyable_type(obj.id, sellable_type, @buyer_id, @buyer_type).supply_chain_requirements_count

        supply_chain_req_count
    end

    node(:type) do |obj|
        type = if obj.type
            "Company"
        else
            "Operation"
        end
    end

    child :supply_chain_buyer_requirements => :requirements do
        attributes :id

        node (:name) { |obj| obj.buyer_demanding_document_definition.document_type }        
    end