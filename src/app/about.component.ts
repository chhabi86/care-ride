import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-about',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div style="background:#fff;padding:48px 0 0 0;">
      <div style="max-width:1100px;margin:0 auto;display:flex;align-items:center;gap:48px;flex-wrap:wrap;">
        <img src="assets/services/illustration-taxi.png" alt="Medical Transportation" style="max-width:320px;width:100%;">
        <div>
          <div style="color:#7be495;font-weight:600;font-size:1.1rem;margin-bottom:8px;">About Independent Ride Services</div>
          <h1 style="font-size:2.2rem;font-weight:700;margin:0 0 16px 0;line-height:1.2;">Your Trusted Partner for Safe and Reliable Medical Transportation</h1>
          <div style="font-size:1.1rem;color:#444;line-height:1.7;max-width:600px;">
            We are dedicated to providing safe, reliable non-emergency transportation for all. Our services include medical rides to and from normal medical and health appointments.<br><br>
            Experience safe, reliable, and comfortable transportation with our professional drivers. Our fleet is maintained with the utmost care, ensuring peace of mind for individuals and groups alike. Enjoy the privilege and freedom of getting to your destination on time. Whether you’re heading to the doctor, hospital, or therapy, we’ll ensure you reach safely and on schedule.
          </div>
        </div>
      </div>
    </div>

    <div style="background:#fafafd;padding:64px 0 0 0;">
      <div style="max-width:1100px;margin:0 auto;text-align:center;">
        <div style="color:#7be495;font-weight:600;font-size:1.1rem;margin-bottom:8px;">Our Commitment To Your Independence</div>
        <h2 style="font-size:2rem;font-weight:700;margin:0 0 32px 0;">Reliable Medical Transportation Services</h2>
        <div style="display:flex;justify-content:center;gap:32px;flex-wrap:wrap;">
          <div style="background:#fff;border-radius:12px;box-shadow:0 2px 8px #0001;padding:32px 24px;max-width:240px;flex:1 1 200px;">
            <img src="assets/services/freedom.png" alt="Freedom to Travel" style="width:48px;margin-bottom:12px;">
            <div style="font-weight:700;font-size:1.1rem;margin-bottom:8px;">Freedom to Travel</div>
            <div style="color:#444;font-size:1rem;">Go where you want, when you want, with our easy-to-schedule rides.</div>
            <a style="color:#2d7be5;font-weight:600;display:block;margin-top:12px;" href="#">Learn More →</a>
          </div>
          <div style="background:#fff;border-radius:12px;box-shadow:0 2px 8px #0001;padding:32px 24px;max-width:240px;flex:1 1 200px;">
            <img src="assets/services/self-sufficiency.png" alt="Self-Sufficiency" style="width:48px;margin-bottom:12px;">
            <div style="font-weight:700;font-size:1.1rem;margin-bottom:8px;">Self-Sufficiency</div>
            <div style="color:#444;font-size:1rem;">Maintain your independence and daily routines with reliable rides.</div>
            <a style="color:#2d7be5;font-weight:600;display:block;margin-top:12px;" href="#">Learn More →</a>
          </div>
          <div style="background:#fff;border-radius:12px;box-shadow:0 2px 8px #0001;padding:32px 24px;max-width:240px;flex:1 1 200px;">
            <img src="assets/services/unrestricted.png" alt="Unrestricted Mobility" style="width:48px;margin-bottom:12px;">
            <div style="font-weight:700;font-size:1.1rem;margin-bottom:8px;">Unrestricted Mobility</div>
            <div style="color:#444;font-size:1rem;">Access medical care and social activities without barriers.</div>
            <a style="color:#2d7be5;font-weight:600;display:block;margin-top:12px;" href="#">Learn More →</a>
          </div>
          <div style="background:#fff;border-radius:12px;box-shadow:0 2px 8px #0001;padding:32px 24px;max-width:240px;flex:1 1 200px;">
            <img src="assets/services/personalized.png" alt="Personalized Support" style="width:48px;margin-bottom:12px;">
            <div style="font-weight:700;font-size:1.1rem;margin-bottom:8px;">Personalized Support</div>
            <div style="color:#444;font-size:1rem;">Responsive and compassionate assistance for every ride.</div>
            <a style="color:#2d7be5;font-weight:600;display:block;margin-top:12px;" href="#">Learn More →</a>
          </div>
        </div>
      </div>
    </div>

    <div style="background:url('assets/banner.jpg') center/cover no-repeat;padding:96px 0 0 0;min-height:420px;">
      <div style="max-width:1100px;margin:0 auto;display:flex;align-items:center;justify-content:center;">
        <div style="background:#fff;border-radius:16px;box-shadow:0 2px 16px #0002;padding:32px 32px 32px 32px;max-width:420px;margin-right:32px;">
          <div style="color:#7be495;font-weight:600;font-size:1.1rem;margin-bottom:8px;">Ready to Book Your Ride?</div>
          <h3 style="font-size:1.4rem;font-weight:700;margin:0 0 16px 0;">Safe, Reliable Medical Transportation at Your Fingertips</h3>
          <div style="font-size:1rem;color:#444;line-height:1.6;">Book your non-emergency medical transportation with ease and confidence. Let Independent Ride Services take care of the journey, so you can focus on your health.</div>
          <div style="margin-top:18px;display:flex;gap:12px;align-items:center;">
            <a routerLink="/contact" style="background:#7be495;color:#fff;font-weight:600;padding:8px 20px;border-radius:6px;text-decoration:none;">Contact Now</a>
            <span style="font-size:1.1rem;color:#222;">(814) 528 - 4547</span>
          </div>
        </div>
        <img src="assets/services/taxi-photo.jpg" alt="Taxi" style="width:260px;border-radius:12px;box-shadow:0 2px 12px #0002;">
      </div>
  <!-- Stats row removed as requested -->
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
          <ul style="list-style:none;padding:0;margin:0;">
            <li style="margin-bottom:16px;display:flex;align-items:center;gap:12px;"><span style="background:#7be495;width:24px;height:24px;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;color:#fff;font-size:1.2rem;">✓</span> Have mobility issues or disabilities</li>
            <li style="margin-bottom:16px;display:flex;align-items:center;gap:12px;"><span style="background:#7be495;width:24px;height:24px;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;color:#fff;font-size:1.2rem;">✓</span> Lack reliable transportation</li>
            <li style="margin-bottom:16px;display:flex;align-items:center;gap:12px;"><span style="background:#7be495;width:24px;height:24px;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;color:#fff;font-size:1.2rem;">✓</span> Need assistance with medical equipment or mobility aids</li>
            <li style="margin-bottom:16px;display:flex;align-items:center;gap:12px;"><span style="background:#7be495;width:24px;height:24px;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;color:#fff;font-size:1.2rem;">✓</span> Require companionship or support during transport</li>
            <li style="margin-bottom:16px;display:flex;align-items:center;gap:12px;"><span style="background:#7be495;width:24px;height:24px;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;color:#fff;font-size:1.2rem;">✓</span> Have limited family or caregiver support</li>
          </ul>
        </div>
      </div>
    </div>
  `
})
export class AboutComponent {}
