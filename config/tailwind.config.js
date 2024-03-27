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
          50: '#F7F7F7',
          100: '#E1D9DC',
          200: '#C2B3B8',
          300: '#B09CA5',
          400: '#9E8892',
          500: '#917380',
          600: '#826074',
          700: '#7A506A',
          800: '#633A53',
          900: '#45203B',
          950: '#30172D'
        },
        chinarose: {
          500: '#9F5776'
        },
        chalmorise: {
          500: '#B0644F'
        },
        oceanside: {
          500: '#6182B8'
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
    require('tailwind-scrollbar-hide')
  ]
}
