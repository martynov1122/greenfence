object @user
attribute :name, :email, :photo, :id

child @user.user_profile do
	attribute :executive_experience, :skills, :title, :image
end

child @user.user_profile.profile_experiences => "profile_experiences" do
	attribute :company_name, :title, :location, :from_date, :to_date, :description
	node(:from_date){|pe| pe.from_date.strftime('%B %Y') if pe.from_date}
	node(:to_date) {|pe|
		if(pe.to_date== nil)
			"Till Present"
		else
			pe.to_date.strftime('%B %Y')
		end
	}
end


child @user.user_profile.profile_languages => "profile_languages" do
	attribute :language , :proficiency
	node(:proficiency_label){|pl| pl.proficiency.humanize()}
end

child @user.user_profile.profile_educations => "profile_educations" do
	attribute :school, :degree, :study_field, :grade, :description, :activities
	node(:from_date){|pe| pe.from_date.strftime('%B %Y') if pe.from_date}
	node(:till_date){|pe| pe.till_date.strftime('%B %Y') if pe.till_date}
end

child @user.company =>"company" do
	attribute :name, :id

	node :company_profile do 
		if(@user.company== nil)
			""
		else
			profile= @user.company.company_profile
			{:summary => profile.summary, :address => profile.address, :zip => profile.zip, :state => profile.state, :city =>profile.city, :phone => profile.phone,  :website => profile.website, :email => profile.email}
		end
	end
end

# for time being we are getting only 5 badges
node (:badges) { |obj| obj.schemes.limit(5).map(&:name) if obj.class.name == "Auditor" }