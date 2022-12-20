// width: x; depth: y; height: z

// "Resolution" of arcs
$fs=0.25;
$fa=5;


// Case Dimensions
wallThickness = 3;
piZeroHeight = 80;
piZeroMountHeight = 17;
stepDownConverterMountHeight = 20;
cableManagementHeight = 20;
plugsHeight = 25;
backplateDepth = wallThickness;
primaryWallHeight = 45;

caseHeight = wallThickness*2 + piZeroHeight + piZeroMountHeight + stepDownConverterMountHeight + cableManagementHeight + plugsHeight;
caseWidth = wallThickness*2 + 70;

// Mounting Dimensions
mountingHoleDiameter = 5;
mountingHoleOffset = 10; // offset from center of hole
mountingHoleBorder = 5; // space around the hole where the screw head sits
mountingHoleDepth = 7.5;

mountPointWidth = mountingHoleDiameter + mountingHoleBorder*2;

module prism(l, w, h){
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module prismEdge(w,h) {
    translate([0, h, 0])
        intersection() {
            rotate([90, 45, 0])
                cylinder(h,w*sqrt(2),00,$fn=4);
            translate([-w/2,-h/2,w/2])
                cube([w,h,w], center=true);
        }
}

module mountPoint(diameter, offset, border, depth) {
    
    outerRadius = diameter/2 + border;
    
    difference() {
        union() {
            translate([0, 0, -offset])
                cube([outerRadius*2, depth, offset]);
            translate([outerRadius, depth/2, -offset])
                rotate([90, 0, 0])
                    cylinder(h=depth, r=outerRadius, center=true);
        }
        translate([outerRadius, depth/2, -offset])
                rotate([90, 0, 0])
                    cylinder(h=depth+0.01, r=diameter/2, center=true);
    }
}

module mountPoints() {
    translate([-caseWidth/2, -backplateDepth/2, -caseHeight/2])
        mountPoint(mountingHoleDiameter, mountingHoleOffset, mountingHoleBorder, mountingHoleDepth);
    translate([caseWidth/2 - mountPointWidth, -backplateDepth/2, -caseHeight/2])
        mountPoint(mountingHoleDiameter, mountingHoleOffset, mountingHoleBorder, mountingHoleDepth);
    translate([-caseWidth/2, mountingHoleDepth-backplateDepth/2, caseHeight/2]) 
        rotate([180,0,0]) 
            mountPoint(mountingHoleDiameter, mountingHoleOffset, mountingHoleBorder, mountingHoleDepth);
    translate([caseWidth/2 - mountPointWidth, mountingHoleDepth-backplateDepth/2, caseHeight/2]) 
        rotate([180,0,0]) 
            mountPoint(mountingHoleDiameter, mountingHoleOffset, mountingHoleBorder, mountingHoleDepth);
}

module backplate() {
    cube([caseWidth, backplateDepth, caseHeight], true);
}

module walls(thickness, width, depth, height) {
    rotate([90,0,0])
        difference() {
            cube([width, depth, height], true);
            cube([width - thickness*2, depth - thickness*2, height + 0.1], true);
        }
}

module primaryWalls() {
    difference() {
        translate([0, (primaryWallHeight+backplateDepth)/2, 0]) 
            walls(wallThickness, caseWidth, caseHeight, primaryWallHeight);
        translate([12.5+40-caseWidth/2, 6+15, -(caseHeight)/2-0.05])
            cylinder(h=wallThickness+0.1, r=6);
    }
}

module roundWall(thickness, outerDiameter, height) {
    rotate([90, 0, 0])
        difference () {
            cylinder(h=height, r=outerDiameter/2, center=true);
            cylinder(h=height+0.01, r=outerDiameter/2-thickness, center=true);
        }
}

module internalMounts() {
    translate([15-caseWidth/2, 4+backplateDepth/2, caseHeight/2-wallThickness-piZeroHeight-11.5]) 
        roundWall(2.5, 8, 8);
    translate([50-caseWidth/2, 4+backplateDepth/2, caseHeight/2-wallThickness-piZeroHeight-11.5]) 
        roundWall(2.5, 8, 8);
    translate([38-caseWidth/2, 4+backplateDepth/2, caseHeight/2-wallThickness-piZeroHeight-11.5-12])
        roundWall(2.5, 8, 8);
}

module screwHole(height, innerWallHeight, screwHoleDiameter, nutSize) {
    verticalPaddingToNut = 2.5;
    color("pink")
    translate([0, -innerWallHeight-verticalPaddingToNut, 0])
        rotate([90, 0, 0])
            cylinder(h=height, r=nutSize/2, $fn=6);
    //cube([height, 2, 2], center=true);
    rotate([90, 0, 0])
        cylinder(h=innerWallHeight+verticalPaddingToNut+0.1, r=screwHoleDiameter/2);
}

// Top section specific
overhang=12;
overhangHeight=12;
outerWallWidth = 2.5;
outerWallHeight = 8;
innerInnerWallWidth = 2;
outerInnerWallWidth = 8;
innerWallHeight = 2.5;
screwHoleDiameter = 3.2;
nutSize = 6.1; // outer circumference 'e' + padding
screwWallWidth = caseWidth-outerWallWidth*2+overhang*2;
screwWallLength = caseHeight-outerWallWidth*2+overhang*2;
module topSection() {
    difference() {
        union() {
            union() {
                translate([-caseWidth/2, backplateDepth/2+primaryWallHeight-overhangHeight, caseHeight/2]) {
                    prism(caseWidth,overhangHeight,overhang);
                    prismEdge(overhang, overhangHeight);
                }
                translate([caseWidth/2, backplateDepth/2+primaryWallHeight-overhangHeight, -caseHeight/2])
                    rotate([0, 180, 0]) {
                        prism(caseWidth,overhangHeight,overhang);
                        prismEdge(overhang, overhangHeight);
                    }
                translate([caseWidth/2, backplateDepth/2+primaryWallHeight-overhangHeight, caseHeight/2])
                    rotate([0, 90, 0]) {
                        prism(caseHeight,overhangHeight,overhang);
                        prismEdge(overhang, overhangHeight);
                    }   
                translate([-caseWidth/2, backplateDepth/2+primaryWallHeight-overhangHeight, -caseHeight/2])
                    rotate([0, 270, 0]) {
                        prism(caseHeight,overhangHeight,overhang);
                        prismEdge(overhang, overhangHeight);
                    }
            }
            color("green")
            translate([0, (backplateDepth+outerWallHeight)/2 + primaryWallHeight, 0])
                walls(outerWallWidth, caseWidth+overhang*2, caseHeight+overhang*2, outerWallHeight);
            color ("red") {
                translate([0, (backplateDepth+innerWallHeight)/2 + primaryWallHeight, 0])
                    walls(innerInnerWallWidth, caseWidth-wallThickness*2+innerInnerWallWidth*2, caseHeight-wallThickness*2+innerInnerWallWidth*2, innerWallHeight);
                translate([0, (backplateDepth+innerWallHeight)/2 + primaryWallHeight, 0])
                    walls(outerInnerWallWidth, caseWidth-outerWallWidth*2+overhang*2, caseHeight-outerWallWidth*2+overhang*2, innerWallHeight);
            }
        }
        for (a =[-1:1]) {
            translate([(-screwWallWidth/2+outerInnerWallWidth/2)*a, backplateDepth/2+innerWallHeight+primaryWallHeight+0.01, screwWallLength/2-outerInnerWallWidth/2]) {
                screwHole(overhangHeight, innerWallHeight, screwHoleDiameter, nutSize);
            }
            translate([(-screwWallWidth/2+outerInnerWallWidth/2)*a, backplateDepth/2+innerWallHeight+primaryWallHeight+0.01, -screwWallLength/2+outerInnerWallWidth/2]) {
                screwHole(overhangHeight, innerWallHeight, screwHoleDiameter, nutSize);
            }
        }
        for (a =[-1:1]) {
            translate([-screwWallWidth/2+outerInnerWallWidth/2, backplateDepth/2+innerWallHeight+primaryWallHeight+0.01, (screwWallLength/2-outerInnerWallWidth/2)/2*a]) {
                rotate([0, 30, 0])
                    screwHole(overhangHeight, innerWallHeight, screwHoleDiameter, nutSize);
            }
            translate([screwWallWidth/2-outerInnerWallWidth/2, backplateDepth/2+innerWallHeight+primaryWallHeight+0.01, (screwWallLength/2-outerInnerWallWidth/2)/2*a]) {
                rotate([0, 30, 0])
                    screwHole(overhangHeight, innerWallHeight, screwHoleDiameter, nutSize);
            }
        }
    }
}

module screwHeadHole() {
    shaftLength = 16;
    shaftDiameter = 3.2;
    headLength = 3;
    headDiameter = 5.75;
    translate([0, -headLength/2, 0])
        rotate([90, 0, 0])
            cylinder(h=headLength, r=headDiameter/2, center=true);
    translate([0, -shaftLength/2-headLength+0.1, 0])
        rotate([90, 0, 0])
            cylinder(h=shaftLength+0.1, r=shaftDiameter/2, center=true);
}

module lid() {
    depth = outerWallHeight-innerWallHeight;
    difference() {
        translate([0, depth/2, 0])
            cube([screwWallWidth, depth, screwWallLength], center=true);
        color("red")
            translate([0, (depth-wallThickness-0.2)/2, 0])
                cube([caseWidth, depth-wallThickness+0.1, caseHeight], center=true);
        color("pink") {
            for (a =[-1:1]) {
                translate([(-screwWallWidth/2+outerInnerWallWidth/2)*a, depth+0.01, screwWallLength/2-outerInnerWallWidth/2])
                    screwHeadHole();
                translate([(screwWallWidth/2-outerInnerWallWidth/2)*a, depth+0.01, -screwWallLength/2+outerInnerWallWidth/2])
                    screwHeadHole();
            }
            for (a =[-1:1]) {
                translate([-screwWallWidth/2+outerInnerWallWidth/2, depth+0.01, (screwWallLength/2-outerInnerWallWidth/2)/2*a]) {
                    screwHeadHole();
                }
                translate([screwWallWidth/2-outerInnerWallWidth/2, depth+0.01, (screwWallLength/2-outerInnerWallWidth/2)/2*a]) {
                    screwHeadHole();
                }
            }
        }
    }
}

module mountPrism() {
difference() {
        union() {
            rotate([270, 0, 0])
                prism(12, 19, 12);
            translate([6, 6, -20.5])
                cube([12,12,3], true);
        }
        color("pink")
        translate([6, 6, -2])
            cylinder(h=30, r=8.5/2, center=true);
        translate([6, 6, -7-0.01])
            cylinder(h=30+0.01, r=5/2, center=true);
    }
}

module piMount() {
    thickness = 3;
    width = 64;
    height = 30;
    shelfWidth = 6;
    holeDiameter = 3.1;
    translate([4, 0, -7])
        difference() {
            union() {
                cube([width, thickness, height], center=true);
                translate([-width/2+shelfWidth/2, -thickness/2-1.5/2, 0])
                    cube([shelfWidth, 1.5, 30], true);
                translate([width/2-shelfWidth/2, -thickness/2-1.5/2, 0])
                    cube([shelfWidth, 1.5, 30], true);
            }
            color("red")
                translate([-width/2+shelfWidth/2, thickness/2-0.5/2, 0])
                    cube([shelfWidth, 0.5, 30], true);
            color("red")
                translate([width/2-shelfWidth/2, thickness/2-0.5/2, 0])
                    cube([shelfWidth, 0.5, 30], true);
            translate([width/2-shelfWidth/2, thickness/2-2.5, 15-3.5])
                rotate([90, 0, 0,])
                    cylinder(h=6, r=holeDiameter/2, center=true);
            translate([width/2-shelfWidth/2, thickness/2-2.5, -15+3.5])
                rotate([90, 0, 0,])
                    cylinder(h=6, r=holeDiameter/2, center=true);
            translate([-width/2+shelfWidth/2, thickness/2-2.5, 15-3.5])
                rotate([90, 0, 0,])
                    cylinder(h=6, r=holeDiameter/2, center=true);
            translate([-width/2+shelfWidth/2, thickness/2-2.5, -15+3.5])
                rotate([90, 0, 0,])
                    cylinder(h=6, r=holeDiameter/2, center=true);
        }
    difference() {
        union() {
            translate([35/2-6, thickness/2, 7])
                mountPrism();
            translate([-35/2-6, thickness/2, 7])
                mountPrism();
        }
        color("green")
            translate([-width/2+shelfWidth/2+4, thickness/2+4/2-0.5, 5])
                cube([6.5, 4, 6.5], true);
    }
}

module stepDownMount() {
    translate([0,0,-5]) {
        cube([12, 2, 27+2.5/2], center=true);
        translate([0, -4-2/2-3/2, 0])
            cube([12, 3, 27+2.5/2], center=true);
        translate([0, -2/2-4/2, -12.875])
            cube([12, 4, 2.5], center=true);
    }
    translate([-6, -0.5, 8.5-1.25/2])
        mountPrism();
}


// Mounting Bracket Dimensions
poleDiameter = 46.2;
poleFittingOffset = 5;
polePadding = 5;
mountScrewHoleDiameter = 5.5;
mountScrewHolePadding = 2.5;
holeBlockDepth = 11;
module rearMountingBracket() {
    difference() {
        //cube([poleDiameter + mountScrewHoleDiameter*2 + mountScrewHolePadding*4, poleDiameter/2 - poleFittingOffset + polePadding, mountScrewHoleDiameter + mountScrewHolePadding*2], center=true);
        union() {
            // Left Hole Block
            translate([poleDiameter/2 + mountScrewHoleDiameter/2 + mountScrewHolePadding, poleDiameter/4+polePadding/2-mountScrewHolePadding-holeBlockDepth/2, 0])
                cube([mountScrewHoleDiameter + mountScrewHolePadding*2, holeBlockDepth, mountScrewHoleDiameter + mountScrewHolePadding*2], center=true);
            // Right Hole Block
            translate([-poleDiameter/2 - mountScrewHoleDiameter/2 - mountScrewHolePadding, poleDiameter/4+polePadding/2-mountScrewHolePadding-holeBlockDepth/2, 0])
                cube([mountScrewHoleDiameter + mountScrewHolePadding*2, holeBlockDepth, mountScrewHoleDiameter + mountScrewHolePadding*2], center=true);
            difference() {
                translate([0, poleDiameter/4 + poleFittingOffset/2 + polePadding/2, 0])
                    cylinder(h=mountScrewHoleDiameter + mountScrewHolePadding*2 + 0.01, r=poleDiameter/2+polePadding, center=true);
                translate([0, poleDiameter/2+polePadding, 0])
                    cube([poleDiameter+polePadding*2, poleDiameter/2+polePadding+poleFittingOffset, mountScrewHoleDiameter + mountScrewHolePadding*2+0.1], center=true);
            }
        }
        // Inner Cutout
        translate([0, poleDiameter/4 + poleFittingOffset/2 + polePadding/2, 0])
            cylinder(h=mountScrewHoleDiameter + mountScrewHolePadding*2 + 0.1, r=poleDiameter/2, center=true);
        // Outer Circle
        
        // screw Hole L
        translate([poleDiameter/2 + mountScrewHoleDiameter/2 + mountScrewHolePadding, 0, 0])
            rotate([90, 0, 0])
                cylinder(h=poleDiameter - poleFittingOffset + 0.01, r=mountScrewHoleDiameter/2, center=true);
        // screw Hole R
        translate([-poleDiameter/2 - mountScrewHoleDiameter/2 - mountScrewHolePadding, 0, 0])
            rotate([90, 0, 0])
                cylinder(h=poleDiameter - poleFittingOffset + 0.01, r=mountScrewHoleDiameter/2, center=true);
        
    }
}

module caseMountingBracket() {
    translate([18.5+4.5, -2.5-4, 5])
        rotate([180, 0, 0])
            mountPoint(mountingHoleDiameter, 7.5, mountingHoleBorder, 5);
    translate([-33.5-4.5, -2.5-4, 5])
        rotate([180, 0, 0])
            mountPoint(mountingHoleDiameter, 7.5, mountingHoleBorder, 5);
    union() {
        translate([38, -6.5, mountScrewHoleDiameter/2 + mountScrewHolePadding])
            rotate([90, 90, 180])
                prism(mountScrewHoleDiameter + mountScrewHolePadding*2, 4.5, 18);
        translate([35.5, -9, 0])
            cube([5, 5, mountScrewHoleDiameter + mountScrewHolePadding*2], center=true);
    }
    rotate([0,180,0])
        union() {
            translate([38, -6.5, mountScrewHoleDiameter/2 + mountScrewHolePadding])
                rotate([90, 90, 180])
                    prism(mountScrewHoleDiameter + mountScrewHolePadding*2, 4.5, 18);
            translate([35.5, -9, 0])
                cube([5, 5, mountScrewHoleDiameter + mountScrewHolePadding*2], center=true);
        }
    difference() {
        cube([poleDiameter + mountScrewHoleDiameter*2 + mountScrewHolePadding*4, poleDiameter/2 - poleFittingOffset + polePadding, mountScrewHoleDiameter + mountScrewHolePadding*2], center=true);
        // Inner Cutout
        translate([0, poleDiameter/4 + poleFittingOffset/2 + polePadding/2, 0])
            cylinder(h=mountScrewHoleDiameter + mountScrewHolePadding*2 + 0.1, r=poleDiameter/2, center=true);
        // Outer Circle
        
        // screw Hole L
        translate([poleDiameter/2 + mountScrewHoleDiameter/2 + mountScrewHolePadding, 0, 0])
            rotate([90, 0, 0])
                cylinder(h=poleDiameter - poleFittingOffset + 0.01, r=mountScrewHoleDiameter/2, center=true);
        // screw Hole R
        translate([-poleDiameter/2 - mountScrewHoleDiameter/2 - mountScrewHolePadding, 0, 0])
            rotate([90, 0, 0])
                cylinder(h=poleDiameter - poleFittingOffset + 0.01, r=mountScrewHoleDiameter/2, center=true);
        
    }
}


module caseAssembly() {
    backplate();
    mountPoints();
    internalMounts();
    primaryWalls();
    topSection();
    translate([0, backplateDepth/2+primaryWallHeight+innerWallHeight, 0,])
        lid();
    translate([50-35/2-caseWidth/2, 30/2+8+backplateDepth/2, -3])
        rotate([270, 0, 0])
            piMount();
    translate([38-caseWidth/2, 28/2+8+backplateDepth/2, -28])
        rotate([270, 180, 0])
            stepDownMount();
    x=2;
    color("grey") {
        translate([0, -poleDiameter+x, 106.5])
            rearMountingBracket();
        translate([0, -40, -106.5])
            rearMountingBracket();
    }
    color("red") {
        translate([0, -13, -106.5])
            rotate([0, 0, 180])
                caseMountingBracket();
        translate([0, -13, 106.5])
            rotate([180, 0, 0])
                caseMountingBracket();
    }
}

caseAssembly();