class Griffin.Models.Semester extends Backbone.Model
  paramRoot: 'semester'

  defaults:
    code: null
    full_name: null

class Griffin.Collections.SemestersCollection extends Backbone.Collection
  model: Griffin.Models.Semester
  url: '/admin/semester'
