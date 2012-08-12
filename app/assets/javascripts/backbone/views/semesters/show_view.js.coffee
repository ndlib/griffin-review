Griffin.Views.Semesters ||= {}

class Griffin.Views.Semesters.ShowView extends Backbone.View
  template: JST["backbone/templates/semesters/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
