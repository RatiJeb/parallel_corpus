import { Controller } from '@hotwired/stimulus'
import { post } from '@rails/request.js'

export default class extends Controller {
  connect() {
  }

  async submit(event) {
    event.preventDefault();
    const currentCard = event.currentTarget.closest("[id^='text-block-']");
    const parentContainer = currentCard.parentElement;
    const nextContainer = parentContainer.nextElementSibling;
    if(!nextContainer){
      return
    }
    const [currentCardOrderId, languageIndex] = this.extractOrderIdAndLang(currentCard);
    const secondCard = nextContainer.children[languageIndex]
    const secondCardOrderId = this.extractOrderIdAndLang(secondCard)[0];
    currentCard.children[0].children[0].children[0].children[0].innerText = `${languageIndex === 0 ? 'KA' : 'EN'}-${secondCardOrderId}`
    secondCard.children[0].children[0].children[0].children[0].innerText = `${languageIndex === 0 ? 'KA' : 'EN'}-${currentCardOrderId}`
    nextContainer.insertBefore(currentCard, nextContainer.children[languageIndex])
    parentContainer.insertBefore(secondCard, parentContainer.children[languageIndex])
  }

  extractOrderIdAndLang(card) {
    const title = card.children[0].children[0].children[0].innerText;
    const id = parseInt(title.split('-')[1]) || 0
    const lang = title.split('-')[0] === 'KA' ? 0 : 1
    return [id, lang];
  }
}
