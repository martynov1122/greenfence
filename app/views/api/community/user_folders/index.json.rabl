object @folders 
  attributes :id, :folder_name, :description, :access_level, :s3_url

  child :documents do
  	attributes :id, :document_name
  end