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
                main: "#f8f5f2",
                "main-red": "#f45d48",
                "main-gray": "#F6F6F6",
                "light-black": "#2d2d2d",
                "secondary-light": "#f9e8e1"
            },
            textColor: {
                main: "#f8f5f2",
                "main-red": "#f45d48",
                "secondary": "#f9e8e1"
            }
        },
    },
    variants: {},
    plugins: [],
}
