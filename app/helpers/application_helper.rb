module ApplicationHelper

  def header_link(name, url, mobile = false)
    if mobile
      if is_active_link?(url, :inclusive)
        link_to(name, url, class: "border-indigo-500 bg-indigo-50 text-indigo-700 block border-l-4 py-2 pl-3 pr-4 text-base font-medium", 'aria-current': "page")
      else
        link_to(name, url, class: "border-transparent text-gray-600 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-800 block border-l-4 py-2 pl-3 pr-4 text-base font-medium")
      end
    else
      if is_active_link?(url, :inclusive)
        link_to(name, url, class: "border-indigo-500 text-gray-900 inline-flex items-center border-b-2 px-1 pt-1 text-sm font-medium", 'aria-current': "page")
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
    link_to(number, url_method.call(**paging_params.merge(page: records.current_page)), class: "relative z-10 inline-flex items-center bg-indigo-600 px-4 py-2 text-sm font-semibold text-white focus:z-20 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600", 'aria-current': "page")
  end

  def other_page(number, url_method, paging_params, records)
    link_to(number, url_method.call(**paging_params.merge(page: number)), class: "relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0")
  end

  def page_ellipsis
    '<span class="relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-700 ring-1 ring-inset ring-gray-300 focus:outline-offset-0">...</span>'
  end

end
