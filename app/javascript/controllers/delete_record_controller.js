import { Controller } from '@hotwired/stimulus'
import { destroy } from '@rails/request.js'

export default class extends Controller {
  static values = {
    url: String,
    redirectUrl: String,
  }

  connect() {
  }

  async submit() {
    if (confirm('Are you sure?') != true) {
      return
    }

    const response = await destroy(this.urlValue)
    if (response.ok) {
      window.location.href = this.redirectUrlValue
    } else {
      alert('Error Deleting Record')
    }
  }
}
