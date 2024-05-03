import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['searchbar', 'body']

  connect() {

    console.log(this.searchbarTarget.querySelectorAll("input[type=text]"))

    this.searchbarTarget.querySelectorAll("input[type=text]").forEach((text_field) => {

      console.log(text_field)

      this.bodyTarget.querySelectorAll(".highlightable").forEach((a) => {


        console.log("text_field.value", text_field.value, "a.innerText", a.textContent)
        if (text_field.value && a.textContent.includes(text_field.value)) {
          console.log('here')
          a.innerHTML = a.textContent.replaceAll(text_field.value, '<span class="bg-yellow-200">' + text_field.value + '</span>')
        }
      })

    })

  }
}
