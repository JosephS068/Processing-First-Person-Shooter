enum QuadType
{
    NS, EW
};

class QuadObstacle extends Obstacle {
  float wallWidth;
  float wallHeight;
  QuadType type;
  PVector L1, L2, U1, U2;
  color obColor;
  
  QuadObstacle(float wallWidth, float wallHeight, PVector pos, QuadType type) {
    this.wallWidth = wallWidth;
    this.wallHeight = wallHeight;
    this.pos = pos;
    this.type = type;
    if(type == QuadType.NS) {
      L1 = new PVector(pos.x-wallWidth/2, pos.y, pos.z);
      L2 = new PVector(pos.x+wallWidth/2, pos.y, pos.z);
      U1 = new PVector(pos.x-wallWidth/2, pos.y+wallHeight, pos.z);
      U2 = new PVector(pos.x+wallWidth/2, pos.y+wallHeight, pos.z);
    } else if(type == QuadType.EW) {
      L1 = new PVector(pos.x, pos.y, pos.z-wallWidth/2);
      L2 = new PVector(pos.x, pos.y, pos.z+wallWidth/2);
      U1 = new PVector(pos.x, pos.y+wallHeight, pos.z-wallWidth/2);
      U2 = new PVector(pos.x, pos.y+wallHeight, pos.z+wallWidth/2);
    }
    ChangePosition();
  }
  
  boolean CheckTopCollision(PVector pos, float nextJumpPos) {
    // 2D wall, no top collision possible
    return false;
  }
  
  PVector SideCollision(PVector pos, PVector oldPos) {
    if(type == QuadType.NS) {
      return NSCollision(pos, oldPos);
    } else if(type == QuadType.EW) {
      return EWCollision(pos, oldPos);
    }
    return null;
  }
  
  PVector NSCollision(PVector pos, PVector oldPos) {
    if(oldPos.x >= L1.x && oldPos.x < L2.x 
    && oldPos.y <= L1.y && oldPos.y >= U1.y
    && (oldPos.z <= L1.z && pos.z >= L1.z
    ||
    oldPos.z >= L1.z && pos.z <= L1.z)) {
      return new PVector(1,1,0);
    }
    return new PVector(1,1,1);
  }
  
  PVector EWCollision(PVector pos, PVector oldPos) {
    if(oldPos.z >= L1.z && oldPos.z < L2.z
    && oldPos.y <= L1.y && oldPos.y >= U1.y
    && (oldPos.x <= L1.x && pos.x >= L1.x
    ||
    oldPos.x >= L1.x && pos.x <= L1.x)) {
      return new PVector(0,1,1);
    }
    return new PVector(1,1,1);
  }  
  
  float GetHeight() {
    return wallHeight;
  }
  
  void Draw() {
    fill(#a2a5a4);
    if(type == QuadType.NS) {
      pushMatrix();
      translate(0, 0, pos.z);
      quad(L1.x, L1.y, U1.x, U1.y, U2.x, U2.y, L2.x, L2.y);
      popMatrix();
    } else if(type == QuadType.EW) {
      pushMatrix();
      rotateY(-PI/2);
      translate(0,0,-pos.x);
      quad(L1.z, L1.y, U1.z, U1.y, U2.z, U2.y, L2.z, L2.y);
      popMatrix();
    }
  }
}
