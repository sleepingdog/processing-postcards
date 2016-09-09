/*
A postcard for Creative Coding course.
*/

// Declare and initialise variables
ArrayList<SolarSystem> systems;
ArrayList<LifeForm> life;
color backgroundColour = #000000;
int numPossibleSystems = 9;
int sunSizeMean = 24;
int sunSizeVariation = 4;
int planetSizeMean = 10;
int planetSizeVariation = 2;
int sunBrightness = 255;
int sunSaturation = 127;
int planetBrightness = 127;
int planetSaturation = 255;
int lifeBodySize = 6;
int lifeBodyMass = lifeBodySize * lifeBodySize / 100;
float breedChance = 0.01; // how likely breeding will occur
float lifeChance = 0.67; // how likely planets are to start with life
float captureChance = 1.5; // how many planet-widths distance will a lifeform be captured

void setup() {
  size (900, 600);
  colorMode(HSB);
  systems = new ArrayList<SolarSystem>();
  life = new ArrayList<LifeForm>();
  int cx, cy, ss, ps;
  int margin = 2 * (sunSizeMean + sunSizeVariation + planetSizeMean + planetSizeVariation);
  color sc, pc;
  //float lerpPoint;
  //boolean tooClose = false;
  for (int i = 0; i < numPossibleSystems; i++ ) {
    //lerpPoint = i / numPossibleSystems;   
    cx = (int) random(margin, width - margin);
    cy = (int) random(margin, height - margin);
    ss = (int) (sunSizeMean + randomGaussian() * sunSizeVariation);
    ps = (int) (planetSizeMean + randomGaussian() * planetSizeVariation);
    sc = color(i * 255 / numPossibleSystems, sunSaturation, sunBrightness);
    pc = color(i * 255 / numPossibleSystems, planetSaturation, planetBrightness);
    systems.add(new SolarSystem(cx, cy, ss, ps, sc, pc));
  }
  // clean up too-close systems
  for (int i = 0; i < systems.size(); i++ ) {
    for (int j = 0; j < systems.size(); j++ ) {
      if (i != 0 && i != j) {
        //println("dist " + systems.get(i).x + ", " + systems.get(i).y + ", " + systems.get(j).x + ", " + systems.get(j).y);
        if(dist(systems.get(i).x, systems.get(i).y, systems.get(j).x, systems.get(j).y) < margin * 1.5) {
          systems.get(i).removed = true;
        }
      }
    }
  }
  /*
  for (int i = 0; i < systems.size(); i++ ) {
    if (systems.get(i).removed == true) systems.remove(i);
    println("removed " + i);
  }
  */
  // test settings
  //frameRate(1);
  //println(systems.size());
  // distribute lifeforms amongst remaining solar systems
  for (int i = 0; i < systems.size(); i++) {
    color thisColour;
    int legs, legLength;
    if (systems.get(i).removed == false && lifeChance > random(1)) {
      thisColour = systems.get(i).planetColour;
      legs = (int) random(1, 4);
      legLength = (int) random(1, lifeBodySize);
      // (color _c, int _ln, int _ll, int _m, int _b, int _p, int _s)
      life.add(new LifeForm(thisColour, legs, legLength, lifeBodyMass, lifeBodySize, i, 0));
    }
  }
}

void draw() {
  background(backgroundColour);
  noStroke();
  for (int i = 0; i < systems.size(); i++) {
    SolarSystem thisSolarSystem = systems.get(i);
    if (systems.get(i).removed == false) {
      thisSolarSystem.display();
      for (int j = 0; j < life.size(); j++) {
        if (life.get(j).planet == i) {
          life.get(j).display(systems.get(i).getPlanetX(), systems.get(i).getPlanetY(), systems.get(i).planetSize);
        }
      }
    }
  }
  // floating lifeforms
  for (int i = 0; i < life.size(); i++) {
    if (life.get(i).planet == -1) {
      //test
      //println("floater!");
      life.get(i).display(life.get(i).x, life.get(i).y, 0);
      // check for capture by another planet
      float distance;
      for (int j = 0; j < systems.size(); j++) {
        if (systems.get(j).removed == false) {
          // distance check
          // test
          distance = dist(life.get(i).x, life.get(i).y, systems.get(j).getPlanetX(), systems.get(j).getPlanetY());
          //println("distance: " + distance + " capture distance: " + systems.get(j).planetSize * captureChance);
          if (distance < systems.get(j).planetSize * captureChance) {
            life.get(i).planet = j;
            life.get(i).mode = 1;
            int inhabitants = 0;
            for (int k = 0; k < life.size(); k++) {
              if (life.get(k).planet == i) inhabitants++;
            }
            life.get(i).planetSlot = inhabitants + 1;
          }
        }
      }
    }
  }
  breed();
  if(key == 's') {
    //println(frameCount);
    saveFrame();
  }

}

void breed() {
  for (int i = 0; i < systems.size(); i++ ) {
    if (systems.get(i).removed == false) {
      int inhabitants = 0;
      color thisColour;
      int legs, legLength;
      for (int j = 0; j < life.size(); j++) {
        if (life.get(j).planet == i) inhabitants++;
      }
      if (inhabitants < 12 && random(inhabitants + 1) < breedChance) {
        thisColour = systems.get(i).planetColour;
        legs = (int) random(1, 2);
        legLength = (int) random(1, lifeBodySize);
        life.add(new LifeForm(thisColour, legs, legLength, lifeBodyMass, lifeBodySize, i, inhabitants));
      }
    }
  }
}