({
    appDir: "./public",
    baseUrl: "./js",
    dir: "./release",
    paths: {
        'zepto': 'libs/zepto/zepto_amd',
        'underscore': 'libs/underscore/underscore-min',
        'backbone': 'libs/backbone/backbone',
        'backbone_localStorage': 'libs/backbone/backbone.localStorage',
        'text': 'libs/require/text',
        'moment': 'libs/moment/moment.min'
    },
    optimize: "uglify",
    modules: [{
        name: "app",
        exclude: [
        // If you prefer not to include certain libs exclude them here
        ]
    }]
})