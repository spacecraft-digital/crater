mongoose = require 'mongoose'
extend = require 'lodash.assignin'

carSchema = mongoose.Schema {
    reg: String
    colour: type: String, crater: suggestions: true
    make: type: String, crater: suggestions: true
    model: type: String, crater: suggestions: true
    },
    # metadata for Crater
    crater:
        name: 'Car'

################################################

# apply methods
extend carSchema.statics,
    require('./methods/static/Base')
extend carSchema.methods,
    require('./methods/instance/Base')

module.exports = carSchema
