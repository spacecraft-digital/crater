
module.exports =
    getName: (forceNoun = false) ->
        if forceNoun then "#{@role} server" else @role

    getNameRegexString: ->
        return "#{@role}(?: server)?"
