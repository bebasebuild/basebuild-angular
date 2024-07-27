

  describe 'Default Options', ->

    ###*
     * Global Variables
    ###
    rootPath             = "../../../../../../.."
    distPath             = "#{rootPath}/dist"
    basebuildNodeModules = "#{rootPath}/node_modules"

    ###*
     * Imports
    ###
    defaultOptions = require("#{distPath}/config/defaults")()
    _              = defaultOptions.plugins.lodash

    sinon              = require 'sinon'
    chai               = require 'chai'
    assert             = chai.assert
    expect             = chai.expect


    ###*
     * Tests
    ###
    describe 'Provides a default error handler... ', ->

      beforeEach ->
        sinon.stub(defaultOptions.plugins.util, 'log')
        sinon.stub(defaultOptions.plugins.util, 'beep')

      afterEach ->
        defaultOptions.plugins.util.log.restore()
        defaultOptions.plugins.util.beep.restore()


      it 'Returns a function when invoked to be a callback on tasks errors', ->
        assert.isFunction defaultOptions.errorHandler('TitleX')

      it 'Uses a custom title to track the error', ->
        cleanCustomTitle  = 'MycleanCustomTitle'
        redCustomTitle    = '\u001b[31m[' + cleanCustomTitle + ']\u001b[39m'
        errorMessage      = 'ErrorXPTO'

        errorHandler = defaultOptions.errorHandler(cleanCustomTitle)

        errorHandler(errorMessage)

        assert.isTrue defaultOptions.plugins.util.log.calledOnce
        assert.isTrue defaultOptions.plugins.util.log.calledWith(redCustomTitle, errorMessage)

      it 'Beeps the terminal to alert the developer', ->

        defaultOptions.errorHandler('whatever')('error')



        assert.isTrue defaultOptions.plugins.util.beep.called

      it 'Emits end of the stream when invoked', ->
        @emit = () ->
        sinon.stub(@, 'emit')

        errorHandler = defaultOptions.errorHandler('whatever')
        errorHandler.apply(@, ['error'])

        assert.isTrue @emit.calledWith('end')
        @emit.reset()






    describe 'Provides node plugins to use as option...', ->

      it 'Being an object as API', ->
        expect(defaultOptions.plugins).to.be.a('object')

      it 'Contains all gulp plugins in basebuild (gulp-* pattern loaded for gulp-load-plugins)', (done) ->
        gulpPlugins = [
          "angularFilesort"
          "angularTemplatecache"
          "cjsx"
          "coffee"
          "coffeelint"
          "concat"
          "csso"
          "filter"
          "flatten"
          "if"
          "inject"
          "jshint"
          "htmlmin"
          "ngAnnotate"
          "protractor"
          "rename"
          "replace"
          "rev"
          "revReplace"
          "sass"
          "size"
          "sourcemaps"
          "uglify"
          "useref"
          "util"
          "watch"
        ]

        for plugin in gulpPlugins then expect(defaultOptions.plugins).to.have.property(plugin)
        done()


      it 'Contains all third-party plugins loaded in basebuild', (done) ->
        thirdPartyPlugins = [
          "browserSync"
          "browserSyncSpa"
          "concatStream"
          "del"
          "httpProxy"
          "jshintStylish"
          "lodash"
          "mainBowerFiles"
          "mergeStream"
          "protractor"
          "requireDir"
          "shelljs"
          "uglifySaveLicense"
          "wiredep"
          "chalk"
        ]

        for plugin in thirdPartyPlugins then expect(defaultOptions.plugins).to.have.property(plugin)
        done()
