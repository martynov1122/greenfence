class ScheduleTaskJob < Struct.new(:task_id)
  def perform
  	task_config = TaskConfiguration.find(task_id)
  	parent = task_config.facility
  	task_params = (task_config.attributes.diff(Task.new.attributes).merge!("task_configuration_id" => task_config.id)).except("id","facility_id","created_at","updated_at","completed_at","bio_sample_id","pre_task_id","pre_task_configuration_id","task_configuration_type")
    task_params=task_params.merge("active"=>"true")
    task = TaskServices.create(parent,parent.manager,task_params)
  end
end
