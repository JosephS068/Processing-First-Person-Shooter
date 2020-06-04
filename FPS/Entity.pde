class Entity {
  PVector pos;
  float r;
  
  boolean hit;
  
  Entity(PVector pos, float r){
    this.pos = pos;
    this.r = r;
    hit = false;
  }
  
  boolean CheckCollision(PVector startPos, PVector endPos){
    //Step 1: Compute V - a normalized vector pointing from the start of the linesegment to the end of the line segment
    float x1 = startPos.x;
    float x2 = endPos.x;
    float y1 = startPos.y;
    float y2 = endPos.y;
    float z1 = startPos.z;
    float z2 = endPos.z;
    float vx,vy, vz;
    vx = x2 - x1;
    vy = y2 - y1;
    vz = z2 - z1;
    float lenv = sqrt(vx*vx + vy*vy + vz*vz);
    vx /= lenv;
    vy /= lenv;
    vz /= lenv;
    
    //Step 2: Compute W - a displacement vector pointing from the start of the line segment to the center of the circle      
    float cx = pos.x;
    float cy = pos.y;
    float cz = pos.z;
    float wx,wy,wz;      
    wx = cx - x1;
    wy = cy - y1;
    wz = cz - z1;
    
    //Step 3: Solve quadratic equation for intersection point (in terms of V and W)
    float a = 1;
    float b = -2*(vx*wx + vy*wy + vz*wz);
    float c = wx*wx + wy*wy + wz*wz - r*r;
    float d = b*b - 4*a*c;
    hit = false;
    boolean colliding = false;
    if (d >= 0){
      float t = (-b - sqrt(d))/(2*a);
      if (t>0 
      //&& t<lenv
      ){
        hit = true;
        return true;
      }
    
    }
    return colliding;
  }
  
  void Draw() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    if(hit) {
      fill(#e0490d);
    } else {
      fill(#bd0de0);
    }
    sphere(r);
    popMatrix();
  }
}
