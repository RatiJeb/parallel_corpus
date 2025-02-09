import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['tooltip', 'cell']
  static values = {
    overflow: Boolean,
    placement: String
  }

  connect() {
    this.mouseEnterHandler = () => {
      if (!this.overflowValue || this.isOverflowing()) {
        this.showTooltip();
      }
    };

    this.mouseLeaveHandler = () => {
      if (this.tooltip) this.hideTooltip();
    };

    this.cellTarget.addEventListener("mouseenter", this.mouseEnterHandler);
    this.cellTarget.addEventListener("mouseleave", this.mouseLeaveHandler);
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

    if (!this.placementValue || this.placementValue === 'bottom') {

      const left = Math.max(rect.left + window.pageXOffset - this.tooltip.offsetWidth/2 + rect.width/2, 0)
      const top = rect.bottom + scrollTop + 2

      this.tooltip.style.left = `${left}px`;
      this.tooltip.style.top = `${top}px`;

    } else if (this.placementValue === 'top') {

      const left = Math.max(rect.left + window.pageXOffset - this.tooltip.offsetWidth/2 + rect.width/2, 0)
      const top = Math.max(rect.top + scrollTop - this.tooltip.offsetHeight - 5)

      this.tooltip.style.left = `${left}px`;
      this.tooltip.style.top = `${top}px`;

    }
  }

  hideTooltip() {
    this.tooltip.classList.remove("visible");
    this.tooltip.classList.add("invisible");

    this.cellTarget.appendChild(this.tooltip)
  }

  disconnect() {
    this.cellTarget.removeEventListener("mouseenter", this.mouseEnterHandler);
    this.cellTarget.removeEventListener("mouseleave", this.mouseLeaveHandler);
  }
}
