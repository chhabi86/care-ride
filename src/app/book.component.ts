import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService, ServiceType } from './api.service';

@Component({
  selector: 'app-book',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <section class="container" style="padding:40px 0">
      <h2 style="font-size:2rem;font-weight:700;margin-bottom:24px;color:#0f766e">Book a Ride</h2>
      <form (ngSubmit)="submit()" #f="ngForm" style="max-width:500px;margin:auto;display:grid;gap:18px;">
        <label class="field">
          <span class="label-text">Full name <span style="color:#c00">*</span></span>
          <input name="fullName" [(ngModel)]="form.fullName" placeholder="Full Name" required>
        </label>
        <label class="field">
          <span class="label-text">Phone <span style="color:#c00">*</span></span>
          <input name="phone" [(ngModel)]="form.phone" placeholder="Phone" required>
        </label>
        <label class="field">
          <span class="label-text">Email</span>
          <input name="email" [(ngModel)]="form.email" placeholder="Email">
        </label>
        <label class="field">
          <span class="label-text">Pickup address <span style="color:#c00">*</span></span>
          <input name="pickupAddress" [(ngModel)]="form.pickupAddress" placeholder="Pickup Address" required>
        </label>
        <label class="field">
          <span class="label-text">Drop-off address <span style="color:#c00">*</span></span>
          <input name="dropoffAddress" [(ngModel)]="form.dropoffAddress" placeholder="Drop-off Address" required>
        </label>
        <label class="field">
          <span class="label-text">Pickup time <span style="color:#c00">*</span></span>
          <input type="datetime-local" name="pickupTime" [(ngModel)]="form.pickupTime" required>
        </label>
        <label class="field">
          <span class="label-text">Service type <span style="color:#c00">*</span></span>
          <select name="serviceTypeId" [(ngModel)]="form.serviceTypeId" required>
            <option value="" disabled selected>Select service</option>
            <option *ngFor="let s of services" [value]="s.id">{{s.name}}</option>
          </select>
        </label>
        <label class="field full">
          <span class="label-text">Notes</span>
          <textarea name="notes" [(ngModel)]="form.notes" placeholder="Notes"></textarea>
        </label>
        <div class="full">
          <button [disabled]="submitting" style="width:100%;background:#0f766e;color:#fff;border:none;padding:10px;border-radius:8px">{{submitting? 'Submitting...' : 'Submit'}}</button>
        </div>
        <p *ngIf="ok" style="color:#0a7a0a" class="full">Request submitted. We’ll contact you shortly.</p>
        <p *ngIf="formError" style="color:#c00" class="full">{{formError}}</p>
      </form>
    </section>
  `
})
export class BookComponent {
  services: ServiceType[] = [];
  form: any = {};
  ok = false;
  submitting = false;
  formError: string|null = null;
  constructor(private api: ApiService) {
    this.api.services().subscribe({
      next: d => { this.services = d; },
      error: () => { this.services = []; }
    });
  }
  submit() {
    this.formError = null;
    if(!this.form.fullName || !this.form.phone || !this.form.pickupAddress || !this.form.dropoffAddress || !this.form.pickupTime || !this.form.serviceTypeId){
      this.formError = 'Please fill required fields.'; return;
    }
    this.submitting = true;
    const payload = { ...this.form, pickupTime: new Date(this.form.pickupTime).toISOString() };
    this.api.book(payload).subscribe({
      next: ()=> { this.ok = true; this.submitting = false; },
      error: ()=> { this.formError = 'Submission failed. Try again.'; this.submitting = false; }
    });
  }
}
