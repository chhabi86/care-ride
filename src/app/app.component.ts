
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
      
      </div>
    </section>
    <router-outlet></router-outlet>

    <footer style="background:#4b6cb7;position:relative;padding:0;margin:0;">
      <div style="max-width:1400px;margin:0 auto;padding:0 24px;display:flex;flex-wrap:wrap;justify-content:space-between;align-items:flex-start;gap:40px 0;background:#4b6cb7;">
        <div style="flex:1;min-width:260px;padding:48px 0 24px 0;text-align:center;">
          <div style="font-size:2rem;font-weight:700;color:#fff;line-height:1.1;">Care Ride Solutions</div>
          <div style="color:#7be495;font-size:1.1rem;font-weight:500;margin:8px 0 18px 0;">Medical Transportation Provider</div>
          <div style="margin-bottom:18px;">Share Via</div>
          <div style="display:flex;justify-content:center;gap:16px;">
            <a href="#" style="background:#3b5998;border-radius:50%;width:40px;height:40px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:1.3rem;"><span class="fa fa-facebook"></span>f</a>
            <a href="#" style="background:#000;border-radius:50%;width:40px;height:40px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:1.3rem;">X</a>
            <a href="#" style="background:#0e76a8;border-radius:50%;width:40px;height:40px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:1.3rem;">in</a>
            <a href="#" style="background:#25d366;border-radius:50%;width:40px;height:40px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:1.3rem;">&#x1F4F2;</a>
            <a href="#" style="background:#000;border-radius:50%;width:40px;height:40px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:1.3rem;">&#x2709;</a>
          </div>
        </div>
        <div style="flex:1;min-width:200px;padding:48px 0 24px 0;">
          <div style="font-size:1.5rem;font-weight:700;color:#7be495;margin-bottom:18px;">Quick Links</div>
          <div style="display:flex;flex-direction:column;gap:10px;">
            <a href="#" style="color:#7be495;font-weight:600;text-decoration:none;">Home</a>
            <a href="#" style="color:#fff;text-decoration:none;">About Us</a>
              <a routerLink="/book" style="color:#fff;text-decoration:none;">Book</a>
              <a routerLink="/services" style="color:#fff;text-decoration:none;">Services</a>
            <a routerLink="/contact" style="color:#fff;text-decoration:none;">Contact Us</a>
          </div>
        </div>
        <div style="flex:1;min-width:220px;padding:48px 0 24px 0;">
          <div style="font-size:1.5rem;font-weight:700;color:#7be495;margin-bottom:18px;">Working Hours</div>
          <div style="display:flex;flex-direction:column;gap:12px;color:#fff;">
            <div><span style="color:#7be495;margin-right:8px;">&#x1F4C5;</span> Monday – Friday</div>
            <div><span style="color:#7be495;margin-right:8px;">&#x23F0;</span> 24 Hours</div>
            <div><span style="color:#7be495;margin-right:8px;">&#x1F4C5;</span> Saturday & Sunday</div>
            <div><span style="color:#7be495;margin-right:8px;">&#x23F0;</span> 05:00 am – 06:00 pm</div>
          </div>
        </div>
        <div style="flex:1;min-width:240px;padding:48px 0 24px 0;">
          <div style="font-size:1.5rem;font-weight:700;color:#7be495;margin-bottom:18px;">Contact Information</div>
          <div style="display:flex;flex-direction:column;gap:12px;color:#fff;">
            <div><span style="color:#7be495;margin-right:8px;">&#x260E;</span> (716) 333 – 7433</div>
            <div><span style="color:#7be495;margin-right:8px;">&#x1F4F2;</span> (716) 335 – 5031</div>
            <div><span style="color:#7be495;margin-right:8px;">&#x2709;</span> cs&#64;independentrides.com</div>
            <div><span style="color:#7be495;margin-right:8px;">&#x1F4CD;</span> Buffalo, NY 14218</div>
          </div>
        </div>
      </div>
      <div style="background:#53c26b;padding:16px 0;text-align:center;color:#fff;font-size:1.1rem;font-weight:500;border-radius:0 0 10px 10px;margin-top:0;">
  Copyright © 2025 | Care Ride Solutions | All Rights Reserved
      </div>
    </footer>
  `
})
export class AppComponent {}
