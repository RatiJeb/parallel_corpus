module ApplicationHelper

  def header_link(name, url, mobile = false, options = {})
    if is_active_link?(url, :inclusive)
      link_to(name, url, class: header_link_classes(url, mobile = false), 'aria-current': "page", **options)
    else
      link_to(name, url, class: header_link_classes(url, mobile = false), **options)
    end
  end

  def header_link_classes(url, mobile = false)
    if mobile
      if is_active_link?(url, :inclusive)
        "border-mountbatten-500 bg-mountbatten-50 text-mountbatten-700 block border-l-4 py-2 pl-3 pr-4 text-base font-medium"
      else
        "border-transparent text-gray-600 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-800 block border-l-4 py-2 pl-3 pr-4 text-base font-medium"
      end
    else
      if is_active_link?(url, :inclusive)
        "border-mountbatten-500 text-gray-900 inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium"
      else
        "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium"
      end
    end
  end

  def page_link(current_page, total_pages, url_method, paging_params, records, turbo = false)
    html = ''
    unless current_page == 1
      html += other_page(1, url_method, paging_params, records, turbo)
    end
    if current_page > 3
      html += page_ellipsis(current_page - 3, url_method, paging_params, turbo)
    end

    if current_page > 2
      html += other_page(current_page - 1, url_method, paging_params, records, turbo)
    end

    html += current_page(current_page, url_method, paging_params, records, turbo)

    if current_page < total_pages - 1
      html += other_page(current_page + 1, url_method, paging_params, records, turbo)
    end

    if current_page < total_pages - 2
      html += page_ellipsis(current_page + 3, url_method, paging_params, turbo)
    end
    unless current_page == total_pages
      html += other_page(total_pages, url_method, paging_params, records, turbo)
    end
    html.html_safe
  end

  def current_page(number, url_method, paging_params, records, turbo = false)
    link_to(number, url_method.call(**paging_params.merge(page: records.current_page, locale: I18n.locale)), data: { turbo_stream: turbo }, class: "relative z-10 inline-flex items-center bg-mountbatten-100 px-4 py-2 rounded-md text-sm font-semibold text-gray-900 focus:z-20 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-mountbatten-200", 'aria-current': "page")
  end

  def other_page(number, url_method, paging_params, records, turbo = false)
    link_to(number, url_method.call(**paging_params.merge(page: number, locale: I18n.locale)), data: { turbo_stream: turbo }, class: "relative inline-flex items-center px-4 py-2 rounded-md text-sm font-semibold text-gray-900 hover:bg-mountbatten-50 focus:z-20 focus:outline-offset-0")
  end

  def page_ellipsis(number, url_method, paging_params, turbo = false)
    link_to('...', url_method.call(**paging_params.merge(page: number, locale: I18n.locale)), data: { turbo_stream: turbo }, class: "relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-700 focus:outline-offset-0 hover:bg-mountbatten-50 focus:z-20")
  end

  def table_header_cell_classes(column, index, size)
    classes = "sticky top-0 z-20 border-b border-r border-t border-gray-400 bg-mountbatten-200 bg-opacity-75 py-3.5 px-3 text-left text-sm font-semibold text-gray-900 backdrop-blur backdrop-filter"
    classes += ' border-l' if index == 0
    classes += " #{column[:classes]}" if column[:classes]
    classes
  end

  def table_filter_cell_classes(column, index, size)
    classes = "sticky top-12 z-20 border-b border-r border-gray-400 bg-gray-200 bg-opacity-75 text-left text-sm text-gray-500 backdrop-blur backdrop-filter"
    classes += ([:text_field, :enum_select, :submit].include?(column[:input_type])) ? ' px-2' : ' px-3'
    classes += ' border-l' if index == 0
    classes += " #{column[:classes]}" if column[:classes]
    classes
  end

  def table_filter_input(form, column)
    if column[:input_type] == :text_field
      classes = "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-3xl focus:ring-oceanside-500 focus:border-oceanside-500 block w-full dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-oceanside-500 dark:focus:border-oceanside-500"
      classes += " #{column[:input_classes]}" if column[:input_classes]
      form.text_field column[:name], name: column[:name], class: classes
    elsif column[:input_type] == :enum_select
      form.select column[:name], column[:model].send(column[:name].to_s.pluralize).keys.map { |enum| [enum.humanize, enum] }, { include_blank: true }, { name: column[:name], class: "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-3xl focus:ring-oceanside-500 focus:border-oceanside-500 block w-full dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-oceanside-500 dark:focus:border-oceanside-500" }
    elsif column[:input_type] == :hidden
      form.hidden_field column[:name], name: column[:name]
    else
      column[:content]
    end
  end

  def clean_from_tags(string)
    string.gsub('[t]', '').gsub('[/t]', '')
  end

end
