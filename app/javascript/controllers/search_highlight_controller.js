import {Controller} from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['searchbar', 'body']
  static values = {
    fullWordMatch: String,
    exactMatch: Boolean
  }

  connect() {
    this.highlight();
  }

  highlight() {
    const urlParams = new URLSearchParams(window.location.search);
    const collocations_first = urlParams.get('collocations[first]');
    const collocations_second = urlParams.get('collocations[second]');
    this.searchbarTarget.querySelectorAll("input[type=text]").forEach((text_field) => {
      this.bodyTarget.querySelectorAll(".highlightable").forEach((a) => {
        let i;
        let parts;
        if (collocations_first && collocations_second && a.textContent.search(new RegExp('([^a-zA-Z0-9ა-ჰ]+' + collocations_first + '[^a-zA-Z0-9ა-ჰ]+' + collocations_second + '[^a-zA-Z0-9ა-ჰ]+)', 'gi')) >= 0) {
          parts = a.textContent.split(new RegExp('([^a-zA-Z0-9ა-ჰ]+' + collocations_first + '[^a-zA-Z0-9ა-ჰ]+' + collocations_second + '[^a-zA-Z0-9ა-ჰ]+)', 'gi'));
          for (i = 0; i < parts.length; i++) {
            if (parts[i].search(new RegExp('([^a-zA-Z0-9ა-ჰ]+' + collocations_first + '[^a-zA-Z0-9ა-ჰ]+' + collocations_second + '[^a-zA-Z0-9ა-ჰ]+)', 'gi')) === 0) {
              parts[i] = '<span class="text-magenta-500 bg-yellow-100">' + parts[i] + '</span>'
            }
          }
          a.innerHTML = parts.join('')
        } else {
          if (this.fullWordMatchValue) {
            if (!this.exactMatchValue) {
              if (text_field.value && a.textContent.search(new RegExp('(' + text_field.value + ')', 'gi')) >= 0) {
                parts = a.textContent.split(new RegExp('(' + text_field.value + ')', 'gi'));
                for (i = 0; i < parts.length; i++) {
                  if (parts[i] === text_field.value) {
                    parts[i] = '<span class="text-magenta-500 bg-yellow-100">' + parts[i] + '</span>'
                  }
                }
                a.innerHTML = parts.join('')
              }
            } else if (text_field.value && a.textContent.search(new RegExp('(^|[^a-zA-Z0-9ა-ჰ-])(' + text_field.value + ')($|[^a-zA-Z0-9ა-ჰ-])', 'i')) >= 0) {
              parts = a.textContent.split(new RegExp('(^|[^a-zA-Z0-9ა-ჰ-])(' + text_field.value + ')($|[^a-zA-Z0-9ა-ჰ-])', 'gi'));
              for (i = 0; i < parts.length; i++) {
                if (i % 4 === 2) {
                  parts[i] = '<span class="text-magenta-500 bg-yellow-100">' + parts[i] + '</span>'
                }
              }
              a.innerHTML = parts.join('')
            }
          } else {
            if (text_field.value && a.textContent.search(new RegExp('(' + text_field.value + ')', 'i')) >= 0) {
              parts = a.textContent.split(new RegExp('(' + text_field.value + ')', 'gi'));
              for (i = 0; i < parts.length; i++) {
                if (i % 2 === 1) {
                  parts[i] = '<span class="text-magenta-500 bg-yellow-100">' + parts[i] + '</span>'
                }
              }
              a.innerHTML = parts.join('')
            }
          }
        }
      })
    })

  }

  toggleExactMatch(event) {
    this.exactMatchValue = event.target.checked;
    this.highlight();
  }
}
