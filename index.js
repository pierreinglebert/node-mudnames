var fs = require('fs');
var path = require('path');

var ucfirst = function(str) {
    return str.charAt(0).toUpperCase() + str.substr(1);
};

/**
 *  This code is a rewrite for NodeJs of the Mudnames php from Xrogaan. <xrogaan - gmail - com>
 *
 * @author Pierre Inglebert <pierre.inglebert - gmail - com> (c) 2012
 * @license http://opensource.org/licenses/mit-license.php MIT license
 * @version 1.0
 */


function Mudnames_Dictionnary(filename) {
    /**
     * Name's Particles
     * Currently used : PRE, MID, SUF.
     */
    this._particle = {
        'PRE': 'P',
        'MID': 'M',
        'SUF': 'S',
        'NOUN': 'N',
        'ADJ': 'A',
        'NADJ': 'X'
    };
    this.capabilities = [];
    this.dictionnary_name = null;

    /**
     * true if the capabilities isn't random
     * @var boolean
     */
    this.forcedcap = false;

    /**
     * Capabilities if forced.
     */
    this.forced_capability = [];

    /**
     * File's particles list.
     * @var array
     */
    this.file_particles = [];

    this.debug = false;

    this.filename = '';

    if (fs.existsSync(filename)) {
        this.filename = filename;
        this.dictionnary_name = path.basename(this.filename);
    }
    else {
        throw new Error('File ' + filename + ' not found');
    }
    var self = this;
    var currentPart = 'PRE';
    fs.readFileSync(this.filename).toString().split('\n').forEach(function(line) {
        line = line.trim();
        if (line.match(/^#/g)) {
            currentPart = line.replace(/^#/g, "");
            if (self._particle[currentPart]) {
                self.file_particles[currentPart] = [];
            }
            else {
                throw new Error(self.filename + " Unknow particle '" + currentPart + "'");
            }
        }
        else if (line.length > 1 && !line.match(/-----/g)) {
            self.file_particles[currentPart].push(line);
        }
    });
    this.set_capabilities();
}

/**
 * Retourne la version courte d'un tag
 */
Mudnames_Dictionnary.prototype.pfull2lite = function(par) {
    return this._particle[par];
};

/**
 * Retourne la version longue d'un tag
 */
Mudnames_Dictionnary.prototype.plite2full = function(par) {
    for (var i in this._particle) {
        if (this._particle[i] == par) {
            return i;
        }
    }
    return null;
};

Mudnames_Dictionnary.prototype.set_capabilities = function() {
    // Build the acronym to know the capacity of the file.
    var check_particle = [];
    var keys = Object.keys(this.file_particles);
    for (var i = 0; i < keys.length; i++) {
        check_particle[i] = this.pfull2lite(keys[i]);
    }

    if (check_particle.indexOf('P') != -1 && check_particle.indexOf('S') != -1) {
        this.capabilities.push('PS');
        if (check_particle.indexOf('M') != -1) {
            this.capabilities.push('PMS');
        }
    }

    if (check_particle.indexOf('N') != -1 && check_particle.indexOf('A') != -1) {
        this.capabilities.push('NA');
    }

    if (check_particle.indexOf('N') != -1 && check_particle.indexOf('X') != -1) {
        this.capabilities.push('NX');
    }

    if (check_particle.indexOf('X') != -1 && check_particle.indexOf('A') != -1) {
        this.capabilities.push('XA');
    }

    if (check_particle.indexOf('N') != -1) {
        this.capabilities.push('N');
    }

    if (check_particle.indexOf('X') != -1) {
        this.capabilities.push('X');
    }
};

/**
 * Détecte si un fichier doit avoir une génération statique de noms.
 */
Mudnames_Dictionnary.prototype.force_capability = function(cap) {
    if (this.capabilities.indexOf(cap) != -1) {
        this.currentcap = cap;
        this.forcedcap = true;
        return true;
    }
    return false;
};

/**
 * Sélectionne une association de capacité de façons aléatoire et la retourne.
 */
Mudnames_Dictionnary.prototype.select_capability = function() {

    this.check_cap_file();

    // If a forced capability exists, we apply it.
    if (this.forced_capability.length > 0) {
        for(var i=0; i < this.forced_capability.length;i++) {
            // as $fnct => $args
            if(typeof this[this.forced_capability[i].fn] != "function") {
                this.force_capability(this.forced_capability[i].arg);
            } else {
                this[this.forced_capability[i].fn](this.forced_capability[i].arg);
            }
        }
    }
    if (!this.forcedcap) {
        if (this.capabilities.length>1) {
            this.currentcap = this.capabilities[Math.floor(Math.random()*(this.capabilities.length-1))];
        } else if(this.capabilities.length == 1) {
            this.currentcap = this.capabilities[0];
        } else {
            throw new Error(this.directory + this.file + ":select_capability: No capability found.");
        }
    }
    return this.currentcap;
};

/**
 * Check if a capability file is present for the current file.
 *
 * If it's present, its content is loaded into the core. It is usefull
 * to force actions in the choice of particles. Some dictionnary have 3
 * set of particles like 'PMS', but if the object return only a name
 * containing the parts 'P' and 'S', the name could mean absolutly nothing.
 * So, the capability file is here to force the object to get the full
 * capacities of the dictionnary by triggering the method self::force_capability().
 *
 * .cap files format :
 * [functionName][:arguments]
 */
Mudnames_Dictionnary.prototype.check_cap_file = function() {
    // Non-lethal error here. If we can't open it, we leave it alone.
    if (fs.existsSync(this.filename + '.cap')) {
        this.forced_cap = true;
        var self = this;
        fs.readFileSync(this.filename + '.cap').toString().split('\n').forEach(function(line) {
            line = line.trim();
            if(line.length > 0) {
                var vals = line.split(':');
                self.forced_capability.push({fn: vals[0], args: vals[1]});
            }
        });
        return true;
    } else {
        return false;
    }
};



/**
 * Sors une partie de nom aléatoire selon le tag et le fichier associé.
 */
Mudnames_Dictionnary.prototype.random_particle_from = function(particle) {
    if(!this.file_particles[particle]) {
        new Error(this.filename + ":load_random_particle: Unknow particle ' "+ particle+ " '");
    }

    if(this.file_particles[particle].length === 0) {
        return '';
    }
    
    var randomId = 0;
    
    do {
        randomId = Math.floor(Math.random()*(this.file_particles[particle].length-1));
        if(this.file_particles[particle][randomId]) 
            break;
    } while(1);

    //this.debug.particles_used[particle] = this.file_particles[particle][randomId];

    return this.file_particles[particle][randomId];
};


/**
 * retourne la liste des parties présente dans le fichier dictionnaire
 */
Mudnames_Dictionnary.prototype.get_file_particle_list = function() {
    return Object.keys(this.file_particles);
};

Mudnames_Dictionnary.prototype.get_file_capability_list = function() {
    return this.capabilities;
};

Mudnames_Dictionnary.prototype.is_forced = function() {
    return this.forcedcap;
};

/**
 * Build a list of files as dictionnaries list.
 * @param string directory directory where the dictionnaries can be found
 */
function Mudnames_Dictionnaries(directory) {
    this._directory = null;
    this._dictionnaries = [];
    this._dictionnaries_instance = [];
    this._caplist = ["PS", "PMS", "PM", "N", "X", "NA", "XA", "NX"],
    this._actions = {
        dictionnaries: {}
    };

    if (!directory) {
        directory = process.cwd() + '/mudnames/data/';
    }

    var stats = fs.lstatSync(directory);
    if (!stats.isDirectory()) {
        // Yes it is
        throw new Error('Directory ' + directory + ' doesn\'t exists or is not a directory');
    }

    this._directory = directory;

    var files = fs.readdirSync(this._directory);
    for (var i = 0; i < files.length; i++) {
        var file = files[i];
        if (!file.match(/\.cap$/g) && file != '.' && file != '..') {
            this._dictionnaries[file] = this._directory + file;
        }
    }

    //    ksort($this->_dictionnaries);
}

/**
 * Return true if the dictionnary file exists. If not, return false.
 */
Mudnames_Dictionnaries.prototype.dictionnary_exists = function(name) {
    return (this._dictionnaries[name] !== undefined && this._dictionnaries[name] !== null);
};

Mudnames_Dictionnaries.prototype.opened_dictionnary = function(name) {
    return (this._dictionnaries_instance[name] !== undefined && this._dictionnaries_instance[name] !== null);
};

/**
 * Open a dictionnary object and return its instance.
 * @param string $name
 * @return Mydnames_Dictionnary
 */
Mudnames_Dictionnaries.prototype.open_dictionnary = function(name) {
    if (!name) {
        name = 'random';
    }
    if (this.opened_dictionnary(name)) {
        return this._dictionnaries_instance[name];
    }

    switch (name) {
    case '':
    case 'random':
        var keys = Object.keys(this._dictionnaries);
        name = keys[Math.floor((Math.random() * (keys.length - 1)))];
        break;
    default:
        if (this.dictionnary_exists(name)) {
            throw new Error("Dictionnary '" + name + "' doesn't exists.");
        }
    }
    this._dictionnaries_instance[name] = new Mudnames_Dictionnary(this._dictionnaries[name]);
    
    this._actions.dictionnaries[name] = {};
    this._actions.dictionnaries[name].capabilities = this._dictionnaries_instance[name].get_file_capability_list();
    this._actions.dictionnaries[name].file = this._dictionnaries_instance[name].filename;
    this._actions.dictionnaries[name].is_forced = this._dictionnaries_instance[name].is_forced();

    return this._dictionnaries_instance[name];
};

Mudnames_Dictionnaries.prototype.get_name = function(dictionnary) {
    var current_cap = this._dictionnaries_instance[dictionnary].select_capability();
    var capability = 'NN';
    switch (current_cap) {
    case 'N':
        capability = 'NN';
        break;
    case 'X':
        capability = 'XX';
        break;
    case 'XA':
        capability = 'N' + (Math.round(Math.random()) ? 'A' : 'X');
        break;
    case 'NX':
        capability = (Math.round(Math.random()) ? 'N' : 'A') + 'A';
        break;
    default:
        capability = current_cap;
    }

    var name = '';
    var particle = '';
    for (var i = 0; i < capability.length; i++) {
        particle = this._dictionnaries_instance[dictionnary].plite2full(capability[i]);
        name += this._dictionnaries_instance[dictionnary].random_particle_from(particle);
    }

    name = ucfirst(name);
    if(!this._actions.dictionnaries[dictionnary].generated) {
        this._actions.dictionnaries[dictionnary].generated = {};
    }
    this._actions.dictionnaries[dictionnary].generated[name] = {
        'capability': capability,
        'particles': particle
    };

    return name;
};

/**
 * Return a list of files indexed by their basename
 */
Mudnames_Dictionnaries.prototype.get_dictionnaries_list = function() {
    return this._dictionnaries;
};

Mudnames_Dictionnaries.prototype.get_name_informations = function(dico, name) {
    if (this._action.dictionnaries && this._action.dictionnaries[dico] && this._action.dictionnaries[dico].generated && this._action.dictionnaries[dico].generated[name]) {
        return this._action.dictionnaries[dico].generated[name];
    }
    else {
        return false;
    }
};

Mudnames_Dictionnaries.prototype.get_file_informations = function(file) {
    return this._actions.dictionnaries[file];
};


function Mudnames(config) {
    this._dictionnaries = [];
    this.latest_name = '';
    this.latest_file = '';
     
    this._dictionnaries = new Mudnames_Dictionnaries(config);
}

Mudnames.getInstance = function(config, auto_create) {
    if(auto_create === undefined) auto_create = true;
    if(auto_create && !Mudnames._instance) {
        Mudnames._instance = new Mudnames();
    }
    return Mudnames._instance;
};
    

Mudnames.generate_name_from = function(file) {
    var mudnames = Mudnames.getInstance();
    var dictionnary = mudnames._dictionnaries.open_dictionnary(file);
    mudnames.latest_file = dictionnary.filename;
    mudnames.latest_name = mudnames._dictionnaries.get_name(dictionnary.dictionnary_name);
    return mudnames.latest_name;
};

Mudnames.generates_several_names = function(number, file) {
    var names = [];
    while(number-- > 0) {
        names.push(Mudnames.generate_name_from(file));
    }
    return names;
};

Mudnames.get_info = function(key, file) {
    var mudnames = Mudnames.getInstance();   
    if(!file) {
        file = mudnames.latest_file;
    }
    var info = mudnames._dictionnaries.get_file_informations(file);
    if(!info[key]) {
        return false;
    }
    return info[key];
};

/**
 * Return an array of all the dictionnaries files
 */
Mudnames.get_file_list = function() {
    return Object.keys(Mudnames.getInstance()._dictionnaries.get_dictionnaries_list());
};

