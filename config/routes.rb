def empty_resource name, options = {}, &block
  default_options = { only: [] }
  resources name, default_options.merge(options), &block
end

def child_resources name, options = {}, &block
  default_options = { only: [:show, :edit, :update] }
  resources name, default_options.merge(options), &block
end

def nested_resources name, options = {}, &block
  default_options = { only: [:index, :new, :create] }
  resources name, default_options.merge(options), &block
end

Ibms::Application.routes.draw do
  apipie
  root to: redirect('/users/sign_in')

  devise_for :users, controllers: {invitations: 'invitations', registrations: 'users/registrations'}, :path_names => { :sign_up => "register" }

  devise_scope :user do
    get 'users/sign_out', :to => 'devise/sessions#destroy'
  end

  ActiveAdmin.routes(self)

  resource :account

  get 'sign_up/personal', to: "sign_up#personal"
  put 'sign_up/personal', to: "sign_up#update_personal"
  get 'sign_up/business', to: "sign_up#business"
  put 'sign_up/business', to: "sign_up#update_business"
  get 'sign_up/facilities', to: "sign_up#facilities"
  put 'sign_up/facilities', to: "sign_up#update_facilities"
  get 'sign_up/managers',  to: "sign_up#add_managers"
  put 'sign_up/managers',  to:"sign_up#update_managers"
  get 'sign_up/suppliers', to: "sign_up#suppliers"
  put 'sign_up/suppliers', to: "sign_up#update_suppliers"
  get 'sign_up/customers', to: "sign_up#customers"
  put 'sign_up/customers', to: "sign_up#update_customers"

  get 'communications/inbox', to: "communications#inbox"

  match "/invites/:importer/contact_callback" => "contacts#callback", via: :get
  get "/contacts/failure" => "contacts#failure"

  resources :regions, only: [:new, :create]
  resources :users, only: [:show, :edit, :update]

  match 'search' => 'search#search', as: :search, via:[:get, :post]
  match 'search_companies' => 'search#search_companies', via:[:get, :post] ,  as: :search_companies
  match 'reports/supply_chain/buyers/:type/:id' => 'reports#supply_chain_buyers' ,via:[:get],  as: :report_supply_chain_buyers
  match 'reports/supply_chain/suppliers/:type/:id' => 'reports#supply_chain_suppliers' ,via:[:get],  as: :report_supply_chain_suppliers
  match 'reports/supply_chain/buyers_by_facility/:type/:id/:facility_id' => 'reports#supply_chain_buyers_by_facility' ,via:[:get] ,  as: :report_supply_chain_buyers_by_facility
  match 'reports/supply_chain/suppliers_by_facility/:type/:id/:facility_id' => 'reports#supply_chain_suppliers_by_facility' ,via:[:get],  as: :report_supply_chain_suppliers_by_facility

  # stripe urls
    get '/connect_to_plateform' => 'stripe_connects#connect_to_plateform'
    get '/stripe_user_credentials' => 'stripe_connects#stripe_user_credentials'
  # end

  # Active admin custom pages link
  get 'community_admin/upload_companies' => 'community_admin#upload_companies'
  get 'community_admin/bulk_invite' => 'community_admin#bulk_invite'
  get 'admin/upload_users' => 'community_admin#upload_users'
  get 'admin/upload_operations' => 'community_admin#upload_operations'
  ## End Active Admin

  namespace "api" do
    resources :docs, only: [:index]



    scope "v1.0" do
      # resources :docs, only: [:index]
      namespace :community do

        put '/managed' => 'stripe_connects#managed'

        resources :docs

        resource :tokens, only: [:create, :destroy]

        resource :user, only: [:create, :show, :update, :destroy] do
          member do
            post :validate_token
            post :resend_email
            post :forgot_password
            get :confirm_account
            put :img_upload
            post :invite_users
            get :user_company_info
            get :get_company_users
            get :get_user_permission
            post :update_permissions
            get :get_all_tags
            get :search_users
            get :get_users_to_share_with
            get :get_accreditations
            get :get_scheme_types
            get :get_scheme_categories
            get :get_scheme_sub_types
            post :update_user_profile
            get :associated_schemes
            get :user_complete_information
            get :endorse_user_tag
            get :get_user_endorsements
            get :get_current_user
            get :get_auditor_authentications
            get :get_public_documents
          end
        end
        resource :follows, only: [:create, :destroy] do
          collection do
            get :company_follows_count
            post :follow_all
          end
        end

        resource :friendships, only: [:create] do
          member do
            get :connected_status
            post :accept
            post :decline
            post :cancel
            post :delete
          end
        end
        resources :operations do
          member do
            post :associate_products
            post :existing_products
          end
          collection do
            get :business_types
            get :business_sub_types
            get :get_featured_list
            get :get_products
            get :get_services
            get :get_documents
            get :get_all_documents
          end
        end
        resources :operation_definitions, only: [:create, :show] do
          collection do
            get :definition_types
          end
        end
        resource :company, only: [:create, :show, :update, :destroy] do
          collection do
            get :suppliable_buyable
            put :img_upload
            get :get_featured_list
            get :get_operations
            get :get_products
            get :get_employees
            get :get_services
            get :get_documents
            get :company_permission
            get :roles_with_users
            get :company_operations
            get :company_operations_paginated
          end
        end
        resources :supply_chain_invitations, only: [:create] do
          collection do
            get :invited_buyer_entities
            get :invited_supplier_entities
            get :accept_reject
          end
        end
        resources :supply_chain_requirements do
          collection do
            get :assigned_requirements
            get :get_buyers_by_type
            get :get_suppliers_by_type
          end
          member do
            post :supply_chain_requirement_comments
          end
        end
        resources :supply_chains do
          collection do
            get :get_suppliers
            get :get_buyers
            get :get_supplied_products
            get :get_bought_products
            get :filter_suppliers_with_products
            get :filter_buyers_with_products
            get :get_filtered_suppliers
            get :get_filtered_tree_suppliers
            get :get_filtered_buyers
            get :get_buyer
            get :get_supplier
            get :get_node_detail
            get :visibility
            post :set_visibility
            get :get_supply_chain_requirements
            get :filter_by_product_suppliers
            get :get_suppliers_requirement
          end
        end
        resources :services do
          collection do
            get :company_services
          end
        end
        resources :product_categories, only: [:index] do
          collection do
            get :products
            get :company_products
            get :entity_products
            get :get_supply_chain_products
          end
        end
        resources :search, only: [:index] do
          collection do
            get :connected_status
          end
        end

        resources :documents do
          member do
            post :document_comments
          end
        end

        resources :user_documents do
          collection do
            get :get_document_file
            post :share_document
            get :search_auditors
            get :get_auditors_directory
            get :search_user_documents
            get :get_audited_records
          end
          member do
            get :sharing_record_detail
            get :sharing_record_file
          end
        end
        resources :company_documents do
          collection do
            get :get_document_file
            post :share_document
            get :get_auditors
            get :get_auditors_directory
            get :get_company_documents
            get :company_documents_by_document_definition
            get :search_company_documents
          end
        end
        resources :user_folders do
          collection do
            get :search_user_folders
          end
        end
        resources :company_folders do
          collection do
            get :search_company_folders
          end
        end
        resources :custom_roles, only: [:create, :show, :index, :update, :destroy] do
          member do
            post :add_role
            post :delete_role
          end
        end
        resources :document_definitions, only: [:create, :show, :index, :update] do
          collection do
            get :definition_types
            get :document_definition_by_company
            get :company_documents
            get :get_document_type_for_assigned_requirement
          end
        end
        resources :shared_record, only: [:index, :destroy] do
          collection do
            get :folder_documents
            get :sharing_records
            get :shared_with_users
            get :unshare_with_all
          end
        end
        resources :communications do
          collection do
            get :unread_in_messages
            get :in_message_threads
            get :in_messages_from_suppliers
            get :in_messages_from_sender
            get :in_notifications
            get :contacts_and_groups
            get :all_users
            get :notifications
            get :unread_notifications
            get :internal_operations
            get :requests
            get :unread_requests
            get :sent_list
            get :group_notifications
            post :mark_as_read
            get :all_contacts
          end
        end
        resource :groups, only: [:show, :update, :create, :destroy] do
          member do
            post :accept
            post :decline
          end
          collection do
            get :my_groups
          end
        end
        resources :document_authentication_request, only: [:update] do
          collection do
            get :accept_decline_request
            get :accept_decline_request_by_notification
          end
          member do
            post :make_payment
            put :approve
            put :reject
          end
        end
        resources :view, only: [:show]
      end
    end

  end
  # get '/:controller(/:action(/:id))',:controller => /community1\/[^\/]+/
  # post '/:controller(/:action(/:id))',:controller => /community1\/[^\/]+/
  # put '/:controller(/:action(/:id))',:controller => /community1\/[^\/]+/
  # # Angular changes (Rajeev )
  get '/:controller(/:action(/:id))',:controller => /community\/[^\/]+/
  get '/community/', to: 'community#index'
  # end
  get '/:controller(/:action(/:id))'
  post '/:controller(/:action(/:id))'
  put '/:controller(/:action(/:id))'
end

=begin
# Community App (new)
Ibms::Application.routes.draw do
  apipie
  #root to: redirect('/users/login')

  devise_for :users, controllers: { invitations: 'invitations', sessions: "users/sessions",  registrations: "users/registrations", passwords: "users/passwords", confirmations: 'users/confirmations'}, path_names: {sign_in: 'login', sign_up: 'register'}

  namespace 'api' do
    scope "v1.0" do
      namespace :greenfence do
        resource :user, only: [:create, :show, :update, :destroy]
      end
    end
  end
end
=end
