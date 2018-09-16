class SendMailToFacilityManagerJob < Struct.new(:task)
  def perform
  	manager = task.facility.facility_manager1
    AlertMailer.alert_task_trigger_execution_email(manager,task).deliver
  end
end