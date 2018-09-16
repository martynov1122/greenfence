class SearchServices
  # SEARCHABLE_CLASSES = [User, Company, Facility, HenHouse]

  SEARCHABLE_CLASSES = [User, Company]
  module SearchResultMethods
    def url_path(namespace)
      path = []
      path << namespace if self.class.name != "User"
      path << self
      path
    end
  end

  # Performs a search of SEARCHABLE_CLASSES with query.
  #
  # Returns a list of (class, list of instances) pairs.
  #
  # If query is empty, nil or does not find anything, returns an empty list.
  def self.search(query)
    if query.present?
      results = Pose.search(query, SEARCHABLE_CLASSES)
      if results.present?
        results_classes = SEARCHABLE_CLASSES.select do |cls|
          !results[cls].empty?
        end

        mapped_results = []
        results_classes.each do |cls|
          if cls.column_names.include?('type')
            # STI
            # work around https://github.com/kevgo/pose/pull/17
            # AR returns records with base classes, query again to get
            # correct classes
            records = results[cls]
            # should be record.type but our records have nil types
            # every now and again!
            types = records.map { |record| record.class.name }.uniq
            typed_results = {}
            types.each do |type|
              typed_results[type] = []
            end
            records.each do |record|
              # see previous comment about record.type
              typed_results[record.class.name] << record
            end
            typed_results.each do |type, records|
              cls = type.constantize
              ids = records.map { |record| record.id }
              records = cls.find(ids)
              records.each do |record|
                record.extend(SearchResultMethods)
              end
              mapped_results << [cls, records]
            end
          else
            records = results[cls]
            records.each do |record|
              record.extend(SearchResultMethods)
            end

            mapped_results << [cls, records]
          end
        end
      else
        mapped_results = []
      end
    else
      mapped_results = []
    end

    mapped_results
  end

  def self.search_companies(query)
    results = Producer.select("name, id").where("lower(name) like ?", "#{query}%".downcase).map{|c| {name: c.name, id: c.id}}
  end
end
