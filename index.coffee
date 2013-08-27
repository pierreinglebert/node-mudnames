fs = require("fs")
path = require("path")

###
This code is a rewrite for NodeJs of the Mudnames php from Xrogaan. <xrogaan - gmail - com>

@author Pierre Inglebert <pierre.inglebert - gmail - com> (c) 2012
@license http://opensource.org/licenses/mit-license.php MIT license
@version 1.0
###
Mudnames = require("./lib/mudnames")

module.exports.Generator = Mudnames
module.exports.get_info = Mudnames.get_info
module.exports.get_file_list = Mudnames.get_file_list
module.exports.generate_name_from = Mudnames.generate_name_from
module.exports.generates_several_names = Mudnames.generates_several_names
