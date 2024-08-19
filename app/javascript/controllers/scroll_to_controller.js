import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    this.observeLoading();
  }

  observeLoading() {
    const observer = new MutationObserver((mutationsList, observer) => {
      if (document.getElementsByClassName('selected-text-block')) {
        this.scrollToSelected()
        observer.disconnect();
      }
    });

    observer.observe(document, {attributes: false, childList: true, characterData: false, subtree:true});
  }

  scrollToSelected() {
    const selectedTextBlock = document.getElementsByClassName('selected-text-block')[0];
    if (selectedTextBlock) {
      selectedTextBlock.scrollIntoView({ behavior: "smooth"});
      setTimeout(() => {selectedTextBlock.scrollIntoView({ behavior: "smooth"})},1000);
    }
  }
}
