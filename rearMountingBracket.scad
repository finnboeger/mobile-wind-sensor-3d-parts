// "Resolution" of arcs
$fs=0.25;
$fa=5;

module rearMountingBracket(
    poleDiameter = 46,
    poleFittingOffset = 5,
    polePadding = 5,
    mountScrewHoleDiameter = 5.5,
    mountScrewHolePadding = 2.5,
    minHoleBlockDepth = 5,
    screwHoleOffset = 1.5,
) {
    innerRadius = poleDiameter/2;
    outerRadius = innerRadius + polePadding;
    outerDiameter = outerRadius*2;
    
    innerArcPositionX = innerRadius - sqrt(innerRadius^2 - poleFittingOffset^2);
    outerArcPositionY = sqrt(outerRadius^2 - (sqrt(innerRadius^2 - poleFittingOffset^2) + screwHoleOffset)^2);

    holeBlockDepth = max(minHoleBlockDepth, outerArcPositionY - poleFittingOffset);
    
    difference() {
        union() {
            // Hole Block
            translate([
                0,
                -holeBlockDepth/2,
                0
            ])
                cube([
                    poleDiameter + mountScrewHoleDiameter*2 + mountScrewHolePadding*4 - innerArcPositionX*2 + screwHoleOffset*2, 
                    holeBlockDepth, 
                    mountScrewHoleDiameter + mountScrewHolePadding*2
                ], center=true);
            
            // Main Body
            difference() {
                translate([
                    0, 
                    poleFittingOffset,
                    0
                ])
                    cylinder(
                        h=mountScrewHoleDiameter + mountScrewHolePadding*2 + 0.01, 
                        r=outerRadius, 
                        center=true
                    );
                translate([0, (innerRadius+poleFittingOffset*2+polePadding)/2, 0])
                    cube([
                        outerDiameter, 
                        innerRadius+poleFittingOffset*2+polePadding, 
                        mountScrewHoleDiameter + mountScrewHolePadding*2+0.1
                    ], center=true);
            }
        }
        // Inner Cutout
        translate([0, poleFittingOffset, 0])
            cylinder(h=mountScrewHoleDiameter + mountScrewHolePadding*2 + 0.1, r=innerRadius, center=true);
        
        screwHolePosition = innerRadius + mountScrewHoleDiameter/2 + mountScrewHolePadding - innerArcPositionX + screwHoleOffset;
        // screw Hole L
        translate([screwHolePosition, -holeBlockDepth/2, 0])
            rotate([90, 0, 0])
                cylinder(h=holeBlockDepth + 0.01, r=mountScrewHoleDiameter/2, center=true);
        // screw Hole R
        translate([-screwHolePosition, -holeBlockDepth/2, 0])
            rotate([90, 0, 0])
                cylinder(h=holeBlockDepth + 0.01, r=mountScrewHoleDiameter/2, center=true);
        
    }
}

rearMountingBracket(46.3, screwHoleOffset = 0.545);