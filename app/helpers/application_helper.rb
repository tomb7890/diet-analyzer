module ApplicationHelper
  def list_for_select_options(hashes)
    array = []
    if hashes
      hashes.each do |h|
        array_element = []
        array_element << h['name']
        array_element << h['ndbno']
        array << array_element
      end
    end
    array
  end
end
