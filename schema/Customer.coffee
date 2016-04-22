mongoose = require 'mongoose'
projectSchema = require './Project'

customerSchema = mongoose.Schema
    # Full name of the Customer
    name: String
    # Other names the customer may be known by
    aliases: [String]
    # A customer's site
    projects: [projectSchema]
    slackChannel: String

################################################

# Virtual properties
customerSchema.virtual('project', _jiri_aliasTarget: 'projects')
    .get -> @getProject()
customerSchema.virtual('alias', _jiri_aliasTarget: 'aliases')
    .get -> @aliases

# apply methods
require('./methods/static/Base') customerSchema
require('./methods/instance/Base') customerSchema
require('./methods/static/Customer') customerSchema
require('./methods/instance/Customer') customerSchema

# load the 'all name regex string' on connect
mongoose.connection.once 'open', (callback) -> customerSchema.statics.getAllNameRegexString(true)

# Refresh cached regex string if data is changed
customerSchema.post 'save', (doc) => customerSchema.statics.getAllNameRegexString(true)

module.exports = customerSchema
