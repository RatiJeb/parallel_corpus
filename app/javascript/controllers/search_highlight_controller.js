import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['searchbar', 'body']

  connect() {

    this.searchbarTarget.querySelectorAll("input[type=text]").forEach((text_field) => {
      this.bodyTarget.querySelectorAll(".highlightable").forEach((a) => {
        if (text_field.value && a.textContent.includes(text_field.value)) {
          a.innerHTML = a.textContent.replaceAll(text_field.value, '<span class="bg-yellow-200">' + text_field.value + '</span>')
        }
      })
    })

  }
}
