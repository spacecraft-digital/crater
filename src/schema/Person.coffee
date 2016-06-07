mongoose = require 'mongoose'
extend = require 'lodash.assignin'
carSchema = require './Car'

personSchema = mongoose.Schema {
    # Full name of the Customer
    name: String
    email: String
    cars: [carSchema]
    team: type: String, crater: suggestions: true
    # metadata for Crater
    crater:
        name: 'Person'
}

################################################

# Virtual properties
personSchema.virtual('car', _jiri_aliasTarget: 'cars')
    .get -> @getDefault('cars')

# apply methods
extend personSchema.statics,
    require('./methods/static/Base'),
    require('./methods/static/Entity')
extend personSchema.methods,
    require('./methods/instance/Base')

module.exports = personSchema
