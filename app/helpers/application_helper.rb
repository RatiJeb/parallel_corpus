module ApplicationHelper

  @@main_color = 'sky'
  @@secondary_color = 'slate'

  def header_link(name, url, mobile = false)
    if mobile
      if is_active_link?(url, :inclusive)
        link_to(name, url, class: "border-skyblue-500 bg-skyblue-50 text-skyblue-700 block border-l-4 py-2 pl-3 pr-4 text-base font-medium", 'aria-current': "page")
      else
        link_to(name, url, class: "border-transparent text-gray-600 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-800 block border-l-4 py-2 pl-3 pr-4 text-base font-medium")
      end
    else
      if is_active_link?(url, :inclusive)
        link_to(name, url, class: "border-skyblue-500 text-gray-900 inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium", 'aria-current': "page")
      else
        link_to(name, url, class: "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium")
      end
    end
  end

  def page_link(current_page, total_pages, url_method, paging_params, records)
    html = ''
    unless current_page == 1
      html += other_page(1, url_method, paging_params, records)
    end
    if current_page > 3
      html += page_ellipsis
    end

    if current_page > 2
      html += other_page(current_page - 1, url_method, paging_params, records)
    end

    html += current_page(current_page, url_method, paging_params, records)

    if current_page < total_pages - 1
      html += other_page(current_page + 1, url_method, paging_params, records)
    end

    if current_page < total_pages - 2
      html += page_ellipsis
    end
    unless current_page == total_pages
      html += other_page(total_pages, url_method, paging_params, records)
    end
    html.html_safe
  end

  def current_page(number, url_method, paging_params, records)
    link_to(number, url_method.call(**paging_params.merge(page: records.current_page)), class: "relative z-10 inline-flex items-center bg-skyblue-100 px-4 py-2 rounded-md text-sm font-semibold text-gray-900 focus:z-20 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-skyblue-200", 'aria-current': "page")
  end

  def other_page(number, url_method, paging_params, records)
    link_to(number, url_method.call(**paging_params.merge(page: number)), class: "relative inline-flex items-center px-4 py-2 rounded-md text-sm font-semibold text-gray-900 hover:bg-gray-50 focus:z-20 focus:outline-offset-0")
  end

  def page_ellipsis
    '<span class="relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-700 focus:outline-offset-0">...</span>'
  end

  def table_header_cell_classes(column, index, size)
    classes = "sticky top-0 z-10 border-b border-r border-t border-gray-400 bg-skyblue-200 bg-opacity-75 py-3.5 px-3 text-left text-sm font-semibold text-gray-900 backdrop-blur backdrop-filter"
    classes += ' border-l' if index == 0
    classes += " #{column[:classes]}" if column[:classes]
    classes
  end

  def table_filter_cell_classes(column, index, size)
    classes = "sticky top-12 z-11 border-b border-r border-gray-400 bg-neutral-200 bg-opacity-75 px-3 text-left text-sm text-gray-500 backdrop-blur backdrop-filter"
    classes += ' border-l' if index == 0
    classes += " #{column[:classes]}" if column[:classes]
    classes
  end

  def table_filter_input(form, column)
    if column[:input_type] == :text_field
      classes = "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
      classes += " #{column[:input_classes]}" if column[:input_classes]
      form.text_field column[:name], name: column[:name], class: classes
    elsif column[:input_type] == :status_select
      form.select :status, column[:model].statuses.keys.map { |status| [status.humanize, status] }, { include_blank: true }, { name: :status, class: "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" }
    else
      column[:content]
    end
  end

  def table_body_cell_classes(column, index, size, row_index)
    classes = "whitespace-nowrap border-b border-r py-4 px-3 text-sm"
    classes += ' border-l' if index == 0
    classes += " bg-slate-100" if row_index % 2 == 0
    classes += " #{column[:classes]}" if column[:classes]
    classes
  end

  def table_body_cell_contents(record, column)
    if column[:type] == :link
      link_to((record.respond_to?(column[:name]) ? record.send(column[:name]) : column[:name]), column[:url_method].call(**column[:url_params]), class: "text-skyblue-700 hover:text-skyblue-900")
    else
      record.send(column[:name])
    end
  end

end
