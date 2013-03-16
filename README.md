node-mudnames
=============

Mudnames for NodeJS

For the moment all the functions are synchronous, it will change soon (so the API).

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


## License

MIT
