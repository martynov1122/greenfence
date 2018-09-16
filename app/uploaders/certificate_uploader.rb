# encoding: utf-8

class CertificateUploader < BaseUploader

  include CarrierWave::RMagick

  def extension_white_list
    %w(pdf jpg jpeg gif png bmp txt log)
  end

  version :detail do
     process :cover
     process :resize_to_fit => [320, 500]
     process :convert => :png

     def full_filename (for_file = model.source.file)
       super.chomp(File.extname(super)) + '.png'
     end
  end
end