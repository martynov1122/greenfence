class IAMServices < Services
  class << self
    def create_user user
      if check_aws_keys?
        iam = Aws::IAM::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),)
        iam.create_user(user_name: user.uuid,)

        resp = iam.list_groups()
        found = false
        resp.groups.each do |group|
          if group.group_name == ENV['AWS_IAM_USER_GROUP']
            found = true
            break
          end
        end
        if !found
          iam.create_group(group_name: ENV['AWS_IAM_USER_GROUP'])
        end
        iam.add_user_to_group(group_name: ENV['AWS_IAM_USER_GROUP'], user_name: user.uuid, )

        resp = iam.create_access_key(user_name: user.uuid,)
        user.access_key_id = resp.access_key.access_key_id
        user.secret_access_key = resp.access_key.secret_access_key

        User.skip_callback("create", :after, :create_user_aws_resources)
        user.save!
        User.set_callback("create", :after, :create_user_aws_resources)
      end
    end

    def delete_user user
      if check_aws_keys?
        iam = Aws::IAM::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),)
        iam.delete_user(user_name: user.uuid,)
      end
    end

    def share_user_directory user
      if check_aws_keys?
        iam = Aws::IAM::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),)
        iam.put_user_policy(user_name: user.uuid, policy_name: "AllAccessPersonal", policy_document: AWSPolicyHelper.create_owner_policy(ENV['AWS_USER_DOCS_BUCKET'], user.uuid),)
      end
    end

    def share_company_directory user
      if check_aws_keys?
        iam = Aws::IAM::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),)
        iam.put_user_policy(user_name: user.uuid, policy_name: "AllAccessCompany", policy_document: AWSPolicyHelper.create_owner_policy(ENV['AWS_COMPANY_DOCS_BUCKET'], user.company.uuid),)
      end
    end

    def share_user_document user, user_uuid, folder      
      if check_aws_keys?        
        iam = Aws::IAM::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),)
        begin
          resp = iam.get_user_policy(user_name: user_uuid, policy_name: "SharedResourceAccess",)
          policy_document = JSON.parse(URI.unescape(resp.policy_document))
          resources = policy_document["Statement"][0]["Resource"]
          resources[resources.length] = "arn:aws:s3:::"+ENV['AWS_USER_DOCS_BUCKET']+"/"+folder.s3_url+"*"
          policy_document["Statement"][0]["Resource"] = resources
        rescue Aws::IAM::Errors::NoSuchEntity
          policy_document = AWSPolicyHelper.create_share_policy(ENV['AWS_USER_DOCS_BUCKET'], folder.s3_url)
        end
        iam.put_user_policy(user_name: user_uuid, policy_name: "SharedResourceAccess", policy_document: policy_document.to_json,)
      end
    end

    def share_company_document user, user_uuid, folder      
      if check_aws_keys?        
        iam = Aws::IAM::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),)
        begin
          resp = iam.get_user_policy(user_name: user_uuid, policy_name: "SharedResourceAccess",)
          policy_document = JSON.parse(URI.unescape(resp.policy_document))
          resources = policy_document["Statement"][0]["Resource"]
          resources[resources.length] = "arn:aws:s3:::"+ENV['AWS_COMPANY_DOCS_BUCKET']+"/"+folder.s3_url+"*"
          policy_document["Statement"][0]["Resource"] = resources
        rescue Aws::IAM::Errors::NoSuchEntity
          policy_document = AWSPolicyHelper.create_share_policy(ENV['AWS_COMPANY_DOCS_BUCKET'], folder.s3_url)
        end
        iam.put_user_policy(user_name: user_uuid, policy_name: "SharedResourceAccess", policy_document: policy_document.to_json,)
      end
    end

    def unshare_document user, user_uuid, folder
      if check_aws_keys?
        iam = Aws::IAM::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),)
        iam.delete_user_policy(user_name: user_uuid, policy_name: user.uuid + "_" + folder.id.to_s,)
      end
    end

    def check_aws_keys?
      ENV['AWS_REGION'] &&
      ENV['AWS_USER_DOCS_BUCKET'] &&
      ENV['AWS_ACCESS_KEY_ID'] &&
      ENV['AWS_COMPANY_DOCS_BUCKET'] &&
      ENV['AWS_SECRET_ACCESS_KEY']
    end

    handle_asynchronously :create_user
    handle_asynchronously :delete_user
    handle_asynchronously :share_user_directory
    handle_asynchronously :share_company_directory
    handle_asynchronously :share_user_document
    handle_asynchronously :share_company_document
    handle_asynchronously :unshare_document
  end
end
