# Makes WillPaginate spit out HTML like Tractions themes html
class CustomPaginationLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer

  protected

    def page_number(page)
      unless page == current_page
        link(page, page, :rel => rel_value(page), :class => 'page')
      else
        tag(:span, page, :class => "current")
      end
    end

    def previous_or_next_page(page, text, classname)
      if page
        link(text.gsub(/[^a-zA-Z]/, ''), page, 
             :class => classname + " #{text.downcase.gsub(/[^a-z]/, '')}postslink")
      end
    end

    def html_container(html)
      if container_attributes.has_key?(:class)
       container_attributes[:class] << ' navigation index'
      else
       container_attributes[:class] = 'navigation index'
      end

      tag(:div, 
         tag(:div,
              tag(:span, "Page #{current_page} of #{total_pages}", :class => 'pages') + html,
              :class => 'wp-pagenavi'),
        container_attributes)
    end

end

