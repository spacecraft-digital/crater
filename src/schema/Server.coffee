mongoose = require 'mongoose'

serverSchema = mongoose.Schema
    role: type: String, crater: suggestions: true
    host: String

# apply methods
require('./methods/static/Base') serverSchema
require('./methods/instance/Base') serverSchema
require('./methods/static/Server') serverSchema
require('./methods/instance/Server') serverSchema

module.exports = serverSchema
