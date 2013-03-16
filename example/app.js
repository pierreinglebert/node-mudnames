var http = require('http');
var mudnames = require('../');
var url = require('url');

http.createServer(function (req, res) {
    res.setHeader("Content-Type", "text/html;charset=utf-8");

    //Get dictionnaries
    var dicts = mudnames.get_file_list();

    var results = [];
    var dict = 'random';
    var number = 1;
    var timeTaken = null;
    //Get Params
    var url_parts = url.parse(req.url, true);    
    if(url_parts.query.dict) {        
        if(dicts.indexOf(url_parts.query.dict) != -1) {
            dict = url_parts.query.dict;
        }
        number = parseInt(url_parts.query.number);
        
        //Generate names
        var now = new Date();
        results = mudnames.generates_several_names(number, dict);
        timeTaken = (new Date().getTime() - now.getTime());
    }

    //Generate select HTML
    var selectHTML = 'Choose dictionnary : <select name="dict">';
    selectHTML += '<option value="random">random</option>';
    for(var i=0;i<dicts.length;i++) {
        selectHTML += '<option value="' + dicts[i] +'" '+((dict==dicts[i])?'selected="selected"':'')+'>'+dicts[i]+'</option>';
    }
    selectHTML += '</select>';

    res.end('<html><body><div><form method="get">'+selectHTML+'<br />Number of names : <input type="text" value="'+number+'" name="number" /><br /><input type="submit" value="Generate"/></form></div><div>'+((timeTaken)? 'Time : '+timeTaken+' ms<br />': '')+'Results : '+results+'</div></body></html>', 'utf-8');
}).listen(1228);

