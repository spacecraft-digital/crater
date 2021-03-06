// Generated by CoffeeScript 1.11.1
(function() {
  var Promise, SubTargetMatch, baseMethods, projectSchema, regexEscape;

  Promise = require('bluebird');

  projectSchema = require('../../Project');

  regexEscape = require('escape-string-regexp');

  SubTargetMatch = require('../../../SubTargetMatch');

  baseMethods = require('./Base');

  module.exports = {
    getName: function(forceNoun) {
      if (forceNoun == null) {
        forceNoun = false;
      }
      if (this.name === 'default' && this.defaultProject) {
        return 'main project';
      } else if (forceNoun) {
        if (this.name) {
          return this.name + " project";
        } else {
          return 'exciting new project';
        }
      } else {
        return this.name;
      }
    },
    getFullName: function() {
      return (this.parent().getName()) + " " + (this.getName(true));
    },
    getStage: function(stage) {
      var i, len, ref, regex, s;
      regex = new RegExp("^" + stage + "$", "i");
      ref = this.stages;
      for (i = 0, len = ref.length; i < len; i++) {
        s = ref[i];
        if (s.name.match(regex)) {
          return s;
        }
      }
    },
    getRepo: function(name) {
      var i, len, r, ref;
      if (name == null) {
        name = null;
      }
      if (name === null) {
        return this.repos[0];
      } else {
        ref = this.repos;
        for (i = 0, len = ref.length; i < len; i++) {
          r = ref[i];
          if (name.match(new RegExp("^(" + (r.getNameRegexString()) + ")\\b\\s*", 'i'))) {
            return r;
          }
        }
      }
    },
    getDefault: function(property) {
      switch (property) {
        case 'stages':
          return this.getStage('production');
        default:
          return baseMethods.getDefault.call(this, property);
      }
    },
    getNameRegexString: function() {
      var names;
      names = [regexEscape(this.name)];
      if (this.defaultProject) {
        names.push('main', 'website', 'main website');
      }
      return "(" + (names.join('|')) + ")";
    },

    /*
      * Get the Jira mapping ID for this project
      * Returns a promise that resolves to the mapping ID (i.e. Reporting Customers string)
      * If the value is null, these values will be imported from Jira first.
      * @param  {Jira} jira    Instance of Jira class
      * @return Promise
     */
    getJiraMappingId: function(jira) {
      if (!(jira != null ? jira.loadReportingCustomerValues : void 0)) {
        throw "getJiraMappingId requires a Jira instance as the first parameter";
      }
      return new Promise((function(_this) {
        return function(resolve, reject) {
          if (_this._mappingId_jira !== null) {
            return resolve(_this._mappingId_jira);
          }
          return jira.loadReportingCustomerValues().then(_this.getJiraMappingId(jira));
        };
      })(this));
    }
  };

}).call(this);
