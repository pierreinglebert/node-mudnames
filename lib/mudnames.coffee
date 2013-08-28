Dictionnaries = require "./dictionnaries"


class Mudnames



Mudnames.instances = {}

module.exports.getList = (folder, cb) ->
  @dictionnaries  = new Dictionnaries

#pathName = __dirname + path.sep + ".." + path.sep + "data" + path.sep  unless directory

###
  constructor: (directory) ->
    @_dictionnaries = []
    @latest_name = ""
    @latest_file = ""
    @_dictionnaries = new Dictionnaries(directory)

  generate_name_from = (file) ->
    dictionnary = @_dictionnaries.open_dictionnary(file)
    @latest_file = dictionnary.filename
    @latest_name = @_dictionnaries.get_name(dictionnary.dictionnary_name)
    @latest_name

  generates_several_names = (number, file) ->
    names = []
    names.push @generate_name_from(file)  while number-- > 0
    names

  get_file_list = ->
    Object.keys @_dictionnaries.get_dictionnaries_list()

  get_info = (key, file) ->
    file = @latest_file  unless file
    info = @_dictionnaries.get_file_informations(file)
    return false  if not info or not info[key]
    info[key]

Mudnames.getInstance = (config, auto_create = true) ->
  Mudnames._instance = new Mudnames()  if auto_create and not Mudnames._instance
  Mudnames._instance

Mudnames.get_file_list = ->
  Object.keys Mudnames.getInstance()._dictionnaries.get_dictionnaries_list()

Mudnames.generate_name_from = (file) ->
  Mudnames.getInstance().generate_name_from file

Mudnames.generates_several_names = (number, file) ->
  Mudnames.getInstance().generates_several_names number, file

Mudnames.get_info = (key, file) ->
  Mudnames.getInstance().get_info key, file

###
