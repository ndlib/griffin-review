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
      aoColumnDefs: [
        bVisible: true
        aTargets: [2]
      ]
    )
 #   oTable.fnFilter($('li.active a[data-toggle="tab"]').attr('filter'), 3, true, false, false)


  setupTableFilters = () ->
    oTable = $(".datatable").dataTable()
    if oTable.size() == 0
      return

    $('a[data-toggle="tab"]').on('shown', ->
      oTable = $(".datatable").dataTable()
      oTable.fnFilter($(this).attr('filter'), 3, true, false, false)
    )

    $('.dataTables_filter').append $('.table_filter').html()

    $('.topic_filter').change ->
      oTable.fnFilter($(this).val(), 2, true, false, false)

    $('.status_filter').change ->
      oTable.fnFilter($(this).val(), 3, true, false, false)

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



  $(document).on 'click', "#add_topic_button", ->
    $("#topic_list").append "<label class=\"checkbox\"><input type=\"checkbox\" checked=\"true\"> New Topic</label>"


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
