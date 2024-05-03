import { Controller } from '@hotwired/stimulus'

export default class extends Controller {

  connect() {
  }

  async trigger() {
    document.querySelectorAll('[data-action="click->text-block#update"]').forEach((button) => {
      button.click()
    })
  }

}
