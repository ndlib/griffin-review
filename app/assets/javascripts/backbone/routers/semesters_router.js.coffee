class Griffin.Routers.SemestersRouter extends Backbone.Router
  initialize: (options) ->
    @semesters = new Griffin.Collections.SemestersCollection()
    @semesters.reset options.semesters

  routes:
    "new"      : "newSemester"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newSemester: ->
    @view = new Griffin.Views.Semesters.NewView(collection: @semesters)
    $("#semesters").html(@view.render().el)

  index: ->
    @view = new Griffin.Views.Semesters.IndexView(semesters: @semesters)
    $("#semesters").html(@view.render().el)

  show: (id) ->
    semester = @semesters.get(id)

    @view = new Griffin.Views.Semesters.ShowView(model: semester)
    $("#semesters").html(@view.render().el)

  edit: (id) ->
    semester = @semesters.get(id)

    @view = new Griffin.Views.Semesters.EditView(model: semester)
    $("#semesters").html(@view.render().el)
