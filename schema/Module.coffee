mongoose = require 'mongoose'

moduleSchema = mongoose.Schema
    name: String
    version: String

# apply methods
require('./methods/static/Base') moduleSchema
require('./methods/instance/Base') moduleSchema

module.exports = moduleSchema
