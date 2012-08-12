Griffin.Views.Semesters ||= {}

class Griffin.Views.Semesters.NewView extends Backbone.View
  template: JST["backbone/templates/semesters/new"]

  events:
    "submit #new-semester": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (semester) =>
        @model = semester
        window.location.hash = "/#{@model.id}"

      error: (semester, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
