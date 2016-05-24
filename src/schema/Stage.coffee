mongoose = require 'mongoose'
extend = require 'lodash.assignin'

serverSchema = require './Server'
softwareSchema = require './Software'

stageSchema = mongoose.Schema {
    name: type: String, crater: suggestions: true
    servers: [serverSchema]
    urls: [String]
    software: [softwareSchema]

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
stageSchema.virtual('cmsVersion').get -> @getSoftware('cms')?.version
stageSchema.virtual('clientVersion').get -> @getSoftware('client')?.version
stageSchema.virtual('customerVersion').get -> @getSoftware('client')?.version
stageSchema.virtual('xfpVersion').get -> @getSoftware('xfp')?.version
stageSchema.virtual('versions', _jiri_aliasTarget: 'software').get -> @software
stageSchema.virtual('modules', _jiri_aliasTarget: 'software').get -> @software
stageSchema.virtual('installedSoftware', _jiri_aliasTarget: 'software').get -> @software

module.exports = stageSchema
