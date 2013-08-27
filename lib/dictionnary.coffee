fs = require "fs"
path = require "path"

class Dictionnary
  constructor: (filename) ->
    ###
    Name's Particles
    Currently used : PRE, MID, SUF.
    ###
    @particle =
      PRE: "P"
      MID: "M"
      SUF: "S"
      NOUN: "N"
      ADJ: "A"
      NADJ: "X"

    @capabilities = []
    @dictionnary_name = null
    
    ###
    true if the capabilities isn't random
    @var boolean
    ###
    @forcedcap = false
    
    ###
    Capabilities if forced.
    ###
    @forced_capability = null
    @file_particles = []
    @filename = ""
    if fs.existsSync(filename)
      @filename = filename
      @dictionnary_name = path.basename(@filename)
    else
      throw new Error("File " + filename + " not found")
    self = this
    currentPart = "PRE"
    fs.readFileSync(@filename).toString().split("\n").forEach (line) ->
      line = line.trim()
      if line.match(/^#/g)
        currentPart = line.replace(/^#/g, "")
        if self._particle[currentPart]
          self.file_particles[currentPart] = []
        else
          throw new Error(self.filename + " Unknow particle '" + currentPart + "'")
      else self.file_particles[currentPart].push line  if line.length > 1 and not line.match(/-----/g)

    @set_capabilities()

  ###
  Return tag's short version
  ###
  pfull2lite: (par) ->
    @_particle[par]

  ###
  Return tag's long version
  ###
  plite2full: (par) ->
    for i of @_particle
      return i  if @_particle[i] is par
    null

  set_capabilities: ->
    # Build the acronym to know the capacity of the file.
    check_particle = []
    keys = Object.keys(@file_particles)
    
    for key in keys
      check_particle[i] = @pfull2lite(key)
    
    if check_particle.indexOf("P") isnt -1 and check_particle.indexOf("S") isnt -1
      @capabilities.push "PS"
      @capabilities.push "PMS"  unless check_particle.indexOf("M") is -1
    @capabilities.push "NA"  if check_particle.indexOf("N") isnt -1 and check_particle.indexOf("A") isnt -1
    @capabilities.push "NX"  if check_particle.indexOf("N") isnt -1 and check_particle.indexOf("X") isnt -1
    @capabilities.push "XA"  if check_particle.indexOf("X") isnt -1 and check_particle.indexOf("A") isnt -1
    @capabilities.push "N"  unless check_particle.indexOf("N") is -1
    @capabilities.push "X"  unless check_particle.indexOf("X") is -1

  ###
  Détecte si un fichier doit avoir une génération statique de noms.
  ###
  force_capability: (cap) ->
    unless @capabilities.indexOf(cap) is -1
      @currentcap = cap
      @forcedcap = true
      return true
    false

  ###
  Sélectionne une association de capacité de façons aléatoire et la retourne.
  ###
  select_capability: ->
    @check_cap_file()  if @forced_capability is null
    
    # If a forced capability exists, we apply it.
    if @forced_capability.length > 0
      i = 0

      while i < @forced_capability.length
        
        # as $fnct => $args
        unless typeof this[@forced_capability[i].fn] is "function"
          @force_capability @forced_capability[i].arg
        else
          this[@forced_capability[i].fn] @forced_capability[i].arg
        i++
    unless @forcedcap
      if @capabilities.length > 1
        @currentcap = @capabilities[Math.floor(Math.random() * (@capabilities.length - 1))]
      else if @capabilities.length is 1
        @currentcap = @capabilities[0]
      else
        throw new Error(@directory + @file + ":select_capability: No capability found.")
    @currentcap

  ###
  Check if a capability file is present for the current file.

  If it's present, its content is loaded into the core. It is usefull
  to force actions in the choice of particles. Some dictionnary have 3
  set of particles like 'PMS', but if the object return only a name
  containing the parts 'P' and 'S', the name could mean absolutly nothing.
  So, the capability file is here to force the object to get the full
  capacities of the dictionnary by triggering the method self::force_capability().

  .cap files format :
  [functionName][:arguments]
  ###
  check_cap_file: ->
    
    # Non-lethal error here. If we can't open it, we leave it alone.
    @forced_capability = []
    if fs.existsSync(@filename + ".cap")
      @forced_cap = true
      self = this
      fs.readFileSync(@filename + ".cap").toString().split("\n").forEach (line) ->
        line = line.trim()
        if line.length > 0
          vals = line.split(":")
          self.forced_capability.push
            fn: vals[0]
            args: vals[1]
      true
    else
      false

  ###
  Sors une partie de nom aléatoire selon le tag et le fichier associé.
  ###
  random_particle_from: (particle) ->
    new Error(@filename + ":load_random_particle: Unknow particle '" + particle + "'") unless @file_particles[particle]
    return ""  if @file_particles[particle].length is 0
    randomId = 0
    loop
      randomId = Math.floor(Math.random() * (@file_particles[particle].length - 1))
      break  if @file_particles[particle][randomId]
      break unless 1
    @file_particles[particle][randomId]

  ###
  retourne la liste des parties présente dans le fichier dictionnaire
  ###
  get_file_particle_list: ->
    Object.keys @file_particles

  get_file_capability_list: ->
    @capabilities

  is_forced: ->
    @forcedcap

module.exports = Dictionnary