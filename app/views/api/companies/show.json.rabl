object @company
attributes :name, :address, :created_at

child :products do
  extends "api/shared/collections/product"
end

child(facilities: :facilities) do
  extends "api/shared/collections/facility"
end

child(upchain_companies: :buyers) do
  extends "api/shared/collections/company"
end

child(downchain_companies: :suppliers) do
  extends "api/shared/collections/company"
end


