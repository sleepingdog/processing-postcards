// SolarSystem class

class SolarSystem {
  public int x, y; // the centre of the sun
  public boolean removed = false; // if too close to others
  int sunSize; // used for the radius of the sun
  public int planetSize; // used for the radius and gravitational pull of the planet
  color sunColour; // colour of the sun
  public color planetColour; // colour of the planet, which determines colour of indigenous life
  float rotationalSpeed;
  float rotationalSpeedFactor = 0.1 * (random(-1, 1) < 0 ? -1.0 : 1.0);
  public float orbitalDistance;
  public float rotationalAngle;
  
  SolarSystem (int _x, int _y, int _s, int _p, color _sc, color _pc) {
    x = _x;
    y = _y;
    sunSize = _s;
    planetSize = _p;
    sunColour = _sc;
    planetColour = _pc;
    rotationalSpeed = rotationalSpeedFactor * (float) _s / (float) _p;
    orbitalDistance = 2.0 * (_s + _p);
    rotationalAngle = random(360);
  }
  
  void display() {
    ellipseMode(RADIUS);
    fill(sunColour);
    ellipse(x, y, sunSize, sunSize);
    //println(x + ", " + y + " " + sunSize);
    fill(planetColour);
    translate(x, y);
    rotate(radians(rotationalAngle));
    ellipse(0, 0 - orbitalDistance, planetSize, planetSize);
    //println(orbitalDistance + " " + planetSize + " " + planetSize + " " + rotationalSpeed);
    rotationalAngle += rotationalSpeed;
    if (rotationalAngle >= 360.0) { rotationalAngle = rotationalAngle - 360.0; }
    resetMatrix();
  }
  
  float getPlanetX() {
    float pX;
    //cos(radians(rotationalAngle)) = orbitalDistance / pX // CAH
    pX = orbitalDistance * cos(radians(90 - rotationalAngle));
    pX = pX + x;
    return pX;
  }
  float getPlanetY() {
    float pY;
    //cos(radians(rotationalAngle)) = orbitalDistance / pX // SOH
    //S(ROT) = O(y) / ORB
    
    pY = orbitalDistance * sin(radians(90 - rotationalAngle));
    pY = y - pY;
    return pY;
  }  
}