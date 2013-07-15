
  $(document).on 'click', ".add_topic_button", ->
    name = $(this).parent().find('.add_topic_input').val()
    if name
      field = "<label class=\"checkbox\"><input name=\"topics[]\" type=\"checkbox\" value=\"#{name}\">#{name}</label>"
      $('.add_topic_form').find(".topic_list").show()
      $('.add_topic_form').find(".topic_list div").append field
      $(this).parents('.modal-body').find(".topic_list input[value=\"#{name}\"]").attr('checked', 'true')
      $(this).parents('.modal-body').find('.topic-form-error').hide()

      if $('.topic_filter')
        $('.topic_filter').show()
        $('.topic_filter').append "<option value=\"#{name}\">#{name}</option>"

    else
      $(this).parents('.modal-body').find('.topic-form-error').show()

    false


  $(document).on 'click', '.topic_form_save', ->
    form = $(this).parents('.modal').find('form')
    $.post form.attr('action'),
      form.serialize()
    , ((data) ->
        $('.loading_image').remove()
        if data['topics']
          for topic in data['topics']
            $("ul.topics#{data['id']}").append("<li>#{topic['name']}</li>")
        else
          $("ul.topics#{data['id']}").append("<li><p class=\"alert alert-error\">#{data['error']}</p></li>")
    ), 'json'

    $(this).parents('tr').find('.topic_cell ul').children().remove();
    $(this).parents('tr').find('.topic_cell').prepend("<img class=\"loading_image\" src=\"/assets/ajax-bar-loader.gif\" >")
    $(this).parents('.modal').modal('hide')

    false
