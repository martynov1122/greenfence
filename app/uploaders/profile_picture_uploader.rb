# encoding: utf-8

class ProfilePictureUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  # To save base64 images 
  class ArgumentError < StandardError; end
 
  class FilelessIO < StringIO
    attr_accessor :original_filename
    attr_accessor :content_type
  end
  
  def extension_white_list
    %w(jpg jpeg gif png bmp)
  end

  def default_url
    ActionController::Base.helpers.asset_path("avatar.jpg")
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

  # Choose what kind of storage to use for this uploader:
  if ENV['DATABASE_URL'].blank?
    # dev
    storage :file
  else
    # heroku
    storage :fog
  end

  # Override the bucket name where the uploaded files will be stored.
  def fog_directory
  	ENV['AWS_PROFILE_PIC_BUCKET']
  end

  # Override the bucket restrictions.
  def fog_public
    true # or false
  end

  def filename 
    "profile_picture.#{file.extension}" if original_filename
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  def cover 
    manipulate! do |frame, index|
      frame if index.zero?
    end
  end

  version :thumb do
    process :cover
    process :resize_to_fit => [150, 210]
    process :convert => :jpg

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.jpg'
    end
  end
end