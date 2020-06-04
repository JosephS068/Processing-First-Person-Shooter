class RectangleObstacle extends Obstacle {
  int w, h, d;
  float wUp, wLow, dUp, dLow;
  float topHeight, bottomHeight;
  color obColor;
  
  RectangleObstacle(int w, int h, int d, PVector pos) {
    this.w = w;
    this.h = h;
    this.d = d;
    this.pos = pos;
    ChangePosition();
    //obColor = #054154;
    obColor = 204;
  }
  RectangleObstacle(int w, int h, int d, PVector pos, color obColor) {
    this.w = w;
    this.h = h;
    this.d = d;
    this.pos = pos;
    this.obColor = obColor;
    ChangePosition();
  }
  
  void ChangePosition() {
    topHeight = -h/2 + pos.y;
    bottomHeight = h/2 + pos.y;
    float halfWidth = w/2;
    float halfDepth = d/2;
    wUp = pos.x + halfWidth;
    wLow = pos.x - halfWidth;
    dUp = pos.z + halfDepth;
    dLow = pos.z - halfDepth;
  }
  
  boolean CheckTopCollision(PVector pos, float nextJumpPos) {
    if(pos.x >= wLow && pos.x <= wUp 
    && pos.z >= dLow && pos.z <= dUp
    && pos.y <= topHeight && nextJumpPos >= topHeight) {
      return true;
    }
    return false;
  }
  
  PVector SideCollision(PVector pos, PVector oldPos) {
    if(pos.x > wLow && pos.x< wUp 
    && pos.z > dLow && pos.z < dUp
    && pos.y <= bottomHeight && pos.y >= topHeight) {
      EWCollision(pos.x, oldPos.x);
      PVector collisionUpdate = new PVector(0,0,0);
      if(!EWCollision(pos.x, oldPos.x)) {
        collisionUpdate.x = 1;
      }
      if(!NSCollision(pos.z, oldPos.z)) {
        collisionUpdate.z = 1;
      }
      return collisionUpdate;
    }
    return new PVector(1, 1, 1);
  }
  
  boolean NSCollision(float newZ, float oldZ) {
    // north check
    if(oldZ > dUp && newZ < dUp) {
      return true;
    }
    // south check
    if(oldZ < dLow && newZ > dLow) {
      return true;
    }
    return false;
  }
  
  boolean EWCollision(float newX, float oldX) {
    // east check
    if(oldX > wUp && newX < wUp) {
      return true;
    }
    
    // west check
    if (oldX < wLow && newX > wLow) {
      return true;
    }
    return false;
  }
  
  float GetHeight() {
    return topHeight;
  }
  
  void Draw() {
    fill(obColor);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    box(w, h, d);
    popMatrix();
  }
}
