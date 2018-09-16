# encoding: utf-8

class ImageUploader < BaseUploader
  
  def extension_white_list
    %w(jpg jpeg gif png bmp)
  end
end