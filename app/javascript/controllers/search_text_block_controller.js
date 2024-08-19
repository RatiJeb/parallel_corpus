import {Controller} from '@hotwired/stimulus'

export default class extends Controller {

  connect() {
  }

  search(event) {
    if (!event.key || event.key === 'Enter') {
      const parent = event.key ? event.currentTarget.parentElement.parentElement : event.currentTarget.parentElement
      const id = parent.children[0].children[0].value
      const name = parent.children[1].children[0].value;
      if (id) {
        this.searchById(id);
      }
      else {
        this.searchByName(name);
      }
    }
  }

  searchById(id) {
    const element = document.getElementById(`KA-${id}`) || document.getElementById(`EN-${id}`)
    element.scrollIntoView({behavior: "smooth"});
  }

  searchByName(name) {
    if (!name) {
      return
    }
    const textareas = document.querySelectorAll('textarea');

    const matchingTextareas = Array.from(textareas).filter(textarea =>
      textarea.value.toLowerCase().includes(name.toLowerCase())
    );

    if (matchingTextareas[0]) {
      matchingTextareas[0].scrollIntoView({behavior: "smooth"});
    }
  }
}
