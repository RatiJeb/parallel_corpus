import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    anchor: String,
  }

  connect() {
    if (this.anchorValue) {
      this._scrollTo(this.anchorValue)
      window.location.hash = this.anchorValue
    }
  }

  _scrollTo(id){
    document.getElementById(id).scrollIntoView({ behavior: 'smooth' })
  }
}
