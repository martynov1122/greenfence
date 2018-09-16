class VisitorServices < Services
  concerns Visitor

  def self.create facility, user, visitor_params
    if (visitor = super).persisted?
      Activity::VisitorLogged.construct(user, visitor)
    end
    visitor
  end
end
