jQuery ($) ->


  setupStudentDatatable = () ->
    # For student table
    oTable = $(".student_datatable").dataTable(
      sPaginationType: "bootstrap"
      iDisplayLength: 1000
      bLengthChange: false
      aoColumnDefs: [
        bVisible: false
        aTargets: [2]
      ,
        bSortable: false
        bSearchable: false
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
      ,
        bSortable: false
        bSearchable: false
        aTargets: [1]
      ]
    )


  setupTableFilters = () ->
    oTable = $(".datatable").dataTable()
    if oTable.size() == 0
      return

    $('.dataTables_filter').append $('.table_filter').html()

    $('.topic_filter').change ->
      oTable.fnFilter($(this).val(), 2, true, false, false)

    $('.status_filter').change ->
      oTable.fnFilter($(this).val(), 3, true, false, false)

    input = $('.dataTables_filter').addClass('well form-vertical ').find('input')
    input.attr('placeholder', "Author name or Title")
    input.attr('data-content', 'Start typeing to filter the list')
    input.attr('data-title', 'Reserve Filter')

    input.popover({ trigger: 'manual' })

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
