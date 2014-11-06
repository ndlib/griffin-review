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

  $('#q').focus()

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
      setupTableFilters()


  setupInstructorDatatable = () ->
    instructorIndexes =
      title: 0
      status: 1
      editLink: 2
      deleteLink: 3
      deleteSort: 4
      sortableTitle: 5
    if $(".instructor_datatable").size() > 0
      # For instructor table
      oTable = $(".instructor_datatable").dataTable(
        pagingType: "bootstrap"
        pageLength: 1000
        lengthChange: false
        columnDefs: [
          targets: instructorIndexes['title']
          orderData: [instructorIndexes['sortableTitle']]
        ,
          visible: false
          targets: [instructorIndexes['deleteSort']]
        ,
          sortable: false
          searchable: false
          targets: [instructorIndexes['editLink'], instructorIndexes['deleteLink']]
        ,
          sortable: false
          searchable: false
          visible: false
          targets: [instructorIndexes['sortableTitle']]
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

      setupTableFilters()

  setupCopyReserveDatatable = () ->
    copyReserveIndexes =
      copy: 0
      title: 1
      sortableTitle: 2
    if $(".copy_reserve_datatable").size() > 0
      oTable = $(".copy_reserve_datatable").dataTable(
        pagingType: "bootstrap"
        searching: false
        pageLength: 1000
        lengthChange: false
        order: [ copyReserveIndexes['title'], 'asc' ]
        columnDefs: [
          sortable: false
          searchable: false
          targets: copyReserveIndexes['copy']
        ,
          targets: copyReserveIndexes['title']
          orderData: [copyReserveIndexes['sortableTitle']]
        ,
          visible: false
          targets: copyReserveIndexes['sortableTitle']
        ]
      )

      setupTableFilters()


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

      setupTableFilters()


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

      setupTableFilters()



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
      input.attr('data-content', 'Search for a reserve by title or author.')
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


  $('.has_electronic_copy_checkbox').change ->
    if this.checked
      $(this).parents('div.controls').find('div.has_electronic_copy').show()
    else
      $(this).parents('div.controls').find('div.has_electronic_copy').hide()

  $('.datepicker').datepicker()

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


  setupPlaylistForm = () ->
    if $('#playlist_fields')
      $("#new_row_button").click ->
        $("#add_row").clone(false).removeAttr("id").removeClass("demo_row").appendTo $("#playlist_fields")
        return

      $("#new_category_button").click ->
        $("#add_category_row").clone(false).removeAttr("id").removeClass("demo_row").appendTo $("#playlist_fields")
        return

      $("#playlist_fields").on "click", ".delete_row", ->
        $(this).parents(".playlist_row").remove()  if confirm("Are you sure you wish to remove this row from the playlist?")
        return

      $("#playlist_fields").sortable revert: true


  setupMetaDataForm()
  setupResourceForm()
  setupStudentDatatable()
  setupInstructorDatatable()
  setupCopyReserveDatatable()
  setupCopyOldReserveDatatable()
  setupUsersDatatable()
  setupPlaylistForm()

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



