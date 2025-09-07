import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-about',
  standalone: true,
  imports: [CommonModule],
  styles: [`
    :host{display:block;font-family:Inter, ui-sans-serif, system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', Arial; color:#142225}
    .header-accent{height:68px;background:linear-gradient(90deg,#0f7b73,#0b6b66);margin-bottom:12px}
    .about-wrap{background:#fff;padding:48px 0 0 0}
  .inner{max-width:1100px;margin:0 auto;display:flex;align-items:center;gap:48px;flex-wrap:wrap;justify-content:space-between}
  .hero-figure{width:520px;position:relative;flex:0 0 520px}
  .illustration{width:100%;height:100%;max-height:360px;object-fit:cover;border-radius:14px;box-shadow:0 26px 60px rgba(11,47,45,0.14);display:block}
  .hero-right{flex:1;min-width:320px;padding-left:28px}
    .hero-title{font-size:2.4rem!important;font-weight:800!important;margin:12px 0 24px 0!important;color:#0b3f3c}
    .hero-text{font-size:1.05rem!important;color:#444;line-height:1.8!important;max-width:600px}
    .section-alt{background:#fafafd;padding:64px 0 40px}
    .section-alt .heading{color:#7be495;font-weight:600;font-size:1.1rem;margin-bottom:8px}
    .cards{display:flex;justify-content:center;gap:28px;flex-wrap:wrap;margin-top:18px}
    .card{background:linear-gradient(180deg,#fff,#fbfdff);border-radius:14px;box-shadow:0 8px 24px rgba(11,47,45,0.06);padding:18px;max-width:240px;flex:1 1 200px;transition:transform .18s ease,box-shadow .18s ease}
    .card:hover{transform:translateY(-6px);box-shadow:0 18px 40px rgba(11,47,45,0.12)}
    .card-img{width:100%;height:120px;object-fit:cover;border-radius:8px;margin-bottom:12px;display:block}
    .card-title{font-weight:700;font-size:1.1rem;margin-bottom:8px;color:#0b3f3c}
    .card-text{color:#444;font-size:0.98rem}
    .learn-link{color:#2d7be5;font-weight:600;display:block;margin-top:12px;text-decoration:none}
  .banner-section{padding:96px 0 0 0;min-height:420px}
    .hero-card{background:#fff;border-radius:16px;box-shadow:0 8px 36px rgba(11,47,45,0.08);padding:32px;max-width:420px;margin-right:32px}
    .cta{background:#0f7b73;color:#fff;padding:10px 18px;border-radius:8px;text-decoration:none;font-weight:600}
    .who-list li{margin-bottom:16px;display:flex;align-items:center;gap:12px}
    @media (max-width:880px){.inner{flex-direction:column-reverse}.hero-card{margin-right:0;margin-bottom:18px}}
  `],
  template: `
    <div class="header-accent"></div>
    <div class="about-wrap">
      <div class="inner">
        <div class="hero-figure">
          <img src="assets/services/illustration-taxi.png" alt="Medical Transportation" class="illustration">
        </div>
        <div class="hero-right">
          <h1 class="hero-title">Your Trusted Partner for Safe and Reliable Medical Transportation</h1>
          <div class="hero-text">
            We are dedicated to providing safe, reliable non-emergency transportation for all. Our services include medical rides to and from normal medical and health appointments.<br><br>
            Experience safe, reliable, and comfortable transportation with our professional drivers. Our fleet is maintained with the utmost care, ensuring peace of mind for individuals and groups alike. Enjoy the privilege and freedom of getting to your destination on time. Whether you’re heading to the doctor, hospital, or therapy, we’ll ensure you reach safely and on schedule.
          </div>
        </div>
        
      </div>
    </div>

    <div class="section-alt">
      <div style="max-width:1100px;margin:0 auto;text-align:center;">
        <div class="heading">Our Commitment To Your Independence</div>
        <h2 style="font-size:2rem;font-weight:700;margin:0 0 32px 0;">Reliable Medical Transportation Services</h2>
        <div class="cards">
          <div class="card">
            <img src="assets/services/freedom.png" alt="Freedom to Travel" class="card-img">
            <div class="card-title">Freedom to Travel</div>
            <div class="card-text">Go where you want, when you want, with our easy-to-schedule rides.</div>
            <a class="learn-link" href="#">Learn More →</a>
          </div>
          <div class="card">
            <img src="assets/services/self-sufficiency.png" alt="Self-Sufficiency" class="card-img">
            <div class="card-title">Self-Sufficiency</div>
            <div class="card-text">Maintain your independence and daily routines with reliable rides.</div>
            <a class="learn-link" href="#">Learn More →</a>
          </div>
          <div class="card">
            <img src="assets/services/unrestricted.png" alt="Unrestricted Mobility" class="card-img">
            <div class="card-title">Unrestricted Mobility</div>
            <div class="card-text">Access medical care and social activities without barriers.</div>
            <a class="learn-link" href="#">Learn More →</a>
          </div>
          <div class="card">
            <img src="assets/services/personalized.png" alt="Personalized Support" class="card-img">
            <div class="card-title">Personalized Support</div>
            <div class="card-text">Responsive and compassionate assistance for every ride.</div>
            <a class="learn-link" href="#">Learn More →</a>
          </div>
        </div>
      </div>
    </div>

  <div class="banner-section" style="background-image:url('/assets/banner.jpg');background-position:center;background-size:cover;background-repeat:no-repeat;">
      <div style="max-width:1100px;margin:0 auto;display:flex;align-items:center;justify-content:center;">
        <div class="hero-card">
          <div style="color:#7be495;font-weight:600;font-size:1.1rem;margin-bottom:8px;">Ready to Book Your Ride?</div>
          <h3 style="font-size:1.4rem;font-weight:700;margin:0 0 16px 0;">Safe, Reliable Medical Transportation at Your Fingertips</h3>
          <div style="font-size:1rem;color:#444;line-height:1.6;">Book your non-emergency medical transportation with ease and confidence. Let Independent Ride Services take care of the journey, so you can focus on your health.</div>
          <div style="margin-top:18px;display:flex;gap:12px;align-items:center;">
            <a routerLink="/contact" class="cta">Contact Now</a>
            <span style="font-size:1.1rem;color:#222;">(814) 528 - 4547</span>
          </div>
        </div>
        <img src="assets/services/taxi-photo.jpg" alt="Taxi" style="width:260px;border-radius:12px;box-shadow:0 2px 12px #0002;">
      </div>
    </div>

    <div style="background:#fff;padding:64px 0;">
      <div style="max-width:1100px;margin:0 auto;display:flex;gap:48px;flex-wrap:wrap;align-items:flex-start;">
        <div style="flex:1;min-width:320px;">
          <div style="color:#7be495;font-weight:600;font-size:1.1rem;margin-bottom:8px;">Who We Serve</div>
          <h2 style="font-size:2rem;font-weight:700;margin:0 0 16px 0;">Supporting Those in Need of Reliable Transportation</h2>
          <div style="font-size:1.1rem;color:#444;line-height:1.7;">At Independent Ride Services, we understand that transportation can be a challenge for many individuals. Our mission is clear: to make non-emergency medical rides accessible, safe, and convenient for those who need it most. We serve individuals with mobility limitations, seniors, those with medical equipment, and those needing assistance with medical support and dignity during travel. We provide compassionate and respectful care, ensuring support for clients with limited mobility or complex support, ensuring that everyone can access the care they need with dignity and comfort.</div>
          <a style="color:#2d7be5;font-weight:600;display:inline-block;margin-top:18px;" href="#">Learn More →</a>
        </div>
        <div style="flex:1;min-width:320px;">
          <ul class="who-list" style="list-style:none;padding:0;margin:0;">
            <li><span style="background:#7be495;width:24px;height:24px;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;color:#fff;font-size:1.2rem;">✓</span> Have mobility issues or disabilities</li>
            <li><span style="background:#7be495;width:24px;height:24px;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;color:#fff;font-size:1.2rem;">✓</span> Lack reliable transportation</li>
            <li><span style="background:#7be495;width:24px;height:24px;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;color:#fff;font-size:1.2rem;">✓</span> Need assistance with medical equipment or mobility aids</li>
            <li><span style="background:#7be495;width:24px;height:24px;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;color:#fff;font-size:1.2rem;">✓</span> Require companionship or support during transport</li>
            <li><span style="background:#7be495;width:24px;height:24px;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;color:#fff;font-size:1.2rem;">✓</span> Have limited family or caregiver support</li>
          </ul>
        </div>
      </div>
    </div>
  `
})
export class AboutComponent {}
