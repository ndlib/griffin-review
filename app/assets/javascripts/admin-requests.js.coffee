adminIndexes =
  dateNeededDisplay: 0
  progress: 1
  title: 2
  requestDateDisplay: 3
  instructor: 4
  course: 5
  typeDisplay: 6
  requestDateTimestamp: 7
  dateNeededTimestamp: 8
  physicalElectronic: 9
  status: 10
  library: 11
  type: 12
  sortableTitle: 13

class AdminDataTable
  constructor: (@tableElement) ->
    @filterDescriptions = []
    if @tableElement.length > 0
      @setupTable()
      @setupFilters()
      @setupForm()

  setupTable: ->
    object = @
    infoCallback = (settings, start, end, max, total, pre) ->
      object.infoCallback(settings, start, end, max, total, pre)
    @table = @tableElement.DataTable(
      dom: "f<'row-fluid'<'span6'i><'span6 paginate-right'p>r>t<'row-fluid'<'span6'i><'span6 paginate-right'p>>",
      pagingType: "full_numbers"
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
        targets: adminIndexes['progress']
        sortable: false
        searchable: false
      ,
        targets: adminIndexes['dateNeededDisplay']
        orderData: [adminIndexes['dateNeededTimestamp']]
      ,
        targets: adminIndexes['title']
        orderData: [adminIndexes['sortableTitle']]
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
      ,
        targets: adminIndexes['sortableTitle']
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

    @setupInstructorFilter(@filterContainer.find('.range-begin'), @filterContainer.find('.range-end'))

  setupForm: ->
    $advancedForm = @container.find('#advancedSearchForm')
    $toggleIcon = @container.find('.advanced-toggle-icon')
    $advancedForm.on 'hide', ->
      $toggleIcon.removeClass('icon-chevron-down').addClass('icon-chevron-right')
    $advancedForm.on 'show', ->
      $toggleIcon.removeClass('icon-chevron-right').addClass('icon-chevron-down')


  setupSelectFilter: (containerClass, columnIndex) ->
    $container = @filterContainer.find(".#{containerClass}")
    $select = $container.find("select")
    $label = $container.find("label").first()
    labelText = $label.text().trim()
    object = @
    applyFilter = ->
      if $select.val()
        selectedOption = $select.find('option:selected')
        filterDescription = "#{labelText}: #{selectedOption.text()}"
      else
        filterDescription = ''
      object.setFilterDescription(columnIndex, filterDescription)
      object.searchColumn(columnIndex, $select.val())

    $select.change ->
      applyFilter()
    applyFilter()

  setupCheckboxesFilter: (containerClass, columnIndex) ->
    $container = @filterContainer.find(".#{containerClass}")
    $checkboxes = $container.find("input")
    $label = $container.find("label").first()
    labelText = $label.text().trim()
    object = @
    applyFilter = ->
      $selectedCheckboxes = $checkboxes.filter(':checked')
      if $selectedCheckboxes.length > 0 && $selectedCheckboxes.length < $checkboxes.length
        searchExpression = object.checkboxSearchExpression($selectedCheckboxes)
        labels = object.checkboxLabels($selectedCheckboxes)
        filterDescription = "#{labelText}: #{labels.join(', ')}"
      else
        searchExpression = ''
        filterDescription = ''
      object.setFilterDescription(columnIndex, filterDescription)
      object.searchColumn(columnIndex, searchExpression)
    $checkboxes.change ->
      applyFilter()
    applyFilter()

  setFilterDescription: (columnIndex, description) ->
    @filterDescriptions[columnIndex] = description

  filterDescriptionArray: ->
    descriptions = []
    for description in @filterDescriptions
      if description
        descriptions.push description
    descriptions

  applyKeywordFilter: ->
    value = @searchBox.val()
    if value
      filterDescription = "Keyword: #{@escape(value)}"
    else
      filterDescription = ""
    @setFilterDescription(adminIndexes['title'], filterDescription)
    @table.search(value)
    @draw()

  checkboxLabels: (checkboxes) ->
    labels = []
    checkboxes.parent('label').each ->
      label = jQuery(this).text().trim()
      labels.push(label)
    labels

  checkboxSearchExpression: (checkboxes) ->
    values = []
    checkboxes.each ->
      value = jQuery(this).val()
      values.push(value)
    values.join('|')

  setupInstructorFilter: (rangeBeginSelect, rangeEndSelect) ->
    object = @
    applyFilter = ->
      object.applyInstructorFilter(rangeBeginSelect, rangeEndSelect)
    rangeBeginSelect.add(rangeEndSelect).change ->
      # If the end letter is before the begin letter, change it to be the same as the begin letter
      if rangeEndSelect.val().charCodeAt(0) < rangeBeginSelect.val().charCodeAt(0)
        rangeEndSelect.val(rangeBeginSelect.val())
      applyFilter()
    applyFilter()

  applyInstructorFilter: (rangeBeginSelect, rangeEndSelect) ->
    rangeBegin = rangeBeginSelect.val()
    rangeEnd = rangeEndSelect.val()
    if rangeBegin == 'A' && rangeEnd == 'Z' || (!rangeBegin && !rangeEnd)
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

  escape: (string) ->
    jQuery('<span></span>').text(string).html()

jQuery ($) ->


  setupAdminDatatable = () ->
    table = $(".admin_datatable")
    if table.size() > 0
      new AdminDataTable(table)

  ready = ->
    setupAdminDatatable()

  $(document).ready ->
    ready()
