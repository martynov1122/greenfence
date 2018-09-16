object @product
attributes :name
child(facilities: :facilities) do
 extends "api/shared/collections/facility"
end
child(companies: :producers) do
 extends "api/shared/collections/company"
end