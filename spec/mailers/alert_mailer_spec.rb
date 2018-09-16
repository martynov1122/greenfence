# require 'spec_helper'

# describe AlertMailer do
#   describe 'alert_notification_email' do
#     let(:user) { stub_model(User, {
#       name: "John Smith",
#       email: "john.smith@example.com"
#     } ) }

#     let(:mail) { AlertMailer.alert_notification_email(user, alert) }

#     it 'renders the subject' do
#       expect(mail.subject).to eql("Alert: #{alert.human_name}")
#     end

#     it 'renders the receiver email' do
#       expect(mail.to).to eql([user.email])
#     end

#     it 'renders the sender email' do
#       expect(mail.from).to eql(["notifications@example.com"])
#     end

#     it 'assigns @alert' do
#       expect(mail.body.encoded).to match(alert.human_name)
#     end

#     it 'prints the message' do
#       expect(mail.body.encoded).to match(alert.message)
#     end

    
#   end


# end
