adminIndexes =
  dateNeededDisplay: 0
  title: 1
  requestDateDisplay: 2
  instructor: 3
  course: 4
  typeDisplay: 5
  requestDateTimestamp: 6
  dateNeededTimestamp: 7
  physicalElectronic: 8
  status: 9
  library: 10
  type: 11

class AdminDataTable
  constructor: (@tableElement) ->
    if @tableElement.length > 0
      @setupTable()
      @setupFilters()

  setupTable: ->
    object = @
    infoCallback = (settings, start, end, max, total, pre) ->
      object.infoCallback(settings, start, end, max, total, pre)
    @table = @tableElement.DataTable(
      dom: "f<'row-fluid'<'span12'ip>r>t<'row-fluid'<'span12'ip>>",
      pagingType: "bootstrap"
      lengthChange: false
      deferRender: true
      pageLength: 100
      processing: true
      infoCallback: infoCallback
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
        targets: adminIndexes['physicalElectronic']
        visible: false
      ,
        targets: adminIndexes['status']
        visible: false
      ,
        targets: adminIndexes['library']
        visible: false
      ,
        targets: adminIndexes['type']
        visible: false
      ]
    )

    @container = @tableElement.parent()
    @filterContainer = @container.find('.dataTables_filter')

  setupFilters: ->
    object = @
    @filterContainer.addClass('well').addClass('well-small')
    @filterContainer.html jQuery('.table_filter').html()
    jQuery('.table_filter').remove()
    @searchBox = @filterContainer.find('#filter_keyword')
    jQuery('.request_status_filter_tabs').hide()
    @container.removeClass('form-inline')

    @searchBox.on 'change keyup', ->
      object.applyKeywordFilter()

    @setupSelectFilter('request_status_filter', adminIndexes['status'])

    @setupCheckboxesFilter('request_type_filter', adminIndexes['type'])

    @setupCheckboxesFilter('request_library_filter', adminIndexes['library'])

    @setupSelectFilter('request_physical_electronic_filter', adminIndexes['physicalElectronic'])

    @setupInstructorFilter(@filterContainer.find('#filter_instructor_range_begin'), @filterContainer.find('#filter_instructor_range_end'))

  setupSelectFilter: (containerClass, columnIndex) ->
    select = @filterContainer.find(".#{containerClass} select")
    object = @
    applyFilter = ->
      object.searchColumn(columnIndex, select.val())

    select.change ->
      applyFilter()
    applyFilter()

  setupCheckboxesFilter: (containerClass, columnIndex) ->
    column = @table.column(columnIndex)
    checkboxes = @filterContainer.find(".#{containerClass} input")
    allCheckbox = checkboxes.filter('.all')
    filterCheckboxes = checkboxes.not('.all')
    object = @
    applyFilter = ->
      object.searchCheckboxes(filterCheckboxes, column)
    filterCheckboxes.change ->
      if filterCheckboxes.filter(':checked').length == 0
        allCheckbox.prop('checked', true)
      else
        allCheckbox.prop('checked', false)
      applyFilter()
    allCheckbox.change ->
      if allCheckbox.prop('checked')
        filterCheckboxes.prop('checked', false)
      else
        allCheckbox.prop('checked', true)
      applyFilter()
    applyFilter()

  searchCheckboxes: (checkboxes, columnIndex) ->
    values = @checkboxSearchExpression(checkboxes)
    @searchColumn(columnIndex, values)

  applyKeywordFilter: ->
    @table.search(@searchBox.val())
    @draw()

  checkboxSearchExpression: (checkboxes) ->
    values = []
    checkboxes.filter(':checked').each ->
      value = jQuery(this).val()
      if value && value != 'all'
        values.push(value)
    values.join('|')

  setupInstructorFilter: (rangeBeginSelect, rangeEndSelect) ->
    object = @
    applyFilter = ->
      object.applyInstructorFilter(rangeBeginSelect, rangeEndSelect)
    rangeBeginSelect.add(rangeEndSelect).change ->
      applyFilter()
    applyFilter()

  applyInstructorFilter: (rangeBeginSelect, rangeEndSelect) ->
    rangeBegin = rangeBeginSelect.val()
    rangeEnd = rangeEndSelect.val()
    if rangeBegin == 'A' && rangeEnd == 'Z'
      expression = ''
    else
      expression = "^[#{rangeBegin}-#{rangeEnd}]"
    @searchColumn(adminIndexes['instructor'], expression)

  searchColumn: (columnIndex, expression) ->
    @table.column(columnIndex).search(expression, true)
    @draw()

  draw: ->
    object = @
    setTimeout ->
      object.table.draw()
    , 10

  infoCallback: (settings, start, end, max, total, pre) ->
    if end == 0
      text = "No requests match your search criteria."
    else
      text = "Showing #{@numberWithCommas(start)} to #{@numberWithCommas(end)} of #{@numberWithCommas(total)} requests"
    if total < max
      text += " (filtered from #{@numberWithCommas(max)} total requests)"
    text

  numberWithCommas: (x) ->
    x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")

jQuery ($) ->


  setupAdminDatatable = () ->
    table = $(".admin_datatable")
    if table.size() > 0
      new AdminDataTable(table)

  ready = ->
    setupAdminDatatable()

  $(document).ready ->
    ready()
