class SendTextToCompanyManagerJob < Struct.new(:task)
  def perform
  	message = "Task trigger executed."
  	phone_number = task.facility.company.producer_admin.try(:mobile_number)
    Robocall.send_text(to: phone_number, text: message)
  end
end