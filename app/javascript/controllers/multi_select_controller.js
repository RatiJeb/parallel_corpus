import { Controller } from '@hotwired/stimulus'
import Choices from 'choices'

export default class extends Controller {
  static values = {
    options: Object,
  }

  connect() {
    console.log(this.optionsValue)
    new Choices(
      this.element,
      {
        ...this.optionsValue,
        ...{
          removeItemButton: true,
          loadingText: 'იტვირთება...',
          noResultsText: 'შედეგი არ მოიძებნა',
          noChoicesText: 'მონაცემები არ არის',
          itemSelectText: 'დააჭირეთ ასარჩევად',
          uniqueItemText: 'მხოლოდ უნიკალური მნიშვნელობები შეიძლება დაემატოს',
          customAddItemText: 'მხოლოდ ის მნიშვნელობები შეიძლება დაემატოს, რომლებიც პირობას აკმაყოფილებენ',
          classNames: {
            containerOuter: 'choices',
            containerInner: 'choices__inner bg-gray-50 border rounded-md px-1 py-2 border-gray-300',
            input: 'choices__input',
            inputCloned: 'choices__input--cloned',
            list: 'choices__list',
            listItems: 'choices__list--multiple',
            listSingle: 'choices__list--single',
            listDropdown: 'choices__list--dropdown',
            item: 'choices__item bg-mountbatten-500',
            itemSelectable: 'choices__item--selectable',
            itemDisabled: 'choices__item--disabled',
            itemChoice: 'choices__item--choice bg-gray-50',
            placeholder: 'choices__placeholder',
            group: 'choices__group',
            groupHeading: 'choices__heading',
            button: 'choices__button',
            activeState: 'is-active',
            focusState: 'is-focused',
            openState: 'is-open',
            disabledState: 'is-disabled',
            highlightedState: 'is-highlighted',
            selectedState: 'is-selected',
            flippedState: 'is-flipped',
            loadingState: 'is-loading',
            noResults: 'has-no-results',
            noChoices: 'has-no-choices'
          }
        }
      }
    );
  }
}
