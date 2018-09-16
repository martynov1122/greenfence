require 'spec_helper'
require 'base64'

describe ImageServices do
  describe 'decode_data_uri' do
    context 'valid input' do
      before do
        data_uri = "data:image\/gif;base64,R0lGODlhAQABAIAAAP7\/\/wAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw=="
        @io = ImageServices.decode_data_uri(data_uri)
      end

      it 'sets content type' do
        @io.content_type.should == 'image/gif'
      end

      it 'provides data' do
        data = Base64.decode64("R0lGODlhAQABAIAAAP7\/\/wAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==")
        @io.read.should == data
      end

      it 'fabricates an original filename' do
        @io.original_filename.should == 'image.gif'
      end
    end

    it 'rejects uri with missing content type' do
      assert_raise(ArgumentError) do
        data_uri = "data:;base64,R0lGODlhAQABAIAAAP7\/\/wAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw=="
        ImageServices.decode_data_uri(data_uri)
      end
    end

    it 'rejects uri with missing data' do
      assert_raise(ArgumentError) do
        data_uri = "data:image\/gif;base64,"
        ImageServices.decode_data_uri(data_uri)
      end
    end

    it 'rejects uri not in base64' do
      assert_raise(ArgumentError) do
        data_uri = "data:image\/gif,test"
        ImageServices.decode_data_uri(data_uri)
      end
    end
  end
end
