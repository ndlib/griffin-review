jQuery ($) ->
  adminIndexes =
    dateNeededDisplay: 0
    title: 1
    requestDateDisplay: 2
    instructor: 3
    course: 4
    typeDisplay: 5
    requestDateTimestamp: 6
    dateNeededTimestamp: 7
    searchKeywords: 8
    status: 9
    library: 10
    type: 11

  setupAdminDatatable = () ->
    if $(".admin_datatable").size() > 0

      oTable = $(".admin_datatable").dataTable(
        pagingType: "bootstrap"
        lengthChange: false
        deferRender: true
        pageLength: 100
        processing: true
        ajax:
          url: window.location.href
        columnDefs: [
          targets: adminIndexes['requestDateDisplay']
          orderData: [adminIndexes['requestDateTimestamp']]
        ,
          targets: adminIndexes['dateNeededDisplay']
          orderData: [adminIndexes['dateNeededTimestamp']]
        ,
          targets: adminIndexes['requestDateTimestamp']
          sortable: false
          searchable: false
          visible: false
        ,
          targets: adminIndexes['dateNeededTimestamp']
          sortable: false
          searchable: false
          visible: false
        ,
          targets: adminIndexes['searchKeywords']
          visible: false
        ,
          targets: adminIndexes['status']
          visible: false
        ,
          targets: adminIndexes['library']
          visible: true
        ,
          targets: adminIndexes['type']
          visible: false
        ]

      )

      table = oTable.DataTable()

      setupTableFilters(table)

  setupTableFilters = (table) ->
    oTable = $(".datatable").dataTable()
    if oTable.size() == 0
      return

    input = $('.dataTables_filter').addClass('well').addClass('well-small').find('input')
    input.attr('placeholder', "Author name or Title")

    $('.dataTables_filter').append $('.table_filter').html()


    $('.dataTables_filter .request_type_filter input').change ->
      applyTypeFilter(table)

    $('.dataTables_filter .request_library_filter input').change ->
      applyLibraryFilter(table)

    $('.topic_filter').change ->
      oTable.fnFilter($(this).val(), 1, true, false, false)

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

  applyTypeFilter = (table) ->
    values = []
    $('.dataTables_filter .request_type_filter input:checked').each ->
      values.push($(this).val())
    values = values.join('|')
    table.column(adminIndexes['type']).search(values, true).draw()

  applyLibraryFilter = (table) ->
    values = []
    $('.dataTables_filter .request_library_filter input:checked').each ->
      values.push($(this).val())
    values = values.join('|')
    table.column(adminIndexes['library']).search(values, true).draw()

  ready = ->
    setupAdminDatatable()

  $(document).ready ->
    ready()
