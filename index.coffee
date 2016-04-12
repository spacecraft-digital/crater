mongoose = require 'mongoose'
Promise = require 'bluebird'
colors = require 'colors'

module.exports = (url = 'mongodb://localhost/customers') ->
    return new Promise (resolve, reject) ->
        if mongoose.connection.readyState > 0
            return resolve mongoose.connection
        else
            mongoose.connection.on 'error', (error) -> console.error colors.bgGreen.red "Database error: #{error}"
            mongoose.connection.once 'open', (callback) -> console.log colors.bgGreen.black 'Database connected'
            mongoose.connection.once 'disconnected', -> console.log colors.bgGreen.red 'Mongoose has been disconnected'

            # avoid creating models twice
            unless mongoose.modelNames().length
                customerSchema = require './schema/Customer'
                projectSchema = require './schema/Project'
                stageSchema = require './schema/Stage'
                serverSchema = require './schema/Server'
                moduleSchema = require './schema/Module'
                repositorySchema = require './schema/Repository'

                Customer = mongoose.model 'Customer', customerSchema
                Project = mongoose.model 'Project', projectSchema
                Stage = mongoose.model 'Stage', stageSchema
                Server = mongoose.model 'Server', serverSchema
                Module = mongoose.model 'Module', moduleSchema
                Repository = mongoose.model 'Repository', repositorySchema

            mongoose.connect(url).then -> resolve mongoose

    .catch (e) -> console.log e.stack
