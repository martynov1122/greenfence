class Api::CompaniesController < Api::BaseController
  model_class Company

  def comment
    CommentServices.create(current_user, instance, params[:text])
    head :ok
  end

  def filters
    load_regions
  end

  def names
    @all_companies = Company.all
  end

  def index
    @companies = Company.all
  end

  def employees
    if params[:id].present?
      c = Company.find_by_id(params[:id])
      @employees = paginate(c.users) if c      
    else
      @employees = paginate(current_user.company.users) if current_user.company
    end
    @employees
  end

  def invite
    company = current_user.company 
    if company[:name] == "Walmart"
       if params[:company_id]
        company.suppliers << Company.find(params[:company_id])
        render json: {}, status: 200
      else
        invited_user = InvitationServices.invite(current_user, company, :producer_admin, nil, params[:user])
        if invited_user.errors.empty?
          company.suppliers << invited_user.company
          render json: {}, status: 200
        else
          errors = invited_user.errors.messages.select{ |k,v| k == :email || k == :new_company_name }
          render status: 400, text: errors.to_json
        end
      end
    else    
      if params[:company_id]
          if params[:supply_chain_type]=='Customer' && company.buyers.find_by_id(params[:company_id])==nil
            company.buyers << Company.find(params[:company_id])         
          elsif company.suppliers.find_by_id(params[:company_id])==nil
            company.suppliers << Company.find_by_id(params[:company_id]) 
          end  
        
        render json: {}, status: 200
      else
        invited_user = InvitationServices.invite(current_user, company, :producer_admin, nil, params[:user])
        if invited_user.errors.empty?
          if params[:supply_chain_type]=='Customer'
            company.buyers << invited_user.company         
          else
            company.suppliers << invited_user.company 
          end  
         render json: {}, status: 200     
        else
          errors = invited_user.errors.messages.select{ |k,v| k == :email || k == :new_company_name }
          render status: 400, text: errors.to_json
        end
      end
    end
  end

  ## DOCUMENTATION ###

  # swagger_controller :companies, "Companies"

  # swagger_model :user do
  #   property :name, :string, :required
  #   property :email, :string, :required
  # end

  # swagger_api :index do
  #   summary "Fetches companies in the user's downchain"
  #   response :unauthorized
  # end

  # swagger_api :show do
  #   summary "Fetches details about a specific company"
  #   param :path, :id, :integer, :required, "Company ID"
  #   response :unauthorized
  #   response :forbidden
  # end

  # swagger_api :comment do
  #   summary "Submits comment on a company"
  #   param :path, :id, :integer, :required, "Company ID"
  #   param :form, :text, :string, :required, "Text of comment"
  #   response :unauthorized
  #   response :forbidden
  # end

  # swagger_api :filters do
  #   summary "Fetches the filters that can be applied to the Companies index"
  #   response :unauthorized
  # end

  # swagger_api :invite do
  #   summary "Sends invitation for a company to be added to the system"
  #   notes "Requires one of the following parameters."
  #   param :form, :company_id, :integer, :optional, "ID of company to add to downchain"
  #   param :form, :user, "User", :optional, "Email and company name of user being invited"
  #   response :unauthorized
  #   response :forbidden
  # end
end
