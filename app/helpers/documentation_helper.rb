module DocumentationHelper


  def tab_css_class(code, translation)
    if code == translation
      'active'
    else
      ''
    end
  end
end
