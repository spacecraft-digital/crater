mongoose = require 'mongoose'
regexEscape = require 'escape-string-regexp'
Promise = require 'bluebird'
fuzzy = require 'fuzzy'
NaturalLanguageObjectReference = require '../../../NaturalLanguageObjectReference'

# define variables in scope
allNames = null
allNameRegexString = null

module.exports =
    simplifyName: (name) ->
        name.replace /\b(council|city|town|university|college|london borough|borough|district|of|and|[^a-z\- ]+)\b/gi, ''
            .replace /[ ]{2,}/g, ' '
            .trim()

    # Find by name, allowing a progressively looser match until at least one is found
    # Returns an array of Customer
    findByName: (name) ->
        @findByExactName(name)
            .then (results) => if results.length then results else @findByExactName(name, '_codename')
            .then (results) => if results.length then results else @findBySingleWord(name)
            .then (results) => if results.length then results else @findByPartialName(name)
            .then (results) => if results.length then results else @findByExactName(name, 'aliases')
            .then (results) => if results.length then results else @findBySingleWord(name, 'aliases')
            .then (results) => if results.length then results else @findByPartialName(name, 'aliases')
            .then (results) => if results.length then results else @findByNameParts(name)
            .then (results) => if results.length then results else @findByNameParts(name, 'aliases')
            .then (results) =>
                return results if results.length
                # simplify the input name and run it all again!
                simplifiedName = @simplifyName name
                if simplifiedName != name
                    return @findByName simplifiedName

    # Finds a Customer by fuzzy matching its name and aliases
    # Returns the highest scoring Customer or null if not found
    fuzzyFindOneByName: (name) ->
        # remove 's
        name = name.replace /['’]s?$/i, ''
        return new Promise (resolve, reject) =>
            @find().then (customers) ->
                results = fuzzy.filter name, customers, extract: (customer) -> "#{customer.name} #{customer.aliases.join ' '}"
                return resolve null unless results.length

                bestMatch = score: 0
                for result in results
                    bestMatch = result if result.score > bestMatch.score

                resolve bestMatch.original

    getAllNames: (forceReload) ->
        new Promise (resolve, reject) ->
            if not forceReload and allNames
                return resolve allNames

            console.log 'Loading all Customer names…' if '--debug' in process.argv

            Customer = mongoose.model 'Customer'
            Customer.find()
            .then (customers) =>

                names = []
                addUniqueName = (name) ->
                    name = name.toLowerCase()
                    names.push name if names.indexOf(name) is -1

                for customer in customers
                    addUniqueName regexEscape(customer.name)
                    addUniqueName alias for alias in customer.aliases
                    addUniqueName Customer.simplifyName customer.name

                # sort long -> short
                names.sort (a, b) -> b.length - a.length

                allNames = names

                resolve names

            .catch console.error.bind(console)

    # returns a Promise which resolves to a regular expression containing all customer names and aliases
    getAllNameRegexString: (forceReload) ->
        if not forceReload and allNameRegexString
            return Promise.resolve allNameRegexString

        @getAllNames(forceReload).then (names) ->
            console.log "Found #{names.length} customer names/aliases — storing regex" if '--debug' in process.argv
            allNameRegexString = "[\"'“‘]?(#{names.join('|')})[\"'”’]?"
            return Promise.resolve allNameRegexString

    # given a natural(ish) language string referring to a piece of customer data,
    # returns a SubTargetMatch referencing the desired object
    resolveNaturalLanguage: (query) ->
        ref = new NaturalLanguageObjectReference @, query
        ref.findTarget()
