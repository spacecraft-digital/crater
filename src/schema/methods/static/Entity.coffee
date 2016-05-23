mongoose = require 'mongoose'
regexEscape = require 'escape-string-regexp'
Promise = require 'bluebird'
fuzzy = require 'fuzzy'
NaturalLanguageObjectReference = require '../../../NaturalLanguageObjectReference'

module.exports =
    # Find by name, allowing a progressively looser match until at least one is found
    # Returns a single Customer or NULL
    findOneByName: (name) ->
        @findByName(name).then (entities) -> if entities?.length then entities[0] else null

    # Find by name, allowing a progressively looser match until at least one is found
    # Returns an array of documents
    findByName: (name) ->
        throw new Error "Name is required" unless name

        @findByExactName(name)
            .then (results) -> if results.length then results else @findBySingleWord(name)
            .then (results) -> if results.length then results else @findByPartialName(name)
            .then (results) -> if results.length then results else @findByNameParts(name)

    # Find where the full name exactly matches the query
    findByExactName: (name, property = 'name') ->
        o = {}
        o[property] = new RegExp("^#{regexEscape(name||'')}$", 'i')
        @find(o).sort(name: 1)

    # Find where the name contains the query as a whole word
    findBySingleWord: (name, property = 'name') ->
        o = {}
        o[property] = new RegExp("\\b#{regexEscape(name||'')}\\b", 'i')
        @find(o).sort(name: 1)

    # Find where the name contains the query as a whole
    findByPartialName: (name, property = 'name') ->
        o = {}
        o[property] = new RegExp("#{regexEscape(name||'')}", 'i')
        @find(o).sort(name: 1)

    # Find where the name contains each of the words in the query, in any order
    findByNameParts: (name, property = 'name') ->
        o = $and: []
        for word in name.split ' '
            expression = {}
            expression[property] = new RegExp("\\b#{regexEscape(word||'')}\\b", 'i')
            o['$and'].push expression
        @find(o).sort(name: 1)

    # given a natural(ish) language string referring to a piece of customer data,
    # returns a SubTargetMatch referencing the desired object
    resolveNaturalLanguage: (query) ->
        ref = new NaturalLanguageObjectReference @, query
        ref.findTarget()
