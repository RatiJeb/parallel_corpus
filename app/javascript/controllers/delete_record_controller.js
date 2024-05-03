import { Controller } from '@hotwired/stimulus'
import { destroy } from '@rails/request.js'

export default class extends Controller {
  static values = {
    url: String,
    redirectUrl: String,
    modalTitle: String,
    modalText: String
  }

  connect() {
    this.confirmCheckbox = document.getElementById('confirm-delete-modal-checkbox')
    this.confirmDeleteBtn = document.getElementById('confirm-delete-modal-delete-button')
    this.confirmCancelBtn = document.getElementById('confirm-delete-modal-cancel-button')
    this.confirmCloseBtn = document.getElementById('confirm-delete-modal-close')
    this.confirmTitle = document.getElementById('confirm-delete-modal-title')
    this.confirmText = document.getElementById('confirm-delete-modal-text')

    this.confirmDeleteBtn.addEventListener('click', () => {
      this.confirmDelete()
    })

    this.confirmCloseBtn.addEventListener('click', () => {
      this.hideModal()
    })

    this.confirmCancelBtn.addEventListener('click', () => {
      this.hideModal()
    })
  }

  async submit() {
    this.modal = document.getElementById('confirm-delete-modal')
    this.showModal()
  }

  showModal() {

    console.log('this.element')
    console.log(this.modalTitleValue)
    console.log(this.modalTextValue)
    console.log(this.urlValue)

    this.modalInner = document.getElementById('confirm-delete-modal-inner')

    const rect = this.element.getBoundingClientRect()
    const left = Math.min(rect.right + window.pageXOffset + 10, window.innerWidth - this.modalInner.offsetWidth)

    const scrollTop = window.pageYOffset || document.documentElement.scrollTop
    const top = Math.max(rect.bottom - this.modalInner.offsetHeight + 10, 0)

    this.modal.style.left = `${left}px`;
    this.modal.style.top = `${top}px`;

    if (this.modalTitleValue) {
      this.confirmTitle.innerHTML = this.modalTitleValue
    }

    if (this.modalTextValue) {
      this.confirmText.innerHTML = this.modalTextValue
    }

    this.modal.classList.remove("invisible")
    this.modal.classList.add("visible")

    this.modal.url = this.urlValue
    console.log(this.urlValue)
  }

  hideModal() {
    this.modal.classList.remove("visible")
    this.modal.classList.add("invisible")
    this.modal.url = null
  }

  async confirmDelete() {

    console.log(this.modal.url)
    if (this.modal.url) {
      if (!this.confirmCheckbox.checked) {
        alert('გთხოვთ, მონიშნოთ "ვეთანხმები" თუ ნამდვილად გსურთ წაშლა.')
        return
      }

      const response = await destroy(this.modal.url)

      if (response.ok) {
        window.location.href = this.redirectUrlValue
      } else {
        alert('წაშლის დროს მოხდა შეცდომა')
      }
    }
  }
}
