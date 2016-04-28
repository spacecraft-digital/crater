
module.exports =
    toObjectAtDepth: (depth) ->
        if depth is 0
            return @toObject()
        else
            return {
                description: @description
                sshUrl: @sshUrl
                webUrl: @webUrl
                mergeRequestsEnabled: @mergeRequestsEnabled
                wikiEnabled: @wikiEnabled
                createdDate: @createdDate
                lastActivityDate: @lastActivityDate
                namespace: @namespace.name
            }

    getName: (forceNoun = false) ->
        name = @host || ''
        name += ' repo' if forceNoun
        name

    # allow names to be aliased
    getNameRegexString: ->
        return "#{@host}(?: repo(sitory)?)?"
