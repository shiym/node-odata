model = require './model'
rest = require './rest'
metadata = require './metadata'

# params:
#   url:
#   model:
#   rest:
#     get:
#       auth:
#       before:
#       after:
#     getAll:
#       auth:
#       before:
#       after:
#     post:
#       auth:
#       before:
#       after:
#     put:
#       auth:
#       before:
#       after:
#     del:
#       auth:
#       before:
#       after:
#   actions:
#     url: function
#   options:
#     orderby:
#     maxSkip:
#     maxTop:
module.exports =
    register: (params) ->
      params.url = params.url[1..]  if params.url.indexOf('/') is 0
      if params.url.indexOf('/') >= 0
        throw new Error("Resource of url can't contain '/', it can only be allowed to exist in the beginning.")

      model.register params.url, params.model
      rest.register params
      metadata.register params
