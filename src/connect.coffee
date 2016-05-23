mongoose = require 'mongoose'
Promise = require 'bluebird'
mongoose.Promise = Promise
colors = require 'colors'
Crater = require './Crater'

module.exports = (url = 'mongodb://localhost/customers') ->
    return new Promise (resolve, reject) ->
        if mongoose.connection.readyState > 0
            return resolve mongoose.connection
        else
            mongoose.connection.on 'error', (error) -> console.error colors.bgGreen.red "Database error: #{error}"
            mongoose.connection.once 'open', (callback) -> console.log colors.bgGreen.black 'Database connected'
            mongoose.connection.once 'disconnected', -> console.log colors.bgGreen.red 'Mongoose has been disconnected'

            # avoid creating models twice
            unless mongoose.modelNames().length
                Crater.getModels()
                # load the 'all name regex string' on connect
                mongoose.connection.once 'open', (callback) -> Crater.getSchema('Customer').statics.getAllNameRegexString(true)

            mongoose.connect(url).then -> resolve mongoose

    .catch (e) -> console.log e.stack
