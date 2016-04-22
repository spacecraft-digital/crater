regexEscape = require 'escape-string-regexp'

methods =
    getName: (forceNoun = false) ->
        switch @name.toLowerCase()
            when 'qa' then name = 'QA'
            when 'uat' then name = 'UAT'
            else name = @name.toLowerCase()

        if forceNoun then "#{name} site" else name

    getServer: (role) ->
        regex = new RegExp "^#{role}$", "i"
        return s for s in @servers when s.role?.match regex

    getModule: (name) ->
        regex = new RegExp "^#{name}$", "i"
        return m for m in @modules when m.name?.match regex

    # allow names to be aliased
    getNameRegexString: ->
        names = [regexEscape(@name)]
        switch @name.toLowerCase()
            when 'production'
                names.push 'live'
                names.push '(pre-?)?prod(uction)?'
            when 'qa'
                names.push 'q[\.\-]?a\.?'
            when 'uat'
                names.push 'u[\.\-]?a[\.\-]?t\.?'

        return "(#{names.join('|')})(?: (?:website|site|stage))?"

module.exports = (schema) ->
    # apply each method to schema
    schema.methods[name] = func for name, func of methods