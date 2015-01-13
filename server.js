// micro web server to support wk-chart demo and doc application
var dest = 'build';

var fs = require('fs-extra');

var express = require('express');
var serveStatic = require('serve-static');
var serveIndex = require('serve-index');
var bodyParser = require('body-parser');
var compress = require('compression');

var app = express();
app.use(compress());
app.use(serveStatic(dest));
app.use('/dir', serveIndex('./', {'icons': true}));
app.use(bodyParser.json());

app.set('port', (process.env.PORT || 3333));

app.get('/list', function(req, res) {
    fs.readdir('./charts', function(err, data) {
        if(err) {
            if(err.code == "ENOENT") {
                res.status(404).send('Data File "' + name + '.csv" does not exist')
            } else {
                res.status(500).send(JSON.stringify(err))
            }
        } else {
            res.send(data)
        }
    })
});
app.get('/chart/:name',function(req, res) {
    var name = req.params.name;
    var fName = './charts/' + name + '/chart.json'

    fs.readFile(fName, {encoding:'utf8'}, function(err, data) {
        if(err) {
            if(err.code == "ENOENT") {
                res.status(404).send('Data File "' + name + '.json" does not exist')
            } else {
                res.status(500).send(JSON.stringify(err))
            }
        } else {
            res.send(data)
        }
    })

});


app.put('/chart/:name', function(req, res) {
    var name = req.params.name;
    var body = req.body;
    //console.log(JSON.stringify(body));
    var fName = './charts/' + name + '/chart.json';
    fs.outputFile(fName, JSON.stringify(body), function(err) {
        if (err) {
            res.status(500).send(err)
        } else {
            res.status(200).send()
        }
    })


});
app.post('/chart/:name', function(req, res) {
    var name = req.params.name;
    var body = req.body;
    var fName = './charts/' + name + '/chart.json';
    fs.outputFile(fName, JSON.stringify(body), function(err) {
        if (err) {
            res.status(500).send(err)
        } else {
            res.status(200).send()
        }
    })
});
app.delete('/chart/:name', function(req, res) {
    var name = req.params.name;
    fs.remove('./charts/' + name, function(err){
        if(err) {
            res.status(500).send('Internal Error: ' + err)
        } else {
            res.status(200).send('deleted Chart ' + name)
        }
    })

});
app.listen(app.get('port'), function() {
    console.log("Node app is running at localhost:" + app.get('port'));
});