# frozen_string_literal: true

module Front # Back
  class FormBuilder < ActionView::Helpers::FormBuilder
    def label(method, text = nil, options = {}, &block)
      options[:class] ||= 'block text-sm font-medium leading-6 text-gray-900'
      super
    end

    CLASSES_BUTTON_FULL = %w[
      flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white
      shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2
      focus-visible:outline-indigo-600 cursor-pointer
    ].join(' ')

    def submit(value = nil, options = {})
      options[:class] ||= CLASSES_BUTTON_FULL
      super
    end

    CLASSES_INPUT_FULL = %w[
      block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300
      placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6
    ].join(' ')

    def text_field(method, options = {})
      options[:class] ||= CLASSES_INPUT_FULL
      options[:class] += ' bg-gray-100' if options[:readonly]
      super
    end

    def email_field(method, options = {})
      options[:class] ||= CLASSES_INPUT_FULL
      options[:class] += ' bg-gray-100' if options[:readonly]
      super
    end

    def password_field(method, options = {})
      options[:class] ||= CLASSES_INPUT_FULL
      super
    end

    CLASSES_SELECT_FIELD = %w[
      block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 focus:ring-2
      focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6
    ].join(' ')

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      html_options[:class] ||= CLASSES_SELECT_FIELD
      super
    end
  end
end
