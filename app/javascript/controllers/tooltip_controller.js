import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['tooltip', 'cell']

  connect() {
    this.cellTarget.addEventListener("mouseenter", () => {
      if (this.isOverflowing()) {
        this.showTooltip()
      }
    })

    this.cellTarget.addEventListener("mouseleave", () => {
      if (this.tooltip)
      this.hideTooltip()
    })
  }

  isOverflowing() {
    return this.cellTarget.scrollWidth > this.cellTarget.clientWidth
  }

  showTooltip() {
    this.tooltipTarget.classList.remove("invisible")
    this.tooltipTarget.classList.add("visible")

    this.tooltip = document.body.appendChild(this.tooltipTarget)

    const rect = this.cellTarget.getBoundingClientRect()
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop
    const left = rect.left + window.pageXOffset
    const top = rect.bottom + scrollTop

    this.tooltip.style.left = `${left}px`;
    this.tooltip.style.top = `${top-10}px`;
  }

  hideTooltip() {
    this.tooltip.classList.remove("visible");
    this.tooltip.classList.add("invisible");

    this.cellTarget.appendChild(this.tooltip)
  }
}
