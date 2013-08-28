path = require "path"
EventEmitter = require('events').EventEmitter
DictionnaryManager = require "./dictionnaryManager"
async = require "async"

class Mudnames extends EventEmitter
  constructor: (options = {}) ->
    options.path = options.path or __dirname + path.sep + ".." + path.sep + "data"
    self = this
    DictionnaryManager.loadDictionnaries(options.path, (err, dictionnaries) ->
      throw err if err
      @dictionnaries = dictionnaries
      self.emit 'dictionnaries', dictionnaries
    )

  getList: (cb) ->
    if @dictionnaries?
      cb @dictionnaries
    @once('dictionnaries', (dict) ->
      cb(dict)
    )

  generate: (dictionnaryName, number, cb) ->
    self = this
    async.times number, ((n, next) ->
      self.generateOne dictionnaryName, (name) ->
        next null, name
    ), (err, names) ->
      cb names

  generateOne: (dictionnaryName, cb) ->
    #console.log dictionnaryName
    #console.log cb
    @getList (dictionnaries) ->
      if dictionnaryName == "random"
        keys = Object.keys(dictionnaries)
        dictionnaryName = keys[Math.floor((Math.random() * (keys.length - 1)))]

      current_cap = dictionnaries[dictionnaryName].select_capability()
      capability = "NN"
      switch current_cap
        when "N"
          capability = "NN"
        when "X"
          capability = "XX"
        when "XA"
          capability = "N" + ((if Math.round(Math.random()) then "A" else "X"))
        when "NX"
          capability = ((if Math.round(Math.random()) then "N" else "A")) + "A"
        else
          capability = current_cap
      name = ""
      particle = ""

      for capa in capability
        particle = dictionnaries[dictionnaryName].plite2full(capa)
        name += dictionnaries[dictionnaryName].random_particle_from(particle)
      
      name = name.charAt(0).toUpperCase() + name.substr(1)
      cb name

module.exports = (options) ->
  new Mudnames options
