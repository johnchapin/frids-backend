# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def comma_and(string_array)
    if string_array.size == 1
      string_array[0]
    elsif string_array.size == 2
      string_array.join(" and ")
    else
      last_element = string_array.pop
      string_array.join(", ") + ", and " + last_element
    end
  end
end
