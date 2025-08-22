
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../environments/environment';
import { Observable } from 'rxjs';

export interface ServiceType { id:number; name:string; description:string; icon:string; }
export interface BookingPayload {
  fullName:string; phone:string; email?:string;
  pickupAddress:string; dropoffAddress:string;
  pickupTime:string; serviceTypeId:number; notes?:string;
}

@Injectable({ providedIn: 'root' })
export class ApiService {
  private base = environment.apiBase;
  constructor(private http: HttpClient) {}
  services(): Observable<ServiceType[]> { return this.http.get<ServiceType[]>(`${this.base}/services`); }
  book(payload: BookingPayload){ return this.http.post(`${this.base}/bookings`, payload); }
  contact(payload: {name:string; email:string; message:string}) { return this.http.post(`${this.base}/contact`, payload); }
}
