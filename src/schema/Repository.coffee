mongoose = require 'mongoose'
extend = require 'lodash.assignin'

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
    .set (value) -> @webUrl = value

# alias cloneUrl -> sshUrl
repositorySchema.virtual('cloneUrl', _jiri_aliasTarget: 'sshUrl')
    .get -> @sshUrl
    .set (value) -> @sshUrl = value

# apply methods
extend repositorySchema.statics,
    require('./methods/static/Base'),
    require('./methods/static/Repository')
extend repositorySchema.methods,
    require('./methods/instance/Base'),
    require('./methods/instance/Repository')

module.exports = repositorySchema
