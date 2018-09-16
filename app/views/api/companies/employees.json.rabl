collection @employees => :company_employees

attributes :id, :name, :title
node(:image) {|obj| (obj.user_profile.image)}
node(:user_title) { |obj| (obj.user_profile.title) }
node(:profile_title) { |obj| (obj.user_profile.title)}
node(:company_name) { |obj| (obj.try(:company).try(:name))}