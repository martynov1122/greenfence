module ApplicationHelper
  STATES = Carmen::Country.named("United States").subregions.map(&:code).sort
  COUNTRY = Carmen::Country.all().map(&:name).sort
  ROLE_NAMES = {
    retail_admin: "Retail Admin",
    producer_admin: "Producer Admin",
    table_egg_farm_foreman: "Farm Foreman",
    table_egg_farm_manager: "Farm Manager",
    table_egg_farm_worker: "Farm Worker",
    test_agency_admin: "Administrator",
    test_agency_manager: "Manager",
    test_agency_worker: "Worker",
    certification_body_auditor: 'Certification Body Auditor',
  }.with_indifferent_access

  def link_to_remove_fields(name, f, options)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", options)
  end

  def link_to_add_fields(name, f, association, options)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", options)
  end

  def yn val
    val ? "Yes" : "No"
  end

  def if_ie
    haml_concat '<!--[if lt IE 9]>'.html_safe
    yield
    haml_concat '<![endif]-->'.html_safe
  end

  def pretty_role_name role_name
    ROLE_NAMES[role_name] || role_name.to_s.humanize
  end

  def role_check_box_hash roles, applicable_roles
    roles = roles.map &:name
    applicable_roles.map { |role| { field_name: role,
                                    display_name: pretty_role_name(role),
                                    checked: roles.include?(role.to_s) } }
  end

  def state_list
    [''] + STATES
  end

  def country_list
     COUNTRY
  end

  def state_list_country_wise country
    if Carmen::Country.named(country).nil?
       STATES
    else
       Carmen::Country.named(country).subregions.map(&:name).sort
    end
  end
  def navigation
    if defined?(navigation_data)
      @navigation_data ||= navigation_data.with_indifferent_access[params[:action]]
      return @navigation_data unless @navigation_data.nil?
    end
    { selected: 'none' }
  end

  def locality_administrative_area obj
    [obj.locality, obj.administrative_area].compact.join(", ")
  end

  def current_company
    @current_company ||=
      if company = (@test_agency || @company)
        company
      elsif facility = (@distribution_center || @farm || @plant || @store || @testing_lab || @facility || @user)
        facility.company
      elsif object = (@bio_sample || @hen_house)
        object.farm.company
      elsif @flock
        @flock.hen_house.farm.company
      elsif @bio_sample_item
        @bio_sample_item.bio_sample.farm.company
      elsif @npip_certificate
        if @npip_certificate.certifiable.is_a?(Flock)
          @npip_certificate.certifiable.hen_house.farm.company
        elsif @npip_certificate.certifiable.is_a?(Pullet)
          @npip_certificate.certifiable.pullet_farm.company
        else
          raise NotImplemented, "Unexpected certifiable type: #{@npip_certificate.certifiable.class}"
        end
      elsif @task
        @task.facility.try(:company)
      elsif @visitor
        @visitor.facility.try(:company)
      else
        current_user.company
      end
  end

  def facility_certificates_path facility
    if facility.type == "Farm"
      return farm_gfsi_certificates_path(facility)
    elsif facility.type == "Plant"
      return plant_gfsi_certificates_path(facility)
    end
  end

  def new_child_polymorphic_path(namespace = nil, parent_record, child_segment)
    parent_segment = parent_record.class.name.underscore
    polymorphic_path_name = [namespace, parent_segment, child_segment].compact.join("_")
    send("new_#{polymorphic_path_name}_path", parent_record)
  end

  def build_no
    "v 0.5.demo"
  end

  def unique_dom_id name
    @incrementor ||= 0
    @incrementor += 1
    "#{name.parameterize}-#{@incrementor}"
  end

  def column_args arg
    if arg.is_a?(Hash)
      arg
    elsif arg.is_a?(Array)
      {name: arg.first, sort: arg.last}
    else
      {name: arg}
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    sort_link(@search, column, title)
  end

  def params_without_ransack_value remove_key, remove_value
    p = params.deep_dup
    p[:q][remove_key] = p[:q][remove_key] - [remove_value]
    p
  end

  def facility_type_options
    Facility.gfsi_certifiable_types.map{|type| [type.titleize, type]}
  end

  def sign_up_steps
    steps = [ { text: 'App Selection' },
       { text: 'Personal Info' },
       { text: 'Company Info' }]

    if !current_user.nil?
      if current_user.is_of_role?(:producer_admin)
        steps += [
          { text: 'Business' },
          { text: 'Add My Facilities' },
          { text: 'Add Facilities Managers'}
        ]
      elsif current_user.is_of_role?(:table_egg_farm_foreman)
        steps += [
          { text: 'Wizard' }
        ]
      end
    end

    steps.each_with_index.map do |step, index|
      step[:klass] = []
      step[:klass] << :active if @progress_step > index
      step[:klass] << :current if @progress_step == index + 1
      step
    end
  end


  def new_user_sign_up_steps
    steps = [ { text: 'Personal Info' },
       { text: 'Site Info' }]
  end

  def activity_message(activity)
    activity.message_iterator do |object|
      if object.is_a?(String)
        content_tag(:div, object, class: 'text')
      elsif object.is_a?(User)
        link_to object.name, object
      else
        link_to object.name, [current_namespace, object]
      end
    end
  end

  def task_classes(task)
    klasses = ['task']
    klasses << 'red' if !task.completed?
    klasses << 'done' if task.completed?
    klasses.join(' ')
  end

  def owners_and_categories
    @_owners_and_categories ||= GfsiSchemeOwner.all.map do |owner|
      sub_options = owner.certification_food_categories.map do |category|
        {text: category.name, value: category.id}
      end

      {text: owner.name, value: owner.id, sub_options: sub_options}
    end
  end

  def gfsi_state_icon(state)
    if state == 'green'
      'check'
    elsif state == 'orange'
      'warning'
    else
      'bell'
    end
  end


  def worker_choices(facility)
    workerStruct = Struct.new(:name, :id)
    [workerStruct.new('Open', '')] + facility.workers
  end

  def workers_choices(facility)
    workerStruct = Struct.new(:name, :id, :email)
    facility.workers
  end

  def alert_level_color(alert_level)
    {
      general: "grey",
      none: "grey",
      non_compliance: "red",
      warning: "orange"
    }[alert_level]
  end

  def resource_name
   :user
  end

  def resource
     @resource ||= User.new
  end

  def devise_mapping
     @devise_mapping ||= Devise.mappings[:user]
  end

  def subscribed_apps
    @app = nil
    if current_user != nil
      facility = current_user.facilities
      is_company = facility.count == 0 ? true : false
      @facilities = is_company ? current_user.company.facilities : current_user.facilities 
      license_object = License.find(:all,:conditions => ['facility_id IN (?) AND company_id = ? AND valid_to > ? AND payment_id IS NOT NULL', @facilities.map(&:id) , current_user.company.id ,Time.now])
      @app = App.find_all_by_id(license_object.map(&:app_id)).try(:uniq)
    end
    @app
  end

  def app_validation(namespace)
    @name_spaces = []
    @app = subscribed_apps
    @app.try(:each) do |app|
      @name_spaces  = @name_spaces + app.name_spaces.map(&:name)
    end
    if @name_spaces.include?namespace.to_s
      true 
    else 
      false
    end
  end
end
