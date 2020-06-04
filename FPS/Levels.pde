Door goalDoor;
Door door3;
Door door4;
RobotBoss robotBoss;
Obstacle pipeHitBox;
ArrayList<Obstacle> jumpObs = new ArrayList<Obstacle>();
ArrayList<Obstacle> section1 = new ArrayList<Obstacle>();
float obsticleMaxHeight;
void Level_1() { 
  // Set Player Start Position
  camera.theta = -PI/2;
  
  // Creating First Room
  Door door1 = new Door(DoorType.NS, new PVector(0,0,4500), 500, 100);
  doors.add(door1);
  
  Obstacle wall1 = new QuadObstacle(1000, -1000, new PVector(500, 0, 5000), QuadType.EW);
  Obstacle wall2 = new QuadObstacle(1000, -1000, new PVector(-500, 0, 5000), QuadType.EW);
  Obstacle wall3 = new QuadObstacle(1000, -1000, new PVector(0, 0, 5500), QuadType.NS);
  
  // Adding Walls
  obstacles.add(wall1);
  obstacles.add(wall2);
  obstacles.add(wall3);
  
  // Hallway One
  Obstacle wall4 = new QuadObstacle(7500, -1000, new PVector(500, 0, 750), QuadType.EW);
  Obstacle wall5 = new QuadObstacle(7000, -1000, new PVector(-500, 0, 1000), QuadType.EW);
  Obstacle wall6 = new QuadObstacle(8000, -1000, new PVector(-3500, 0, -3000), QuadType.NS);
  Obstacle wall7 = new QuadObstacle(3000, -1000, new PVector(-2000, 0, -2500), QuadType.NS);
  
  obstacles.add(wall4);
  obstacles.add(wall5);
  obstacles.add(wall6);
  obstacles.add(wall7);
  
  for(Obstacle ob : obstacles) {
    section1.add(ob);
  }
  
  // Target Practice Room
  Door door2 = new Door(DoorType.EW, new PVector(-2000,0,-2750), 250, 100);
  doors.add(door2);
  
  Obstacle wall8 = new QuadObstacle(4000, -1000, new PVector(-3500, 0, -500), QuadType.EW);
  Obstacle wall9 = new QuadObstacle(5000, -1000, new PVector(-6000, 0, 1500), QuadType.NS);
  Obstacle wall10 = new QuadObstacle(8000, -1000, new PVector(-8500, 0, -2500), QuadType.EW);
  Obstacle wall11 = new QuadObstacle(3500, -1000, new PVector(-7500, 0, -4750), QuadType.EW);
  
  obstacles.add(wall8);
  obstacles.add(wall9);
  obstacles.add(wall10);
  obstacles.add(wall11);
  
  // Target Area
  Obstacle targetTable = new RectangleObstacle(3500, 1400, 200, new PVector(-6800, 0, -1000), #7b7c74);
  Obstacle targetBlocker = new RectangleObstacle(200, 600, 3000, new PVector(-5500, 0, 500), #7b7c74);
  obstacles.add(targetTable);
  obstacles.add(targetBlocker);
  
  pipeHitBox = new CircularObstacle(175, 400, new PVector(-6800, 0, -1500));
  obstacles.add(pipeHitBox);
  
  // Target entities
  float targetRadius = 100;
  float targetHeight = -500;
  float targetX = -8480;
  float targetZ = 750;
  Target target1 = new Target(new PVector(targetX,targetHeight,targetZ), targetRadius);
  Target target2 = new Target(new PVector(targetX,targetHeight,targetZ-500), targetRadius);
  Target target3 = new Target(new PVector(targetX,targetHeight,targetZ-1000), targetRadius);
  
  targets.add(target1);
  targets.add(target2);
  targets.add(target3);
  
  // Jump Room
  door3 = new Door(DoorType.NS, new PVector(-8000,0,-6450), 500, 250);
  door3.disabled = true;
  doors.add(door3);
  
  Obstacle wall12 = new QuadObstacle(8000, -1000, new PVector(-3500, 0, -6500), QuadType.NS);
  Obstacle wall13 = new QuadObstacle(8000, -1000, new PVector(500, 0, -10500), QuadType.EW);
  Obstacle wall14 = new QuadObstacle(11000, -1000, new PVector(-5000, 0, -14500), QuadType.NS);
  Obstacle wall15 = new QuadObstacle(7000, -1000, new PVector(-8500, 0, -10000), QuadType.EW);
  Obstacle wall16 = new QuadObstacle(2000, -1000, new PVector(-9500, 0, -13500), QuadType.NS);
  
  Obstacle wall12a = new QuadObstacle(9000, -2000, new PVector(-4000, -1000, -6500), QuadType.NS);
  Obstacle wall13a = new QuadObstacle(8000, -2000, new PVector(500, -1000, -10500), QuadType.EW);
  Obstacle wall14a = new QuadObstacle(11000, -2000, new PVector(-5000, -1000, -14500), QuadType.NS);
  Obstacle wall15a = new QuadObstacle(8000, -2000, new PVector(-8500, -1000, -10500), QuadType.EW);
  
  obstacles.add(wall12);
  obstacles.add(wall13);
  obstacles.add(wall14);
  obstacles.add(wall15);
  obstacles.add(wall16);
  
  obstacles.add(wall12a);
  obstacles.add(wall13a);
  obstacles.add(wall14a);
  obstacles.add(wall15a);
  
  // Parasite Corridor
  door4 = new Door(DoorType.EW, new PVector(-8550,0,-14000), 500, 100);
  doors.add(door4);
  door4.disabled = true;
  
  // Disabled Doors, not meant to be opened by player
  Door door5 = new Door(DoorType.EW, new PVector(-9500,0,-11000), 500, 100);
  door5.disabled = true;
  Door door6 = new Door(DoorType.EW, new PVector(-13000,0,-14500), 500, 100);
  door6.disabled = true;
  Door door7 = new Door(DoorType.NS, new PVector(-11000,0,-16000), 500, 100);
  door7.disabled = true;
  
  doors.add(door5);
  doors.add(door6);
  doors.add(door7);
  
  Obstacle wall17 = new QuadObstacle(1500, -1000, new PVector(-10500, 0, -15250), QuadType.EW);
  Obstacle wall18 = new QuadObstacle(2000, -1000, new PVector(-10500, 0, -12500), QuadType.EW);
  Obstacle wall19 = new QuadObstacle(2000, -1000, new PVector(-9500, 0, -11500), QuadType.NS);
  Obstacle wall20 = new QuadObstacle(2000, -1000, new PVector(-9500, 0, -10500), QuadType.NS);
  Obstacle wall21 = new QuadObstacle(5000, -1000, new PVector(-10500, 0, -8000), QuadType.EW);
  Obstacle wall22 = new QuadObstacle(1000, -1000, new PVector(-11500, 0, -15500), QuadType.EW);
  Obstacle wall23 = new QuadObstacle(2000, -1000, new PVector(-12500, 0, -15000), QuadType.NS);
  Obstacle wall24 = new QuadObstacle(2000, -1000, new PVector(-12500, 0, -14000), QuadType.NS);
  Obstacle wall25 = new QuadObstacle(8500, -1000, new PVector(-11500, 0, -9750), QuadType.EW);
  
  obstacles.add(wall17);
  obstacles.add(wall18);
  obstacles.add(wall19);
  obstacles.add(wall20);
  obstacles.add(wall21);
  obstacles.add(wall22);
  obstacles.add(wall23);
  obstacles.add(wall24);
  obstacles.add(wall25);
  
  // Goal Room
  Obstacle wall26 = new QuadObstacle(1000, -1000, new PVector(-10500, 0, -5000), QuadType.EW);
  Obstacle wall27 = new QuadObstacle(1000, -1000, new PVector(-11500, 0, -5000), QuadType.EW);
  Obstacle wall28 = new QuadObstacle(1000, -1000, new PVector(-11000, 0, -4500), QuadType.NS);
  
  Door door8 = new Door(DoorType.NS, new PVector(-11000,0,-5500), 350, 15);
  door8.DoorOpenSet();
  doors.add(door8);
  goalDoor = door8;
  
  obstacles.add(wall26);
  obstacles.add(wall27);
  obstacles.add(wall28);
  
  // Obstacle Course
  Obstacle ob1 = new RectangleObstacle(650, 350, 650, new PVector(-7000, 0, -7500), #29ad7f);
  Obstacle ob2 = new RectangleObstacle(900, 1200, 650, new PVector(-5000, 0, -7500), #29ad7f);
  Obstacle ob3 = new RectangleObstacle(900, 1500, 650, new PVector(-4000, 0, -9000), #29ad7f);
  Obstacle ob4 = new RectangleObstacle(900, 2500, 650, new PVector(-2500, 0, -8000), #29ad7f);
  Obstacle ob5 = new RectangleObstacle(500, 2500, 1500, new PVector(-2000, 0, -11000), #29ad7f);
  Obstacle ob6 = new RectangleObstacle(300, 3000, 400, new PVector(-3000, 0, -11500), #29ad7f);
  Obstacle ob7 = new RectangleObstacle(200, 2300, 600, new PVector(-4000, 0, -13500), #29ad7f);
  Obstacle ob8 = new RectangleObstacle(300, 2000, 600, new PVector(-5000, 0, -13500), #29ad7f);
  Obstacle ob9 = new RectangleObstacle(600, 2200, 600, new PVector(-5500, 0, -12000), #29ad7f);
  Obstacle ob10 = new RectangleObstacle(150, 2200, 2000, new PVector(-7000, 0, -13500), #29ad7f);
  Obstacle ob11 = new RectangleObstacle(1650, 2200, 150, new PVector(-7750, 0, -12500), #29ad7f);
  obsticleMaxHeight = 1600;
  
  obstacles.add(ob1);
  obstacles.add(ob2);
  obstacles.add(ob3);
  obstacles.add(ob4);
  obstacles.add(ob5);
  obstacles.add(ob6);
  obstacles.add(ob7);
  obstacles.add(ob8);
  obstacles.add(ob9);
  obstacles.add(ob10);
  obstacles.add(ob11);
  
  jumpObs.add(ob1);
  jumpObs.add(ob2);
  jumpObs.add(ob3);
  jumpObs.add(ob4);
  jumpObs.add(ob5);
  jumpObs.add(ob6);
  jumpObs.add(ob7);
  jumpObs.add(ob8);
  jumpObs.add(ob9);
  jumpObs.add(ob10);
  jumpObs.add(ob11);
  
  for(Obstacle ob : jumpObs) {
    ob.pos.y += obsticleMaxHeight;
    ob.ChangePosition();
  }
  
  robotBoss = new RobotBoss(new PVector(-4000, 0, -10000));
}


void Level1Draw() {
  // Floor Creation, a global floor collision is in place, we just need to texture it
  //Elevators
  noStroke();
  if(camera.position.x > -600 ) {
    pushMatrix();
    beginShape();
    texture(elevatorFloor);
    translate(0, 0, 5000);
    vertex(-500, 0, -500, 0, 0);
    vertex(500, 0, -500, elevatorFloor.width, 0);
    vertex(500, 0, 500, elevatorFloor.width, elevatorFloor.height);
    vertex(-500, 0, 500, 0, elevatorFloor.height);
    endShape();
    popMatrix();
  }
  
  if(camera.position.x < -10500  && !player.won) {
    pushMatrix();
    beginShape();
    texture(elevatorFloor);
    translate(-11000, 0, -5000);
    vertex(-500, 0, -500, 0, 0);
    vertex(500, 0, -500, elevatorFloor.width, 0);
    vertex(500, 0, 500, elevatorFloor.width, elevatorFloor.height);
    vertex(-500, 0, 500, 0, elevatorFloor.height);
    endShape();
    popMatrix();
  }
  
  // Floor
  beginShape();
  fill(#46473d);
  vertex(500, 0, -1000);
  vertex(-8500, 0, -1000);
  vertex(-8500, 0, -6500);
  vertex(500, 0, -6500);
  endShape();
  
  beginShape();
  fill(#46473d);
  vertex(500, 0, 4500);
  vertex(500, 0, -1000);
  vertex(-500, 0, -1000);
  vertex(-500, 0, 4500);
  endShape();
  
  beginShape();
  fill(#7a490e);
  vertex(-3500, 0, 2500);
  vertex(-8500, 0, 2500);
  vertex(-8500, 0, -1000);
  vertex(-3500, 0, -1000);
  endShape();
  
  beginShape();
  fill(#054154);
  vertex(500, 0, -6500);
  vertex(-8500, 0, -6500);
  vertex(-8500, 0, -14500);
  vertex(500, 0, -14500);
  endShape();
  
  beginShape();
  fill(#46473d);
  vertex(-8500, 0, -5500);
  vertex(-16000, 0, -5500);
  vertex(-16000, 0, -16000);
  vertex(-8500, 0, -16000);
  endShape();
  
  // Ceiling
  // Ceiling color 
  fill(#291d54);
  
  beginShape();
  vertex(500, -1000, 5500);
  vertex(-8500, -1000, 5500);
  vertex(-8500, -1000, -6500);
  vertex(500, -1000, -6500);
  endShape();
  
  beginShape();
  vertex(500, -3000, -6500);
  vertex(-8500, -3000, -6500);
  vertex(-8500, -3000, -14500);
  vertex(500, -3000, -14500);
  endShape();
  
  beginShape();
  vertex(-8500, -1000, -4500);
  vertex(-16000, -1000, -4500);
  vertex(-16000, -1000, -16000);
  vertex(-8500, -1000, -16000);
  endShape();
  
  for(Target target : targets) {
    target.Draw();
  }
  
  stroke(1);
  
  robotBoss.Draw();
  pipeHitBox.Draw();
}

boolean invasionPhase = false;
float spawnRate = 0.10;
float spawnTime = 0;
float victorySongTime = 0;
boolean victoryPhase = false;
boolean loopPhase = false;
float jumpObHeight = 0;

// Flags for music switching
boolean start = true;
boolean militaryPlay = false;
boolean bossPlay = false;
boolean bossStart = false;
boolean obsPlay = false;

// Flags for announcer
boolean targetQuote = false;
boolean botIntroQuote = false;
boolean botDeadQuote = false;

void Level1Scripts() {
  if(loopPhase) {
    return;
  }
  player.HurtAudioTimer();
  // Handling AUDIO
  if(start) {
    start =false;
    jukeBox.Play(startSong);
    welcome.trigger();
  }
  
  if(camera.position.x < -3500 && camera.position.z > -1000 && !militaryPlay ) {
    militaryPlay = true;
    jukeBox.Play(militarySong);
  }
  
  if(camera.position.x < -7000 && camera.position.z < -12500 && !invasionPhase && !robotBoss.alive) {
    invasionPhase = true;
    jukeBox.Play(invasionSong);
    minim.loadFile("audio/explosion.mp3", 1024).play();
    invasion.trigger();
  }
  
  if(!robotBoss.alive && !obsPlay) {
    obsPlay = true;
    jukeBox.Play(obsSong);
  }
  
  // Target 
  if(targets.get(0).targetComplete && targets.get(1).targetComplete && targets.get(2).targetComplete && camera.position.z > -6450) {
    doors.get(2).disabled = false;
    if(!targetQuote) {
      targetQuote = true;
      targetFinish.trigger();
    }
  }
  
  if(door3.doorOpen && camera.position.z < -6450) {
    door3.disabled = true;
    door3.doorSpeed = -275;
    door3.moveDoor = true;
    if(!botIntroQuote) {
      botIntroQuote = true;
      botIntro.trigger();
    }
  }
  
  if(!door3.doorOpen && camera.position.z < -6450 && !bossStart && !door3.moveDoor) {
    bossStart = true;
    jukeBox.Play(bossSong);
    obstacles.removeAll(section1);
  }
  
  if(!robotBoss.alive) {
    door4.disabled = false;
    if(!botDeadQuote) {
      botDeadQuote = true;
      botBeat.trigger();
    }
  }
  
  // Boss fight
  if(robotBoss.alive && bossStart) {
    robotBoss.UpdateAngle();
    robotBoss.UpdatePlan();
    robotBoss.UpdatePosition();
    robotBoss.SpawnTrap();
    robotBoss.DamagePlayer();
    robotBoss.InvicibleCheck();
    robotBoss.TeleportCheck();
  }
  
  if(jumpObHeight < obsticleMaxHeight && !robotBoss.alive) {
    for(Obstacle ob : jumpObs) {
      ob.pos.y -= obsticleMaxHeight * 1/frameRate/2;
      ob.ChangePosition();
    }
    jumpObHeight += obsticleMaxHeight * 1/frameRate/2;
  }
  
  for(BearTrap trap : robotBoss.traps) {
    trap.CheckCollision();
  }
  
  // Invasion phase
  if(invasionPhase && spawnTime > spawnRate && player.alive && !player.won) {
    for(int i=0; i<int(random(3, 5)); i++) {
      // upper door spawn
      if(camera.position.z > -13200) {
        SpawnBoidling(new PVector(-12000 + random(0, 100), -350 + random(0, 200), -14500));
      }
      
      // Only start spawning once player started to walk past door
      if(camera.position.z > -10800) {
        // lower door spawn
        SpawnBoidling(new PVector(-9900 - random(0, 100), -350 + random(0, 100), -11000 + random(0, 50)));
      }
    }
  }
  if(spawnTime > spawnRate) {
    spawnTime -= spawnRate;
  }
  spawnTime += spawnRate * 1/frameRate;
  
  if(camera.position.x < -10500 && camera.position.z > -5500 && !goalDoor.doorOpen) {
    player.won = true;
  }
  
  //Victory theme
  if(player.won) {    
    victorySongTime += 1/frameRate;
    boidlings.removeAll(boidlings);
  }
  if(player.won && !victoryPhase) {
    victoryPhase = true;
    victorySong.trigger(); 
    winner.trigger();
    jukeBox.Stop();
  }
  if(victorySongTime > 11 && !loopPhase) {
    loopPhase = true;
    jukeBox.Play(victoryLoopSong);
  }
}
