class CommentServices < Services
  def self.create(user, item, text)
    return if text.blank?
    Activity::CommentCreated.construct(user, item, text: text)
  end
end
