class Target extends Entity {
  boolean targetComplete;
  Target(PVector pos, float r){
    super(pos, r);
    targetComplete = false;
  }
  
  boolean CheckCollision(PVector startPos, PVector endPos){
    super.CheckCollision(startPos, endPos);
    if(hit) {
      targetHit.trigger();
      targetComplete = true;
    }
    return hit;
  }
  
  void Draw() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    if(targetComplete) {
      target.setFill(#1aef61);
    } else {
      target.setFill(#ef1a4c);
    }
    scale(275);
    rotateY(-PI/2);
    rotateX(PI);
    shape(target);
    popMatrix();
  }
}
