# encoding: utf-8

class DocumentProfilePictureUploader < CarrierWave::Uploader::Base

  # include CarrierWave::RMagick
  
  # kind of storage to use for this uploader
  # storage :fog

  # Override the bucket name where the uploaded files will be stored.
  # def fog_directory
  #   if model.class.to_s == 'CompanyDocument'
  #     ENV['AWS_COMPANY_DOCS_BUCKET']
  #   elsif model.class.to_s == 'UserDocument'
  #     ENV['AWS_USER_DOCS_BUCKET']
  #   end
  # end

  # def filename 
  #   "profile_picture.jpg"
  # end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  # def store_dir
  #   path = ''
  #   if model.documentable.class.to_s == 'Operation'
  #       path = model.documentable.company.uuid
  #   else
  #     path = model.documentable.uuid
  #   end
  #   if model.folder && model.folder.parent
  #     path = path + "/#{model.folder.parent.uuid}/#{model.folder.uuid}/profile_picture"
  #   else
  #     path = path + "/#{model.folder.uuid}/profile_picture"
  #   end
  # end

  # def extension_white_list
  #   %w(pdf jpg jpeg gif png bmp)
  # end

  def default_url
    ActionController::Base.helpers.asset_path("document.png")
  end

  # def cover 
  #   manipulate! do |frame, index|
  #     frame if index.zero?
  #   end
  # end

  version :thumb do
    process :cover
    process :resize_to_fit => [150, 210]
    process :convert => :jpg

    def full_filename (for_file = model.source.file)
      'thumb_profile_picture.jpg'
    end
  end
end