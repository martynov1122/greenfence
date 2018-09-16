object @products
	attributes :id, :name

node :filter_type do
	"products"
end
node (:followed_by_current_user) { |obj| current_user.following?(obj)}

node (:admin_ids) { |obj| obj.admin_ids }