import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div style="position:relative;width:100vw;min-height:70vh;overflow:hidden;background:#f8f8f8;">
  <img src="assets/banner.jpg" alt="Medical Transportation Banner" style="width:100vw;height:70vh;object-fit:cover;object-position:center;filter:brightness(0.7);position:absolute;top:0;left:0;z-index:0;" />
      <div style="position:relative;z-index:1;display:flex;flex-direction:column;align-items:center;justify-content:center;height:70vh;">
        <h1 style="color:#fff;font-size:2.5rem;font-weight:700;text-align:center;margin-bottom:18px;max-width:700px;">The easiest way to order wheelchair-accessible rides</h1>
        <p style="color:#fff;font-size:1.2rem;text-align:center;max-width:600px;margin-bottom:24px;">Getting a wheelchair-accessible ride should be just as easy as getting one that’s not. CareRide Technology makes it possible by uniting certified service and patients for more freedom and mobility of life.</p>
        <a href="#" style="background:#f59e0b;color:#fff;font-weight:600;padding:12px 32px;border-radius:8px;font-size:1.1rem;text-decoration:none;box-shadow:0 2px 8px rgba(0,0,0,0.12);">Book a ride</a>
      </div>
    </div>
    <div style="background:#fff;padding:60px 0 40px 0;">
      <div style="display:flex;justify-content:center;gap:48px;flex-wrap:wrap;max-width:1100px;margin:0 auto 40px auto;">
        <div style="display:flex;flex-direction:column;align-items:center;max-width:160px;">
          <img src="assets/services/wheelchair.png" alt="Easy and secure on request" style="width:56px;height:56px;margin-bottom:12px;" />
          <div style="font-weight:600;color:#0f766e;text-align:center;">Easy and secure on request</div>
        </div>
        <div style="display:flex;flex-direction:column;align-items:center;max-width:160px;">
          <img src="assets/services/doctor.jpg" alt="Secure door-to-door transportation" style="width:56px;height:56px;margin-bottom:12px;" />
          <div style="font-weight:600;color:#0f766e;text-align:center;">Secure door-to-door transportation</div>
        </div>
        <div style="display:flex;flex-direction:column;align-items:center;max-width:160px;">
          <img src="assets/services/hospital.jpg" alt="Careful data and licensed drivers" style="width:56px;height:56px;margin-bottom:12px;" />
          <div style="font-weight:600;color:#0f766e;text-align:center;">Careful data and licensed drivers</div>
        </div>
        <div style="display:flex;flex-direction:column;align-items:center;max-width:160px;">
          <img src="assets/services/physical-therapy.png" alt="Transparent pricing model" style="width:56px;height:56px;margin-bottom:12px;" />
          <div style="font-weight:600;color:#0f766e;text-align:center;">Transparent pricing model</div>
        </div>
      </div>
      <div style="max-width:900px;margin:0 auto;text-align:center;">
        <h2 style="font-size:2rem;font-weight:700;margin-bottom:18px;color:#222;">Current <span style='color:#0f766e'>statistics</span></h2>
        <div style="display:flex;flex-wrap:wrap;gap:32px;justify-content:center;">
          <div style="min-width:180px;">
            <div style="font-size:2rem;font-weight:700;color:#0f766e;">2M</div>
            <div style="color:#444;">Make wheelchair users in the US rely on paratransit</div>
          </div>
          <div style="min-width:180px;">
            <div style="font-size:2rem;font-weight:700;color:#0f766e;">3.6M</div>
            <div style="color:#444;">is the number of Americans who need wheelchair-based travel assistance</div>
          </div>
          <div style="min-width:180px;">
            <div style="font-size:2rem;font-weight:700;color:#0f766e;">8.5M</div>
            <div style="color:#444;">of US total population ages 5 and older have ambulatory disability</div>
          </div>
          <div style="min-width:180px;">
            <div style="font-size:2rem;font-weight:700;color:#0f766e;">13.7%</div>
            <div style="color:#444;">of people with a disability in the US have difficulty walking or climbing stairs</div>
          </div>
          <div style="min-width:180px;">
            <div style="font-size:2rem;font-weight:700;color:#0f766e;">90%</div>
            <div style="color:#444;">is the percent spent per year on non-emergency medical transportation (NEMT) trips covered by Medicaid</div>
          </div>
          <div style="min-width:180px;">
            <div style="font-size:2rem;font-weight:700;color:#0f766e;">1 in 4</div>
            <div style="color:#444;">US adults have a disability that impacts major life activities</div>
          </div>
        </div>
      </div>
    </div>
  `
})
export class HomeComponent {}
