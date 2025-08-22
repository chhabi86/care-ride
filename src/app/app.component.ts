
import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { ApiService, ServiceType } from './api.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],

  template: `
    <header style="background:#fff;border-bottom:1px solid #eee">
      <div class="container" style="display:flex;align-items:center;justify-content:space-between;padding:14px 0;">
        <div style="display:flex;align-items:center;gap:16px;">
          <img src="assets/care-ride-logo.png" alt="Care Ride Solutions Logo" style="width:60px;height:60px;object-fit:contain;" />
          <span style="font-weight:800;color:#0f766e;font-size:1.3rem;white-space:nowrap;">Care Ride Solutions</span>
        </div>
        <nav style="display:flex;gap:18px;">
          <a routerLink="/" routerLinkActive="active">Home</a>
          <a routerLink="/services" routerLinkActive="active">Services</a>
          <a routerLink="/book" routerLinkActive="active">Book</a>
          <a routerLink="/contact" routerLinkActive="active">Contact</a>
        </nav>
      </div>
    </header>
    <section style="background:#0f766e;color:#fff;padding:60px 0">
      <div class="container">
        <h1>MEDICAL TRANSPORTATION</h1>
        <p>Safe and reliable non-emergency transport for patients.</p>
        <a routerLink="/book" style="display:inline-block;background:#f59e0b;color:#fff;padding:10px 16px;border-radius:8px;text-decoration:none;margin-top:12px">GET A QUOTE</a>
      </div>
    </section>
    <router-outlet></router-outlet>
  `
})
export class AppComponent {}
