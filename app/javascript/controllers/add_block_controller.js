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

    const newCardHTML = await this.fetchNewCardHTML(newCardOrderId + 1, collectionId,languageIndex === 0 ? 'ka' : 'en');
    const nextContainer = parentContainer.nextElementSibling
    if (nextContainer) {
      const overflowCard = nextContainer.children[languageIndex];
      overflowCard.insertAdjacentHTML('beforebegin', newCardHTML);
      nextContainer.children[languageIndex + 1].remove()
      overflowCard.children[0].children[0].children[0].children[0].innerText = `${languageIndex === 0 ? 'KA' : 'EN'}-${newCardOrderId + 2}`
      await this.moveCardToNextContainer(overflowCard, nextContainer, languageIndex, newCardOrderId + 3, collectionId);
    } else {
      const newContainer = document.createElement('div');
      const newAdjacentCardHTML = await this.fetchNewCardHTML(newCardOrderId + 1, collectionId,languageIndex === 0 ? 'en' : 'ka');
      newContainer.classList.add('mt-3', 'flex', 'justify-stretch', 'grid', 'grid-cols-2', 'grid-flow-col', 'max-w-screen-2xl');
      newContainer.innerHTML = newCardHTML;
      languageIndex === 0 ? newContainer.children[0].insertAdjacentHTML('afterend', newAdjacentCardHTML) : newContainer.children[0].insertAdjacentHTML('beforebegin', newAdjacentCardHTML);
      parentContainer.parentNode.appendChild(newContainer);
    }
  }

  async fetchNewCardHTML(orderId, collectionId, language) {
    const response = await fetch(`new?order_number=${orderId}&collection_id=${collectionId}&language=${language}`);

    if (response.ok) {
      return await response.text();
    } else {
      console.error("Failed to fetch new card HTML");
      return '';
    }
  }

  async moveCardToNextContainer(card, parentContainer, index, orderId, collectionId) {
    const nextContainer = parentContainer.nextElementSibling

    if (nextContainer) {
      const overflowCard = nextContainer.children[index];
      nextContainer.insertBefore(card, overflowCard);
      nextContainer.children[index + 1].remove()
      overflowCard.children[0].children[0].children[0].children[0].innerText = `${index === 0 ? 'KA' : 'EN'}-${orderId}`
      await this.moveCardToNextContainer(overflowCard, nextContainer, index, orderId + 1);
    } else {
      // Create a new container and append 2 empty cards
      const newContainer = document.createElement('div');
      const newAdjacentCardHTML = await this.fetchNewCardHTML(orderId, collectionId,index === 0 ? 'en' : 'ka');
      newContainer.classList.add('mt-3', 'flex', 'justify-stretch', 'grid', 'grid-cols-2', 'grid-flow-col', 'max-w-screen-2xl');
      newContainer.appendChild(card);
      index === 0 ? newContainer.children[0].insertAdjacentHTML('afterend', newAdjacentCardHTML) : newContainer.children[0].insertAdjacentHTML('beforebegin', newAdjacentCardHTML);
      parentContainer.parentNode.appendChild(newContainer);
    }
  }

  extractOrderIdAndLang(card) {
    const title = card.children[0]?.children[0]?.children[0]?.innerText;
    const id = parseInt(title.split('-')[1]) || 0
    const lang = (card.id === 'text-block-00' || title.split('-')[0] === 'KA') ? 0 : 1
    return [id, lang];
  }
}
