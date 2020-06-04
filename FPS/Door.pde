enum DoorType
{
    NS, EW
};

class Door {
  Obstacle firstDoor;
  Obstacle secondDoor;
  DoorType type;
  PVector pos;
  boolean doorOpen;
  boolean moveDoor;
  float doorSpeed;
  float currentLength;
  float maxLength;
  boolean disabled; 
  
  Door(DoorType type, PVector pos, float maxLength, float doorSpeed) {
    this.pos = pos;
    this.pos.y -= 250;
    color doorColor = #7baa3d;
    if(type == DoorType.NS) {
      PVector right = new PVector(pos.x + 400, pos.y, pos.z);
      Obstacle firstDoor = new RectangleObstacle(800, 1500, 100, right, doorColor);
      PVector left = new PVector(pos.x - 400, pos.y, pos.z);
      Obstacle secondDoor = new RectangleObstacle(800, 1500, 100, left, doorColor);
      obstacles.add(firstDoor);
      obstacles.add(secondDoor);
      this.firstDoor = firstDoor;
      this.secondDoor = secondDoor;
    } else if(type == DoorType.EW) {
      PVector right = new PVector(pos.x, pos.y, pos.z + 400);
      Obstacle firstDoor = new RectangleObstacle(100, 1500, 800, right, doorColor);
      PVector left = new PVector(pos.x, pos.y, pos.z - 400);
      Obstacle secondDoor = new RectangleObstacle(100, 1500, 800, left, doorColor);
      obstacles.add(firstDoor);
      obstacles.add(secondDoor);
      this.firstDoor = firstDoor;
      this.secondDoor = secondDoor;
    }
  
    this.type = type;
    moveDoor = false;
    doorOpen = false;
    this.maxLength = maxLength; 
    this.doorSpeed = doorSpeed;
    this.disabled = false;
  }
  
  void OpenDoor() {
    moveDoor = true;
    doorOpenAudio.trigger();
  }
  
  void DoorOpenSet() {
    doorOpen = true;
    if(type == DoorType.NS) {
      firstDoor.pos.x += maxLength;
      secondDoor.pos.x -= maxLength;
    } else if(type == DoorType.EW) {
      firstDoor.pos.z += maxLength;
      secondDoor.pos.z -= maxLength;
    }
    firstDoor.ChangePosition();
    secondDoor.ChangePosition();
    doorSpeed = -doorSpeed;
    currentLength = maxLength;
  }
  
  boolean NearBy(PVector playerPos) {
   if(!this.disabled && PVector.sub(playerPos, pos).mag() < 850) {
     return true;
   } else {
     return false;
   }
  }
  
  void Move(float dt) {
    if(!moveDoor) {
      return;
    }
    
    if(type == DoorType.NS) {
      firstDoor.pos.x += doorSpeed * dt;
      secondDoor.pos.x -= doorSpeed * dt;
    } else if(type == DoorType.EW) {
      firstDoor.pos.z += doorSpeed * dt;
      secondDoor.pos.z -= doorSpeed * dt;
    }
    
    currentLength += doorSpeed * dt;
    
    firstDoor.ChangePosition();
    secondDoor.ChangePosition();
    
    if(!doorOpen && currentLength >= maxLength) {
      doorOpen = true;
      doorSpeed = -doorSpeed;
      moveDoor = false;
    } else if(doorOpen && currentLength <= 0) {
      doorOpen = false;
      doorSpeed = -doorSpeed;
      moveDoor = false;
    }
  }
}
