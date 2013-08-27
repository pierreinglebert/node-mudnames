fs = require "fs"
Dictionnary = require "./Dictionnary"

###
Build a list of files as dictionnaries list.
@param string directory directory where the dictionnaries can be found
###
class Mudnames_Dictionnaries
  constructor: (directory) ->
    @_directory = null
    @_dictionnaries = []
    @_dictionnaries_instance = []
    @_caplist = ["PS", "PMS", "PM", "N", "X", "NA", "XA", "NX"]
    @_actions = dictionnaries: {}

    directory = __dirname + "/data/"  unless directory
    stats = fs.lstatSync(directory)
    
    # Yes it is
    throw new Error("Directory " + directory + " doesn't exists or is not a directory")  unless stats.isDirectory()
    @_directory = directory
    files = fs.readdirSync(@_directory)
    
    for file in files
      @_dictionnaries[file] = @_directory + file  if not file.match(/\.cap$/g) and file isnt "." and file isnt ".."
    

  ###
  Return true if the dictionnary file exists. If not, return false.
  ###
  dictionnary_exists: (name) ->
    @_dictionnaries[name]?

  opened_dictionnary: (name) ->
    @_dictionnaries_instance[name]?


  ###
  Open a dictionnary object and return its instance.
  @param string $name
  @return Mydnames_Dictionnary
  ###
  open_dictionnary: (name) ->
    name = "random"  unless name
    switch name
      when "", "random"
        keys = Object.keys(@_dictionnaries)
        name = keys[Math.floor((Math.random() * (keys.length - 1)))]
      else
        throw new Error("Dictionnary '" + name + "' doesn't exists.")  unless @dictionnary_exists(name)
    return @_dictionnaries_instance[name]  if @opened_dictionnary(name)
    @_dictionnaries_instance[name] = new Mudnames_Dictionnary(@_dictionnaries[name])
    @_actions.dictionnaries[name] = {}
    @_actions.dictionnaries[name].capabilities = @_dictionnaries_instance[name].get_file_capability_list()
    @_actions.dictionnaries[name].file = @_dictionnaries_instance[name].filename
    @_actions.dictionnaries[name].is_forced = @_dictionnaries_instance[name].is_forced()
    @_dictionnaries_instance[name]

  get_name = (dictionnary) ->
    current_cap = @_dictionnaries_instance[dictionnary].select_capability()
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
      particle = @_dictionnaries_instance[dictionnary].plite2full(capa)
      name += @_dictionnaries_instance[dictionnary].random_particle_from(particle)
    
    name = name.charAt(0).toUpperCase() + name.substr(1)
    @_actions.dictionnaries[dictionnary].generated = {}  unless @_actions.dictionnaries[dictionnary].generated
    @_actions.dictionnaries[dictionnary].generated[name] =
      capability: capability
      particles: particle
    name

  ###
  Return a list of files indexed by their basename
  ###
  get_dictionnaries_list: ->
    @_dictionnaries

  get_name_informations: (dico, name) ->
    if @_action.dictionnaries and @_action.dictionnaries[dico] and @_action.dictionnaries[dico].generated and @_action.dictionnaries[dico].generated[name]
      @_action.dictionnaries[dico].generated[name]
    else
      false

  get_file_informations: (file) ->
    @_actions.dictionnaries[file]

module.exports = Dictionnaries