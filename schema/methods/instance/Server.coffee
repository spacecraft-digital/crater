
methods =
    getName: (forceNoun = false) ->
        if forceNoun then "#{@role} server" else @role

    getNameProperty: ->
        'role'

    getNameRegexString: ->
        return "#{@role}(?: server)?"


module.exports = (schema) ->
    # apply each method to schema
    schema.methods[name] = func for name, func of methods
