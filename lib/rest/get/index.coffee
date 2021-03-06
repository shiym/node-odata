module.exports =
  get : (req, mongooseModel) ->
    new Promise (resolve, reject) ->
      mongooseModel.findOne
        _id: req.params.id
      , (err, entity) ->
        if err
          return reject err

        unless entity
          return reject status: 404, text: 'Not Found'

        return resolve entity: entity

  getAll : (req, mongooseModel, options) ->
    new Promise (resolve, reject) ->
      resData = {}

      query = mongooseModel.find()

      errHandle = (err) ->
        return reject err

      if err =require('./query-parser/$count')(resData, mongooseModel, req.query['$count'], req.query['$filter'])
        return errHandle err
      if err = require('./query-parser/$filter')(query, req.query['$filter'])
        return errHandle err
      if err = require('./query-parser/$orderby')(query, req.query['$orderby'] || options.orderby)
        return errHandle err
      if err = require('./query-parser/$skip')(query, req.query['$skip'], options.maxSkip)
        return errHandle err
      if err = require('./query-parser/$top')(query, req.query['$top'], options.maxTop)
        return errHandle err
      if err = require('./query-parser/$select')(query, req.query['$select'])
        return errHandle err

      # todo
      # $expand=Customers/Orders
      # $search

      query.exec (err, data) ->
        resData.value = data
        return resolve entity: resData
