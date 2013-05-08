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
        bVisible: false
        bSortable: false
        bSearchable: false
        aTargets: [6]
      ,
        bSortable: false
        bSearchable: false
        aTargets: [0]
      ]
    )

    qs = new QueryString()
    filter = qs.get('filter')
    if typeof filter is 'undefined' || filter == "new"
      oTable.fnFilter("new", 6, true, false, false)
    else if filter == 'awaiting'
      $('a[filter="awaiting"]').tab('show')


  setupMetaDataForm = () ->
    $('#admin_reserve_title').keyup ->
      $('.title').html($(this).val())

    $('#admin_reserve_creator').keyup ->
      $('.author').html($(this).val())

    $('#admin_reserve_publisher').keyup ->
      $('.publisher').html($(this).val())


  $('a[data-toggle="tab"]').on('shown', ->
    oTable = $(".datatable").dataTable()
    oTable.fnFilter($(this).attr('filter'), 6, true, false, false)
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
  setupMetaDataForm()
