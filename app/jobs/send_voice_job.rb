class SendVoiceJob < Struct.new(:phone_number, :message)
  def perform
    Robocall.send_robocall(to: phone_number, text: message)
  end
end
