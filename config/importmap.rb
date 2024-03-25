# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "choices", to: "https://ga.jspm.io/npm:choices.js@10.2.0/public/assets/scripts/choices.js"

pin_all_from "app/javascript/controllers", under: "controllers"
