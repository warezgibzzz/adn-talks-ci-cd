# Generated on 2017-05-02 using generator-reveal 1.0.0
module.exports = (grunt) ->

    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'

        manifest:
            generate:
                options:
                    basePath: 'dist'
                    cache: [
                      'css/theme.css'
                      'js/loadhtmlslides.js'
                      'bower_components/reveal.js/lib/js/head.min.js'
                      'bower_components/reveal.js/js/reveal.js'
                      'bower_components/reveal.js/plugin/highlight/highlight.js'
                      'bower_components/reveal.js/plugin/zoom-js/zoom.js'
                      'bower_components/reveal.js/plugin/notes/notes.js'
                      'bower_components/reveal.js/css/reveal.css'
                      'bower_components/reveal.js/css/print/paper.css'
                      'bower_components/reveal.js/highlight/styles/solarized_dark.js'
                      'slides/ci-cd-history.html'
                      'slides/how-bad-that-is-for-developer.html'
                      'slides/how-it-helps-client.html'
                      'slides/how-it-helps-developer.html'
                      'slides/index.html'
                      'slides/intro.html'
                      'slides/preambule.html'
                      'slides/questions.html'
                      'slides/thanks.html'
                      'slides/use-cases.html'
                      'index.html'
                    ]
                    verbose: true
                    timestamp: true
                    hash: true
                    network: ['http://*', 'https://*']
                    master: ['index.html']
                src: [
                    'dist/*.html'
                    'dist/js/*.js'
                    'dist/css/*.css'
                    'dist/resources/*.css'
                    'dist/slides/*'
                ]
                dest: 'dist/manifest.appcache'

        watch:

            livereload:
                options:
                    livereload: true
                files: [
                    'index.html'
                    'slides/{,*/}*.{md,html}'
                    'js/*.js'
                    'css/*.css'
                    'resources/**'
                ]

            index:
                files: [
                    'templates/_index.html'
                    'templates/_section.html'
                    'slides/list.json'
                ]
                tasks: ['buildIndex']

            coffeelint:
                files: ['Gruntfile.coffee']
                tasks: ['coffeelint']

            jshint:
                files: ['js/*.js']
                tasks: ['jshint']

            sass:
                files: ['css/source/theme.scss']
                tasks: ['sass']

        sass:

            theme:
                files:
                    'css/theme.css': 'css/source/theme.scss'

        connect:

            livereload:
                options:
                    port: 9000
                    base: '.'
                    open: true
                    livereload: true

        coffeelint:

            options:
                indentation:
                    value: 4
                max_line_length:
                    level: 'ignore'

            all: ['Gruntfile.coffee']

        jshint:

            options:
                jshintrc: '.jshintrc'

            all: ['js/*.js']

        copy:

            dist:
                files: [{
                    expand: true
                    src: [
                        'slides/**'
                        'bower_components/**'
                        'js/**'
                        'css/*.css'
                        'resources/**'
                    ]
                    dest: 'dist/'
                },{
                    expand: true
                    src: ['index.html']
                    dest: 'dist/'
                    filter: 'isFile'
                }]


        buildcontrol:

            options:
                dir: 'dist'
                commit: true
                push: true
                message: 'Built from %sourceCommit% on branch %sourceBranch%'
            pages:
                options:
                    remote: '<%= pkg.repository.url %>'
                    branch: 'gh-pages'



    # Load all grunt tasks.
    require('load-grunt-tasks')(grunt)

    grunt.registerTask 'buildIndex',
        'Build index.html from templates/_index.html and slides/list.json.',
        ->
            indexTemplate = grunt.file.read 'templates/_index.html'
            sectionTemplate = grunt.file.read 'templates/_section.html'
            slides = grunt.file.readJSON 'slides/list.json'

            html = grunt.template.process indexTemplate, data:
                slides:
                    slides
                section: (slide) ->
                    grunt.template.process sectionTemplate, data:
                        slide:
                            slide
            grunt.file.write 'index.html', html

    grunt.registerTask 'test',
        '*Lint* javascript and coffee files.', [
            'coffeelint'
            'jshint'
        ]

    grunt.registerTask 'serve',
        'Run presentation locally and start watch process (living document).', [
            'buildIndex'
            'sass'
            'connect:livereload'
            'watch'
        ]

    grunt.registerTask 'dist',
        'Save presentation files to *dist* directory.', [
            'test'
            'sass'
            'buildIndex'
            'copy'
            'manifest'
        ]


    grunt.registerTask 'deploy',
        'Deploy to Github Pages', [
            'dist'
            'buildcontrol'
        ]


    # Define default task.
    grunt.registerTask 'default', [
        'test'
        'serve'
    ]
