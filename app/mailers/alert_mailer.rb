class AlertMailer < ActionMailer::Base
  layout 'email'

  default from: "notifications@example.com"

  def alert_notification_email(user, alert)
    @user = user
    @alert = alert
    mail(to: @user.email, subject: "Alert: #{@alert.human_name}")
  end

  def alert_requirement_email(requirements,facility)
    @requirements = requirements
    @facility = facility
    subject = @requirements.map(&:name).join(', ')
    if @facility.manager.present?
      mail(to:@facility.manager.email, subject:"Requirements: #{subject} required.")
    end
  end

  def alert_configration_email facility,token,path,app_id
    @facility = facility
    @path = path+"?authentication_token=#{token}&app_id=#{app_id}"
    if @facility.facility_manager1.present?
      mail(to:@facility.facility_manager1.email, subject:"Configure Facility Detail!!")
    end
  end

  def alert_free_app_coworker_invite email_address, from_user
    @from_user_name = from_user.name
    mail(to:email_address, subject:"You are invited to Greenfence!!")
  end

  def new_message_received_email to_user, from_user, message
    @from_user_name = from_user.name
    @message = message
    mail(to:to_user.email, subject:"You have received message at Greenfence!!")
  end

  def alert_verification_mail_to_certification_body cb_user, certificate
    @new_certificate = certificate
    cb_user_email = cb_user.email
    @cb_user_name = cb_user.name
    mail(to:cb_user_email, subject:"Notification for new certificate!!")
  end

  def alert_certificate_approved_email freeapp_admin, certificate
    @new_certificate = certificate
    freeapp_admin_email = freeapp_admin.email
    @freeapp_admin_name = freeapp_admin.name
    mail(to:freeapp_admin_email, subject:"Your certificate is approved. Congratulations !!")
  end

  def alert_certificate_rejected_email freeapp_admin, certificate
    @new_certificate = certificate
    freeapp_admin_email = freeapp_admin.email
    @freeapp_admin_name = freeapp_admin.name
    mail(to:freeapp_admin_email, subject:"Your certificate is rejected. Sorry !!")
  end

  def alert_survey_assignment_email(survey_assignment)
    @facility = survey_assignment.facility
    @survey = survey_assignment.survey_format
    @survey_assignment = survey_assignment
    subject = survey_assignment.survey_format
    if @facility.manager.present?
      f_manager = @facility.facility_manager
      if f_manager.nil?
        f_manager = @facility.facility_manager1
      end

      mail(to:f_manager.email, subject:"Survey: #{subject.name} assigned.")
    end
  end

  def alert_email_for_document_upload doc_auth_req
    @auditor = User.find_by_id(doc_auth_req.auditor_id)
    @document = Document.find_by_id(doc_auth_req.document_id)
    @uploaded_by = doc_auth_req.get_document_uploading_user
    @accept_request_url = '/api/v1.0/community/document_authentication_request/accept_decline_request?id='+doc_auth_req.id.to_s+"&type=Accepted"
    @decline_request_url = '/api/v1.0/community/document_authentication_request/accept_decline_request?id='+doc_auth_req.id.to_s+"&type=Declined"
    User.send_messages([@auditor], "#{@document.documentable.name} has requested authentication of document #{@document.document_name}.", @document)
    mail(to:@auditor.email, subject: "#{@document.documentable.name} has requested authentication of document #{@document.document_name}.")
  end

  def alert_make_document_accept_email_to_doc_owner doc_auth_req
    @auditor = User.find_by_id(doc_auth_req.auditor_id)
    @document = Document.find_by_id(doc_auth_req.document_id)
    @uploaded_by = doc_auth_req.get_document_uploading_user
    @document_created_by_user = User.find_by_id(@document.created_by)
    User.send_messages([@document_created_by_user,@uploaded_by], "#{@auditor.name} has accepted #{@document.document_name} document.", @document)
    mail(to:[@uploaded_by.email, @document_created_by_user.email], subject: "#{@auditor.name} has accepted #{@document.document_name} document.")
  end

  def alert_make_document_decline_email_to_doc_owner doc_auth_req
    @auditor = User.find_by_id(doc_auth_req.auditor_id)
    @document = Document.find_by_id(doc_auth_req.document_id)
    @uploaded_by = doc_auth_req.get_document_uploading_user
    @document_created_by_user = User.find_by_id(@document.created_by)
    User.send_messages([@document_created_by_user,@uploaded_by], "#{@auditor.name} has declined #{@document.document_name} document.", @document)
    mail(to:[@uploaded_by.email, @document_created_by_user.email], subject: "#{@auditor.name} has declined #{@document.document_name} document.")
  end

  def alert_make_quote_email_to_doc_owner doc_auth_req
    @auditor = User.find_by_id(doc_auth_req.auditor_id)
    @document = Document.find_by_id(doc_auth_req.document_id)
    @uploaded_by = doc_auth_req.get_document_uploading_user
    @document_created_by_user = User.find_by_id(@document.created_by)
    User.send_messages([@document_created_by_user,@uploaded_by], "#{@auditor.name} has provided a quote for #{@document.document_name} document.", @document)
    mail(to: [@uploaded_by.email, @document_created_by_user.email], subject: "#{@auditor.name} has provided a quote for #{@document.document_name} document.")
  end

  def alert_make_payment_to_auditor doc_auth_req
    @auditor = User.find_by_id(doc_auth_req.auditor_id)
    @document = Document.find_by_id(doc_auth_req.document_id)
    @uploaded_by = doc_auth_req.get_document_uploading_user
    User.send_messages([@auditor], "#{@uploaded_by.name} has made payment for #{@document.document_name} document.", @document)
    mail(to:@auditor.email, subject: "#{@uploaded_by.name} has made payment for #{@document.document_name} document.")
  end

  def alert_document_approved_to_doc_owner doc_auth_req
    @auditor = User.find_by_id(doc_auth_req.auditor_id)
    @document = Document.find_by_id(doc_auth_req.document_id)
    @uploaded_by = doc_auth_req.get_document_uploading_user
    @document_created_by_user = User.find_by_id(@document.created_by)
    User.send_messages([@document_created_by_user,@uploaded_by], "#{@auditor.name} has approved #{@document.document_name} document.", @document)
    mail(to:[@uploaded_by.email, @document_created_by_user.email], subject: "#{@auditor.name} has approved #{@document.document_name} document.")
  end

  def alert_document_rejected_to_doc_owner doc_auth_req
    @auditor = User.find_by_id(doc_auth_req.auditor_id)
    @document = Document.find_by_id(doc_auth_req.document_id)
    @uploaded_by = doc_auth_req.get_document_uploading_user
    @document_created_by_user = User.find_by_id(@document.created_by)
    User.send_messages([@document_created_by_user,@uploaded_by],"#{@auditor.name} has rejected #{@document.document_name} document.",@document)
    mail(to: [@uploaded_by.email, @document_created_by_user.email], subject: "#{@auditor.name} has rejected #{@document.document_name} document.")
  end

  def supply_chain_requirement_assignment_mail supplier, buyer, requirements, supply_chain_obj,custom_message, arr
    @user = nil
    if supplier.is_a?(Operation)
      @user = supplier.company.admin.first
    else
      @user = supplier.admin.first
    end
    @message = custom_message
    @supply_chain_obj = supply_chain_obj
    @requirement = @supply_chain_obj.supply_chain_requirements.try(:last)
    @buyer = buyer
    @supplier = supplier
    @requirements = requirements
    @arr = arr
    User.send_messages([@user],"Requirement of type" + "  " + @requirements.map(&:document_type).join(",")+ "  is assigned.",nil)
    mail(to:@user.email, subject:"Requirement of type" + "  " + @requirements.map(&:document_type).join(",")+" is assigned.")
  end

  def license_expire_soon_mail_job(license)
    @facility = license.facility
    @payment = Payment.find(license.payment_id)
    @app = license.app
    @valid_to = license.valid_to
    if @facility.manager.present?
      f_manager = @facility.facility_manager
      if f_manager.nil?
        f_manager = @facility.facility_manager1
      end

      mail(to:f_manager.email, subject:"Subscription for #{@app.name} of #{@facility.name} is expiring soon.")
    end
  end

  def alert_subscription_email(user, task)
    @user = user
    mail(to: @user.email, subject: "Alert subscription for task #{task}")
  end

  def alert_task_trigger_execution_email(user,task)
    @user = user
    @task = task
    mail(to: @user.try(:email), subject: "Alert Task trigger executed")
  end

  def welcome_email_to_user(user,current_user)
    @user = user
    @current_user=current_user
    User.send_messages([@user],"Welcome to Greenfence",nil)
    mail=mail(to: @user.try(:email), subject: "Welcome to Greenfence")
    mail.deliver
  end

  def welcome_email_to_company(user,current_user)
    @user =user
    @current_user=current_user
    User.send_messages([@user],"Welcome to Greenfence",nil)
    mail=mail(to: @user.try(:email), subject: "Welcome to Greenfence")
    mail.deliver
  end


  def supply_chain_invitation_email_to_user(user,supply_chain_invitation)
    @user = user
    @inviting_entity = supply_chain_invitation.inviting_entity
    @accept_url = '/api/v1.0/community/supply_chain_invitations/accept_reject?accept_invitation='+supply_chain_invitation.uuid
    @reject_url = '/api/v1.0/community/supply_chain_invitations/accept_reject?reject_invitation='+supply_chain_invitation.uuid
    User.send_messages([@user],"You are invited to supply chain of #{@inviting_entity.name}.",nil)
    mail=mail(to: @user.try(:email), subject: "You are invited to supply chain of #{@inviting_entity.name}.")
    mail.deliver
  end

  def document_expired_mail document
    @document = document
    @user = [document.documentable] if document.documentable.is_a?(User)
    @user = document.documentable.admin if document.documentable.is_a?(Company)
    @user = document.documentable.company.admin if document.documentable.is_a?(Operation)
    if @user != []
      User.send_messages([@user],"#{document.document_name} is expired.",document)
      mail(to: @user.first.try(:email), subject: "#{document.document_name} is expired.")
    end
  end

  def document_soon_expired_alert document,user
    @user = user
    @document = document
    if @user
      User.send_messages([@user],"#{document.document_name} is expiring soon.",document)
      mail(to: @user.try(:email), subject: "#{document.document_name} is expiring soon.")
    end
  end

  def document_request_expired_mail document_request
    @doc_request = document_request
    @user = [document_request.document.documentable] if document_request.document.documentable.is_a?(User)
    @user = document_request.document.documentable.admin if document_request.document.documentable.is_a?(Company)
    if @user != []
      User.send_messages([@user.first],"#{document_request.document.document_name} is expired.",document_request.document)
      mail = mail(to: @user.first.try(:email), subject: "#{document_request.document.document_name} is expired.")
      mail.deliver
    end
  end

  def group_invitation_mail group_invitation
    @group = group_invitation.group
    @contact = group_invitation.contact
    @current_user = group_invitation.sender

    if @contact.email.present?
      mail = mail(to: @contact.email, subject: "#{@group.name} invitation")
    end
  end

  def alert_document_viewed document,user,time,notifier
    @user,@document,@time,@notifier = user,document,time,notifier
    User.send_messages([notifier],"#{user.name} has viewed #{document.document_name} at #{time}",nil)
    mail(to:notifier.email,subject:"#{document.document_name} viewed")
  end

end
