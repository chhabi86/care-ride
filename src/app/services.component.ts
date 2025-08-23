import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-services',
  standalone: true,
  imports: [CommonModule],
  template: `
    <section style="max-width:900px;margin:0 auto;padding:40px 0 60px 0;">
      <h2 style="text-align:center;font-size:2.1rem;font-weight:700;margin-bottom:8px;color:#222;">Our Medical Transportation Services</h2>
      <div style="text-align:center;font-size:1.2rem;color:#0f766e;font-weight:600;margin-bottom:8px;">Safe, Efficient, and Reliable Medical Transportation</div>
      <div style="text-align:center;color:#444;max-width:700px;margin:0 auto 32px auto;font-size:1.05rem;">We provide safe and dependable transportation for a wide range of medical appointments and treatments, whether it’s routine checkup or specialized care.</div>
      <div class="services-grid" style="display:grid;grid-template-columns:repeat(auto-fit,minmax(340px,1fr));gap:28px;">
        <div *ngFor="let s of serviceList" style="background:#fff;border-radius:16px;box-shadow:0 2px 12px rgba(0,0,0,.07);padding:28px 24px;display:flex;align-items:center;gap:24px;min-height:140px;">
          <div style="width:140px;height:140px;display:flex;align-items:center;justify-content:center;flex-shrink:0;background:transparent;">
            <img [src]="s.icon" [alt]="s.name"
              [ngStyle]="
                s.name.startsWith('Doctor') || s.name.startsWith('Hospital') || s.name.startsWith('Physical Therapy') || s.name.startsWith('Dialysis') || s.name.startsWith('Chemotherapy') || s.name.startsWith('Radiation') || s.name.startsWith('Medical Testing') || s.name.startsWith('Surgery') || s.name.startsWith('Follow-Up') || s.name.startsWith('Discharge') || s.name.startsWith('Specialized Care') || s.name.startsWith('Ongoing Therapy')
                  ? {'object-fit':'cover','width':'100%','height':'100%','border-radius':'12px'}
                  : {'object-fit':'contain','width':'100%','height':'100%'}
              " />
          </div>
          <div style="flex:1;display:flex;flex-direction:column;gap:8px;">
            <div style="font-weight:700;font-size:1.08rem;line-height:1.1;">{{s.name}}</div>
            <div style="color:#888;font-size:0.98rem;line-height:1.5;">{{s.desc}}</div>
            <div style="margin-top:8px;">
              <a href="#" style="background:linear-gradient(90deg,#4f8cff,#4fd1a1);color:#fff;font-weight:500;padding:8px 22px;border-radius:32px;font-size:1rem;text-decoration:none;box-shadow:0 2px 8px rgba(79,140,255,0.08);transition:background .2s;">Get Connected</a>
            </div>
          </div>
        </div>
      </div>
    </section>
  `
})
export class ServicesComponent {
  serviceList = [
    { name: "Doctor's Appointments Transportation Service", desc: "Safe, timely rides for medical appointments.", icon: 'assets/services/doctor.jpg' },
    { name: "Hospital Visits Transportation Service", desc: "Reliable transportation for emergency and scheduled hospital visits.", icon: 'assets/services/hospital.jpg' },
    { name: "Physical Therapy Sessions Transportation Service", desc: "Comfortable rides to and from physical therapy sessions.", icon: 'assets/services/physical-therapy.jpg' },
    { name: "Dialysis Treatment Transportation Service", desc: "Dependable service for regular dialysis appointments.", icon: 'assets/services/dialysis.jpg' },
    { name: "Chemotherapy Sessions Transportation Service", desc: "Supportive rides to chemotherapy treatments.", icon: 'assets/services/chemotherapy.jpg' },
    { name: "Radiation Therapy Appointments Transportation Service", desc: "Safe transport for ongoing radiation therapy sessions.", icon: 'assets/services/radiation.jpg' },
    { name: "Medical Testing Transportation Service", desc: "Easy access to labs and testing appointments.", icon: 'assets/services/testing.jpg' },
    { name: "Surgery or Procedure Appointments Transportation Service", desc: "Pre- and post-surgery transportation for procedures.", icon: 'assets/services/surgery.jpg' },
    { name: "Follow-Up or Post-Operative Appointments", desc: "Reliable rides for all post-surgery follow-ups.", icon: 'assets/services/followup.jpg' },
    { name: "Discharge from Hospital or Rehabilitation Center", desc: "Safe rides home after hospital or rehab stays.", icon: 'assets/services/discharge.jpg' },
    { name: "Specialized Care Facility Transportation", desc: "Transportation to/from nursing or specialized care facilities.", icon: 'assets/services/specialized-care.jpg' },
    { name: "Ongoing Therapy or Treatment Appointments Transportation", desc: "Consistent rides for ongoing therapy and treatment.", icon: 'assets/services/ongoing-therapy.jpg' }
  ];
}
