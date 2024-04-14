import { Controller } from '@hotwired/stimulus'
import { post } from '@rails/request.js'

export default class extends Controller {
  static values = {
    url: String,
    redirectUrl: String,
  }

  connect() {
  }

  async submit() {
    const response = await post(this.urlValue)
    if (response.ok) {
      window.location.href = this.redirectUrlValue
    } else {
      alert('Error Merging Blocks')
    }
  }
}
