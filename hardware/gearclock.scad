use <involute.scad>



//motor(holes=true);

assembly();
//hour_gear();
//minute_gear();
//second_gear();

//sun_gear(second_sun_teeth);
//sun_gear(minute_sun_teeth);
//sun_gear(hour_sun_teeth);

font = "Castellar";

/******* gear vars ******/
gear_sep = 87;

pitch = 5;
steps = 7;  //smoothness of gear
height = 10;
fn = 18;
wall=2;
tol = .2;

ring_thick=5.15;

second_sun_teeth = 11;
second_ring_teeth = 19;
second_ring_wall = 20;

minute_sun_teeth = 13;
minute_ring_teeth = 47;
minute_ring_wall = 25;
minute_lift = 25;

hour_sun_teeth = 17;
hour_ring_teeth = 79;
hour_ring_wall = 35;
hour_lift = 39;


/******* motor vars ******/
motor_rad = 28/2+.25;
motor_height = 19;
motor_screw_sep = 35;
motor_screw_rad = 3.5/2;
motor_screw_tab_rad = 7/2+.125;
motor_wire_jut_width = 14.5;
motor_wire_jut_length = 17.5;
motor_shaft_offset = 8;
motor_shaft_rad = 5/2-.1;
motor_shaft_length = 10;
motor_shaft_flat = 1.1;
slop = .2;

module sun_gear(teeth = 7){
    height = ring_thick+wall*2;
    rad = gear_diameter(teeth, pitch)/2;
    
    difference(){
        union(){
            for(i=[0:1]) mirror([0,0,i]) translate([0,0,-height*i]) cylinder(r1=rad, r2=rad-wall*2, h=wall, $fn=teeth);
            
            translate([0,0,0]) gear(n=teeth,p=pitch,b=0,s=steps,t=tol,h=height,chamfer=false,spindle=0,helix=0,hole=0,nut=0,spokes=0,hollow=0,wall=wall,fn=fn);
        }
        
        //shaft hole
        difference(){
            union(){
                translate([0,0,-.1]) cylinder(r1=motor_shaft_rad+slop*3, r2=motor_shaft_rad+slop, h=slop*2);
                cylinder(r=motor_shaft_rad+slop, h=height*3, center=true, $fn=36);
            }
            for(i=[0:1]) mirror([i,0,0]) translate([motor_shaft_rad+slop,0,0]) cube([motor_shaft_flat*2-slop*2, 100, 100], center=true); 
                
        }
    }
}


module hour_gear(){
    projection()
    //hours
    translate([-minute_lift-hour_lift,0,0]) difference(){
        hanging_gear(sun_teeth = hour_sun_teeth, ring_teeth = hour_ring_teeth, ring_wall = hour_ring_wall, sun=false);
        
        circle_text(["24", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"], rad = gear_diameter(hour_ring_teeth, pitch)/2+hour_ring_wall/2-2, size=13);
    }
}

module minute_gear(){
    projection()
    //minutes
    translate([-minute_lift,0,0]) difference(){
        hanging_gear(sun_teeth = minute_sun_teeth, ring_teeth = minute_ring_teeth, ring_wall = minute_ring_wall, sun=false);
        
        //text ring
        circle_text(["60", "2", "4", "6", "8",
        "10", "12", "14", "16", "18",
        "20", "22", "24", "26", "28",
        "30", "32", "34", "36", "38",
        "40", "42", "44", "46", "48",
        "50", "52", "54", "56", "58"], rad = gear_diameter(minute_ring_teeth, pitch)/2+minute_ring_wall/2+1, size=11);
    }
}

module second_gear(){
    projection()
    //seconds
    difference(){
        hanging_gear(sun_teeth = second_sun_teeth, ring_teeth = second_ring_teeth, ring_wall = second_ring_wall, sun=false);
        
        //text ring
        circle_text(["60", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"], rad = gear_diameter(second_ring_teeth, pitch)/2+second_ring_wall/2+1.5, size=8);
    }
}

module mount(){
    difference(){
        union(){
            //body
            hull(){
                cylinder(r=motor_screw_sep/2+wall*2, h=motor_height+wall*2);
                translate([-(-gear_diameter(hour_sun_teeth,pitch)+gear_diameter(hour_ring_teeth,pitch))/2+motor_shaft_offset-minute_lift-hour_lift,0,0]) cylinder(r=motor_screw_sep/2+wall*2, h=motor_height+wall*2);
            }
            
            //hanger
            translate([-(-gear_diameter(hour_sun_teeth,pitch)+gear_diameter(hour_ring_teeth,pitch))/2+motor_shaft_offset-minute_lift-hour_lift-motor_rad-wall*5,0,0]) cylinder(r=11, h=wall*3);
        }
        
        //hanger
        translate([-(-gear_diameter(hour_sun_teeth,pitch)+gear_diameter(hour_ring_teeth,pitch))/2+motor_shaft_offset-minute_lift-hour_lift-motor_rad-wall*5,0,0]) cylinder(r=5, h=wall*41, center=true);
        
        //make the whole thing a slot
        hull(){
            cylinder(r=motor_rad-wall, h=motor_height*3, center=true);
            translate([-(-gear_diameter(hour_sun_teeth,pitch)+gear_diameter(hour_ring_teeth,pitch))/2+motor_shaft_offset-minute_lift-hour_lift,0,0]) cylinder(r=motor_rad-1, h=motor_height*3, center=true);
        }
            
        //motor cutouts
        for(i=[0:.9:wall+1]) translate([0,0,i]) {
            render() translate([-(-gear_diameter(second_sun_teeth,pitch)+gear_diameter(second_ring_teeth,pitch))/2+motor_shaft_offset, 0,wall]) rotate([0,0,90]) motor(holes=true);
            render() translate([-(-gear_diameter(minute_sun_teeth,pitch)+gear_diameter(minute_ring_teeth,pitch))/2+motor_shaft_offset-minute_lift,0,wall]) rotate([0,0,90]) motor(holes=true);
            render() translate([-(-gear_diameter(hour_sun_teeth,pitch)+gear_diameter(hour_ring_teeth,pitch))/2+motor_shaft_offset-minute_lift-hour_lift,0,wall]) rotate([0,0,90]) motor(holes=true);
        }
    }
}

module assembly(){
    !translate([0,50,0]) mount(); 
    //seconds
    difference(){
        hanging_gear(sun_teeth = second_sun_teeth, ring_teeth = second_ring_teeth, ring_wall = second_ring_wall);
        
        //text ring
        circle_text(["60", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"], rad = gear_diameter(second_ring_teeth, pitch)/2+second_ring_wall/2+1.5, size=8);
    }
    
    //minutes
    translate([-minute_lift,0,0]) difference(){
        hanging_gear(sun_teeth = minute_sun_teeth, ring_teeth = minute_ring_teeth, ring_wall = minute_ring_wall);
        
        //text ring
        circle_text(["60", "2", "4", "6", "8",
        "10", "12", "14", "16", "18",
        "20", "22", "24", "26", "28",
        "30", "32", "34", "36", "38",
        "40", "42", "44", "46", "48",
        "50", "52", "54", "56", "58"], rad = gear_diameter(minute_ring_teeth, pitch)/2+minute_ring_wall/2+1, size=11);
    }
    
    //hours
    translate([-minute_lift-hour_lift,0,0]) difference(){
        hanging_gear(sun_teeth = hour_sun_teeth, ring_teeth = hour_ring_teeth, ring_wall = hour_ring_wall);
        
        circle_text(["24", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"], rad = gear_diameter(hour_ring_teeth, pitch)/2+hour_ring_wall/2-2, size=13);
    }
}

module circle_text(letter_array=["1", "5", "12"], rad = 30, size=12){
    
    for(i=[0:len(letter_array)-1]) rotate([0,0,90-i*(360/len(letter_array))]) translate([0,rad,0]) linear_extrude(height=30, center=true)text(letter_array[i], size=size, halign="center", valign="center", font=font);
}

module hanging_gear(sun_teeth = 7, ring_teeth = 19, ring_wall = 20, sun = true, ring=true){
    
    echo("Ring Rad:", gear_diameter(ring_teeth, pitch)/2+ring_wall);
    
    translate([-(-gear_diameter(sun_teeth,pitch)+gear_diameter(ring_teeth,pitch))/2,0,0]) {
    if(sun == true)
        gear(n=sun_teeth,p=pitch,b=0,s=steps,t=tol,h=height,chamfer=false,spindle=0,helix=0,hole=0,nut=0,spokes=0,hollow=0,wall=wall,fn=fn);
    
    extra_gap = 1/pitch*3;
    
    if(ring == true)
        translate([(-gear_diameter(sun_teeth,pitch)+gear_diameter(ring_teeth,pitch))/2,0,0]) rotate([0,0,360/ring_teeth*round(ring_teeth/6)+((ring_teeth%2)?0:180/ring_teeth)-extra_gap/2])
            difference(){
                translate([0,0,height/2]) cylinder(r=gear_diameter(ring_teeth, pitch)/2+ring_wall, height/2, center=true, $fn=90);
                gear(n=ring_teeth,p=pitch,b=0,s=steps,t=-tol,h=height,chamfer=false,spindle=0,helix=0,hole=0,nut=0,spokes=0,hollow=0,wall=wall,fn=fn);
                rotate([0,0,extra_gap]) gear(n=ring_teeth,p=pitch,b=0,s=steps,t=-tol,h=height,chamfer=false,spindle=0,helix=0,hole=0,nut=0,spokes=0,hollow=0,wall=wall,fn=fn);
            }
    }
}


module motor(holes = false){
    difference(){
        union(){
            //body
            cylinder(r=motor_rad, h=motor_height);
            
            //wires
            translate([0,-motor_wire_jut_length/2,motor_height/2]) cube([motor_wire_jut_width, motor_wire_jut_length, motor_height], center=true);
            
            //screw tabs
            hull() for(i=[0:1]) mirror([i,0,0]) translate([motor_screw_sep/2,0,motor_height-1]) cylinder(r=motor_screw_tab_rad, h=1);
                
            //shaft
            translate([0,motor_shaft_offset,0]) cylinder(r=motor_shaft_rad, h=motor_shaft_length+motor_height);
            
            if(holes == true)
                for(i=[0:1]) mirror([i,0,0]) translate([motor_screw_sep/2,0,motor_height-1]) cylinder(r1=motor_screw_rad, r2=motor_screw_rad+slop, h=25, center=true);
        }
        
        //screw holes
        if(holes == false)
            for(i=[0:1]) mirror([i,0,0]) translate([motor_screw_sep/2,0,motor_height-1]) cylinder(r=motor_screw_rad, h=5, center=true);
    }
}
