class CircularObstacle extends Obstacle{
  float r, h;
  
  CircularObstacle(float r, float h, PVector pos) {
    this.r = r;
    this.h = -h;
    this.pos = pos;
  }
  
  boolean CheckTopCollision(PVector pos, float nextJumpPos) {
    PVector thisPosNoY = new PVector(this.pos.x, 0, this.pos.z);
    PVector posNoY = new PVector(pos.x, 0, pos.z);
    if (PVector.sub(thisPosNoY, posNoY).mag() <= r && pos.y <= h && nextJumpPos >= h) {
      return true;
    }
    return false;
  }
  
  PVector SideCollision(PVector pos, PVector oldPos) {
    PVector collisionUpdate = new PVector(1, 0, 1);
    
    PVector thisPosNoY = new PVector(this.pos.x, 0, this.pos.z);
    PVector posNoY = new PVector(pos.x, 0, pos.z);
    
    if(PVector.sub(thisPosNoY, posNoY).mag() < r && pos.y >= h && pos.y <= this.pos.y) {
      PVector xTest = new PVector(pos.x, 0, oldPos.z);
      if (PVector.sub(this.pos, xTest).mag() < r) {
        collisionUpdate.x = 0;
      }
      
      PVector zTest = new PVector(oldPos.x, 0, pos.z);
      if (PVector.sub(thisPosNoY, zTest).mag() < r) {
        collisionUpdate.z = 0;
      }
    }
    return collisionUpdate;
  }
  
  float GetHeight() {
    return h;
  }
  
  void Draw() {
    //pushMatrix();
    //translate(pos.x, pos.y, pos.z);
    //rotateX(PI/2);
    //circle(0, 0, r*2);
    //popMatrix();
    //pushMatrix();
    //translate(pos.x, pos.y + h, pos.z);
    //rotateX(PI/2);
    //circle(0, 0, r*2);
    //popMatrix();
    
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateX(PI);
    scale(200);
    shape(pipe);
    popMatrix();
  }
}
