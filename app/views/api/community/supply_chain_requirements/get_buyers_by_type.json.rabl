object @buyers
    attributes :id, :name

    node(:supply_chain_requirements_count) do |obj|
        buyable_type = if obj.type
            "Company"
        else
            "Operation"
        end
        supply_chain_req_count = SupplyChain.find_by_buyable_id_and_buyable_type_and_sellable_id_and_sellable_type(obj.id, buyable_type, @supplier_id, @supplier_type).supply_chain_requirements_count

        supply_chain_req_count
    end

    node(:type) do |obj|
        type = if obj.type
            "Company"
        else
            "Operation"
        end
    end

    child :supply_chain_supplier_requirements => :requirements do
        attributes :id

        node (:name) { |obj| obj.buyer_demanding_document_definition.document_type }
    end