import { Controller } from '@hotwired/stimulus'
import { post, put } from '@rails/request.js'

export default class extends Controller {
  static targets = ['textarea']
  static values = {
    url: String,
    redirectUrl: String,
  }

  connect() {
  }

  async split() {

    console.log('get here')
    const firstContents = this.textareaTarget.value.substring(0, this.textareaTarget.selectionStart)
    const lastContents = this.textareaTarget.value.substring(this.textareaTarget.selectionStart, this.textareaTarget.value.length)
    console.log(firstContents)
    console.log(lastContents)

    const response = await post(
      this.urlValue, {
        body: JSON.stringify(
          { first_contents: firstContents, last_contents: lastContents }
        )
      }
    )
    if (response.ok) {
      window.location.href = this.redirectUrlValue
    } else {
      alert('Error Deleting Record')
    }
  }
}
