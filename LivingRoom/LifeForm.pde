// LifeForm class

class LifeForm {
  public color colour;
  public int legNumber;
  public int legLength;
  int bodySize;
  float mass;
  float jumpForce;
  //int age;
  //int maturityAge = 600;
  int mode; // 0 = immature; 1 = mature; 2 = floating
  public int planet;
  int planetSlot;
  
  LifeForm (color _c, int _ln, int _ll, int _m, int _b, int _p, int _s) {
    colour = _c;
    legNumber = _ln;
    legLength = _ll;
    mass = _m + (_ln * _ll);
    jumpForce = _ln * _ll * 100;
    //age = 0;
    bodySize = _b;
    planet = _p;
    planetSlot = _s;
  }
  
  void display(float _x, float _y, float _o) { // , float _r, float _h
    rectMode(CENTER);
    fill(colour);
    noStroke();
    if (this.mode < 2) {
      float amplitude = jumpForce / (mass * _o);
      float frequency = frameRate / 2000;
      //float jumpHeight = sin(frameCount % 360) * amplitude + amplitude / 2;
      float jumpHeight = (sin(frequency * frameCount % 360) * amplitude + amplitude / 2);
      translate(_x, _y);
      rotate(radians(planetSlot * 30)); // _r + 
      rect(0, 0 - _o - legLength - (bodySize / 2) - jumpHeight, bodySize, bodySize, bodySize / 4);
      for (int i = 0; i < legNumber; i++) {
        stroke(colour);
        line(0, 0 - _o - jumpHeight, 0, 0 - _o - legLength - jumpHeight);
      }
      resetMatrix();
      noStroke();
      //age++;
      //println("jumpHeight: " + jumpHeight + " planetSize: " + _o);
      if (jumpHeight - bodySize > _o) {
        this.mode = 2;
        this.planet = -1;
      } else {
        // float
      }
    }
  }
  
}