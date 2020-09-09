module.exports = {
    purge: [
        './app/views/**/*.{js,jsx,ts,tsx,html,html.erb}',
        './app/javascript/bundles/**/*.{js,jsx,ts,tsx}'
    ],
    theme: {
        extend: {
            height: {
                "es": "0.125em",
                xl: "22em",
                xxl: "28em"
            },
            backgroundColor: {
                facebook: "#4065b4",
                main: "#f8f5f2",
                "main-red": "#f45d48",
                "main-gray": "#eaeaea",
                "light-black": "#2d2d2d",
                "secondary-light": "#f9e8e1",
                "main-teal": "#2befb2",
                "main-blue": "#5f48f6",
                "main-dark": "#1e2125",
                "main-teal-dark": "#228f6d"
            },
            textColor: {
                main: "#f8f5f2",
                "main-red": "#f45d48",
                "secondary": "#f9e8e1",
                "main-dark": "#3f444c"
            }
        },
    },
    variants: {
        // display: ['responsive', 'hover', 'focus'],
        // visibility: ['responsive', 'hover', 'focus']
    },
    plugins: [],
}
