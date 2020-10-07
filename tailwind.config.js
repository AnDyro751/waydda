module.exports = {
    purge: [
        './app/helpers/**/*.{rb}',
        './app/helpers/*.{rb}',
        './app/views/**/*.{js,jsx,ts,tsx,html,html.erb}',
        './app/javascript/bundles/**/*.{js,jsx,ts,tsx}'
    ],
    theme: {
        extend: {
            height: {
                "es": "0.125em",
                xl: "22em",
                xxl: "28em",
                xxxl: "35em"
            },
            backgroundColor: {
                facebook: "#4065b4",
                main: "#f8f5f2",
                "main-red": "#d43c27",
                "main-gray": "#f3f3f3",
                "main-gray-dark": "#e2e2e2",
                "light-black": "#2d2d2d",
                "secondary-light": "#f9e8e1",
                "main-teal": "#2befb2",
                "main-blue": "#5f48f6",
                "main-blue-light": "rgba(95,72,246,0.1)",
                "main-dark": "#1e2125",
                "main-teal-dark": "#228f6d",
                "gray-50": "#f9fafb"
            },
            textColor: {
                main: "#f8f5f2",
                "main-red": "#d43c27",
                "secondary": "#f9e8e1",
                "main-dark": "#3f444c",
                "main-teal": "#2befb2",
                "main-blue": "#5f48f6",
            },
            boxShadow: {
                "small": "2px 2px 0px rgb(0, 0, 0)",
                main: "rgb(0, 0, 0) 3px 3px 0px",
                "product-modal": "rgba(45, 22, 20, 0.08) -15px 0px 10px -10px",
                "top": "5px 0 20px rgba(0,0,0,0.2)"
            },
            inset: {
                "simple": "1px",
            },
            padding: {
                "7": "1.75em"
            }
        },
    },
    variants: {
        // display: ['responsive', 'hover', 'focus'],
        // visibility: ['responsive', 'hover', 'focus']
        inset: ['responsive', 'hover', 'focus'],
        backgroundColor: ['responsive', 'hover', 'focus', 'checked'],
    },
    plugins: [],
}
