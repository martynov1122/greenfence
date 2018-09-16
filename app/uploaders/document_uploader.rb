# encoding: utf-8

class DocumentUploader < BaseUploader

  def extension_white_list
    %w(pdf jpg jpeg gif png bmp txt log)
  end
end