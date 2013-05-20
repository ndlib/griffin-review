module AssetsHelper

  include HesburghAssets::AssetsHelper

  def breadcrumb(*crumbs)
    crumbs.unshift(link_to("Hesburgh Libraries", "https://www.library.nd.edu"))
    content_for(:breadcrumb, raw(crumbs.join(" &gt; ")))
  end


  def display_notices
    content = raw("")
    if notice
      content += content_tag(:div, raw(notice), class: "alert alert-info")
    end
    if alert
      content += content_tag(:div, raw(alert), class: "alert")
    end
    if success
      content += content_tag(:div, raw(success), class: "alert alert-success")
    end
    content_tag(:div, content, id: "notices")
  end

end
