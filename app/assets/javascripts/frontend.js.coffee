jQuery ($) ->


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
      )


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
      oTable = $(".admin_datatable").dataTable(
        sPaginationType: "bootstrap"
        iDisplayLength: 1000
        bLengthChange: false
        aoColumnDefs: [
          bVisible: false
          bSortable: false
          bSearchable: false
          aTargets: [6]
        ,
          bSortable: false
          bSearchable: false
          aTargets: [1]
        ]
      )

      if $('li.active > a.tab').attr('filter') != "complete"
        oTable.fnFilter($('li.active > a.tab').attr('filter'), 6, true, false, false)


      $('a[data-toggle="tab"]').on('click', ->
        if oTable.size() == 0
          return

        oTable.fnFilter($(this).attr('filter'), 6, true, false, false)
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

    $('.show_full_meta_data').click ->
      $('#admin_update_meta_data_overwrite_nd_meta_data').val("1")
      $('#full_meta_data').show()
      $('#discovery_meta_data').hide()

    $('.use_meta_data_id').click ->
      $('#admin_update_meta_data_overwrite_nd_meta_data').val("0")
      $('#full_meta_data').hide()
      $('#discovery_meta_data').show()

    $('#test_meta_data').click ->
      $(this).removeData "modal"
      href = $(this).attr('base_url') + "?id=" + encodeURIComponent($('#admin_update_meta_data_nd_meta_data_id').val())
      $(this).attr('href', href)



  setupMetaDataForm()
  setupAdminDatatable()
  setupStudentDatatable()
  setupInstructorDatatable()
  setupCopyOldReserveDatatable()

  setupTableFilters()

