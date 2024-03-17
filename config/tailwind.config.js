const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/lib/**/form_builder.rb'
  ],
  theme: {
    extend: {
      colors: {
        skyblue: {
          50: '#e5f1f4',
          100: '#d5e8ed',
          200: '#aad0db',
          300: '#83bbcd',
          400: '#5ba6bf',
          500: '#3b96b4',
          600: '#1385a8',
          700: '#0d6985',
          800: '#0c516b',
          900: '#0a354a',
          950: '#032333'
        },
        mountbatten: {
          300: '#a6959d',
          400: '#9e8892',
          500: '#907c85'
        }
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
