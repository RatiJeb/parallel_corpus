import { Controller } from '@hotwired/stimulus'
import { put } from '@rails/request.js'

export default class extends Controller {
  static targets = ['textarea']
  static values = {
    url: String,
    redirectUrl: String,
  }

  connect() {
  }

  async tag() {

    console.log('get here')
    const firstContents = this.textareaTarget.value.substring(0, this.textareaTarget.selectionStart)
    const term = this.textareaTarget.value.substring(this.textareaTarget.selectionStart, this.textareaTarget.selectionEnd)
    const lastContents = this.textareaTarget.value.substring(this.textareaTarget.selectionEnd, this.textareaTarget.value.length)

    const contents = firstContents + '<t>' + term + '</t>' + lastContents

    const response = await put(
      this.urlValue, {
        body: JSON.stringify(
          { contents: contents }
        )
      }
    )
    if (response.ok) {
      window.location.href = this.redirectUrlValue
    } else {
      alert('Error Taging Term')
    }
  }
}
