object @document_comment_activity
  attributes :id

  node(:comments_count) { |obj| obj.activity_comments.count }

  node(:can_see_document_comment) do |obj|
    { can_see: current_user.can_see_document_comments(obj.subject.id) }
  end

  child :activity_comments do
    attributes :text, :user_id, :created_at
    
    node(:user) do |obj|
      { name: obj.user.name, image_url: obj.user.user_profile.image.url(:thumb), title: obj.user.user_profile.title } if obj.user
    end

  end