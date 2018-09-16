class ComplianceJob < Struct.new(:location_id,:state,:task)
  def perform
    state_color = state == "compliant" ? 'green' : 'red'
    task.actionable.update_attributes(compliance_status: state.capitalize,state_color: state_color)
    if task.actionable.compliance_status == "Non compliant"
      Activity::LocationNonCompliant.construct(task,task.actionable)
    end
  end
end