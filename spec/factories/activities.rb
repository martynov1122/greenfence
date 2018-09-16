FactoryGirl.define do
  factory :activity

  factory :roles_changed_activity, class: Activity::RolesChanged do
    association :activator, factory: :farm
    association :subject, factory: :user
  end

  factory :roles_removed_activity, class: Activity::RolesRemoved do
    association :activator, factory: :farm
    association :subject, factory: :user
  end

  factory :subject_added_activity, class: Activity::SubjectAdded do
    association :activator, factory: :user
    association :subject, factory: :farm
  end

  factory :subject_removed_activity, class: Activity::SubjectRemoved do
    association :activator, factory: :user
    association :subject, factory: :farm
  end

  factory :subject_updated_activity, class: Activity::SubjectUpdated do
    association :activator, factory: :user
    association :subject, factory: :farm
  end

  factory :visitor_logged_activity, class: Activity::VisitorLogged do
    association :activator, factory: :user
    association :subject, factory: :visitor
  end

  factory :comment_created_activity, class: Activity::CommentCreated do
    association :activator, factory: :user
    association :subject, factory: :farm
    text "Hello!"
  end
end
