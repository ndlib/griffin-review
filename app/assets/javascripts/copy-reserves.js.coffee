class copyReservePage
  constructor: (@document) ->
    @setup()

  setup: ->
    @setupForm()
    @setupEvents()

  setupForm: ->
    @form = new copyReserveForm(@find('#copy-overlay'))

  setupEvents: ->
    $document = @document
    form = @form
    @document.on 'change', ".copy-reserve", ->
      checkbox = $(this)
      row = checkbox.parents('.copy-reserve-row')
      reserveRow = new copyReserveRow(row)
      if checkbox.prop('checked')
        form.addReserve(reserveRow)
      else
        form.removeReserve(reserveRow)
    form.cancelButton().click (event) ->
      event.preventDefault()
      $document.find(".copy-reserve:checked").click()

  find: (selector) ->
    @document.find(selector)


class copyReserveRow
  constructor: (@row) ->
    @title = @row.data('title')
    @id = @row.data('id')


class copyReserveForm
  constructor: (@overlay) ->
    @form = @find('form')
    @list = @find('ul')

  reserveCount: ->
    @list.find('li').length

  setVisibility: ->
    if @reserveCount() > 0
      @show()
    else
      @hide()

  addReserve: (reserve) ->
    listItem = @reserveListItem(reserve)
    @list.append(listItem)
    listItem.effect "highlight", {}, 1000
    @form.append(@reserveField(reserve))
    @setVisibility()

  removeReserve: (reserve) ->
    @find(".#{@reserveClass(reserve)}").remove()
    @setVisibility()

  reserveClass: (reserve) ->
    "copy-reserve-form-#{reserve.id}"

  reserveListItem: (reserve) ->
    li = $("<li class=\"#{@reserveClass(reserve)}\"></li>")
    li.text(reserve.title)
    li

  reserveField: (reserve) ->
    $("<input type=\"hidden\" name=\"reserve_ids[]\" class=\"#{@reserveClass(reserve)}\" value=\"#{reserve.id}\">")

  cancelButton: ->
    @find('.cancel')

  find: (selector) ->
    @overlay.find(selector)

  show: ->
    @overlay.show()

  hide: ->
    @overlay.hide()


jQuery ($) ->
  ready = ->
    new copyReservePage($(document))

  $(document).ready(ready)
