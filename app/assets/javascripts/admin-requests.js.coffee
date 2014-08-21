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

class AdminDataTable
  constructor: (@tableElement) ->
    if @tableElement.length > 0
      @setupTable()
      @setupFilters()

  setupTable: ->
    @table = @tableElement.DataTable(
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

    @container = @tableElement.parent()
    @filterContainer = @container.find('.dataTables_filter')
    @searchInput = @filterContainer.find('input')
    @filterContainer.append jQuery('.table_filter').html()
    @typeCheckboxes = @filterContainer.find('.request_type_filter input')
    @libraryCheckboxes = @filterContainer.find('.request_library_filter input')

  setupFilters: ->
    object = @
    @filterContainer.addClass('well').addClass('well-small')
    @searchInput.attr('placeholder', "Author name or Title")

    @typeCheckboxes.change ->
      object.applyTypeFilter()

    @libraryCheckboxes.change ->
      object.applyLibraryFilter()

  applyTypeFilter: ->
    values = []
    @typeCheckboxes.filter(':checked').each ->
      values.push(jQuery(this).val())
    values = values.join('|')
    @table.column(adminIndexes['type']).search(values, true).draw()

  applyLibraryFilter: ->
    values = []
    @libraryCheckboxes.filter(':checked').each ->
      values.push(jQuery(this).val())
    values = values.join('|')
    @table.column(adminIndexes['library']).search(values, true).draw()

jQuery ($) ->


  setupAdminDatatable = () ->
    table = $(".admin_datatable")
    if table.size() > 0
      new AdminDataTable(table)

  ready = ->
    setupAdminDatatable()

  $(document).ready ->
    ready()
