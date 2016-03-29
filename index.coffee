mongoose = require 'mongoose'

module.exports = (url = 'mongodb://localhost/customers') ->
    mongoose = mongoose.connect url

    # avoid creating models twice
    unless mongoose.modelNames().length
        mongoose.connection.on 'error', (error) -> console.error "Database error: #{error}"
        mongoose.connection.once 'open', (callback) -> console.log 'Database connected'

        mongoose.connection.once 'disconnected', -> console.log '** Mongoose has been disconnected **'

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

    mongoose
