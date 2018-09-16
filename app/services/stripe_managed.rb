 class StripeManaged < Struct.new(:user)
 	COUNTRIES = %w(US CA AU UK IE)
 	
 	  def manage_account!(params, ip)
      result = {:updated => true}
    	country = params[:country] if country.in?(COUNTRIES)
      tos_acceptance = { ip: ip,date: Time.zone.now.to_i }  if params[:tos] 
      if !account_exist?
        params[:legal_entity] ||= {}
        params[:legal_entity].merge!(:type => 'individual') 
      end
      bank_account = params[:bank_account] if params[:bank_account].present? 
		  begin
        if !account_exist?
          @account = Stripe::Account.create(managed: true,country: country,email: user.email,tos_acceptance:tos_acceptance ,legal_entity: params[:legal_entity],bank_account:bank_account)
          account_info = UserAccountInfo.create(user_id:user.id,stripe_user_id:@account.id,secret_key: @account.keys.secret,publishable_key: @account.keys.publishable,account_status: account_status)
        else
          update_account!(params,tos_acceptance)
          account_info = user.user_account_info
          result[:updated] = account_info.update_attributes(account_status: account_status)
        end
	    rescue Stripe::InvalidRequestError => e
        puts "-----------------------------"
        err = e.json_body[:error]
        puts err
        result = {:message => 'Not able to change payment setting.',:updated => false}
      ensure
        if !result[:updated] && result[:message].blank?
          result[:message] = I18n.t('account_info_not_updated')
        end
	    end
	    result
    end

  def update_account!( params,tos_acceptance )
    if params
      new_legal_entity = {}
      if params[:legal_entity].present?
         params[:legal_entity].each do |key,value|
          if [:dob ].include? key.to_sym
            value.entries.each do |akey, avalue|
              next if avalue.blank?
              new_legal_entity[key] ||= {}
              new_legal_entity[key][akey] = avalue
            end
            account.legal_entity.send(key+"=",new_legal_entity[key])
          else
            next if value.blank?
            new_legal_entity[key] = value
            account.legal_entity.send(key+"=",new_legal_entity[key])
          end
        end
      end
      if tos_acceptance.present?
        account.tos_acceptance = tos_acceptance
      end
      if params[:bank_account].present?
        account.bank_account = params[:bank_account]
      end
      account.save  
    end
  end

  def legal_entity
    account.legal_entity
  end


  def needs?( field )
    user.user_account_info.account_status['fields_needed']
  end

  protected

  def account_exist?
     user.user_account_info && user.user_account_info.stripe_user_id
  end

  def account_status
    {
      details_submitted: account.details_submitted,
      charges_enabled: account.charges_enabled,
      transfers_enabled: account.transfers_enabled,
      fields_needed: account.verification.fields_needed,
      due_by: account.verification.due_by
    }
  end

  def account
    @account ||= Stripe::Account.retrieve( user.user_account_info.stripe_user_id )
  end


 end