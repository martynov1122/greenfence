require File.join(Rails.root, 'lib/ibms/addressable')
require File.join(Rails.root, 'lib/ibms/subscribable')

class Company < ActiveRecord::Base
  include Authority::Abilities
  include Ibms::Addressable
  include Ibms::Subscribable

  paginates_per 10

  self.authorizer_name = 'CompanyAuthorizer'

  attr_accessible \
    :facilities_attributes,
    :farm_ids,
    :logo,
    :name,
    :type,
    :phone_number,
    :cms_company_id,
    :downchain_companies,
    :downchain_company_ids,
    :report_company_id,
    :company_profile_attributes,
    :connections_attributes,
    :follows_count,
    :business_types,
    :other_company_type

  attr_accessor :image_crop_x

  acts_as_followable

  has_one :company_profile
  has_many :operations, -> { includes :address, :operation_definition, :products }, inverse_of: :company
  has_many :farms
  has_many :pullet_farms
  has_many :distribution_centers
  has_many :plants
  has_many :peanut_plants
  has_many :users ,-> { confirmed }, inverse_of: :company
  has_many :stores
  has_many :testing_labs, foreign_key: :company_id
  has_many :requirements
  has_many :special_product_categories
  has_many :pathogens
  has_many :product_categories
  has_many :survey_formats
  has_many :licenses
  has_many :certificate_approvals, as: :certificateapprovable

  has_many :products, -> {uniq }, through: :operations
  has_many :services, through: :operations

  has_many :activities_viewers, as: :viewer
  has_many :activities,  -> {order 'activities.created_at DESC' } , through: :activities_viewers
  # Supply chain associations
  has_many :upstreams , -> { where sellable_type: "Company" }, class_name: "SupplyChain" , foreign_key: :sellable_id
  has_many :downstreams , -> { where buyable_type: "Company" }, class_name: "SupplyChain" , foreign_key: :buyable_id

  has_many :buyers , through: :upstreams, source: :buyable, source_type: "Company" , inverse_of: :suppliers
  has_many :suppliers , through: :downstreams, source: :sellable, source_type: "Company" , inverse_of: :buyers

  has_many :buying_operations , through: :upstreams, source: :buyable, source_type: "Operation"
  has_many :supplying_operations , through: :downstreams, source: :sellable, source_type: "Operation"

  has_many :folders, as: :folderable
  has_many :documents, as: :documentable

  has_many :supply_chain_buyer_requirements, class_name: "SupplyChainRequirement", as: :supplier
  has_many :supply_chain_supplier_requirements, class_name: "SupplyChainRequirement", as: :buyer

  has_many :custom_roles,:dependent => :destroy

  mount_uploader :logo, ProfilePictureUploader

  # company connections like (website, facebook page, linkedin page etc)
  has_many :connections, :as => :connectionable
  has_one :supply_chain_setting

  # accepts_nested_attributes_for :facilities
  accepts_nested_attributes_for :operations
  accepts_nested_attributes_for :connections
  accepts_nested_attributes_for :company_profile
  accepts_nested_attributes_for :address

  validates :name, presence: true, uniqueness: true, length: { maximum: 255,too_long: "is too long (maximum is %{count} characters)" }

  # companies that buy products from this company DEPRECATED
  has_and_belongs_to_many :upchain_companies,
    class_name: 'Company',
    join_table: :buyers_sellers,
    foreign_key: :seller_id,
    association_foreign_key: :buyer_id

  # companies that sell products to this company DEPRECATED
  has_and_belongs_to_many :downchain_companies,
    class_name: 'Company',
    join_table: :buyers_sellers,
    foreign_key: :buyer_id,
    association_foreign_key: :seller_id,
    after_add: :update_subscriptions

  # after_create :build_company_profile
  after_create :build_company_dependencies, :create_company_aws_resources
  after_save :update_graph_node
  #after_commit

  # SOLR Search
  searchable do
    text :name, stored: true

    string :products, multiple: true, stored: true do
      products.map { |p| p.name }
    end
    string :product_categories, multiple: true, stored: true do
      products.map { |p| p.product_category.name }.uniq
    end
    text :produces, stored: true do
      products.map { |p| { name: p.name , id: p.id, extra: 'Facilities of this company produce this product'}  }
    end
    string :id, stored: true
    string :profile, stored: true do
      { id: company_profile.company_id, summary: company_profile.summary, city: address.city, state: address.state, country: address.country , website: company_profile.website , url: logo.url, thumb_url: logo.thumb.url, products_count: products_count, operations_count: operations_count, services_count: services_count, employees_count: users_count, documents_count: Document.company_and_its_operations_documents(company_profile.company_id).public.count }.to_json
    end    

    string :company_results, multiple: true, stored: true do
      { name: name }
    end

    string :location, multiple: true, stored: true do
      [address.country, address.state, address.city]
    end
  end

  #rolify requirement
  resourcify

  scope :compliant, -> { where(gfsi_status: ["green", "orange"]) }
  scope :warning, -> { where(gfsi_status: "orange") }
  scope :non_compliant, -> { where(gfsi_status: "red") }

  scope :all_companies_count, lambda { |id, term| where("id NOT IN (?) AND lower(name) like ?", [id, 1, 2, 3], "%#{term}%".downcase).count }
  scope :all_companies, lambda { |id, term, p| where("id NOT IN (?) AND lower(name) like ?", [id, 1, 2, 3], "%#{term}%".downcase).page(p) }

  caches_column :users_count, count_of: :users, inverse_of: :company
  caches_column :operations_count, count_of: :operations, inverse_of: :company
  caches_column :documents_count, count_of: :documents, inverse_of: :documentable

  caches_column :products_count, depends_on: :operations, inverse_of: :company do
    products.count
  end

  caches_column :services_count, depends_on: :operations, inverse_of: :company do
    services.count
  end

  caches_column :documents_count, depends_on: :operations, inverse_of: :company do
    documents.count
  end

  # should be improved to get featured count from stored db column value
  def featured_count
    self.operations.featured.count + self.users.featured.count + self.products.featured.count + self.services.featured.count
  end

  def update_follows_count
    o_ids = self.operations.map(&:id)
    s_ids = self.services.map(&:id)
    p_ids = self.products.map(&:id)
    user_count = User.where("id in (?)", Follow.where("(follower_type = ? ) AND ((followable_id in (?) AND followable_type = 'Operation') OR (followable_id in (?) AND followable_type = 'Service') OR (followable_id in (?) AND followable_type = 'Product'))", "User", o_ids, s_ids, p_ids).map(&:follower_id)).count
    self.update_attributes(:follows_count => user_count)
    user_count
  end

  def self.associated_gfsi_companies company_type, options={}
    order = company_type.to_s <=> self.to_s.underscore
    has_and_belongs_to_many company_type, options.merge(
      join_table: :companies_companies,
      foreign_key: order > 0 ? :left_id : :right_id,
      association_foreign_key: order > 0 ? :right_id : :left_id
    )
  end

  def self.associated_facilities facility_name
    has_and_belongs_to_many "associated_#{facility_name}".to_sym,
      join_table: :companies_facilities,
      class_name: facility_name.to_s.singularize.camelize,
      foreign_key: :company_id,
      association_foreign_key: :facility_id
  end

  def self.collection_for(user)
    user.company.suppliers
  end

  def evaluate_gfsi_status
    statuses = certifiable_facilities.pluck(:gfsi_status)
    if statuses.include?("red")
      "red"
    elsif statuses.include?("orange")
      "orange"
    else
      "green"
    end
  end

  def admins
    User.with_role(:producer_admin, self)
  end

  def admin
    admin_role = CustomRole.company_admin(self.type)
    user_ids = self.users.map(&:id)
    admin_user_ids = UsersCustomRole.users_in_system_role(admin_role.id, user_ids).pluck(:user_id)
    User.find_all_by_id(admin_user_ids)
  end

  def build_company_dependencies
    self.company_profile = CompanyProfile.create! if company_profile == nil
    self.address = Address.create! if address == nil
    self.supply_chain_setting = SupplyChainSetting.create! if supply_chain_setting == nil
    if connections == []
      links = ['Linkedin']
      new_connections = []
      links.each do |link|
        new_connections.push (Connection.create!("name" => link, "url" => ""))
      end
     self.connections << new_connections
     end
  end

  def update_graph_node
    if uuid == nil
      self.reload # to get uuid
    end
    if Graph::Node::CompanyNode.find(uuid) == nil
      Graph::Node::CompanyNode.create(name: name, entity_id: id, entity_uuid: uuid, entity_type: type)
    else
      comp = Graph::Node::CompanyNode.find uuid
      comp.name = name
      comp.save(uuid) if comp.name_changed?
    end
  end

  def create_company_aws_resources
    S3Services.create_company_directory(self)
      self.users.each do |user|
        IAMServices.share_company_directory(user)
      end if self.users
  end
end
