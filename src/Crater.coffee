mongoose = require 'mongoose'

module.exports =
    getSchemas: ->
        Customer: require './schema/Customer'
        Project: require './schema/Project'
        Stage: require './schema/Stage'
        Server: require './schema/Server'
        Module: require './schema/Module'
        Repository: require './schema/Repository'

    getModels: ->
        unless @models
            @models = {}
            @models[name] = mongoose.model name, schema for name, schema of @getSchemas()
        @models
