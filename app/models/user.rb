# A user account in the system.
#
# USED:
#   * Rails UI

class User < ActiveRecord::Base
  include Authority::UserAbilities
  include Ibms::Addressable
  include Authority::Abilities

  acts_as_reader

  attr_accessor :role, :image_crop_x, :changed_fields

  attr_accessible \
    :last_notification_seen_at

  acts_as_followable
  acts_as_follower


  MIN_PHONE_NUMBER_LENGTH = 5

  def self.valid_languages
    {"English" => "en",
     "Español" => "es"}
  end

  FREEAPP_ROLES = %w(user)

  rolify
  # rolify after_add: :update_subscriptions
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :multiple_tokenable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :invitable,
         :confirmable,
         :registerable,
         :lockable,
         :password_expirable,
         :password_archivable

  attr_accessible\
    :authentication_token,
    :company_id,
    :name,
    :first_name,
    :last_name,
    :email,
    :mobile_number,
    :voice_number,
    :language_preference,
    :password,
    :password_confirmation,
    :photo,
    :photo_cache,
    :remember_me,
    :type,
    :invitation_message,
    :new_company_name,
    :time_zone,
    :general_alert_subscription,
    :warning_alert_subscription,
    :non_compliance_alert_subscription,
    :tags,
    :is_welcome_message_closed,
    :subscription_preferences_attributes,
    :connections_attributes,
    :user_profile_attributes,
    :address_attributes,
    :featured,
    :verified,
    :authenticated

  belongs_to :company, inverse_of: :users, counter_cache: true
  has_many :activities, -> {order 'activities.created_at DESC' } , through: :activities_viewers
  has_many :activities_viewers, as: :viewer

  has_many :folders, as: :folderable
  has_many :documents, as: :documentable
  caches_column :documents_count, count_of: :documents, inverse_of: :documentable

  has_many :tasks
  has_many :task_configurations

  has_many :subscription_preferences

  has_many :authentication_tokens
  has_one :user_profile

  has_many :in_messages, class_name: "Communication", as: :to, :dependent => :destroy
  has_many :out_messages, class_name: "Communication", foreign_key: :from_user, :dependent => :destroy
  has_many :users_custom_roles ,  :dependent => :destroy
  has_many :custom_roles, :through => :users_custom_roles

  # user connections like (website, facebook page, linkedin page etc)
  has_many :connections, as: :connectionable

  has_many :shared_records, -> {uniq}

  has_many :document_authentication_requests, foreign_key: "doc_owner_id"

  has_many :user_endorsements

  has_one :user_account_info
  # has_one :user_stripe_credential

  has_many :group_members,    foreign_key: :member_id, dependent: :destroy
  has_many :groups,           through: :group_members
  has_many :notifications,    foreign_key: :recipient_id
  has_many :sent_notifications,  class_name: "Notification",    foreign_key: :sender_id

  has_many :contacts

  # friendships
  has_many :friendships
  has_many :friends,
            :through => :friendships,
            :conditions => "status = 'accepted'"
  has_many :requested_friends,
            :through => :friendships,
            :source => :friend,
            :conditions => "status = 'requested'",
            :order => :created_at
  has_many :pending_friends,
            :through => :friendships,
            :source => :friend,
            :conditions => "status = 'pending'",
            :order => :created_at

  # For auditor type user.
  has_many :auditors_schemes, -> { includes :scheme_type }
  has_many :scheme_types, through: :auditors_schemes

  # USer verifications
  has_many :user_verifications

  # callbacks
  before_update :catch_changed_fields
  after_update :send_notification!

  def sharing_records
    SharedRecord.where(shareee_id: self.id)
  end

  def auditing_records
    audit_records = {}
    if type == "Auditor"
      records = SharedRecord.where(shareee_id: self.id).includes(:shareee, :sharable)
      audit_records = records.select {|s| (s.sharable_type == "Document") && (s.sharable.document_authentication_requests.size > 0)  && (s.sharable.document_authentication_requests.last.auditor_id == self.id ) &&  ( s.sharable.document_authentication_requests.last.request_status == "new_request"  || s.sharable.document_authentication_requests.last.request_status == "quote_provided"  || s.sharable.document_authentication_requests.last.request_status == "customer_accepted_and_made_payment" || s.sharable.document_authentication_requests.last.request_status == "authenticated" || s.sharable.document_authentication_requests.last.request_status == "rejected")  }
      audit_records
    end
    audit_records
  end

  accepts_nested_attributes_for :subscription_preferences
  accepts_nested_attributes_for :connections
  accepts_nested_attributes_for :user_profile
  accepts_nested_attributes_for :address

  scope :invited, -> { where(invitation_accepted_at: nil) }

  scope :featured, -> { where(featured: true) }

  scope :confirmed, ->{ where("confirmed_at IS NOT NULL") }

  scope :company_auditors, lambda { |company_id| where('type = ? AND company_id = ?','Auditor',company_id)  }

  scope :company_users, lambda { |company_id| where('company_id = ?',company_id)  }

  scope :document_followers, lambda { |followable| self.joins('INNER JOIN "follows" ON "users"."id" = "follows"."follower_id"').where('follows.followable_id = ? AND followable_type = ?',followable.id,'Document') }

  def verify_by_admin
    admin_user = User.find(1) # TODO : Change it to email once it is finalized : aswami
    self.user_verifications << UserVerification.new(verifying_user_id: admin_user.id)
  end

  def unverify
    self.user_verifications.destroy_all
  end

  def friend?(user)
    self.friends.include?(user)
  end

  def connected_status(user)
    friendship = Friendship.find_by_user_id_and_friend_id(self.id, user.id)
    if friendship
      friendship.status
    else
      "unconnected"
    end
  end

  def public_documents
    self.documents.where("access_level='public'")
  end

  def all_messages
    self.in_messages + self.out_messages
  end

  def merged_tags_endorsements current_app_user
    merged = {}
    merge_json(current_app_user) do |k, v|
      if v
        v[:users].each do |v_element|
          v_element.photo = v_element.user_profile.image
          v_element.name = v_element.first_name + " " + v_element.last_name
        end
      end
      merged[k] = v
    end
    merged
  end

  def message_threads
    result = Communication.where(thread_id: nil).where("from_user = ? or to_id = ?", self.id, self.id).to_a

    self.groups.each do |group|
      result << group.in_messages.where(thread_id: nil).where("from_user <> ?", self.id)
    end

    result.flatten.uniq
  end

  def in_messages_with_groups
    result = self.in_messages.to_a

    self.groups.each do |group|
      result << group.in_messages.where("from_user <> ?", self.id)
    end

    return result.flatten.sort_by(&:time_of_message).reverse!
  end

  def in_messages_with_group_threads
    result = []

    self.in_messages_with_groups.each do |message|
      if message.thread
        result << message.thread
      else
        result << message
      end
    end

    return result.uniq
  end

  def in_messages_count
    self.in_messages.where(is_read: false).count
  end

  def in_messages_from_sender(sender_id)
    in_messages = self.in_messages.where(from_user: sender_id).order("created_at desc")
    messages = []
    in_messages.each do |msg|
      message = msg.attributes.merge({from: msg.from.attributes.extract!("id", "first_name", "last_name").merge({"name" => msg.from.name, "photo_url" => msg.from.user_profile.image.url})})
      message["updated_at"] = msg.updated_at_in_words
      message["attachment"] = msg.attachment.url
      messages << message
    end
    messages
  end

  after_create :build_user_dependencies, :create_user_aws_resources
  before_create :fill_last_notification_seen_at
  around_update :share_company_aws_resources

  mount_uploader :photo, ProfilePictureUploader

  # not sure why this is not needed
  #validates :company_id, presence: true, if: lambda { |record| record.invitation_sent_at && !record.invitation_accepted_at }
  # validates :first_name, :last_name,  presence: true

  validates :language_preference, :inclusion => {:in => User.valid_languages.values}
  validates :mobile_number, numericality: true,length:{maximum: 13 ,minimum: 10,message: "not a valid number"},allow_blank: true
  validates :voice_number, numericality: true,length:{maximum: 13 ,minimum: 10},allow_blank: true
  validates :name,:length => { maximum: 255,too_long: "is too long (maximum is %{count} characters)" }
  validates :first_name,presence: true
  attr_accessor :invitation_message, :new_company_name

  validate :password_complexity

  def password_complexity
    if password.present? and not password.match(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\W)(?=.*\d).+\z/)
      errors.add :password, "must include at least one lowercase letter, one uppercase letter,one special character and one digit."
    end
  end

  scope :with_rolex, -> (name, resource) {
    joins(:roles).where(
      'roles.name' => name,
      'roles.resource_type' => resource.try_chain(:class, :to_s),
      'roles.resource_id' => resource.try(:id)
    )
  }

  searchable do
    text :name, :first_name, :last_name, stored: true
    string :featured, stored: true
    boolean :verified, stored: true
    boolean :authenticated, stored: true
    string :profile, stored: true do
      { title: user_profile.title, thumb_url: user_profile.image.thumb.url, summary: user_profile.executive_experience, documents_count: documents.public.count }.to_json
    end
    text :company, stored: true do
      { name: company.try(:name), id: company.try(:id) }.to_json
    end
    text :extra, stored: true do
      {type: 'User', tags: tags}
    end
    string :products, multiple: true, stored: true do
      company.products.map { |p| p.name } if company
    end
    string :product_categories, multiple: true, stored: true do
      company.products.map { |p| p.product_category.name } if company
    end
    string :user_results, multiple: true, stored: true do
      { email: email }
    end
    string :tags, multiple: true, stored: true
    string :location, multiple: true, stored: true do
      [address.country, address.state, address.city]
    end
    string :auditor_results, multiple: true, stored: true do
      { email: email } if type == 'Auditor'
    end
    string :scheme_types, multiple: true, stored: true do
      scheme_types.map { |s| s.name } if type == 'Auditor'
    end
  end

  def authentication_keys
    authentication_tokens.map(&:value)
  end

  def is_payment_settings_verified?
    user_account_info && user_account_info.account_status['charges_enabled'] && user_account_info.account_status['transfers_enabled']
  end

  def permission_list entity
    permissions = []
    if entity
      roles = entity_roles(entity)
    else
      roles = self.custom_roles
    end
    roles.each do |role|
      permissions += role.permissions.map(&:name)
    end
    permissions.uniq
  end

  def entity_roles entity
    if entity.is_a?(Company)
      opt  = { entity_id:entity.id,entity_type:'Company' }
    else
      opt = { entity_id:entity.id,entity_type:entity.class.to_s }
    end
    ids = users_custom_roles.where(opt).pluck(:custom_role_id)
    CustomRole.where(id: ids)
  end

  def roles_for facility
    roles.where(resource_id: facility.id, resource_type: facility.class.to_s)
  end

  def is_free_app_role?
    is_of_role?(FREEAPP_ROLES)
  end

  def is_of_role?(*role_names)
    roles.where(name: [role_names]).any?
  end

  def name
    [first_name, last_name].compact.join(" ")
  end

  def name=(str)
    temp = str.split
    self.first_name = temp[0]
    self.last_name = ''
    for index in 1...temp.length do
      self.last_name = self.last_name + " " + temp[index]
    end
  end

  def notify(message)
    SubscriptionPreference::MECHANISMS.each do |mechanism|
      notify_by_mechanism(mechanism, message)
    end
  end

  def notify_by_mechanism(mechanism, message)
    notify_job = send("send_#{mechanism}_job", message)
    if notify_job
      opts = {}
      preference = subscription_preferences.find_by_mechanism(mechanism)
      opts[:run_at] = preference.end_of_blackout if preference.try(:during_blackout?)
      Delayed::Job.enqueue(notify_job, opts)
    end
  end

  def send_email_job(activity)
    AlertMailerJob.new(self, activity)
  end

  def valid_mobile_number?
    mobile_number && mobile_number.length > MIN_PHONE_NUMBER_LENGTH
  end

  def valid_voice_number?
    voice_number && voice_number.length > MIN_PHONE_NUMBER_LENGTH
  end

  def send_text_job(message)
    SendTextJob.new(mobile_number, message) if valid_mobile_number?
  end

  def send_voice_job(message)
    SendVoiceJob.new(voice_number,message) if valid_voice_number?
  end

  # Twilio requires more specific language codes
  def twilio_language
    translate = {'en' => 'en-US', 'es' => 'es-MX'}
    return translate[language_preference] || 'en-US'
  end

  def build_user_dependencies
    self.user_profile = UserProfile.create! if user_profile == nil
    self.address = Address.create! if address == nil
    links = ['Website', 'Linkedin']
    new_connections = []
    links.each do |link|
      new_connections.push (Connection.create!("name" => link, "url" => ""))
    end
    self.connections << new_connections
  end

  def fill_last_notification_seen_at
    self.last_notification_seen_at = Time.zone.now
    # self.save!
  end

  def self.reset_last_notification_seen_at user
    user.last_notification_seen_at = Time.zone.now
    user.save!
  end

  def can_see_document_comments document_id
    activity = Activity.where("activator_id = ? AND activator_type =? AND subject_id =? AND subject_type = ?", document_id, "Document", document_id, "Document").first
    viewers = activity.viewers
    viewers.include?self
  end

  def catch_changed_fields
    # get the user fields to be notified
    self.changed_fields = self.changed & ["email", "username", "first_name", "last_name", "title", "photo", "language_preference", "mobile_number", "voice_number", "type", "tags", "featured", "directory_name"]
    # get the user profile fields to be notified
    user_profile_changed_fields = self.user_profile.changed & ["executive_experience", "skills", "title"]
    self.changed_fields << user_profile_changed_fields
    # get the user address fields to be notified
    user_address_changed_fields = self.address.changed & ["street1", "street2", "country", "state", "city", "postal_code"]
    user_address_changed_fields = "location" if user_address_changed_fields.present?
    self.changed_fields << user_address_changed_fields

    # get the user connections fields to be notified
    user_connection_changed_fields = []
    self.connections.each do |connection|
      connection_changed_fields = connection.changed & ["name", "url"]
      if connection_changed_fields.present?
        user_connection_changed_fields = ["links"]
      end
    end
    self.changed_fields << user_connection_changed_fields
    self.changed_fields.flatten!
  end

  def send_notification!(opts = {})
    activity_key = 'user_general_change'
    if self.changed_fields.present?
      self.followers.each do |follower|
        Notification.send_notification!(self, follower, self, activity_key, {changed_fields: self.changed_fields})
      end
      if self.followers.present?
        FirebaseServices.create_firebase(self.followers)
      end
    end
  end

  def only_notifications
    notifications = self.notifications.where.not(activity_key: ["new_message", "friendship_request", "group_user_invited", "generic"]).to_a

    generic_notifications = self.notifications.where(activity_key: "generic")

    generic_notifications.each do |notification|
      if notification.activity_key == "generic"
        # the notification has the "Take Action"
        if notification.actions.length == 0
          notifications << notification
        end
      end
    end

    notifications
  end

  def internal_operations_notifications
    internal_operation_ids = self.company.users.collect(&:id) if self.company
    notifications = self.notifications.where(sender_id: internal_operation_ids).where("activity_key != ?", "new_message").to_a
    notifications << self.message_threads
    notifications.flatten!
    notifications.sort_by{|e| -e[:updated_at].to_i }
  end

  def requests_notifications
    friendship_requests = self.notifications.where(activity_key: "friendship_request")
    group_invitation_requests = self.notifications.where(activity_key: "group_user_invited")
    generic_notifications = self.notifications.where(activity_key: "generic")

    result = []
    friendship_requests.each do |notification|
      if notification.parameters == {}
        result << notification
      end
    end
    group_invitation_requests.each do |notification|
      if notification.object.join_status == "invited"
        result << notification
      end
    end
    generic_notifications.each do |notification|
      if notification.actions.length > 0
        result << notification
      end
    end
    result
  end

  def sent_message_threads
    threads = []

    new_message_notifications = self.sent_notifications.where(activity_key: "new_message").order("created_at desc")

    new_message_notifications.each do |notification|
      if notification.object.thread
        threads << notification.object.thread
      else
        threads << notification.object
      end
    end

    threads.uniq
  end

  def sent_messages_count
    result = 0
    self.message_threads.each do |thread|
      result = result + 1 if thread.from_user == self.id
    end
    self.message_threads.each do |thread|
      result = result + thread.replies_by(self).count
    end
    result
  end

  def group_notifications(group_id)
    group = Group.find(group_id)
    sender_ids = group.members.collect(&:id)
    notifications = self.notifications.where(sender_id: sender_ids).where("activity_key != ?", "new_message").to_a
    notifications << group.in_messages.where(thread_id: nil).to_a
    notifications.flatten!
    notifications.sort_by{|e| -e[:updated_at].to_i }
  end

  private
  def merge_json current_app_user
    merged = {}
    if block_given?
      if tags
        tags.each  do |d|
          if self.user_endorsements.find_by_tag_name(d)
            users = User.includes(:user_profile).find(self.user_endorsements.find_by_tag_name(d).endorse_by_users, :select => "uuid, first_name, last_name, id")
            endorsed_users = Hash.new
            isEndorsed = false
            users.each do |u|
              if u[:id] == current_app_user.id
                isEndorsed = true
              end
            end
            obj = Hash.new
            obj[:isEndorsed] = isEndorsed
            obj[:users] = users
            yield d, obj
          else
            yield d, nil
          end
        end
      end
    else
        nil
    end
  end

  # only works with subclasses of facility!
  # def facility_resources(types)
  #    opts = {
  #      resource_type: types
  #    }
  #    ids = roles.where(opts).pluck(:resource_id)
  #    Facility.where(id: ids)
  # end

  def role_resources(klass, role_name = nil)
    opts = {
      resource_type: klass.name
    }
    opts["roles.name"] = role_name if role_name
    ids = roles.where(opts).pluck(:resource_id)
    klass.where(id: ids)
  end

  # def has_admin_role?(admin_type, resource=nil)
  #   collection = roles.where(name: admin_type)
  #   if resource
  #     collection = collection.where(resource_id: resource.id, resource_type: resource.class.name)
  #   end
  #   collection.any?
  # end


  # should be refactor later
  class << self

    def send_messages users,message,document
      users.try(:each) do |user|
        user.notify(message)
        pusher_data = {message: message}
        if document
          doc_owner = User.find_by_id(document.created_by)
          doc_auditor = document.document_authentication_requests.last.auditor
          pusher_data.merge!({document_name: document.document_name, document_id:document.id, owner_name: doc_owner.name, owner_id: doc_owner.id, auditor_name: doc_auditor.name, auditor_id: doc_auditor.id})
        end
        GreenfencePusher.trigger_community(user,"message",pusher_data)
      end
    end
    handle_asynchronously :send_messages
  end

  private
  def text_message_for(activity)
    "#{activity.alert_level.capitalize} level Food Safety Alert:\n#{activity.message}"
  end

  def core_voice_message_for(activity)
    "This is a Food Safety Alert #{activity.alert_level}:\n#{activity.message}\n"
  end

  def voice_message_for(activity)
    "Hello." +
    core_voice_message_for(activity) +
    "...This message will repeat 2 more times..." +
    core_voice_message_for(activity) +
    "...This message will repeat 1 more time..." +
    core_voice_message_for(activity) +
    "Thank you. Goodbye."
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  def self.unconfirmed_user_email
    Thread.current[:email]
  end

  def self.unconfirmed_user_email=(email)
    Thread.current[:email] = email
  end

  def self.unconfirmed_user_first_name
    Thread.current[:first_name]
  end

  def self.unconfirmed_user_first_name=(first_name)
    Thread.current[:first_name] = first_name
  end

  def create_user_aws_resources
    IAMServices.create_user(self)
    S3Services.create_users_directory(self)
    IAMServices.share_user_directory(self)
    if self.company_id
        IAMServices.share_company_directory(self)
    end
  end

  def share_company_aws_resources
    company_id_changed = self.company_id_changed?
    yield
    IAMServices.share_company_directory(self) if company_id_changed
  end
end