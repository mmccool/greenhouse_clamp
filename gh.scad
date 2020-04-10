// Greenhouse support
// Michael McCool 2020
sm = 10;
tol = 0.1;
eps = 0.01;

// print scale correction
sc = true;
sx = sc ? 0.97*15.2/15.6 : 1.0;
sy = sc ? 0.97*15.2/15.6 : 1.0;
sz = sc ? 15.2/14 : 1.0;

shaft_h = 15;
shaft_tol = 0.6;
shaft_H = shaft_h + 2*shaft_tol;

support_r = 2 + shaft_h/cos(45);
support_R = support_r + 3;
support_L = 4*support_R;
support_h = 4;
support_H = 2*support_r - 6;
support_b = sqrt(support_r*support_r-support_H*support_H/4);
support_B = sqrt(support_R*support_R-support_H*support_H/4);
support_sm = 4*sm;

shaft_L = support_r+support_R+support_L;

pin_tol = 0.1;
pin_r = 3/2 - pin_tol;
pin_h = 10; // support_R + support_h;
pin_e = 2;
pin_R = 6/2 + tol;
pin_H = 4;

module support(t=0,b=true) {
  intersection() {
    union() {
      sphere(r=support_R+t,$fn=support_sm);
      if (b) translate([0,0,-support_H/2-support_h-t])
          cylinder(r=support_B+t,support_h+t+tol,$fn=support_sm);
      hull() {
        sphere(r=support_r+t,$fn=support_sm);
        translate([-support_L,0,0])
          sphere(r=support_r+t,$fn=support_sm);
      }
      if (b) hull() {
        translate([0,0,-support_H/2-support_h-t])
          cylinder(r=support_b+t,support_h+tol,$fn=support_sm);
        translate([-support_L,0,-support_H/2-support_h-t])
          cylinder(r=support_b+t,support_h+t+tol,$fn=support_sm);
      }
    }
    translate([-(support_r+support_L+tol+t),-support_R-t-tol,-support_H/2-support_h-t])
      cube([support_r+support_R+support_L+2*tol+2*t,2*(support_R+2*t+tol),support_H+2*t+support_h]);
  }
}

module shaft() {
  translate([-shaft_L,-shaft_H/2,-shaft_H/2])
    cube([shaft_L,shaft_H,shaft_H]);
}

// bolts
pin_tr = pin_R - pin_r;
module pin() {
  // bolt body 
  translate([0,0,-pin_h])
    cylinder(r=pin_r,h=pin_h,$fn=sm);
  translate([0,0,-pin_h-pin_tr])
    cylinder(r1=pin_R,r2=pin_r,h=pin_tr+eps,$fn=sm);
  translate([0,0,-support_R-pin_h-pin_tr])
    cylinder(r=pin_R,h=support_R+eps,$fn=sm);
}

module body() {
  difference() {
    support();
    shaft();
    translate([-1*support_L/4,0,-shaft_H/2+pin_e]) pin();
    translate([-2*support_L/4,0,-shaft_H/2+pin_e]) pin();
    translate([-3*support_L/4,0,-shaft_H/2+pin_e]) pin();
    translate([-4*support_L/4,0,-shaft_H/2+pin_e]) pin();
  }
}

clamp_t = 4*0.8+tol;
clamp_tol = 1;
clamp_r = 5;
clamp_sm = 3*sm;
clamp_tt = clamp_t/2;
module clamp(t=clamp_t) {
  difference() {
    intersection() {
      support(t=clamp_t,b=false);
      translate([-(support_L+tol),-support_R-t-tol,-support_H/2-support_h+clamp_tt])
        cube([support_L-support_R+2*tol+t,2*(support_R+t+tol),2*support_R+support_h+2*t]);
      hull() {
        translate([-(support_L+tol)+clamp_r,-support_R-t-tol,-support_H/2-clamp_t+clamp_r])
          rotate([-90,0,0])
            cylinder(r=clamp_r,h=2*(support_R+t+tol),$fn=clamp_sm);
        translate([-support_R+tol-clamp_r,-support_R-t-tol,-support_H/2-clamp_t+clamp_r])
          rotate([-90,0,0])
            cylinder(r=clamp_r,h=2*(support_R+t+tol),$fn=clamp_sm);
        translate([-(support_L+tol)+clamp_r,-support_R-t-tol,support_H])
          rotate([-90,0,0])
            cylinder(r=clamp_r,h=2*(support_R+t+tol),$fn=clamp_sm);
        translate([-support_R+tol-clamp_r,-support_R-t-tol,support_H])
          rotate([-90,0,0])
            cylinder(r=clamp_r,h=2*(support_R+t+tol),$fn=clamp_sm);
      }
    }
    support(t=clamp_tol);
  }

}

// VISUALIZE
module viz() {
  body();
  clamp();
}
viz();

// PRINT
module print_body() {
  scale([sx,sy,sz]) {
    body();
  }
}
// print_body();

module print_clamp() {
  scale([sx,sy,sz]) {
    rotate([0,90,0])
      clamp();
  }
}
// print_clamp();

