jQuery ($) ->
  worldcatLinks = $(".worldcat-import")
  if worldcatLinks.length > 0
    worldcat_hide_alerts = ->
      $('#worldcat_alerts div').hide()

    worldcat_search = (link) ->
      form = link.data('form')
      worldcat_hide_alerts()
      $('#worldcat_import_loading').fadeIn()
      $.getJSON(link.data('target'),{oclc_number: link.data('oclc-field').val(), isbn: link.data('isbn-field').val()}, (data, resp)->
        console.log(data)
        worldcat_hide_alerts()
        form.find('.worldcat-import-author').val(data.creator.join('; ')).effect("highlight", 2000)
        form.find('.worldcat-import-publication-year').val(data.date).effect("highlight", 2000)
        form.find('.worldcat-import-publisher').val(data.publisher).effect("highlight", 2000)
        form.find('.worldcat-import-title').val(data.title).keyup().effect("highlight", 2000)
      ).error ->
        worldcat_hide_alerts()
        $('#worldcat_import_failed').fadeIn()

    worldcatLinks.each (index, element) ->
      link = $(element)
      form = link.parents('form').first()
      link.data('form', form)
      console.log(link)
      link.data('oclc-field', form.find('.worldcat-import-oclc'))
      link.data('isbn-field', form.find('.worldcat-import-isbn'))
      link.click (e) ->
        e.preventDefault()
        worldcat_search($(this))

      link.data('oclc-field').add(link.data('isbn-field')).keypress (e) ->
        if e.keyCode
          code = e.keyCode
        else
          code = e.which
        if code == 13
          worldcat_search(link)
          false
        else
          true
