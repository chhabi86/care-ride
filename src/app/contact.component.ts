import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { ApiService } from './api.service';

import { FormsModule } from '@angular/forms';
@Component({
  selector: 'app-contact',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './contact.component.html',
})
export class ContactComponent {
  name = '';
  phone = '';
  email = '';
  reason = '';
  message = '';
  sending = false;
  sent = false;
  error = '';

  constructor(private router: Router, private api: ApiService) {}

  goToBook() {
    this.router.navigate(['/book']);
  }

  submitContact() {
  if (this.sending || this.sent) return; // prevent double clicks/submits
  if (!this.name || !this.phone || !this.email || !this.reason || !this.message) {
      this.error = 'Please fill in all required fields.';
      return;
    }
    this.sending = true;
    this.error = '';
    this.api.contact({
      name: this.name,
      email: this.email,
      phone: this.phone,
      reason: this.reason,
      message: this.message
    }).subscribe({
      next: () => {
  this.sending = false;
  this.sent = true;
  // set a DOM-level flag so external automation (Playwright) can reliably detect success
  try { document.body.setAttribute('data-contact-sent', '1'); } catch (e) { /* ignore */ }
      },
      error: err => {
        this.sending = false;
        this.error = 'Failed to send. Please try again later.';
      }
    });
  }
}
