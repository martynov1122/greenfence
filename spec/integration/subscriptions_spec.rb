# require 'spec_helper'

# describe 'Subscriptions' do
#   include RSpec::Rails::ControllerExampleGroup
#   let(:user) { create(:user) }

#   describe 'producer admin' do
#     let(:producer) { create(:producer) }
#     let(:downchain_producer) { create(:producer) }
#     let(:producer_facility) { create(:facility,address: create(:address,
#                       street1: "234 Pickens St",
#                       street2: "",
#                       locality: "GREEN FOREST",
#                       administrative_area: "AR",
#                       postal_code: "72638".to_i,
#                       latitude_degrees: "36.3354",
#                       longitude_degrees: "-93.4372"), company: producer) }
#     let(:grant_role) { user.add_role(:producer_admin, producer) }

#     context 'when granted role' do
#       before do
#         producer.downchain_companies << downchain_producer
#         producer_facility
#       end

#       it "subscribes to company, company's downchain companies, and company's facilities" do
#         # expect{ grant_role }.to change(Subscription, :count).by(3)
#       end

#       it "subscribes to company (non_compliance)" do
#         grant_role
#         subscription = Subscription.for(user, producer)
#         subscription.should_not be_nil
#         subscription.general.should eq(false) 
#         subscription.warning.should eq(false)
#         subscription.non_compliance.should eq(true)
#       end

#       it "subscribes to all of company's downchain companies (non_compliance)" do
#         # grant_role
#         # subscription = Subscription.for(user, downchain_producer)
#         # subscription.should_not be_nil
#         # subscription.general.should be_false
#         # subscription.warning.should be_false
#         # subscription.non_compliance.should be_true
#       end

#       it "subscribes to all of company's facilities (general, warning, non_compliance)" do
#         grant_role
#         subscription = Subscription.for(user, producer_facility)
#         subscription.should_not be_nil
#         subscription.general.should eq(true)
#         subscription.warning.should eq(true)
#         subscription.non_compliance.should eq(true)
#       end
#     end

#     context 'role already granted' do
#       before { grant_role }

#       context 'when company adds downchain company' do
#         it 'is subscribed to (non_compliance)' do
#           expect{ producer.downchain_companies << downchain_producer }.to change(Subscription, :count).by(1)

#           subscription = Subscription.for(user, downchain_producer)
#           subscription.should_not be_nil
#           subscription.general.should eq(false)
#           subscription.warning.should eq(false)
#           subscription.non_compliance.should eq(true)
#         end
#       end

#       context 'when company adds facility' do
#         it 'is subscribed to (general, warning, non_compliance)' do
#           expect{ producer_facility }.to change(Subscription, :count).by(1)

#           subscription = Subscription.for(user, producer_facility)
#           subscription.should_not be_nil
#           subscription.general.should eq(true)
#           subscription.warning.should eq(true)
#           subscription.non_compliance.should eq(true)
#         end
#       end
#     end
#   end

#   describe 'certification body auditor' do
#     let(:certification_body) { create(:gfsi_certification_body) }
#     let(:grant_role) { user.add_role(:certification_body_auditor, certification_body) }
#     let(:facility) { create(:facility,address: create(:address,
#                       street1: "234 Pickens St",
#                       street2: "",
#                       locality: "GREEN FOREST",
#                       administrative_area: "AR",
#                       postal_code: "72638".to_i,
#                       latitude_degrees: "36.3354",
#                       longitude_degrees: "-93.4372")) }
#     let(:gfsi_certificate) { create(:gfsi_certificate, facility: facility, certification_body: certification_body)}

#     context 'when granted role' do
#       before { gfsi_certificate }

#       it "subscribes to all of certification body's facilities (general)" do
#         expect{ grant_role }.to change(Subscription, :count).by(1)

#         subscription = Subscription.for(user, facility)
#         subscription.should_not be_nil
#         subscription.general.should eq(true)
#         subscription.warning.should eq(true)
#         subscription.non_compliance.should eq(true)
#       end
#     end

#     context 'role already granted' do
#       before { grant_role }

#       context 'when gfsi certificate created with certification body' do
#         it 'is subscribed to (general)' do
#           expect{ gfsi_certificate }.to change(Subscription, :count).by(1)

#           subscription = Subscription.for(user, facility)
#           subscription.should_not be_nil
#           subscription.general.should eq(true)
#           subscription.warning.should eq(true)
#           subscription.non_compliance.should eq(true)
#         end
#       end
#     end
#   end

#   describe 'scheme owner admin' do
#     let(:scheme_owner) { create(:gfsi_scheme_owner) }
#     let(:grant_role) { user.add_role(:scheme_owner_admin, scheme_owner) }
#     let(:facility) { create(:facility,address: create(:address,
#                       street1: "234 Pickens St",
#                       street2: "",
#                       locality: "GREEN FOREST",
#                       administrative_area: "AR",
#                       postal_code: "72638".to_i,
#                       latitude_degrees: "36.3354",
#                       longitude_degrees: "-93.4372")) }
#     let(:gfsi_certificate) { create(:gfsi_certificate, facility: facility, scheme_owner: scheme_owner)}

#     context 'when granted role' do
#       before { gfsi_certificate }

#       it "subscribes to all of scheme owner's facilities (general)" do
#         expect{ grant_role }.to change(Subscription, :count).by(1)

#         subscription = Subscription.for(user, facility)
#         subscription.should_not be_nil
#         subscription.general.should eq(true)
#         subscription.warning.should eq(true)
#         subscription.non_compliance.should eq(true)
#       end
#     end

#     context 'role already granted' do
#       context 'when gfsi certificate created with scheme owner' do
#         before { grant_role }

#         it 'is subscribed to (general)' do
#           expect{ gfsi_certificate }.to change(Subscription, :count).by(1)

#           subscription = Subscription.for(user, facility)
#           subscription.should_not be_nil
#           subscription.general.should eq(true)
#           subscription.warning.should eq(true)
#           subscription.non_compliance.should eq(true) 
#         end
#       end
#     end
#   end
# end
