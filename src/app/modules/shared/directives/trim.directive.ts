import { Directive, ElementRef, HostListener, inject } from '@angular/core';
import { NgControl } from '@angular/forms';

@Directive({
  selector: '[appTrim]',
  standalone: true,
})
export class TrimDirective {
  el = inject(ElementRef);
  ngControl = inject(NgControl);

  @HostListener('blur') onBlur() {
    const control = this.ngControl.control;
    if (control) {
      control.setValue(this.el.nativeElement.value.trim());
    }
  }
}
