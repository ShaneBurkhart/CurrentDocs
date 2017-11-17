module JobsHelper
  def active_class(expected, current)
    return expected == current ? 'active' : ''
  end

  def plans_tab_link(tab, current_tab)
    class_name = tab == current_tab ? 'active' : ''

    return [
      "<a href='#{job_tab_path(@job, tab)}' class='#{class_name}'>",
        tab.titleize,
      '</a>'
    ].join.html_safe
  end
end
