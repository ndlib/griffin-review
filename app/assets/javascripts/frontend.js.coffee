jQuery ($) ->

  $('.check_availability_link').click ->
    $('#check_availability').modal()
    $('#check_availability .modal-body').html('<img src="/assets/ajax-bar-loader.gif" >')
    $.get $(this).attr('href'), (data) ->
      $("#check_availability .modal-body").html data
    return false

  $('#fulfillment_change').click ->
    $('#fulfillment_library_select').show()
    $('#fulfillment_library').hide()
    return false

  $('#needed_by_change').click ->
    $('#needed_by_select').show()
    $('#needed_by_date').hide()
    $('#needed_by_reserve_form_needed_by').datepicker()
    return false

  setupStudentDatatable = () ->
    if $(".student_datatable").size() > 0
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
    if $(".instructor_datatable").size() > 0
      # For instructor table
      oTable = $(".instructor_datatable").dataTable(
        sPaginationType: "bootstrap"
        iDisplayLength: 1000
        bLengthChange: false
        aoColumnDefs: [
            bVisible: false
            aTargets: [4]
          ,
          bSortable: false
          bSearchable: false
          aTargets: [3, 2]
        ]
      )

      oTable.fnFilter("available", 4, true, false, false)

      $('.show_deleted_reserves').click ->
        oTable = $(".instructor_datatable").dataTable()

        if $(this).text() == "Deleted Reserves"
          oTable.fnFilter("removed", 4, true, false, false)
          $(this).text('Active Reserves')
        else
          oTable.fnFilter("available", 4, true, false, false)
          $(this).text('Deleted Reserves')



  setupCopyOldReserveDatatable = () ->
    if $(".copy_old_reserve_datatable").size() > 0
      oTable = $(".copy_old_reserve_datatable").dataTable(
        sPaginationType: "bootstrap"
        iDisplayLength: 1000
        bLengthChange: false
        aoColumnDefs: [
          bVisible: true
          bSortable: false
          bSearchable: false
          aTargets: [4]
        ]
      )


  setupUsersDatatable = () ->
    if $(".users_datatable").size() > 0
      oTable = $(".users_datatable").dataTable(
        sPaginationType: "bootstrap"
        iDisplayLength: 1000
        bLengthChange: false
        aoColumnDefs: [
          bSortable: false
          bSearchable: false
          aTargets: [3]
        ,
          bSortable: false
          bSearchable: false
          aTargets: [4]
        ,
          bSortable: false
          bSearchable: false
          aTargets: [5]
        ]
      )



  setupTableFilters = () ->
    oTable = $(".datatable").dataTable()
    if oTable.size() == 0
      return

    $('.dataTables_filter').append $('.table_filter').html()

    $('.topic_filter').change ->
      oTable.fnFilter($(this).val(), 1, true, false, false)

    input = $('.dataTables_filter').addClass('well').addClass('well-small').find('input')
    input.attr('placeholder', "Author name or Title")

    if ($('.show_popover_help').size() > 0)
      input.attr('data-content', 'Type the title or course name.')
      input.attr('data-title', 'Search')

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



  $(document).on 'change', ".copy",  ->
    txt = $(this).parents("tr").find(".title").text()
    input = "<input type=\"hidden\" name=\"reserve_ids[]\" value=\"#{$(this).val()}\">"
    if $("#copy-overlay ul li:contains(" + txt + ")").size() > 0
      $("#copy-overlay ul li:contains(" + txt + ")").remove()
    else
      row = $("<li>" + txt + "</li>")
      $("#copy-overlay ul").append row
      $("#copy-overlay form").append input
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



  setupAdminDatatable = () ->
    # For admin table

    if $(".admin_datatable").size() > 0
      adminIndexes =
        dateNeededDisplay: 0
        title: 1
        requestDateDisplay: 2
        instructor: 3
        course: 4
        type: 5
        requestDateTimestamp: 6
        dateNeededTimestamp: 7
        searchKeywords: 8

      oTable = $(".admin_datatable").dataTable(
        sPaginationType: "bootstrap"
        bLengthChange: false
        deferRender: true
        iDisplayLength: 100
        bProcessing: true
        sAjaxSource: window.location.href
        aoColumnDefs: [
          iDataSort: adminIndexes['requestDateTimestamp']
          aTargets: [adminIndexes['requestDateDisplay']]
        ,
          iDataSort: adminIndexes['dateNeededTimestamp']
          aTargets: [adminIndexes['dateNeededDisplay']]
        ,
          bSortable: false
          bSearchable: false
          bVisible: false
          aTargets: [adminIndexes['requestDateTimestamp']]
        ,
          bSortable: false
          bSearchable: false
          bVisible: false
          aTargets: [adminIndexes['dateNeededTimestamp']]
        ,
          bVisible: false
          aTargets: [adminIndexes['searchKeywords']]
        ]

      )



  setupMetaDataForm = () ->
    $('#admin_update_meta_data_title').keyup ->
      $('.title').html($(this).val())

    $('#admin_update_meta_data_creator').keyup ->
      $('.author').html($(this).val())

    $('#admin_update_meta_data_publisher_provider').keyup ->
      $('.publisher').html($(this).val())

    $('#admin_update_meta_data_details').keyup ->
      $('.details').html($(this).val())

    $('#admin_update_meta_data_length').keyup ->
      $('.length').html($(this).val())

    $('.show_full_meta_data').click ->
      $('#admin_update_meta_data_overwrite_nd_meta_data').val("1")
      $('#full_meta_data').show()
      $('#resync_meta_data').hide()
      false

    $('.use_meta_data_id').click ->
      $('#admin_update_meta_data_overwrite_nd_meta_data').val("0")
      $('#full_meta_data').hide()
      $('resync_meta_data').show()
      false

    $('#test_meta_data').click ->
      $(this).removeData "modal"
      href = $(this).attr('base_url') + "?id=" + encodeURIComponent($('#admin_update_meta_data_nd_meta_data_id').val())
      $(this).attr('href', href)


  setupResourceForm = () ->
    $('.toggle_video_form').click ->
      if $(this).attr('data-state') == 'streaming_server'
        $(this).html('Video is on the internet')
        $(this).attr('data-state', 'internet')
        $('label.url').html('Streaming Server Filename')
      else
        $(this).html('Video on our streaming server')
        $(this).attr('data-state', 'streaming_server')
        $('label.url').html('Video URL')
      return false



  setupMetaDataForm()
  setupResourceForm()

  setupAdminDatatable()
  setupStudentDatatable()
  setupInstructorDatatable()
  setupCopyOldReserveDatatable()
  setupUsersDatatable()

  setupTableFilters()


  $('.needed_by_datepicker').change ->
    d = Date.parse($(this).val())
    test_date = new Date();
    test_date.setDate(test_date.getDate() + 10)

    if d < test_date
      $('#needed_by_modal').modal(
        show: true
      )

  $('.needed_video_datepicker').change ->
    d = Date.parse($(this).val())
    test_date = new Date();
    test_date.setDate(test_date.getDate() + 14)

    if d < test_date
      $('#video_needed_by_modal').modal(
        show: true
      )
      $(this).parents('.control-group').addClass('error')
      $(this).val("")
    else
      $(this).parents('.control-group').removeClass('error')

