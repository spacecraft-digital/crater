mongoose = require 'mongoose'
extend = require 'lodash.assignin'

softwareSchema = mongoose.Schema {
    name: type: String, crater: suggestions: true
    version: String
    },
    # metadata for Crater
    crater:
        name: 'Software'

# apply methods
extend softwareSchema.statics,
    require('./methods/static/Base')
extend softwareSchema.methods,
    require('./methods/instance/Base')

module.exports = softwareSchema
