
methods =
    # returns the property that is used within getName
    # If it's not 'name', override this
    getNameProperty: -> 'name'

module.exports = (schema) ->
    # apply each method to schema
    schema.statics[name] = func for name, func of methods
