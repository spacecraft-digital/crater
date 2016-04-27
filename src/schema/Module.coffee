mongoose = require 'mongoose'
extend = require 'lodash.assignin'

moduleSchema = mongoose.Schema
    name: type: String, crater: suggestions: true
    version: String

# apply methods
extend moduleSchema.statics,
    require('./methods/static/Base')
extend moduleSchema.methods,
    require('./methods/instance/Base')

module.exports = moduleSchema
