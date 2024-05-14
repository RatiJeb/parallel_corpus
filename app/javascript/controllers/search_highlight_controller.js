import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['searchbar', 'body']
  static values = {
    fullWordMatch: String
  }

  connect() {

    this.searchbarTarget.querySelectorAll("input[type=text]").forEach((text_field) => {
      this.bodyTarget.querySelectorAll(".highlightable").forEach((a) => {
        if (this.fullWordMatchValue) {
          if (text_field.value && a.textContent.search(new RegExp('(^|[^a-zA-Z0-9ა-ჰ-])(' + text_field.value + ')($|[^a-zA-Z0-9ა-ჰ-])', 'i')) >= 0) {
            var parts = a.textContent.split(new RegExp('(^|[^a-zA-Z0-9ა-ჰ-])(' + text_field.value + ')($|[^a-zA-Z0-9ა-ჰ-])', 'gi'))
            for (var i = 0; i < parts.length; i++) {
              if (i % 4 == 2) {
                parts[i] = '<span class="text-magenta-500 bg-yellow-100">' + parts[i] + '</span>'
              }
            }
            a.innerHTML = parts.join('')
          }
        }
        else {
          if (text_field.value && a.textContent.search(new RegExp('(' + text_field.value + ')', 'i')) >= 0) {
            var parts = a.textContent.split(new RegExp('(' + text_field.value + ')', 'gi'))
            for (var i = 0; i < parts.length; i++) {
              if (i % 2 == 1) {
                parts[i] = '<span class="text-magenta-500 bg-yellow-100">' + parts[i] + '</span>'
              }
            }
            a.innerHTML = parts.join('')
          }
        }
      })
    })

  }
}
