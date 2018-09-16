class RegionServices < Services
  concerns Region

  def self.create user, region_params
    region = Region.new(region_params)
    raise CanCan::AccessDenied.new(access_denied_message("create")) unless user.can?(:create, region)
    return region unless region.valid?
    region.save

    region
  end
end
