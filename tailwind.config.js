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
                facebook: "#4065b4"
            }
        },
    },
    variants: {},
    plugins: [],
}
