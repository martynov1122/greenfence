module NamedFactories
  extend ActiveSupport::Concern

  included do
    let(:upchain_company) { create(:company) }

    let(:downchain_company) { create(:company) }

    let(:company) do
      company = create(:company)
      company.downchain_companies << downchain_company
      company.upchain_companies << upchain_company
      company
    end

    let(:gfsi_scheme_owner) { create(:gfsi_scheme_owner) }
    let(:gfsi_certification_body) { create(:gfsi_certification_body) }

    let(:other_company) { create(:company) }
    let(:other_scheme_owner) { create(:gfsi_scheme_owner) }
    let(:other_certification_body) { create(:gfsi_certification_body) }


    let(:gfsi_certificate) { create(:gfsi_certificate, scheme_owner: gfsi_scheme_owner, certification_body: gfsi_certification_body) }
    let(:address) {create(:address)}
    

    let(:product) { create(:product) }

    let(:producer_admin) do
      user = create(:user, company: company)
      user.add_role(:producer_admin, company)
      user
    end

    let(:unrelated_producer_admin) do
      user = create(:user)
      user.add_role(:producer_admin, other_company)
      user
    end

    let(:certification_body_auditor) do
      user = create(:user, company: gfsi_certification_body)
      user.add_role(:certification_body_auditor, gfsi_certification_body)
      user
    end

    let(:unrelated_certification_body_auditor) do
      user = create(:user, company: other_certification_body)
      user.add_role(:certification_body_auditor, other_certification_body)
      user
    end

    # for community
    let(:admin) do
      user = create(:user,company: company)
      user.add_role(:admin,company)
      user
    end
    
    let(:other_company_admin) do
      user = create(:user,company: other_company)
      user.add_role(:admin,other_company)
      user
    end

    let(:other_company_user) do
      user = create(:user,company: other_company)
      user.add_role(:user,other_company)
      user
    end

    let(:user) do
      user = create(:user,company: company)
      user.add_role(:user,company)
      user
    end

  end
end
