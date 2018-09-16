module NotificationsHelper
  def my_notifications
    notifcations ||= current_user.notifications.order(created_at: :desc)
                                               .limit(10)

    content_tag(:ul, id: "notifdrop", class: "f-dropdown", 'data-dropdown-content'=>'true', 'aria-hidden'=>'true', 'tabindex' => 1) do
      notifcations.collect {|item| concat(content_tag(:li, notification_to_text(item), class: "#{item.is_unread ? 'unread' : nil}"))}
    end
  end

  def notification_to_text(notification)
    case notification.activity_key
    when 'new_message'
      message = notification.object
      from_user = message.from

      link_to "You are receiving this notification because:  you have a message in the message center from #{from_user.name}.", '#'

    when 'group_user_accept_invitation'
      group_member = notification.object
      group = group_member.group
      member = group_member.member

      link_to "You are receiving this notification because: #{sender.name} just accept your invitation to join group #{group.name}", '#'

    when 'group_user_invited'
      group_member = notification.object
      group = group_member.group
      sender = notification.sender

      link_to "You are receiving this notification because: #{sender.name} just send you invitation to join group #{group.name}", '#'

    when 'group_user_decline_invitation'
      group_member = notification.object
      group = group_member.group
      sender = notification.sender

      link_to "You are receiving this notification because: #{sender.name} just decline your invitation", '#'
    end
  end
end