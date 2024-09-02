import { Controller } from '@hotwired/stimulus'
import { put } from '@rails/request.js'

export default class extends Controller {

  connect() {
  }

  async trigger() {
    const searchParams = new URLSearchParams(window.location.search);
    let params = {collection_id: searchParams.get('collection_id'), text_blocks: []}
    document.querySelectorAll('[id^=\'text-block-\']:not([id^=\'text-block-dummy\'])').forEach((block) => {
      let [language, order_number] = block.outerText.split('-')
      let id = block.dataset.new ? 'new' : block.id.split('text-block-')[1]
      let contents = block.children[0].children[0].children[1].children[0].value
      params.text_blocks.push({language: language.toLowerCase(), order_number, id, contents})
    })

    const response = await put('update_multiple', { body: JSON.stringify(params) })

    if(response.ok){
      window.alert('ცვლილებები განახლდა წარმატებით.');
    }else{
      window.alert('ცვლილებების შენახვისას წარმოიშვა შეცდომა.');
    }

  //   data-new="true"
  }

}
