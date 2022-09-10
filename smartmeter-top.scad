
$casewidth=110;
$caseheight=30;
$casedepth=42;
$casewall=1.5;

$screwdistance=61;
$screwdiameter=4;
$screwblockdepth=4.5;
$screwblockwidth=8;
$screwopeningdiameter=8;

/* Relative to center back point */
$irborex=14;
$irborey=15;
$irledborediameter=5;
$irledmountdiameter=8;
$irledheight=6.5;


$pcbboredistx=52;
$pcbboredisty=25;
$pcbborediameter=1.8;
$pcbmountdiameter=4;
$pcbmountheight=15;

/* Offset PCB -> Center Borehole x */
$pcbboreoffset_x_left=3;
/* The PCB should touch the wall */
$pcboffsetx=$casewall+$pcbboreoffset_x_left;

/* Needs to be more to not let the PCB touch the notch */
$pcboffsety=12;


$slidedistance=85;
$slidebasewidth=3;
$slideheadwidth=8;
$slideheadheight=2.5;
$slideheight=4;
$slidedepth=12;

$slideblockwidth=$slideheadwidth+2;
$slideblockdepth=$slidedepth+1;
$slideblockheight=$slideheight+1;

$pcbthickness=1.8;
$musbz=$pcbmountheight+$pcbthickness;
$musbwidth=9;
$musbheight=3.5;

$notchwidth=10;
$notchdepth=6;

module case_simple() {
  translate([-$casewidth/2,0,0]) {
      difference() {
         cube([$casewidth, $casedepth, $caseheight]);
         translate([$casewall, $casewall, $casewall]) {
           cube([$casewidth-2*$casewall, $casedepth-2*$casewall, $caseheight-$casewall]);
         }
     }
  }
}

module case() {
    difference() {
        union() {
            case_simple();
            translate([-$notchwidth/2-$casewall,0,0]) {
                cube([$notchwidth+2*$casewall, $notchdepth+$casewall, $caseheight]);
            }
        }
        translate([-$notchwidth/2,0,0]) {
            cube([$notchwidth, $notchdepth, $caseheight]);
        }
    }
}


module irled(diameter) {
  translate([$irborex, $irborey, 0]) {
    cylinder(h=$irledheight, d=diameter, $fn=12);
  } 
}

module pcbmount(diameter) {
  translate([-$casewidth/2+$pcboffsetx,$pcboffsety,$casewall]) {
  union() {
      cylinder(h=$pcbmountheight, d=diameter, $fn=12);
      translate([$pcbboredistx, 0, 0]) {
        cylinder(h=$pcbmountheight, d=diameter, $fn=12);
      }
      translate([$pcbboredistx, $pcbboredisty, 0]) {
        cylinder(h=$pcbmountheight, d=diameter, $fn=12);
      }
      translate([0, $pcbboredisty, 0]) {
        cylinder(h=$pcbmountheight, d=diameter, $fn=12);
      }
  }
  }
}

module screwblock_block() {
    translate([-$screwblockwidth/2,-$screwblockdepth,0]) {
        cube([$screwblockwidth, $screwblockdepth, $screwblockwidth]);
    }
}

module screwblock_bore() {
    translate([0,$casewall,$screwblockwidth/2]) {
        rotate([90,0,0]) {
            cylinder(h=$screwblockdepth+$casewall, d=$screwdiameter, $fn=12);
        }
    }
}

module screwblock(bore) {
    if (bore) {
        screwblock_bore();
    } else {
        screwblock_block();
    }
}

module screwblocks(bore) {
    translate([-$screwdistance/2,0,0]) {
        screwblock(bore);
    }
    translate([+$screwdistance/2,0,0]) {
        screwblock(bore);
    }
}

module screwopenings() {
    translate([-$screwdistance/2,$casedepth,$screwblockwidth/2]) {
        rotate([90,0,0]) {
            cylinder(h=$casewall, d=$screwopeningdiameter, $fn=12);
        }
    }
    translate([+$screwdistance/2,$casedepth,$screwblockwidth/2]) {
        rotate([90,0,0]) {
            cylinder(h=$casewall, d=$screwopeningdiameter, $fn=12);
        }
    }
}

module slide() {
    union() {
        translate([-$slidebasewidth/2,0,0]) {
            cube([$slidebasewidth, $slidedepth, $slideheight]);
        }
        translate([-$slideheadwidth/2,0,$slideheight-$slideheadheight]) {
            cube([$slideheadwidth, $slidedepth, $slideheadheight]);
        }
    }
}

module slides() {
    translate([-$slidedistance/2,0,0]) {
        slide();
    }
    translate([+$slidedistance/2,0,0]) {
        slide();
    }
}

module slideblock() {
    translate([-$slideblockwidth/2,0,0]) {
        cube([$slideblockwidth, $slideblockdepth, $slideblockheight]);
    }
}

module slideblocks() {
    translate([-$slidedistance/2,0,0]) {
        slideblock();
    }
    translate([+$slidedistance/2,0,0]) {
        slideblock();
    }
}

module microusb() {
    translate([0,-$musbwidth/2,0]) {
        cube([$casewall, $musbwidth, $musbheight]);
    }
}





difference() {    
  union() {
    case();
    irled($irledmountdiameter);
    pcbmount($pcbmountdiameter);
    screwblocks(0);
    slideblocks();
  }
  irled($irledborediameter);
  pcbmount($pcbborediameter);
  screwblocks(1);
  screwopenings();
  slides();
  translate([-$casewidth/2,$pcboffsety+$pcbboredisty/2,$musbz+$casewall]) {
      microusb();
  }
}




$coverbasethickness=2;
$coverintake=5;
$coverintakewall=2;

module cover_simple() {
    difference() {
        translate([-$casewidth/2,0,0]) {
            cube([$casewidth, $casedepth, $coverbasethickness]);
        }
        notchplus($notchwidth, $notchdepth, $coverbasethickness);        
    }
}

$intakewidth=$casewidth-2*$casewall;
$intakedepth=$casedepth-2*$casewall;

module cover_intake_simple() {
    translate([-$casewidth/2+$casewall, $casewall, 0]) {
          difference() {
            cube([$intakewidth, $intakedepth, $coverintake]);
            translate([$coverintakewall, $coverintakewall,0]) {
                cube([$intakewidth-2*$coverintakewall,
                        $intakedepth-2*$coverintakewall,
                        $coverintake]);
            }
          }
    }
}

module notchplus(width, depth, height) {
    translate([-width/2,0,0]) {
        cube([width, depth, height]);
    }
}

module cover_intake() {
    difference() {
        union() {
            translate([0,$casewall, 0]) {
                notchplus($notchwidth+$casewall*2+$coverintakewall*2,
                    $notchdepth+$coverintakewall,
                    $coverintake);
            }
            cover_intake_simple();
        }
        translate([0,$casewall,0]) {
            notchplus($notchwidth+$casewall*2, $notchdepth,$coverintake);
        }
    }
}


mirror([0,1,0]) {
    translate([0,10,0]) {
        union() {
            cover_simple();
            translate([0,0,$coverbasethickness]) {
                cover_intake();
            }
        }
    }
}