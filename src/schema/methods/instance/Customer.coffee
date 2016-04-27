projectSchema = require '../../Project'
regexEscape = require 'escape-string-regexp'
SubTargetMatch = require '../../../SubTargetMatch'
BaseMethods = require './Base'

module.exports =
    getProject: (name = null) ->
        if name is null
            return @getDefault('projects')
        else
            regex = new RegExp "^#{regexEscape(name)}$", "i"
            return p for p in @projects when p.name.match regex

    getRepo: (id) ->
        for project in @projects
            for repo in project.repos
                return repo if repo.id is id
        return

    addAlias: (alias) ->
        @aliases.push alias if alias not in @aliases

    # Returns a default single member of array property 'property'
    # For projects, this is the one named 'default'
    getDefault: (property) ->
        switch property
            # special case for default project
            when 'projects'
                project = p for p in @projects when p.defaultProject
                # return first project if 'default' one not found
                return project or @projects[0]
            else
                return @getDefault property


    # Returns something that matches the start of the query
    #
    # @return object with properties:
    #   target   the property that matched the query string
    #   keywords the string found at the start of the query
    #   query    the updated query, with the match removed
    findSubtarget: (query) ->
        o = BaseMethods.findSubtarget.call this, query
        return o if o

        # no match on property or project name, so assume it's a property of the default project
        defaultProject = @getProject()
        return if defaultProject
            new SubTargetMatch
                target: defaultProject
                keyword: ''
                property: 'project'
                query: query

        return false
