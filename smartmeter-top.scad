
$casewidth=110;
$caseheight=30;
$casedepth=35;
$casewall=2;

$screwdistance=61;
$screwdiameter=4;
$screwblockdepth=3.5;
$screwblockwidth=8;
$screwopeningdiameter=6;

$irborex=69;
$irborey=15;
$irledborediameter=4.8;
$irledmountdiameter=8;
$irledheight=5.1;

$pcbboredistx=52;
$pcbboredisty=25;
$pcbborediameter=1.8;
$pcbmountdiameter=4;
$pcbmountheight=15;
$pcboffsetx=4.5;


$slidedistance=85;
$slidebasewidth=3;
$slideheadwidth=8;
$slideheadheight=2;
$slideheight=4.5;
$slidedepth=12;

$slideblockwidth=$slideheadwidth+1;
$slideblockdepth=$slidedepth+1;
$slideblockheight=$slideheight+1;

$pcbthickness=2.2;
$musbz=$pcbmountheight+$pcbthickness;
$musbwidth=9;
$musbheight=3.5;

module case() {
  difference() {
     cube([$casewidth, $casedepth, $caseheight]);
     translate([$casewall, $casewall, $casewall]) {
       cube([$casewidth-2*$casewall, $casedepth-2*$casewall, $caseheight-$casewall]);
     }
  }
}

module irled(diameter) {
  translate([$irborex, $irborey, 0]) {
    cylinder(h=$irledheight, d=diameter, $fn=12);
  } 
}

module pcbmount(diameter) {
  translate([$pcboffsetx, $casedepth/2-$pcbboredisty/2, $casewall]) {
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
    translate([$casewidth/2-$screwdistance/2,0,0]) {
        screwblock(bore);
    }
    translate([$casewidth/2+$screwdistance/2,0,0]) {
        screwblock(bore);
    }
}

module screwopenings() {
    translate([$casewidth/2-$screwdistance/2,$casedepth,$screwblockwidth/2]) {
        rotate([90,0,0]) {
            cylinder(h=$casewall, d=$screwopeningdiameter, $fn=12);
        }
    }
    translate([$casewidth/2+$screwdistance/2,$casedepth,$screwblockwidth/2]) {
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
    translate([$casewidth/2-$slidedistance/2,0,0]) {
        slide();
    }
    translate([$casewidth/2+$slidedistance/2,0,0]) {
        slide();
    }
}

module slideblock() {
    translate([-$slideblockwidth/2,0,0]) {
        cube([$slideblockwidth, $slideblockdepth, $slideblockheight]);
    }
}

module slideblocks() {
    translate([$casewidth/2-$slidedistance/2,0,0]) {
        slideblock();
    }
    translate([$casewidth/2+$slidedistance/2,0,0]) {
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
  translate([0,$casedepth/2,$musbz]) {
      microusb();
  }
}

$coverbasethickness=2;
$coverintake=5;
$coverintakewall=2;

translate([0,$casedepth+10,0]) {
    cube([$casewidth, $casedepth, $coverbasethickness]);
    translate([$casewall, $casewall, $coverbasethickness]) {
        difference() {
            cube([$casewidth-2*$casewall, $casedepth-2*$casewall, $coverintake]);
            translate([$coverintakewall, $coverintakewall, 0]) {
                cube([$casewidth-2*$casewall-$coverintakewall*2, $casedepth-2*$casewall-2*$coverintakewall, $coverintake]);
            }
        }
    }
}