import {Controller} from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['options']

  connect() {
    this.hidden = true;
  }

  toggle() {
    if (this.hidden) {
      this._showOptions();
    } else {
      this.hideOptions();
    }
  }

  outsideClick(e) {
    if (!this.hidden && e.target !== this.element && !this.element.contains(e.target)) {
      this.hideOptions();
    }
  }

  hideOptions() {
    this.optionsTarget.classList.remove('transition', 'ease-out', 'duration-200', 'transform', 'opacity-100', 'scale-100');
    this.optionsTarget.classList.add('hidden', 'transition', 'ease-in', 'duration-75', 'transform', 'opacity-0', 'scale-95');
    this.hidden = true;
  }

  _showOptions() {
    this.optionsTarget.classList.remove('hidden', 'transition', 'ease-in', 'duration-75', 'transform', 'opacity-0', 'scale-95');
    this.optionsTarget.classList.add('transition', 'ease-out', 'duration-200', 'transform', 'opacity-100', 'scale-100');
    this.hidden = false;
  }

  showOrHide(event) {
    event.preventDefault();
    const parent = event.target.parentElement.parentElement;
    const grandparent = document.getElementById('search-form-with-results');

    const hide = parent.id === 'isVisible';

    parent.id = hide ? 'isInvisible' : 'isVisible';
    if (hide) {
      grandparent.classList?.add('flex-col');
    } else {
      grandparent.classList?.remove('flex-col');
    }
    parent.childNodes.forEach((child) => {
      if (!(child.id === 'dropdown-arrow')) {
        if (hide) {
          child.classList?.add("invisible");
        } else {
          child.classList?.remove("invisible");
        }
      }
      if (hide) {
        parent.style.height = '40px';
        event.target.style.scale = -1;
      } else {
        parent.style.height = '80dvh';
        event.target.style.scale = 1;
      }
    });
  }
}
