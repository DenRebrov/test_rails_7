import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    let timer = document.getElementById('timer');
    if (timer) { runTimer(timer) }

    function runTimer() {
      let startTime = timer.dataset.startTime;
      let passageTime = timer.dataset.passageTime;
      let spentTime = Math.trunc(Date.now() / 1000) - startTime;
      let remainingTime = passageTime - spentTime;

      if (spentTime >= passageTime) {
        let resultPage = window.location.href + '/result';
        window.location.replace(resultPage);
      }

      let seconds = remainingTime % 60;
      let minutes = (remainingTime - seconds) / 60;
      if (seconds < 10) { seconds = '0' + seconds }

      if (seconds < '00') {
        timer.textContent = 'Time is over...';
      } else {
        timer.textContent = minutes + ':' + seconds;
      }

      setTimeout(runTimer, 1000, timer);
    }

  }
}
