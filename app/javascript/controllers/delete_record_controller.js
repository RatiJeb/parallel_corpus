import {Controller} from '@hotwired/stimulus'

export default class extends Controller {

  connect() {
  }

  async submit(event) {
    event.preventDefault();

    this.confirmCheckbox = document.getElementById('confirm-delete-modal-checkbox')
    this.confirmDeleteBtn = document.getElementById('confirm-delete-modal-delete-button')
    this.confirmCancelBtn = document.getElementById('confirm-delete-modal-cancel-button')
    this.confirmCloseBtn = document.getElementById('confirm-delete-modal-close')

    this.confirmDeleteBtn.addEventListener('click', () => {
      this.confirmDelete()
    })

    this.confirmCloseBtn.addEventListener('click', () => {
      this.hideModal()
    })

    this.confirmCancelBtn.addEventListener('click', () => {
      this.hideModal()
    })

    this.recordId = event.currentTarget.dataset.deleteRecordId;

    this.modal = document.getElementById('confirm-delete-modal')
    this.showModal()
  }

  showModal() {

    this.modalInner = document.getElementById('confirm-delete-modal-inner')

    const rect = this.element.getBoundingClientRect()
    const left = Math.min(rect.right + window.pageXOffset + 10, window.innerWidth - this.modalInner.offsetWidth)

    const scrollTop = window.pageYOffset || document.documentElement.scrollTop
    const top = Math.max(rect.bottom - this.modalInner.offsetHeight + 10, 0)

    this.modal.style.left = `${left}px`;
    this.modal.style.top = `${top}px`;

    this.modal.classList.remove("invisible")
    this.modal.classList.add("visible")
  }

  hideModal() {
    this.modal.classList.remove("visible")
    this.modal.classList.add("invisible")
  }

  confirmDelete() {
    if (!this.confirmCheckbox.checked) {
      alert('გთხოვთ, მონიშნოთ "ვეთანხმები" თუ ნამდვილად გსურთ წაშლა.')
      return
    }
    const currentCard = document.getElementById(`text-block-${this.recordId}`)
    const parentContainer = currentCard.parentElement;
    const [newCardOrderId, languageIndex] = this.extractOrderIdAndLang(currentCard);
    currentCard.remove();
    this.moveCardFromNextContainer(parentContainer.nextElementSibling, languageIndex, newCardOrderId);
    this.hideModal()
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

  extractOrderIdAndLang(card) {
    const title = card.children[0].children[0].children[0].innerText;
    const id = parseInt(title.split('-')[1]) || 0
    const lang = title.split('-')[0] === 'KA' ? 0 : 1
    return [id, lang];
  }

  oppositeIndex(index) {
    return index === 0 ? 1 : 0
  }
}
