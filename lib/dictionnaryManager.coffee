path = require "path"
async = require "async"

DictionnaryManager =

  dictionnaries = {}

  loadDictionnaries: (pathName, cb) ->
    stats = fs.lstat(pathName, (err, stats) ->
      if err
        cb err
      else
        unless stats.isDirectory() 
          cb new Error("Directory " + directory + " doesn't exists or is not a directory")
        else
          #Load each dictionnary now
          files = fs.readdir(pathName, (err, files) ->
            if err
              cb err
            else
              dictionnaries = []
              async.each(
                files, 
                (file, done) ->
                  if not file.match(/\.cap$/g) and file isnt "." and file isnt ".."
                    dictionnaries[file] = @_directory + file
                , (err) ->
                  cb err, 
              )
          )
    )

  get_dictionnaries_list: (pathName, cb) ->
    DictionnaryManager.loadDictionnaries pathName, (err, dictionnaries) ->
      cb err, dictionnaries