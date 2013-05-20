#
#= require jquery-ui-1.10.2.custom.js
#= require dataTables/jquery.dataTables
#= require dataTables/jquery.dataTables.bootstrap
jQuery ($) ->

  $('#full_meta_data').hide()

  $('.show_full_meta_data').click ->
    $('#full_meta_data').show()
    $('#discovery_meta_data').hide()


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
          aTargets: [7]
        ,
          bSortable: false
          bSearchable: false
          aTargets: [1]
        ]
      )

      if $('li.active a.tab').attr('filter') != "all" && $('li.active a.tab').attr('filter') != "complete"
        oTable.fnFilter($('li.active a.tab').attr('filter'), 7, true, false, false)

      $('.dataTables_filter').append $('.table_filter').html()
      $('.dataTables_filter').addClass('well')



  setupMetaDataForm = () ->
    $('#admin_reserve_title').keyup ->
      $('.title').html($(this).val())

    $('#admin_reserve_creator').keyup ->
      $('.author').html($(this).val())


    $('#admin_reserve_publisher').keyup ->
      $('.publisher').html($(this).val())


  $('a[data-toggle="tab"]').on('shown', ->
    oTable = $(".datatable").dataTable()
    if oTable.size() == 0
      return

    oTable.fnFilter($(this).attr('filter'), 7, true, false, false)
  )




  setupMetaDataForm()
  setupAdminDatatable()
  setupInstructorDatatable()

