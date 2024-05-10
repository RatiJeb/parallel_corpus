import { Controller } from '@hotwired/stimulus'
import { post, put } from '@rails/request.js'

export default class extends Controller {
  static targets = ['textarea']
  static values = {
    tagUrl: String,
    splitUrl: String,
    updateUrl: String,
    redirectUrl: String,
  }

  connect() {
  }

  async tag() {

    const firstContents = this.textareaTarget.value.substring(0, this.textareaTarget.selectionStart)
    const term = this.textareaTarget.value.substring(this.textareaTarget.selectionStart, this.textareaTarget.selectionEnd)
    const lastContents = this.textareaTarget.value.substring(this.textareaTarget.selectionEnd, this.textareaTarget.value.length)

    const contents = firstContents + '[t]' + term + '[/t]' + lastContents

    const response = await put(
      this.tagUrlValue, {
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

  async split() {

    const firstContents = this.textareaTarget.value.substring(0, this.textareaTarget.selectionStart)
    const lastContents = this.textareaTarget.value.substring(this.textareaTarget.selectionStart, this.textareaTarget.value.length)

    const response = await post(
      this.splitUrlValue, {
        body: JSON.stringify(
          { first_contents: firstContents, last_contents: lastContents }
        )
      }
    )
    if (response.ok) {
      window.location.href = this.redirectUrlValue
    } else {
      alert('Error Splitting Block')
    }
  }

  async update() {

    const contents = this.textareaTarget.value

    const response = await put(
      this.updateUrlValue, {
        body: JSON.stringify(
          { contents: contents }
        )
      }
    )
    if (response.ok) {
      window.location.href = this.redirectUrlValue
    } else {
      alert('Error Updating Block')
    }
  }
}
