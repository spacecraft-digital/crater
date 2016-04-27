mongoose = require 'mongoose'
extend = require 'lodash.assignin'

serverSchema = require './Server'
moduleSchema = require './Module'

stageSchema = mongoose.Schema {
    name: type: String, crater: suggestions: true
    servers: [serverSchema]
    urls: [String]
    modules: [moduleSchema]

    # e.g. SSH, VPN, RDP
    accessMethod: String
    },
    # metadata for Crater
    crater:
        name: 'Stage'

# apply methods
extend stageSchema.statics,
    require('./methods/static/Base')
extend stageSchema.methods,
    require('./methods/instance/Base'),
    require('./methods/instance/Stage')

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
