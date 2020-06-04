class Boidling extends Entity {
  PVector velocity;
  PVector acceleration;
  int effectRadius = 900;
  int speed = 1;
  boolean alive;
  float angle;
  int particlesCount = 10;
  PVector[] particles = new PVector[particlesCount];
  float[] x = new float[particlesCount];
  float[] z = new float[particlesCount];
  float yAcceleration = -50;
  
  Boidling(PVector pos, float r){
    super(pos, r);
    velocity = new PVector();
    acceleration = new PVector();
    alive = true;
    angle = 0;
    
    for(int i=0; i<particles.length; i++) {
      x[i] = 10 * cos(2*PI*i/particles.length);
      z[i] = 10 * sin(2*PI*i/particles.length);
      particles[i] = new PVector(x[i],0, z[i]);
    }
  }
  
  void UpdatePosition() {
    UpdateAcceleration();
    PVector goalDirection = PlayerForce();
    PVector nextPos = new PVector(pos.x, pos.y, pos.z);
    nextPos.sub(goalDirection);
    nextPos.add(velocity);
    velocity.add(acceleration);  
    
    PVector collisionUpdate;
    int xUpdate = 1;
    int zUpdate = 1;
    
    for(Obstacle obstacle : obstacles) {
      collisionUpdate = obstacle.SideCollision(nextPos, pos);
      xUpdate *= collisionUpdate.x;
      zUpdate *= collisionUpdate.z;
    }
    if(xUpdate == 1) {
      pos.x = nextPos.x;
    }
    
    if(zUpdate == 1) {
      pos.z = nextPos.z;
    }
    pos.y = nextPos.y;
  }
  
  void UpdateAcceleration() {
    int boidsInRadius = 0;
    // For cohesion
    PVector averagePosition = new PVector(0, 0, 0);
    // For alignment
    PVector averageVelocity = new PVector(0, 0, 0);
    // For seperation
    PVector seperation = new PVector(0, 0, 0);
    for(Boidling boid : boidlings) {
      PVector distanceBetween = PVector.sub(this.pos, boid.pos);
      float distance = distanceBetween.mag();
      if(boid != this && distance < effectRadius && boid.alive) {
        averagePosition.add(boid.pos);
        averageVelocity.add(boid.velocity);
        boidsInRadius++;
        if(distance < effectRadius-10) {
          PVector currentForce = new PVector(0, 0, 0);
          currentForce.add(pos);
          currentForce.sub(boid.pos);
          currentForce.normalize();
          currentForce.div(PVector.dist(pos, boid.pos));
          seperation.add(currentForce);
        }
      }
    }
    
    if(boidsInRadius != 0) {
      acceleration = new PVector(0,0,0);
      // cohesion
      averagePosition.div(boidsInRadius);
      averagePosition.sub(pos);
      averagePosition.div(150);
      acceleration.add(averagePosition);
      
      // alignment
      averageVelocity.div(boidsInRadius);
      averageVelocity.normalize();
      averageVelocity.mult(speed);
      averageVelocity.sub(velocity);
      averageVelocity.div(8);
      acceleration.add(averageVelocity);
      
      // seperation
      seperation.mult(40);
      acceleration.add(seperation);
    }
  }
  
  PVector PlayerForce() {
    PVector targetPos = new PVector(camera.position.x, camera.position.y+player.pHeight/2, camera.position.z);
    // Reached player
    if(PVector.sub(pos, targetPos).mag() < 150) {
      player.TakeDamage(3);
      alive = false;
    }
    
    PVector result;
    result = PVector.sub(pos, targetPos);
  
    result.normalize();
    result.mult(30);
    PVector xUnit = new PVector(1,0);
    PVector xzVector = new PVector(result.x, result.z);
    angle = PVector.angleBetween(xUnit, xzVector);
    
    if(result.z < 0) {
      angle = -angle;
    }
    return result;
  }
  
  void Draw() {
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  if(debug) {
    //sphere(r);
  }
  translate(0, 60, 0);
  rotateX(PI);
  rotateY(angle - PI);
  scale(50);
  shape(wasp);
  popMatrix();
  }
  
  float timeSinceDeath = 0;
  float timeBetweenDeaths = 1;
  boolean playDeath = true;
  void WaspDeathNoiseTimer() {
    timeSinceDeath += 1/frameRate;
    if(timeBetweenDeaths < timeSinceDeath) {
      timeSinceDeath = 0;
      playDeath = true;
    }
  }
  
  boolean CheckCollision(PVector startPos, PVector endPos){
    boolean result = super.CheckCollision(startPos, endPos);
    if(result) {
      if(alive) {
        if(playDeath) {
          waspDeathAudio.trigger();
          playDeath = false;
        }
      }
      alive = false;
    }
    return result;
  }
  
  float totalTime = 0;
  void GenerateParticles(float dt) {
    if(alive || totalTime > 1.5) {
      return;
    }
    noStroke();
    for(int i=0; i<particlesCount; i++) {
      particles[i].x += 2 * x[i] * dt;
      particles[i].y += 10 * yAcceleration * dt;
      particles[i].z += 2 * z[i] * dt;
      fill(#538237);
      pushMatrix();
      translate(pos.x+particles[i].x, pos.y+particles[i].y, pos.z+particles[i].z);
      rotateY(angle - 3*PI/4);
      circle(0,0,25);
      popMatrix();
    }
    yAcceleration += 4 * gravity * dt;
    totalTime += dt;
    stroke(1);
  }
}

void SpawnBoidling(PVector pos) {
  Boidling created = new Boidling(pos, 125);
  boidlings.add(created);
}
