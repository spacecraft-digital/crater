
methods =
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

    getName: -> "#{@host} repo"

    # allow names to be aliased
    getNameRegexString: ->
        return "#{@host}(?: repo(sitory)?)?"

module.exports = (schema) ->
    # apply each method to schema
    schema.methods[name] = func for name, func of methods