abstract class Obstacle {
  PVector pos;
  abstract boolean CheckTopCollision(PVector pos, float nextJumpPos);
  abstract PVector SideCollision(PVector pos, PVector oldPos);
  abstract void Draw();
  abstract float GetHeight();
  void ChangePosition() {}
}
