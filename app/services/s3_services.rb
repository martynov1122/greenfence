require 'RMagick'
class S3Services < Services
  class << self
    class FilelessIO < StringIO
      attr_accessor :original_filename
      attr_accessor :content_type
    end

    # Param must be a hash with to 'base64_contents' and 'filename'.
    def cache!(document)
      if document.is_a?(Hash) && document.has_key?("base64") && document.has_key?("filename")
        raise ArgumentError unless document["base64"].present?
        file = FilelessIO.new(Base64.decode64(document["base64"]))
        file.original_filename = document["filename"]
        file.content_type = document["filetype"]  
        super(file)
      else
        super(document)
      end
    end

    def create_company_directory company
      if check_aws_keys?
        s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']))
        company.directory_name = company.uuid + '/'
        s3.put_object(bucket: ENV['AWS_COMPANY_DOCS_BUCKET'], key: company.directory_name)
        company.save!
      end
    end

    def create_users_directory user
      if check_aws_keys?
        s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']))
        user.directory_name = user.uuid + '/'
        s3.put_object(bucket: ENV['AWS_USER_DOCS_BUCKET'], key: user.directory_name)
        user.save!
      end
    end

    def create_companies_folder user, folder_uuid
      if check_aws_keys?
        if user.company.directory_name
          s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(user.access_key_id, user.secret_access_key))
          key = user.company.uuid + '/' + folder_uuid + '/'
          s3.put_object(bucket: ENV['AWS_COMPANY_DOCS_BUCKET'], key: key)
        end
        return key
      end
    end

    def create_users_folder user, folder_uuid
      if check_aws_keys?
        if user.directory_name
          s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(user.access_key_id, user.secret_access_key))
          key = user.uuid + '/' + folder_uuid + '/'
          s3.put_object(bucket: ENV['AWS_USER_DOCS_BUCKET'], key: key)
        end
        return key
      end
    end

    def upload_companies_document user, access_level, document_files, file_path
      if check_aws_keys?
        user_s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(user.access_key_id, user.secret_access_key))
        admin_s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']))
        if document_files

          picture = Magick::Image::read_inline(document_files["0"]["file"]["base64"]).first
          picture.change_geometry!('320x500') do |cols, rows, image|
            if cols < picture.columns or rows < picture.rows then image.resize!(cols, rows) end
          end
          profile_picture = "#{user.company.uuid}/" + file_path + "/profile_picture/profile_picture.jpg"
          admin_s3.put_object(acl: 'authenticated-read', body: picture.to_blob, bucket: ENV['AWS_COMPANY_DOCS_BUCKET'], key: profile_picture,)
          picture.change_geometry!('150x210') do |cols, rows, image|
            if cols < picture.columns or rows < picture.rows then image.resize!(cols, rows) end
          end
          thumb_profile_picture = "#{user.company.uuid}/" + file_path + "/profile_picture/thumb_profile_picture.jpg"
          admin_s3.put_object(acl: 'authenticated-read', body: picture.to_blob, bucket: ENV['AWS_COMPANY_DOCS_BUCKET'], key: thumb_profile_picture,)

          document_files.each do |key, value|
            document = value["file"]
            file = FilelessIO.new(Base64.decode64(document["base64"]))
            file.original_filename = document["filename"]            
            object_key = "#{user.company.uuid}/" + file_path + "/" + file.original_filename
            object_key = object_key.downcase.tr(' ', '.')
            # all documents uploaded public unless the policy issue resolved
            # if access_level == 'private'
            #   user_s3.put_object(acl: 'private', body: file, bucket: ENV['AWS_COMPANY_DOCS_BUCKET'], key: object_key,)
            # elsif access_level == 'public'
              admin_s3.put_object(acl: 'authenticated-read', body: file, bucket: ENV['AWS_COMPANY_DOCS_BUCKET'], key: object_key,)
            # end
            document_files[key] = { "file_name"=> file.original_filename, "object_key"=> object_key }
          end
        end
      end
    end

    def upload_users_document user, access_level, document_files, file_path
      if check_aws_keys?
        user_s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(user.access_key_id, user.secret_access_key))
        admin_s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']))
        if document_files

          picture = Magick::Image::read_inline(document_files["0"]["file"]["base64"]).first
          picture.change_geometry!('320x500') do |cols, rows, image|
            if cols < picture.columns or rows < picture.rows then image.resize!(cols, rows) end
          end
          profile_picture = "#{user.uuid}/" + file_path + "/profile_picture/profile_picture.jpg"
          admin_s3.put_object(acl: 'authenticated-read', body: picture.to_blob, bucket: ENV['AWS_USER_DOCS_BUCKET'], key: profile_picture,)
          picture.change_geometry!('150x210') do |cols, rows, image|
            if cols < picture.columns or rows < picture.rows then image.resize!(cols, rows) end
          end
          thumb_profile_picture = "#{user.uuid}/" + file_path + "/profile_picture/thumb_profile_picture.jpg"
          admin_s3.put_object(acl: 'authenticated-read', body: picture.to_blob, bucket: ENV['AWS_USER_DOCS_BUCKET'], key: thumb_profile_picture,)

          document_files.each do |key, value|
            document = value["file"]
            file = FilelessIO.new(Base64.decode64(document["base64"]))
            file.original_filename = document["filename"]
            object_key = "#{user.uuid}/" + file_path + "/" + file.original_filename
            object_key = object_key.downcase.tr(' ', '.')
            # all documents uploaded public unless the policy issue resolved
            # if access_level == 'private'
            #   user_s3.put_object(acl: 'private', body: file, bucket: ENV['AWS_USER_DOCS_BUCKET'], key: object_key,)
            # elsif access_level == 'public'
              admin_s3.put_object(acl: 'authenticated-read', body: file, bucket: ENV['AWS_USER_DOCS_BUCKET'], key: object_key,)
            # end
            document_files[key] = { "file_name"=> file.original_filename, "object_key"=> object_key }
          end
        end
      end
    end

    def get_company_document user, object_key
      if check_aws_keys?
        s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(user.access_key_id, user.secret_access_key))
        return Aws::S3::Presigner.new(client: s3).presigned_url(:get_object, bucket: ENV['AWS_COMPANY_DOCS_BUCKET'], key: object_key)
      end
    end

    def get_user_document user, object_key
      if check_aws_keys?
        s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(user.access_key_id, user.secret_access_key))
        return Aws::S3::Presigner.new(client: s3).presigned_url(:get_object, bucket: ENV['AWS_USER_DOCS_BUCKET'], key: object_key)
      end
    end

    def get_shared_document user, bucket_name, object_key
      if check_aws_keys?
        s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: Aws::Credentials.new(user.access_key_id, user.secret_access_key))
        return Aws::S3::Presigner.new(client: s3).presigned_url(:get_object, bucket: bucket_name, key: object_key)
      end
    end

    def check_aws_keys?
      ENV['AWS_REGION'] &&
      ENV['AWS_USER_DOCS_BUCKET'] &&
      ENV['AWS_ACCESS_KEY_ID'] &&
      ENV['AWS_COMPANY_DOCS_BUCKET'] &&
      ENV['AWS_SECRET_ACCESS_KEY']
    end

    handle_asynchronously :create_company_directory
    handle_asynchronously :create_users_directory
  end
end
