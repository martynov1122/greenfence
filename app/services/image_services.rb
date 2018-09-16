require 'base64'

class ImageServices
  class DataUriStringIO < StringIO
    attr_reader :content_type, :original_filename

    def initialize(mime_type, data)
      @content_type = mime_type
      @original_filename = mime_type.sub('/', '.')
      super(data)
    end
  end

  def self.decode_data_uri(data_uri)
    if data_uri !~ /\Adata:(.+?)(?:;(base64))?,(.+)\z/
      raise ArgumentError, "Data uri invalid: #{data_uri[0...20]}#{'...' if data_uri.length > 20}"
    end
    mime_type, base64, data = $1, $2, $3
    if mime_type !~ %r.\Aimage/\w+\z.
      raise ArgumentError, "Only image/* mime types are accepted (got #{mime_type})"
    end
    if base64 != 'base64'
      raise ArgumentError, 'Only base64 encoding is accepted'
    end

    DataUriStringIO.new(mime_type, Base64.decode64(data))
  end
end
