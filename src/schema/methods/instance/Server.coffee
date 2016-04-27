
module.exports =
    getName: (forceNoun = false) ->
        if forceNoun
            if !@role
                return 'some kind of server'
            else if m = @role.match /^([a-z\-]+)(\d+)$/i
                return "#{m[1]} server #{m[2]}"
            else
                return "#{@role} server"
        else
            return @role

    getNameRegexString: ->
        return "#{@role}(?: server)?"
