Promise = require 'bluebird'
projectSchema = require '../../Project'
regexEscape = require 'escape-string-regexp'
SubTargetMatch = require '../../../SubTargetMatch'
baseMethods = require './Base'

module.exports =
    getName: (forceNoun = false) ->
        if @name is 'default' and @defaultProject
            return 'main project'
        else if forceNoun
            return "#{@name} project"
        else
            return @name

    getStage: (stage) ->
        regex = new RegExp "^#{stage}$", "i"
        return s for s in @.stages when s.name.match regex

    getRepo: (name = null) ->
        if name is null
            return @repos[0]
        else
            return r for r in @repos when name.match new RegExp("^(#{r.getNameRegexString()})\\b\\s*", 'i')

    # Returns a default single member of array property 'property'
    # For projects, this is the one named 'default'
    getDefault: (property) ->
        switch property
            when 'stages' then return @getStage 'production'
            else return baseMethods.getDefault.call this, property

    # allow names to be aliased
    getNameRegexString: ->
        names = [regexEscape(@name)]
        if @defaultProject
            names.push 'main', 'website', 'main website'

        return "(#{names.join('|')})"

    ###
     # Get the Jira mapping ID for this project
     # Returns a promise that resolves to the mapping ID (i.e. Reporting Customers string)
     # If the value is null, these values will be imported from Jira first.
     # @param  {Jira} jira    Instance of Jira class
     # @return Promise
    ###
    getJiraMappingId: (jira) ->
        throw "getJiraMappingId requires a Jira instance as the first parameter" unless jira?.loadReportingCustomerValues
        return new Promise (resolve, reject) =>
            return resolve @_mappingId_jira if @_mappingId_jira != null
            # import values from Jira and try again
            jira.loadReportingCustomerValues().then @getJiraMappingId jira
