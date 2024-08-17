import {Controller} from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
  }

  async submit(event) {
    event.preventDefault();
    const searchParams = new URLSearchParams(window.location.search);

    // Reference the button's closest card and find its order_id
    const currentCard = event.currentTarget.closest("[id^='text-block-']");
    const parentContainer = currentCard.parentElement;
    const [newCardOrderId, languageIndex] = this.extractOrderIdAndLang(currentCard);
    const collectionId = searchParams.get('collection_id')

    const newCardHTML = await this.fetchNewCardHTML(newCardOrderId, collectionId,languageIndex === 0 ? 'ka' : 'en');
    currentCard.insertAdjacentHTML('beforebegin', newCardHTML);
    currentCard.remove();
    currentCard.children[0].children[0].children[0].innerText = `${languageIndex === 0 ? 'KA' : 'EN'}-${newCardOrderId + 1}`
    this.moveCardToNextContainer(currentCard, parentContainer, languageIndex, newCardOrderId + 2);
  }

  async fetchNewCardHTML(orderId, collectionId, language) {
    const response = await fetch(`fetch_edit_card?order_number=${orderId}&collection_id=${collectionId}&language=${language}`);

    if (response.ok) {
      return await response.text();
    } else {
      console.error("Failed to fetch new card HTML");
      return '';
    }
  }

  moveCardToNextContainer(card, parentContainer, index, orderId) {
    const nextContainer = parentContainer.nextElementSibling

    if (nextContainer) {
      const overflowCard = nextContainer.children[index];
      nextContainer.insertBefore(card, nextContainer.children[index]);
      nextContainer.children[index + 1].remove()
      if(!overflowCard.id.includes('text-block-dummy')){
        overflowCard.children[0].children[0].children[0].innerText = `${index === 0 ? 'KA' : 'EN'}-${orderId}`
        this.moveCardToNextContainer(overflowCard, nextContainer, index, orderId + 1);
      }
    } else {
      // Create a new container and append the card
      const newContainer = document.createElement('div');
      const dummyChild = document.createElement('div')
      newContainer.classList.add('mt-3', 'flex', 'justify-stretch', 'grid', 'grid-cols-2', 'grid-flow-col', 'max-w-screen-2xl');
      dummyChild.classList.add('col-span-1')
      newContainer.appendChild(card);
      index === 0 ? newContainer.appendChild(dummyChild) : newContainer.insertBefore(dummyChild, newContainer.childNodes[0]);
      parentContainer.parentNode.appendChild(newContainer);
    }
  }

  extractOrderIdAndLang(card) {
    const title = card.children[0].children[0].children[0].innerText;
    const id = parseInt(title.split('-')[1]) || 0
    const lang = title.split('-')[0] === 'KA' ? 0 : 1
    return [id, lang];
  }
}
