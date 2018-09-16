object @employees
	attributes :id, :name, :verified, :authenticated

node (:title) { |obj| obj.user_profile.title }
node (:summary) { |obj| obj.user_profile.executive_experience }
node (:image) { |obj| obj.user_profile.image }
node (:city) { |obj| obj.address.city }
node :filter_type do
	"users"
end