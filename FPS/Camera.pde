// Created for CSCI 5611 by Liam Tyler and Stephen Guy
class Camera
{
  Camera()
  {
    position      = new PVector( 0, 0, 5200 ); // initial position
    theta         = 0; // rotation around Y axis. Starts with forward direction as ( 0, 0, -1 )
    phi           = 0; // rotation around X axis. Starts with up direction as ( 0, 1, 0 )
    moveSpeed     = 1900;
    turnSpeed     = 1.57; // radians/sec
    
    // dont need to change these
    negativeMovement = new PVector( 0, 0, 0 );
    positiveMovement = new PVector( 0, 0, 0 );
    negativeTurn     = new PVector( 0, 0 ); // .x for theta, .y for phi
    positiveTurn     = new PVector( 0, 0 );
    fovy             = PI / 4;
    aspectRatio      = width / (float) height;
    nearPlane        = 0.1;
    farPlane         = 10000;
  }
  
  void Update( float dt )
  {
    
    theta += turnSpeed * (negativeTurn.x + positiveTurn.x) * dt;
    float strafeTheta = theta + (PI/2);
    phi += turnSpeed * (negativeTurn.y + positiveTurn.y) * dt;
    
    // TODO LOOK INTO GIMBLE LOCK
    // cap the rotation about the X axis to be less than 90 degrees to avoid gimble lock
    float maxAngleInRadians = PI / 2.2;
    phi = min( maxAngleInRadians, max( -maxAngleInRadians, phi + turnSpeed * ( negativeTurn.y + positiveTurn.y ) * dt ) );
    
    PVector nextPosition = new PVector(position.x, position.y, position.z);
    PVector forwardVelocity = new PVector(cos(theta),0,sin(theta));
    forwardVelocity.mult(positiveMovement.z + negativeMovement.z);
    forwardVelocity.mult(moveSpeed);
    forwardVelocity.mult(dt);
    nextPosition.add(forwardVelocity);
    
    PVector strafeVelocity = new PVector(cos(strafeTheta),0,sin(strafeTheta));
    strafeVelocity.mult(positiveMovement.x + negativeMovement.x);
    strafeVelocity.mult(moveSpeed);
    strafeVelocity.mult(dt);
    nextPosition.add(strafeVelocity);
    
    PVector xAxisRotation = new PVector(cos(theta),0,sin(theta));
    xAxisRotation.normalize();
    
    PVector yAxisRotation = new PVector(0,sin(phi),cos(phi));
    yAxisRotation.normalize();
    
    xAxisRotation.mult(cos(phi));
    
    PVector collisionUpdate;
    int xUpdate = 1;
    int zUpdate = 1;
    // check all otacles
    for(Obstacle obstacle : obstacles) {
      collisionUpdate = obstacle.SideCollision(nextPosition, position);
      xUpdate *= collisionUpdate.x;
      zUpdate *= collisionUpdate.z;
    }
    
    if(xUpdate == 1) {
      position.x = nextPosition.x;
    }
    
    if(zUpdate == 1) {
      position.z = nextPosition.z;
    }
    
    VerticalMovement(dt);
    aspectRatio = width / (float) height;
    perspective( fovy, aspectRatio, nearPlane, farPlane );
    camera( position.x, position.y + player.pHeight, position.z,
            position.x + xAxisRotation.x, position.y + yAxisRotation.y + player.pHeight, position.z + xAxisRotation.z,
            0, 1, 0);
            
   if(state == State.LAND && (xUpdate == 1 || zUpdate == 1)
   && (positiveMovement.x != 0 || positiveMovement.z != 0 || negativeMovement.x !=0 || negativeMovement.z != 0)) {
     footStepsAudio.play();
     footStepRest += dt;
     if(5 < footStepRest) {
       footStepRest = 0;
       footStepsAudio.rewind();
     }
   } else {
     footStepsAudio.pause();
   }
  }
  float footStepRest = 0;
    void Jump() {
    if(state == State.LAND) {
      jumpSpeed = -30;
      state = State.AIR;
    }
  }
  
  void VerticalMovement(float dt) {
    VerticalCollisionCheck(dt);
    if(state == State.LAND) {
      player.TakeFallDamage(jumpSpeed);
      jumpSpeed = 0;
    } else {
      jumpSpeed += (gravity*dt);
      position.y += jumpSpeed;
      if(position.y >= 0 ) {
        position.y = 0;
      }
    }
  }
  
  void VerticalCollisionCheck(float dt) {
    float nextJumpPos = position.y + jumpSpeed + (gravity * dt);
    for(int i=0; i< obstacles.size(); i++) {
      boolean result = obstacles.get(i).CheckTopCollision(position, nextJumpPos);
      if(result == true) {
        state = State.LAND;
        position.y = obstacles.get(i).GetHeight();
        return;
        // Create a global floor, may remove this for actual levels
      } 
      if(position.y >= 0 && jumpSpeed >= 0) {
        state = State.LAND;
        // This shouldn't be needed, but a just incase the player some how managed to get lower than global floor
        position.y = 0;
        return;
      }
    } 
    state = State.AIR;
  }
  
  // only need to change if you want difrent keys for the controls
  void HandleKeyPressed()
  {
    if ( key == 'w' ) positiveMovement.z = 1;
    if ( key == 's' ) negativeMovement.z = -1;
    if ( key == 'a' ) negativeMovement.x = -1;
    if ( key == 'd' ) positiveMovement.x = 1;
    if ( key == ' ' ) Jump();
    if ( key == '/' ) pistol.Shoot();
    if ( key == 'r' ) pistol.Reload();
    if ( key == 'm' ) useMouse = !useMouse;
    if ( key == 'e' && player.nearByDoor != null) {
     if (!player.nearByDoor.moveDoor) player.nearByDoor.OpenDoor();
    }
    
    //DEBUG COMMANDS
    if(debug) {
      if ( key == 'k' ) player.TakeDamage(100);
      if ( key == 'l' ) setup();
    }
    
    
    if ( keyCode == RIGHT )  negativeTurn.x = 1;
    if ( keyCode == LEFT ) positiveTurn.x = -1;
    if ( keyCode == DOWN )    positiveTurn.y = 1;
    if ( keyCode == UP )  negativeTurn.y = -1;
  }
  
  // only need to change if you want difrent keys for the controls
  void HandleKeyReleased()
  {
    if ( key == 'w' ) positiveMovement.z = 0;
    if ( key == 'd' ) positiveMovement.x = 0;
    if ( key == 'a' ) negativeMovement.x = 0;
    if ( key == 's' ) negativeMovement.z = 0;
    
    if ( keyCode == RIGHT  ) negativeTurn.x = 0;
    if ( keyCode == LEFT ) positiveTurn.x = 0;
    if ( keyCode == DOWN    ) positiveTurn.y = 0;
    if ( keyCode == UP  ) negativeTurn.y = 0;
  }
  
  void StopMovement() {
    positiveMovement.z = 0;
    positiveMovement.x = 0;
    negativeMovement.x = 0;
    negativeMovement.z = 0;
    negativeTurn.x = 0;
    positiveTurn.x = 0;
    positiveTurn.y = 0;
    negativeTurn.y = 0;
  }
  
  // only necessary to change if you want different start position, orientation, or speeds
  PVector position;
  float theta;
  float phi;
  float moveSpeed;
  float turnSpeed;
  float jumpSpeed = 0;
  State state = State.LAND;
  
  // probably don't need / want to change any of the below variables
  float fovy;
  float aspectRatio;
  float nearPlane;
  float farPlane;  
  PVector negativeMovement;
  PVector positiveMovement;
  PVector negativeTurn;
  PVector positiveTurn;
};

Camera camera;
