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
    const languageIndex = this.extractOrderIdAndLang(currentCard)[1];
    const secondCard = nextContainer.children[languageIndex]
    const secondCardOrderId = this.extractOrderIdAndLang(secondCard)[0];
    currentCard.children[0].children[0].children[1].children[0].value = currentCard.children[0].children[0].children[1].children[0].value.toString() + secondCard.children[0].children[0].children[1].children[0].value.toString()
    secondCard.remove();
    this.moveCardFromNextContainer(nextContainer.nextElementSibling, languageIndex, secondCardOrderId);
  }

  extractOrderIdAndLang(card) {
    const title = card.children[0].children[0].children[0].innerText;
    const id = parseInt(title.split('-')[1]) || 0
    const lang = title.split('-')[0] === 'KA' ? 0 : 1
    return [id, lang];
  }

  moveCardFromNextContainer(parentContainer, index, orderId) {
    const nextContainer = parentContainer.nextElementSibling
    const previousContainer = parentContainer.previousElementSibling
    const containerNeedsRemoval = parentContainer.children[this.oppositeIndex(index)].id.includes('text-block-dummy')
    const cardToMove = parentContainer.children[index];
    index === 0 ? previousContainer.insertBefore(cardToMove, previousContainer.children[index]) : previousContainer.appendChild(cardToMove);
    if (!cardToMove.id.includes('text-block-dummy')) {
      cardToMove.children[0].children[0].children[0].children[0].innerText = `${index === 0 ? 'KA' : 'EN'}-${orderId}`
    }
    if(nextContainer){
      this.moveCardFromNextContainer(nextContainer, index, orderId + 1);
    }
    else{
      if(containerNeedsRemoval){
        parentContainer.remove()
      }
      else{
        const dummyCard = document.createElement('div')
        dummyCard.classList.add('col-span-1')
        dummyCard.setAttribute('id', `text-block-dummy${Math.random()}`)
        index === 0 ? parentContainer.insertBefore(dummyCard, parentContainer.children[index]) : parentContainer.appendChild(dummyCard);
      }
    }
  }
  oppositeIndex(index) {
    return index === 0 ? 1 : 0
  }
}
