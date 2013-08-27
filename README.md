node-mudnames
=============

Mudnames for NodeJS

For the moment all the functions are synchronous, it will change soon (so the API).

[![Build Status](https://secure.travis-ci.org/pierreinglebert/node-mudnames.png)](http://travis-ci.org/pierreinglebert/node-mudnames)
[![Coverage Status](https://coveralls.io/repos/pierreinglebert/node-mudnames/badge.png?branch=master)](https://coveralls.io/r/pierreinglebert/node-mudnames?branch=master)
[![Dependency Status](https://gemnasium.com/pierreinglebert/node-mudnames.png)](https://gemnasium.com/pierreinglebert/node-mudnames)


## Usage

You can simply use it with the embedded dictionnaries in the `./data` directory

```javascript
var mudnames = require('mudnames');
```

Get the list of availabe dictionnaries
```javascript
mudnames.get_file_list();
```

Get information on a particular dictionnary

```javascript
mudnames.get_info(dict);
```

And of couse generate one or more names from available dictionnary (or random)

```javascript
mudnames.generate_name_from('random');
mudnames.generates_several_names(10, 'random');
```

### Custom dictionnary files

You can also use you own dictionnary files by instanciating a generator and use it as above

```javascript
var mudnames = require('mudnames').Generator(__dirname + '/mydicts');
mudnames.get_file_list(dict);
mudnames.generates_several_names(10, 'random');
```

## Benchmark against PHP version from xrogaan

The scripts were executed 20 times each and i kept the average on a ubuntu64 core2@3.4Ghz

Generation of 200 000 random names from dicts in the repo directory.
NodeJS : 1.164 sec
PHP : 182.379 sec
PHP (corrected script) : 6.302 sec


## License

MIT
