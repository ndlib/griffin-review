Griffin.Views.Semesters ||= {}

class Griffin.Views.Semesters.SemesterView extends Backbone.View
  template: JST["backbone/templates/semesters/semester"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
