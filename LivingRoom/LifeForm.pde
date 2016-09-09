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
  public int planetSlot;
  public float x;
  public float y;
  float rot;
  float dx; // x movement per frame in float mode
  float dy; // y movement per frame in float mode
  float spaceSpeed = 0.02; // factor governing space travel speed (0.01 is good if slow)
  float escapeFactor = 0.75; // factor governing escape height
  float jumpForceFactor = 98.0;
  float jumpForceRandom = 15.0;

  LifeForm (color _c, int _ln, int _ll, int _m, int _b, int _p, int _s) {
    colour = _c;
    legNumber = _ln;
    legLength = _ll;
    mass = _m + (_ln * _ll);
    jumpForce = _ln * _ll * (jumpForceFactor + random(jumpForceRandom));
    //age = 0;
    bodySize = _b;
    planet = _p;
    planetSlot = _s;
  }

  void display(float _x, float _y, float _o) { // , float _r, float _h
    rectMode(CENTER);
    fill(colour);
    noStroke();
    if (this.mode < 2) { // planet-based lifeforms
      float amplitude = jumpForce / (mass * _o);
      float frequency = frameRate / 2000;
      //float jumpHeight = sin(frameCount % 360) * amplitude + amplitude / 2;
      float jumpHeight = (sin(frequency * frameCount % 360) * amplitude + amplitude / 2);
      translate(_x, _y);
      rotate(radians(planetSlot * 30)); // _r + 
      // draw body then legs
      rect(0, 0 - _o - legLength - (bodySize / 2) - jumpHeight, bodySize, bodySize, bodySize / 4);
      for (int i = 0; i < legNumber; i++) { // draw legs
        stroke(colour);
        line(i/legNumber * bodySize / 2, 0 - _o - jumpHeight, i/legNumber * bodySize / 2, 0 - _o - legLength - jumpHeight);
      }
      resetMatrix();
      noStroke();
      //age++;
      //println("jumpHeight: " + jumpHeight + " planetSize: " + _o);
      if (jumpHeight - bodySize > _o * escapeFactor) { // TODO: tweak escape height
        //test
        //println("take-off!");
        this.mode = 2;
        this.rot = planetSlot * 30;
        //sin(planetSlot * 30) = dx / _o
        this.dx = sin(radians(this.rot)) * _o * spaceSpeed;
        //cos(planetSlot * 30) = dy / _o
        this.dy = cos(radians(this.rot)) * _o * spaceSpeed;
        this.x = _x + sin(radians(this.rot)) * (_o - legLength - (bodySize / 2) - jumpHeight);
        this.y = _y + cos(radians(this.rot)) * (_o - legLength - (bodySize / 2) - jumpHeight);
        //if (this.x < _x) this.dx = this.dx * -1;
        //if (this.y < _y) this.dy = this.dy * -1;        
        this.planet = -1; // escapes from planet
      }
    } else {
      // float
      //test
      //println(this.x + "," + this.y);
      translate(this.x, this.y);
      rotate(radians(this.rot));
      rect(0, 0, bodySize, bodySize);
      resetMatrix();
      this.x = this.x + this.dx;
      this.y = this.y + this.dy;
      // wraparound space
      if (this.x > width) this.x = this.x - width;
      if (this.x < 0) this.x = width + this.x;
      if (this.y > height) this.y = this.y - height;
      if (this.y < 0) this.y = height + this.y;
    }
  }
}