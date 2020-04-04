// Greenhouse support
// Michael McCool 2020
sm = 10;
tol = 0.1;

shaft_h = 15;
shaft_tol = 0.3;
shaft_H = shaft_h + shaft_tol;

support_r = 8 + shaft_h/cos(45);
support_R = support_r + 3;
support_L = 5*support_R;
support_H = 2*support_r - 6;
support_sm = 4*sm;

shaft_L = support_r+support_R+support_L;

pin_tol = 0.1;
pin_r = 3/2 - pin_tol;
pin_h = support_R;
pin_R = 6/2 + tol;
pin_H = 4;

module support(t=0) {
  intersection() {
    union() {
      sphere(r=support_R+t,$fn=support_sm);
      hull() {
        sphere(r=support_r+t,$fn=support_sm);
        translate([-support_L,0,0])
          sphere(r=support_r+t,$fn=support_sm);
      }
    }
    translate([-(support_r+support_L+tol+t),-support_R-t-tol,-support_H/2-t])
      cube([support_r+support_R+support_L+2*tol+2*t,2*(support_R+2*t+tol),support_H+2*t]);
  }
}

module shaft() {
  translate([-shaft_L,-shaft_H/2,-shaft_H/2])
    cube([shaft_L,shaft_H,shaft_H]);
}

module pin() {
  translate([0,0,-pin_h])
    cylinder(r=pin_r,h=pin_h,$fn=sm);
  translate([0,0,support_R-support_H/2-pin_h-tol])
    cylinder(r=pin_R,h=pin_H,$fn=sm);
}

module assembly() {
  difference() {
    support();
    shaft();
    translate([-1*support_L/4,0,0]) pin();
    translate([-2*support_L/4,0,0]) pin();
    translate([-3*support_L/4,0,0]) pin();
    translate([-4*support_L/4,0,0]) pin();
  }
}

clamp_t = 4*0.8+tol;
clamp_tol = 1;
clamp_a = 5;
module clamp(t=clamp_t) {
  difference() {
    intersection() {
      support(t=clamp_t);
      rotate([0,clamp_a,0])
        translate([-(support_L+tol+t),-support_R-t-tol,-support_H/4-t])
          cube([support_R+support_L+2*tol+2*t,2*(support_R+2*t+tol),support_H+2*t]);
    }
    support(t=clamp_tol);
  }
}

assembly();
clamp();
