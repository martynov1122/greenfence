class LicenseExpireSoonMailJob < Struct.new(:license)
  def perform
    AlertMailer.license_expire_soon_mail_job(license).deliver
  end
end
