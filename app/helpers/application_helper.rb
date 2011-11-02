# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def errors(obj)
    if obj.errors.any?
      "<div class=\"error_messages\"><h3>Oops! There are some things for you to fix:</h3></div>" +
      "<ul>" + obj.errors.full_messages.map {|m| "<li>#{m}</li>" }.join + "</ul>"
    end
  end
end
