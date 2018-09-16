class Admin::RegistrationsController < Devise::RegistrationsController
  layout 'new_user_sign_up'
  skip_before_filter :require_no_authentication
  before_filter :resource_name
  before_filter :get_progress_step
  before_filter :get_user, only: [:personal]
  before_filter :get_company, only: [:site]

  def resource_name
  end

  def appinfo
    @apps = App.all
  end

  def update_appinfo  
     @app_id = 0
    if params[:commit] == "Sign up For free Edition"
      @app_id = 0
      redirect_to "/community/signup" and return
    else
      if params[:commit] == "Sign up For Pro Edition"
      @app_id =1
      else
       @app_id =2 
      end
    end
   # @app_id = params[:select_app]
    # @app_name = App.find_by_id(@app_id).name
    redirect_to admin_sign_up_personal_path(app_id:@app_id)
  end

  def personal
    @user = User.new(params[:user])
  end

  def update_personal
   
    @user = User.new(params[:user])
    if @user.first_name.blank? || @user.last_name.blank?
      redirect_to :back, flash: { error: "First name & last name can't be blank." }
    else
      if @user.valid?
          @user = AccountServices.update(current_user, params[:user])
          redirect_to admin_sign_up_site_path(producer:@user.id, app_id:params[:app_id])
    else
      render 'personal'
      end
    end
  end

  def site
    puts @user
  end

  def update_site
    @company = Producer.new(params[:company])
    # @company = Company.new(params[:company])
    if @company.name.blank?
      redirect_to :back, flash: { error: "Company name can't be blank." }
    else  
      if @company.valid?
        @company.save

        user = User.find_by_id(params[:producer])
        user.update_attributes(company_id:@company.id)
        user.add_role("producer_admin",@company)
       # user.invite!(user)
      # @company = CompanyServices.update(@company, current_user, params[:company])

    # respond_with([current_namespace, instance])
        @token = user.new_authentication_token!(device_type)
    	   redirect_to polymorphic_path(dashboard_path(user),authentication_token:@token.value, app_id:params[:app_id])
        # redirect_to admin_sign_up_facilitycount_path(producer:user.id, app_id:params[:app_id])
    else
      redirect_to :back, flash: { error: "Company Name can't be duplicate." }
    # render 'site'
    end
    end
  end

  def facilitycount    
  end

  def update_facilitycount
    # user = User.find_by_id(params[:producer])
    # @token = user.new_authentication_token!(device_type)
    #  redirect_to polymorphic_path(dashboard_path(user),authentication_token:@token.value, count:params[:text])
  end

  def inviteinfo
  end

  def update_inviteinfo
      redirect_to admin_sign_up_payment_path
  end

  def payment
  end

  def update_payment
      redirect_to admin_sign_up_payment_path
  end
  
  def get_user
    @user = current_user
  end

  def get_company
    @company = Company.new
  end
  
  def get_progress_step
    @progress_step = case params[:action]
    when 'appinfo', 'update_appinfo'
      1
    when 'personal', 'update_personal'
      2
    when 'site','update_site'
      3
    # when 'facilitycount','facilitycount'
    #   4
    end
  end
end

