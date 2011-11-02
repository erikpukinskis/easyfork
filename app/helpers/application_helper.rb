# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def errors(*objects)
    errors = objects.inject([]) do |errors,obj|
      errors + obj.errors.full_messages
    end
    if errors.any?
      render :partial => "/errors", :locals => {:errors => errors}
    end
  end
end
