path = require "path"
fs = require "fs"
async = require "async"
Dictionnary = require "./dictionnary"

module.exports = DictionnaryManager =

  dictionnaries: {}

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
              dictionnaries = {}
              async.each files, ((file, done) ->
                if not file.match(/\.cap$/g) and file isnt "." and file isnt ".."
                  dictionnaries[file] = new Dictionnary pathName + path.sep + file
                  done(null)
                else
                  done(null, null)
              ), (err) ->
                cb err, dictionnaries
          )
    )
