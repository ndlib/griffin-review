Griffin.Views.Semesters ||= {}

class Griffin.Views.Semesters.IndexView extends Backbone.View
  template: JST["backbone/templates/semesters/index"]

  initialize: () ->
    @options.semesters.bind('reset', @addAll)

  addAll: () =>
    @options.semesters.each(@addOne)

  addOne: (semester) =>
    view = new Griffin.Views.Semesters.SemesterView({model : semester})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(semesters: @options.semesters.toJSON() ))
    @addAll()

    return this
