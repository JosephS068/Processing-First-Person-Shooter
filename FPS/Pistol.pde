class Pistol {
  PShape model;
  int bullets;
  int fullClip = 7;
  boolean shootAnimation, reloadAnimation, generateSmoke;
  int particlesCount = 825;
  PVector[] particles = new PVector[particlesCount];
  float[] angles = new float[particlesCount];
  float[] x = new float[particlesCount];
  float[] y = new float[particlesCount];
  PVector smokePos;
  float theta, phi;
  
  Pistol() {
    model = loadShape("Pistol_1.obj");
    bullets = fullClip;
    shootAnimation = false;
    generateSmoke = false;
    smokePos = new PVector();
    ResetParticles();
  }
  
  void Shoot() {
    // you can't shoot while you are already shooting
    if(shootAnimation || reloadAnimation) {
      return;
    }
    if(bullets == 0) {
      return;
    }
    gunShotAudio.trigger();
    ResetParticles();
    shootAnimation = true;
    generateSmoke = true;
    smokePos.x = camera.position.x;
    smokePos.y = camera.position.y + player.pHeight;
    smokePos.z = camera.position.z;
    theta = camera.theta;
    phi = camera.phi;
    PVector position = camera.position;
    PVector bulletStart = new PVector(position.x, position.y + player.pHeight, position.z);
    PVector bulletEnd = new PVector();
    bulletEnd.add(bulletStart);
    bulletEnd.x += 1000 * cos(theta);
    bulletEnd.y += 1000 * sin(phi);
    bulletEnd.z += 1000 * sin(theta);
    // TODO check all entities
    for(Boidling boidling : boidlings) {
      boidling.CheckCollision(bulletStart, bulletEnd);
    }
    for(Target target: targets) {
      target.CheckCollision(bulletStart, bulletEnd);
    }
    robotBoss.CheckCollision(bulletStart, bulletEnd);
    bullets--;
  }
  
  void Reload() {
    if(shootAnimation || reloadAnimation) {
      return;
    }
    reloadAudio.trigger();
    reloadAnimation = true;
    bullets = fullClip;
  }
  
  void Display() {
    if(shootAnimation || reloadAnimation) {
      return;
    }
    pushFPSMatrix();
    translate(6, 4 ,2);
    // Rotate gun to be in proper position for y
    rotateX(PI);
    scale(3);
    shape(model);
    popMatrix();
  }
  
  float angleSpeed = 2.5*PI;
  float currentAngle = 0;
  void ShootAnimation(float dt) {
    if (!shootAnimation || reloadAnimation) {
      return;
    }
    
    currentAngle += angleSpeed * dt;
    
    if (currentAngle > PI/3) {
      angleSpeed = -3*PI;
    } else if (currentAngle < 0) {
      angleSpeed = 3*PI;
      currentAngle = 0;
      shootAnimation = false; 
      return;
    }
    
    pushFPSMatrix();
    translate(6 - 2 * cos(currentAngle), 4, 2);
    rotateZ(-currentAngle);
    // Rotate gun to be in proper position for y
    rotateX(PI);
    scale(3);
    shape(model);
    popMatrix();
  }
  
  float forceForward = 10;
  float forceUp = -3;
  float transparency = 30;
  float dtTotal = 0;
  void GenerateSmoke(float dt) {
    if(!generateSmoke) {
      return;
    }
    noStroke();
    pushMatrix();
    translate(smokePos.x, smokePos.y, smokePos.z);
    rotateY(-theta);
    rotateZ(phi);
    rotateY(PI/2);
    translate(-20, 20, 150);
    for(int i=0; i<particles.length; i++) {
      pushMatrix();
      translate(0, 0, particles[i].z);
      fill(#a5a5a5, transparency);
      circle(particles[i].x, particles[i].y, 10);
      popMatrix();
      particles[i].x += 0.01 * abs(cos(angles[i])) * x[i]; 
      particles[i].y += 0.01 * abs(sin(angles[i])) * y[i];
      
      particles[i].y += forceUp * dt;
      particles[i].z += forceForward * dt;
    }
    popMatrix();
    transparency -= 30 * dt;
    forceUp += 5 * dt;
    if(forceUp > 0) {
      forceUp = 0;
    }
    forceForward -= 30 * dt;
    if(forceForward < 1) {
      forceForward = 1;
    }
    dtTotal += dt;
    if(dtTotal > 1) {
      generateSmoke = false;
      ResetParticles();
    }
    stroke(0);
  }
  
    void ResetParticles() {
      dtTotal = 0;
      transparency = 30;
      forceUp = -3;
      forceForward = 10;
      for(int i=0; i<particles.length; i++) {
        PVector particle = new PVector();
        float angle = random(0, 2*PI);
        particle.x = random(0, 50) * cos(angle);
        particle.y = random(0, 50) * sin(angle);
        particle.z = random(0, 2);
        particles[i] = particle;
        angles[i] = angle;
        x[i] = particle.x;
        y[i] = particle.y;
      }
  }
  
  // number of times the gun moves up and down
  boolean peaked = false;
  float reloadSpeed = -10;
  float reloadPosition = 0;
  void ReloadAnimation(float dt) {
    if(!reloadAnimation || shootAnimation) {
      return;
    }
    
    reloadPosition += reloadSpeed * dt;
    
    pushFPSMatrix();
    translate(6, 4 + reloadPosition, 2.5);
    // Rotate gun to be in proper position for y
    rotateZ(-PI/2);
    rotateX(PI);
    scale(3);
    shape(model);
    popMatrix();
    
    if (reloadPosition < -2.5) {
      reloadSpeed = -reloadSpeed;
      peaked = true;
    } else if (reloadPosition > 0) {
      peaked = false;
      reloadPosition = 0;
      reloadSpeed = -10;
      reloadAnimation = false; 
      return;
    }
  }
}
