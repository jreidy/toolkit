spawn = require('child_process').spawn

task 'test', 'Run the tests', ->
  process.env['GINKGO_ENV'] = 'test'
  spawn('find', ['specs', '-name', '*_spec.js']).stdout.on 'data', (data) ->
    mocha = spawn 'node_modules/.bin/mocha', "#{data.toString().trim()} --colors --require should --reporter dot".split(/\s+?/)
    mocha.stderr.on 'data', (data) -> process.stderr.write data
    mocha.stdout.on 'data', (data) -> process.stdout.write data

task 'server', 'start the development server', (options) ->
  require('./lib/server').app.start()
  console.log "Started Static Server: http://localhost:3000/"
  spawn('open', ['http://localhost:3000']).stdout

task 'build', 'build release version', ->
  console.log 'clean previous build'
  clean = spawn('rm', ['-rf', 'release'])
  clean.on 'exit', ->
    build = spawn('./node_modules/requirejs/bin/r.js', ['-o', 'app.build.js'])
    build.stdout.on 'data', (data) ->
      console.log data.toString()
    build.on 'exit', ->
      console.log 'build complete'

# task 'deploy', 'deploy release version', ->
  # console.log 'start deploy'
  # deploy = spawn('jitsu', ['deploy'])
  # deploy.stdout.on 'data', (data) ->
  #   console.log data.toString()
  # deploy.on 'exit', ->
  #   console.log 'deploy done'

task 'db:migrate', 'migrate database', ->
  console.log 'creating tables'
  {Store} = require('./lib/server')
  store = new Store
  console.log 'migrate DONE'

task 'db:drop', 'clear database', ->
  spawn('rm', ['gree.sqlite3'])
  console.log 'clear DONE'
  