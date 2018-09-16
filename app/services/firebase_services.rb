class FirebaseServices < Services
  class << self
    def create_firebase(recipients, activity_key=nil)
      base_uri = ENV['FIREBASE_RUI']

      firebase = Firebase::Client.new(base_uri)

      receiver_ids = recipients.collect(&:id)

      response = firebase.push("notifications", {:receiver_ids => receiver_ids, :activity_key => activity_key})
    end

    def import_contact(recipient, provider, status)
      base_uri = ENV['FIREBASE_RUI']

      firebase = Firebase::Client.new(base_uri)

      receiver_ids = [recipient.id]

      response = firebase.push("contacts", {:receiver_ids => receiver_ids, :provider => provider, :status => status})
    end
  end
end