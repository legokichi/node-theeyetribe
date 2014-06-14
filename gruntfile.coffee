module.exports = (grunt) ->
  grunt.loadNpmTasks("grunt-contrib-coffee")
  grunt.loadNpmTasks("grunt-contrib-watch")

  grunt.initConfig
    pkg: grunt.file.readJSON('./package.json')
    coffee:
      compile:
        files:
          './app.js': './app.coffee'
      options:
        bare: yes
    watch:
      coffee:
        files:["./*.coffee"],
        tasks:["make"]

  grunt.registerTask("make", ["coffee:compile"])
  grunt.registerTask("default", ["make"])
