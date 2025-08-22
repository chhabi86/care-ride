
import { Routes } from '@angular/router';
import { AppComponent } from './app.component';
import { ContactComponent } from './contact.component';

import { ServicesComponent } from './services.component';
import { BookComponent } from './book.component';
import { HomeComponent } from './home.component';

export const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'services', component: ServicesComponent },
  { path: 'book', component: BookComponent },
  { path: 'contact', component: ContactComponent },
];
