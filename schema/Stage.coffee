mongoose = require 'mongoose'

serverSchema = require './Server'
moduleSchema = require './Module'

stageSchema = mongoose.Schema
    name: String
    servers: [serverSchema]
    urls: [String]
    modules: [moduleSchema]

    # e.g. SSH, VPN, RDP
    accessMethod: String

# apply methods
require('./methods/static/Base') stageSchema
require('./methods/instance/Base') stageSchema
require('./methods/static/Stage') stageSchema
require('./methods/instance/Stage') stageSchema

stageSchema.virtual('url', _jiri_aliasTarget: 'urls')
    .get -> @urls[0]
    .set (urls) ->
        @urls = urls
        @markModified 'urls'

stageSchema.virtual('server', _jiri_aliasTarget: 'servers').get -> @servers[0]
stageSchema.virtual('cmsVersion').get -> @getModule('cms')?.version
stageSchema.virtual('clientVersion').get -> @getModule('client')?.version
stageSchema.virtual('customerVersion').get -> @getModule('client')?.version
stageSchema.virtual('xfpVersion').get -> @getModule('xfp')?.version
stageSchema.virtual('versions', _jiri_aliasTarget: 'modules').get -> @modules
stageSchema.virtual('software', _jiri_aliasTarget: 'modules').get -> @modules
stageSchema.virtual('installedSoftware', _jiri_aliasTarget: 'modules').get -> @modules

module.exports = stageSchema
