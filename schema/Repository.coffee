mongoose = require 'mongoose'

repositorySchema = mongoose.Schema
    id: Number
    name: String
    # path in Gitlab
    codename: String
    description: String

    # default_branch in Gitlab
    defaultBranch: String

    # ssh_url_to_repo in Gitlab
    sshUrl: String
    # http_url_to_repo in Gitlab
    httpUrl: String
    # web_url in Gitlab
    webUrl: String

    # avatar_url in Gitlab
    avatarUrl: String

    # merge_requests_enabled in Gitlab
    mergeRequestsEnabled: Boolean
    # wiki_enabled in Gitlab
    wikiEnabled: Boolean

    # created_at in Gitlab
    createdDate: Date
    # last_activity_at in Gitlab
    lastActivityDate: Date

    namespace:
        id: Number
        name: String
        # path in Gitlab
        codename: String

(require './_Base').applyTo repositorySchema

repositorySchema.methods.toObjectAtDepth = (depth) ->
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

repositorySchema.methods.getName = -> "#{@host} repo"

# allow names to be aliased
repositorySchema.methods.getNameRegexString = ->
    return "#{@host}(?: repo(sitory)?)?"

repositorySchema.virtual('host')
    .get ->
        url = @sshUrl or @webUrl or @httpUrl
        if @url?.match /gitlab/i
            return 'GitLab'
        else if @url?.match /github/i
            return 'GitHub'
        else
            return 'unknown'

# alias url -> webUrl
repositorySchema.virtual('url', _jiri_aliasTarget: 'webUrl')
    .get -> @webUrl
    .set (value) ->
        @webUrl = value
        @markModified 'webUrl'

# alias url -> webUrl
repositorySchema.virtual('cloneUrl', _jiri_aliasTarget: 'sshUrl')
    .get -> @sshUrl
    .set (value) ->
        @sshUrl = value
        @markModified 'sshUrl'

module.exports = repositorySchema