# Serializes search results in the format expected by jquery autocomplete plugin
class SearchJsonPresenter
  def initialize(record)
    @record = record
  end

  def as_json(*)
    {
      id: "#{@record.class.name.tableize.singularize}:#{@record.id}",
      label: @record.name,
      value: @record.name,
      href: @record.url_path(current_namespace),
      
    }
  end
end
