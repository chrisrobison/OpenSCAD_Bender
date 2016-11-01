$fn = 120;

module eye() {
    difference() {
        color("White") sphere(d=9);
        color("Black") translate([-1,3,-1]) cube([2,5,2]);
    }
}
module eyecover(dir=1) {
   difference() {
      sphere(d=9, center=true);
      rotate([45,0,0]) translate([0,0,-4.50]) cube([50,50,9],center=true);
      
   }
}

module head() {
   difference() {
       union() {
           difference() {
              headshape(w=22,h=28);
              translate([0,0,-1]) headshape(w=21,h=30);
           }
           translate([5,11,20]) eye();
           translate([-5,11,20]) eye();
           translate([-6.5,3,20]) rotate([-90,-51,0]) visor();
       }
       translate([-5,4,7]) rotate([-90,0,0]) scale([1,1,.8]) mouthhole();
   }
   color("Black") translate([5,12,20]) rotate([0,0,0]) eyecover();
   color("Black") translate([-5,12,20]) rotate([0,-0,0])  eyecover(-1);
   translate([0,0,44]) antennae();
}

module headshape(w=24,h=28) {
    color("LightGrey") union() {
        translate([0,0,28]) sphere(r=w/2);
        cylinder(h=h,r=w/2);
    }
}

module visor() {
   difference() {
      color("LightGrey") linear_extrude(12) hull() {
         translate([8,10,0]) circle(5);
         circle(5);
       };
       color("Black") translate([0,0,-2]) linear_extrude(15) hull() {
         translate([8,10,0]) circle(4);
         circle(4);
       };
    }
 }
 
module antennae() {
   color("LightGrey") union() {
      cylinder(h=10, r1=1.3,r2=.7,center=true);
      translate([0,0,6.25]) sphere(d=3);
      translate([0,0,-5]) rotate_extrude() translate([1,0,0]) circle(1);
   }
 }
 
module mouthhole() {
   linear_extrude(10) hull() {
         translate([10,0,0]) circle(4.5);
      circle(4.5);
   }
 }

module roundedGridLines() {
   for(i=[0:4]) {
      translate([15-(i*2.5),-4-(i*2.5),3]) rotate([0,0,45]) cube([.5,15,12],center=true);
   }
   translate([8,-8,5]) rotate([0,0,45]) cube([19,15,.25],center=true);
   translate([8,-8,3]) rotate([0,0,45]) cube([19,15,.25],center=true);   
}

module mouth() {
   intersection() {
      translate([8,0,2]) rotate([0,90,0]) hull() {
         translate([0,-5,0]) cylinder(h=5,d=10,center=true);
         translate([0,5,0]) cylinder(h=5,d=10,center=true);
      }
      translate([-2,0,0]) cylinder(h=20,r=12,center=true);
   }
   /*
   intersection() {
      difference() {
         cylinder(h=25,d=25,center=true);
         cylinder(h=28,d=24,center=true);
      }
      translate([-1,-4,3]) rotate([90,0,90]) linear_extrude(25) hull() {
         translate([10,0,0]) circle(5);
         circle(5);
      }
   }
   */
}

module mouthlines() {
   intersection() {
      mouth();
      translate([0,-1,-1]) rotate([0,0,50])  roundedGridLines();
   }
}

module arm_main() {
   translate([10,-20,-50]) rotate([90,0,0]) 
         rotate_extrude(angle=60,convexity=2) translate([40,0,0]) circle(4);
}

module arm_rings() {
    for (x=[90:14:180]) {
           difference() {
              translate([(35*cos(x))+5.5,-20, -48 + 35*sin(x)]) rotate([-x,0,90]) cylinder(h=1,r=4.5,center=true);
              translate([(35*cos(x))+5.5,-20, -48 + 35*sin(x)]) rotate([-x,0,90]) cylinder(h=1,r=3.5,center=true);
           }
    }
}
module leg_main() {
   translate([-1,-30,-25]) cylinder(h=40,r=4,center=true);
   
}

module leg_rings() {
    for (x=[0:8:30]) {
           translate([1,-20,-10-x]) difference() {
              cylinder(h=1,r=4.5,center=true);
              cylinder(h=1,r=3.5,center=true);
           }
    }
}

module leg() {
   difference() {
      translate([0,-50,0]) rotate([0,0,180]) scale([1,1,1]) leg_main();
      leg_rings();
   }
   translate([1,-20,-53]) cylinder(h=8,r1=9,r2=5);
}

module arm() {
      union() {
         arm_main();
         arm_rings();
      }
      // Arm socket
      translate([-12,-20,-18]) rotate([83,0,90]) rotate_extrude() translate([5,0,0]) circle(3);

      translate([-30,-20,-55]) union() {
         rotate([0,0,90]) cylinder(h=5,r1=7,r2=5);
         translate([-4,0,-5]) rotate([0,0,90]) cylinder(h=5,r1=2,r2=2);
         translate([3,3,-5]) rotate([0,0,90]) cylinder(h=5,r1=2,r2=2);
         translate([2,-4,-5]) rotate([0,0,90]) cylinder(h=5,r1=2,r2=2);
      }
}

module door() {
   difference() {
      translate([0,0,-32]) intersection() {
         color("LightGrey") cylinder(h=48,d1=34,d2=47,center=true);
         color("LightGrey") cylinder(h=47,d1=32,d2=45,center=true);
         color("Black") translate([0,10,0]) cube([24.5,30,29.5],center=true);
      }
      color("Black") difference() {
         translate([-8,20,-32.5])  rotate([90,0,0]) linear_extrude(15) circle(3,center=true);
         translate([-8,21,-32.5])  rotate([90,0,0]) linear_extrude(18) circle(2.75,center=true);
      }
   }
}
// Head, eyes, visor & mouth
head();

// Shoulder
color("LightGrey") translate([0,0,-8]) cylinder(h=8,d1=45,d2=25);

// Body
color("LightGrey") translate([0,0,-32]) difference() {
   cylinder(h=48,d1=32,d2=45,center=true);
   cylinder(h=47,d1=30,d2=43,center=true);
   translate([0,20,0]) cube([25,20,30],center=true);
}
door();
// Left Arm 
color("LightGrey") translate([-10,20,0]) arm();

// Right Arm 
color("LightGrey") translate([10,-20,0]) rotate([0,0,180]) arm();

// Left Leg 
color("LightGrey") translate([-10,20,-50]) leg();

// Right Leg 
color("LightGrey") translate([10,-20,-50]) rotate([0,0,180]) leg();


translate([-.5,-3,4]) rotate([0,0,85]) {
   color("White") mouth();
   color("Black") translate([.25,.25,0]) mouthlines();
}
