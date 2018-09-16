object @user_profile
attribute :executive_experience, :skills, :title, :completion , :image, :has_skills, :has_executive_experience, :has_profile_experiences, :has_profile_languages, :has_user_company, :has_profile_educations

child @user_profile.profile_experiences => "profile_experiences" do
	attribute :company_name, :title, :location,  :description, :id,:till_present
	node(:from_date){|pe| pe.from_date.strftime('%B %Y') if pe.from_date}
	node(:to_date) {|pe|
		if(pe.to_date== nil)
			"Till Present"
		else
			pe.to_date.strftime('%B %Y')
		end
	}
	node(:from_year){|pe| pe.from_date.strftime('%Y') if pe.from_date}
	node(:to_year){|pe| pe.to_date.strftime('%Y') if pe.to_date}
	node(:from_month){|pe| pe.from_date.strftime('%-m') if pe.from_date}
	node(:to_month){|pe| pe.to_date.strftime('%-m') if pe.to_date}
end


child @user_profile.profile_languages => "profile_languages" do
	attribute :language ,:proficiency,  :id
	node(:proficiency_label){|pl| pl.proficiency.humanize()}
end

child @user_profile.profile_educations => "profile_educations" do
	attribute :school,  :degree, :study_field, :grade, :description, :activities, :id
	node(:from_date){|pe| pe.from_date.strftime('%B %Y') if pe.from_date}
	node(:till_date){|pe| pe.till_date.strftime('%B %Y') if pe.till_date}
	node(:from_year){|pe| pe.from_date.strftime('%Y') if pe.from_date}
	node(:from_month){|pe| pe.from_date.strftime('%-m') if pe.from_date}
	node(:to_year){|pe| pe.till_date.strftime('%Y') if pe.till_date}
	node(:to_month){|pe| pe.till_date.strftime('%-m') if pe.till_date}
end

child @user_permissions => "permissions" do
	attribute :id, :name, :label
end

child @address do
	attribute :city, :state, :country
end