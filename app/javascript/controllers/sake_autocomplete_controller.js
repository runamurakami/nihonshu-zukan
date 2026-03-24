import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocomplete"
export default class extends Controller {
  static targets = ["input", "results"]

  search() {
    const query = this.inputTarget.value.trim()

    if (query.length < 2) {
      this.clearResults()
      return
    }

    fetch(`/sakes/autocomplete?q=${encodeURIComponent(query)}`)
      .then(res => res.json())
      .then(data => this.showResults(data))
  }

  showResults(results) {
    this.resultsTarget.innerHTML = results.map(name =>
      `<li class="px-2 py-1 cursor-pointer hover:bg-gray-100"
           data-action="click->sake-autocomplete#select">${name}</li>`
    ).join("")

    this.resultsTarget.classList.remove("hidden")
  }

  select(event) {
    this.inputTarget.value = event.target.textContent.trim()
    this.clearResults()
  }

  clearResults() {
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.classList.add("hidden")
  }
}
