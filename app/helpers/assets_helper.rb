module AssetsHelper

  include HesburghAssets::AssetsHelper


  def breadcrumb(*crumbs)
    crumbs.unshift(link_to("Home", root_path()))
    content_for(:breadcrumb, raw(crumbs.join(" &gt; ")))
  end


  def display_notices
    content = raw("")
    if notice.present?
      content += content_tag(:div, raw(notice), class: "alert alert-info")
    end
    if alert.present?
      content += content_tag(:div, raw(alert), class: "alert")
    end
    if success.present?
      content += content_tag(:div, raw(success), class: "alert alert-success")
    end
    if flash[:error].present?
      content += content_tag(:div, raw(flash[:error]), class: "alert alert-error")
    end
    content_tag(:div, content, id: "notices")
  end


  def help_popover(title, content, klass = "popover_help")
    link_to(image_tag("help.png"), "#", "data-original-title" => title, "data-content" => content, :class => klass)
  end

end
