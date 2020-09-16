const {environment} = require('@rails/webpacker')
environment.loaders.delete('nodeModules')
const webpack = require('webpack')
environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        Popper: ['popper.js', 'default']
    })
)
module.exports = environment
