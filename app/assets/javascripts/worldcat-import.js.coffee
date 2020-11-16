jQuery ($) ->
  worldcatLinks = $(".worldcat-import")
  if worldcatLinks.length > 0
    worldcat_hide_alerts = ->
      $('.worldcat-alerts div').hide()

    worldcat_search = (link) ->
      form = link.data('form')
      worldcat_hide_alerts()
      $('.worldcat-import-loading').fadeIn()
      $.getJSON(link.data('target'),{oclc_number: link.data('oclc-field').val(), isbn: link.data('isbn-field').val()}, (data, resp)->
        console.log(data)
        worldcat_hide_alerts()
        citation_val = ''
        if $('#instructor_reserve_request_oclc_number').val()
          citation_val += 'oclc: ' + $('#instructor_reserve_request_oclc_number').val() + '\n'
        if $('#instructor_reserve_request_isbn').val().length > 0
          citation_val += 'isbn: ' + $('#instructor_reserve_request_isbn').val() + '\n'
        if data.creator != null
          citation_val += 'author: ' + data.creator.join('; ') + '\n'
        if data.publisher != null
          citation_val += 'publisher: ' + data.publisher + '\n'
        if data.date != null 
          citation_val += 'published date: ' + data.date + '\n'
        if data.description != null
          citation_val += 'description: ' + data.description + '\n'
        if data.type != null
          citation_val += 'type: ' + data.type + '\n'
        if data.title  != null
          form.find('.worldcat-import-title').val(data.title).keyup().effect("highlight", 2000)
          form.find('.worldcat-import-title').attr('readonly','readonly');
        if citation_val != ''
          form.find('.worldcat-import-citation').val(citation_val).effect("highlight", 2000)
          form.find('.worldcat-import-citation').attr('readonly','readonly');
      ).error ->
        worldcat_hide_alerts()
        $('.worldcat-import-failed').fadeIn()

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
