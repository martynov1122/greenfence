# Serializes search result classes/headings in the format expected by
# jquery autocomplete plugin
class SearchClassJsonPresenter
  def initialize(cls, query)
    @cls = cls
    @query = query
  end

  def as_json(*)
    {
      id: nil,
      label: @cls.name.humanize.pluralize,
      # if a heading is selected, autocomplete plugin will put
      # the query back in the text box
      value: @query,
    }
  end
end
