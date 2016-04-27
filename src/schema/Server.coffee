mongoose = require 'mongoose'
extend = require 'lodash.assignin'

serverSchema = mongoose.Schema
    role: type: String, crater: suggestions: true
    host: String

# apply methods
extend serverSchema.statics,
    require('./methods/static/Base'),
    require('./methods/static/Server')
extend serverSchema.methods,
    require('./methods/instance/Base'),
    require('./methods/instance/Server')

module.exports = serverSchema
