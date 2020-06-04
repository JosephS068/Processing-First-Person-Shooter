class BearTrap {
  PVector pos;
  boolean active;
  BearTrap(PVector pos) {
    this.pos = pos;
    active = true;
  }
  
  void CheckCollision() {
    if(active && PVector.sub(pos, camera.position).mag() < 150) {
      active = false;
      player.TakeDamage(5);
      trapAudio.trigger();
    }
  }
  
  void Draw() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateZ(PI);
    scale(100);
    if(active) {
      shape(trapOpen);
    } else {
      shape(trapClosed);
    }
    popMatrix();
  }
}
