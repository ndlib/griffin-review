#
#= require jquery-ui-1.10.2.custom.js
#= require dataTables/jquery.dataTables
#= require dataTables/jquery.dataTables.bootstrap
jQuery ($) ->

  $('#full_meta_data').hide()

  $('.show_full_meta_data').click ->
    $('#full_meta_data').show()
    $('#discovery_meta_data').hide()



  setupAdminDatatable = () ->
    # For student table
    oTable = $(".admin_datatable").dataTable(
      sPaginationType: "bootstrap"
      iDisplayLength: 1000
      bLengthChange: false
      aoColumnDefs: [
        bSortable: false
        bSearchable: false
        aTargets: [4]
      ,
        bSortable: false
        bSearchable: false
        aTargets: [0]
      ]
    )

    qs = new QueryString()
    filter = qs.get('filter')
    if typeof filter is 'undefined'
      $('a[filter="new"]').first().tab('show')
    else if filter == 'awaiting'
      $('a[filter="awaiting"]').tab('show')

  $('a[data-toggle="tab"]').on('shown', ->
    oTable = $(".datatable").dataTable()
    oTable.fnFilter($(this).attr('filter'), 4, true, false, false)
  )


  # Provide easy access to QueryString data
  class QueryString

    constructor: (@queryString) ->
      @queryString or= window.document.location.search?.substr 1
      @variables = @queryString.split '&'
      @pairs = ([key, value] = pair.split '=' for pair in @variables)

    get: (name) ->
      for [key, value] in @pairs
        return value if key is name



  setupAdminDatatable()
