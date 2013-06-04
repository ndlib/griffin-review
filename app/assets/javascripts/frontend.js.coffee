jQuery ($) ->


  setupStudentDatatable = () ->
    # For student table
    oTable = $(".student_datatable").dataTable(
      sPaginationType: "bootstrap"
      iDisplayLength: 1000
      bLengthChange: false
      aoColumnDefs: [
        bVisible: false
        aTargets: [1]
      ]
    )


  setupInstructorDatatable = () ->
    # For instructor table
    oTable = $(".instructor_datatable").dataTable(
      sPaginationType: "bootstrap"
      iDisplayLength: 1000
      bLengthChange: false
    )


  setupTableFilters = () ->
    oTable = $(".datatable").dataTable()
    if oTable.size() == 0
      return

    $('.dataTables_filter').append $('.table_filter').html()

    $('.topic_filter').change ->
      oTable.fnFilter($(this).val(), 1, true, false, false)

    input = $('.dataTables_filter').addClass('well').find('input')
    input.attr('placeholder', "Author name or Title")
    input.attr('data-content', 'Type the title or author of the work you need.')
    input.attr('data-title', 'Search')
    input.attr('data-placement', "top")

    input.popover({ trigger: 'manual',  })

    input.focus ->
      if ($(this).attr('data-popover-shown') != 'shown')
        input = $(this)

        setTimeout ( -> input.popover('show') ), 2000
        input.attr('data-popover-shown', 'shown')

      true


    input.blur ->
      $(this).popover('hide')

    input.keyup ->
      $(this).popover('hide')


    input.focus()


  setupStudentDatatable()
  setupInstructorDatatable()
  setupTableFilters()



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


  $(document).on 'change', ".copy",  ->
    txt = $(this).parents("tr").find(".title").text()
    if $("#copy-overlay ul li:contains(" + txt + ")").size() > 0
      $("#copy-overlay ul li:contains(" + txt + ")").remove()
    else
      row = $("<li>" + txt + "</li>")
      $("#copy-overlay ul").append row
      row.effect "highlight", {}, 3000
    if $("#copy-overlay ul li").size() is 0
      $("#copy-overlay").hide()
    else
      $("#copy-overlay").show()

  $("#copy-overlay .cancel").click ->
    $("#copy-overlay ul li").remove()
    $("#copy-overlay").hide()
    $(".copy").each ->
      @checked = false

    false


  $('.has_electronic_copy_checkbox').change ->
    if this.checked
      $(this).parents('div.controls').find('div.has_electronic_copy').show()
    else
      $(this).parents('div.controls').find('div.has_electronic_copy').hide()

  $('.datepicker').datepicker()
