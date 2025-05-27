import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["labelSelect", "quarterSelect", "instructorSelect"]

  submit(event) {
    // Prevent the default change event
    event.preventDefault()
    
    // Submit the form
    this.element.requestSubmit()
  }
} 