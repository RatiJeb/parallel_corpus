import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['options']

  connect() {
    this.hidden = true
  }

  toggle() {
    if (this.hidden) {
      this._showOptions()
    } else {
      this.hideOptions()
    }
  }

  outsideClick(e) {
    if (!this.hidden && e.target !== this.element && !this.element.contains(e.target)) {
      this.hideOptions()
    }
  }

  hideOptions(){
    this.optionsTarget.classList.remove('transition', 'ease-out', 'duration-200', 'transform', 'opacity-100', 'scale-100')
    this.optionsTarget.classList.add('hidden', 'transition', 'ease-in', 'duration-75', 'transform', 'opacity-0', 'scale-95')
    this.hidden = true
  }

  _showOptions(){
    this.optionsTarget.classList.remove('hidden', 'transition', 'ease-in', 'duration-75', 'transform', 'opacity-0', 'scale-95')
    this.optionsTarget.classList.add('transition', 'ease-out', 'duration-200', 'transform', 'opacity-100', 'scale-100')
    this.hidden = false
  }
}
