// Generated by CoffeeScript 1.10.0
(function() {
  var extend, mongoose, repositorySchema;

  mongoose = require('mongoose');

  extend = require('lodash.assignin');

  repositorySchema = mongoose.Schema({
    id: Number,
    name: String,
    codename: String,
    description: String,
    defaultBranch: String,
    sshUrl: String,
    httpUrl: String,
    webUrl: String,
    avatarUrl: String,
    mergeRequestsEnabled: Boolean,
    wikiEnabled: Boolean,
    createdDate: Date,
    lastActivityDate: Date,
    namespace: {
      id: Number,
      name: String,
      codename: String
    }
  }, {
    crater: {
      name: 'Repository'
    }
  });

  repositorySchema.virtual('host').get(function() {
    var ref, ref1, url;
    url = this.sshUrl || this.webUrl || this.httpUrl;
    if ((ref = this.url) != null ? ref.match(/gitlab/i) : void 0) {
      return 'GitLab';
    } else if ((ref1 = this.url) != null ? ref1.match(/github/i) : void 0) {
      return 'GitHub';
    } else {
      return 'unknown';
    }
  });

  repositorySchema.virtual('url', {
    _jiri_aliasTarget: 'webUrl'
  }).get(function() {
    return this.webUrl;
  }).set(function(value) {
    return this.webUrl = value;
  });

  repositorySchema.virtual('cloneUrl', {
    _jiri_aliasTarget: 'sshUrl'
  }).get(function() {
    return this.sshUrl;
  }).set(function(value) {
    return this.sshUrl = value;
  });

  extend(repositorySchema.statics, require('./methods/static/Base'), require('./methods/static/Repository'));

  extend(repositorySchema.methods, require('./methods/instance/Base'), require('./methods/instance/Repository'));

  module.exports = repositorySchema;

}).call(this);