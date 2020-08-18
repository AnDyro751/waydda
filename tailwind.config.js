module.exports = {
    purge: [
        './app/views/**/*.{js,jsx,ts,tsx,html,html.erb}',
        './app/javascript/bundles/**/*.{js,jsx,ts,tsx}'
    ],
    theme: {
        extend: {
            height: {
                xl: "22em",
                xxl: "28em"
            },
            backgroundColor: {
                facebook: "#4065b4",
                main: "#0a2540",
                "main-gray": "#F6F6F6"
            }
        },
    },
    variants: {},
    plugins: [],
}
