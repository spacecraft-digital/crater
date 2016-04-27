mongoose = require 'mongoose'

module.exports =
    getSchemas: ->
        unless @schemas
            @schemas =
                Customer: require './schema/Customer'
                Project: require './schema/Project'
                Stage: require './schema/Stage'
                Server: require './schema/Server'
                Module: require './schema/Module'
                Repository: require './schema/Repository'
        @schemas

    getSchema: (name) ->
        schemas = @getSchemas()
        schemas[name]

    getModels: ->
        unless @models
            @models = {}
            @models[name] = mongoose.model name, schema for name, schema of @getSchemas()
        @models

    getModel: (name) ->
        models = @getModels()
        models[name]
