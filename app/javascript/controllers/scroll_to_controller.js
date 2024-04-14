import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    anchor: String,
  }

  connect() {
    if (this.anchorValue) {
      console.log('here')
      window.location.hash = this.anchorValue
      // this._scrollTo(this.anchorValue)
    }
  }

  _scrollTo(id){
    console.log('there')
    setTimeout(document.getElementById(id).scrollIntoView({ behavior: 'smooth' }, 1000))
  }
}
