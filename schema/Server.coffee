mongoose = require 'mongoose'
regexEscape = require 'escape-string-regexp'

serverSchema = mongoose.Schema
    role: String
    host: String

# apply methods
require('./methods/static/Base') serverSchema
require('./methods/instance/Base') serverSchema
require('./methods/static/Server') serverSchema
require('./methods/instance/Server') serverSchema

module.exports = serverSchema
