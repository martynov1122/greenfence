class SendTextJob < Struct.new(:phone_number, :message)
  def perform
    Robocall.send_text(to: phone_number, text: message)
  end
end
