import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // connect() {
  //   alert("Hello, Stimulus!");
  // }

  static targets = [ "topic" ]

  ads() {
    alert("Hello, Stimulus!");


  }

  greet() {
    let topic_button = document.getElementById('topic_button_' + this.topicTarget.value);

    topic_button.style.background = 'red'

  }

  by() {
    let topic_button = document.getElementById('topic_button_' + this.topicTarget.value);

    topic_button.style.background = 'white'
  }
}