Griffin.Views.Semesters ||= {}

class Griffin.Views.Semesters.EditView extends Backbone.View
  template : JST["backbone/templates/semesters/edit"]

  events :
    "submit #edit-semester" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (semester) =>
        @model = semester
        window.location.hash = "/#{@model.id}"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
