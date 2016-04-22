mongoose = require 'mongoose'
Promise = require 'bluebird'
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

            mongoose.connect(url).then -> resolve mongoose

    .catch (e) -> console.log e.stack
