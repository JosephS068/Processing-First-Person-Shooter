import java.util.ArrayList;
import ddf.minim.*;

Minim minim;
// SFX
AudioSample gunShotAudio;
AudioSample reloadAudio;
AudioSample waspDeathAudio;
AudioPlayer footStepsAudio;
AudioSample doorOpenAudio;
AudioSample trapAudio;
AudioSample trapDrop;
AudioSample robotHeadDamage;
AudioSample robotLegDamage;
AudioSample blocked;
AudioSample teleport;
AudioSample shieldUp;
AudioSample targetHit;

// Music
AudioPlayer gameOverSong;
AudioSample victorySong;
AudioPlayer victoryLoopSong;
AudioPlayer startSong;
AudioPlayer militarySong;
AudioPlayer invasionSong;
AudioPlayer bossSong;
AudioPlayer obsSong;
JukeBox jukeBox;

// Announcer
AudioSample welcome;
AudioSample targetFinish;
AudioSample botIntro;
AudioSample botBeat;
AudioSample invasion;
AudioSample winner;

// Mouse related
import java.awt.Robot;
import java.awt.PointerInfo;
import java.awt.MouseInfo;
Robot rbt;
PointerInfo pointer;

// Textures
PImage elevatorFloor;

// Config
boolean debug = false;
boolean useMouse = false;

ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Boidling> boidlings = new ArrayList<Boidling>();
ArrayList<Target> targets = new ArrayList<Target>();
ArrayList<Door> doors = new ArrayList<Door>();

Pistol pistol;
Player player;

// MODELS
PShape wasp;
PShape target;
PShape trapOpen;
PShape trapClosed;
PShape pipe;

// constants that shouldn't be here
float gravity = 50;

void setup() {
  //fullScreen(P3D);
  size(1400, 1000, P3D);
  try {
    rbt = new Robot();
  } catch(Exception e) {
    e.printStackTrace();
  }
  minim = new Minim(this);
  player = new Player();
  camera = new Camera();
  pistol = new Pistol();
  LoadSound();
  LoadModels();
  LoadTextures();
  Level_1();
}

void LoadSound() {
  jukeBox = new JukeBox();
  gunShotAudio = minim.loadSample("audio/gun-shot.mp3", 1024);
  reloadAudio = minim.loadSample("audio/reload.mp3", 1024);
  gameOverSong = minim.loadFile("audio/music/Game Over.mp3", 1024);
  waspDeathAudio = minim.loadSample("audio/wasp-death-quiet.mp3", 1024);
  footStepsAudio = minim.loadFile("audio/foot-steps.mp3", 1024);
  doorOpenAudio = minim.loadSample("audio/door-open.mp3", 1024);
  robotHeadDamage = minim.loadSample("audio/head-damage.mp3", 1024);
  robotLegDamage = minim.loadSample("audio/leg-damage.mp3", 1024);
  trapAudio = minim.loadSample("audio/trap.mp3", 1024);
  trapDrop = minim.loadSample("audio/trap-drop.mp3", 1024);
  victorySong = minim.loadSample("audio/music/Victory.mp3", 1024);
  victoryLoopSong = minim.loadFile("audio/music/Victory Loop.mp3", 1024);
  blocked = minim.loadSample("audio/blocked.mp3", 1024);
  teleport = minim.loadSample("audio/teleport.mp3", 1024);
  shieldUp = minim.loadSample("audio/shield-up.mp3", 1024);
  targetHit = minim.loadSample("audio/target-hit.mp3", 1024);
  
  // music
  startSong = minim.loadFile("audio/music/Start.mp3", 1024);
  militarySong = minim.loadFile("audio/music/Military.mp3", 1024);
  invasionSong = minim.loadFile("audio/music/Invasion.mp3", 1024);
  bossSong = minim.loadFile("audio/music/Boss Fight.mp3", 1024);
  obsSong = minim.loadFile("audio/music/Obstacle.mp3", 1024);
  
  // announcer
  welcome = minim.loadSample("audio/announcer/Welcome2.mp3", 1024);
  targetFinish = minim.loadSample("audio/announcer/Target Clear1.mp3", 1024);
  botIntro = minim.loadSample("audio/announcer/Bot Intro1.mp3", 1024);
  botBeat = minim.loadSample("audio/announcer/Beat Bot1.mp3", 1024);
  invasion = minim.loadSample("audio/announcer/Breach1.mp3", 1024);
  winner = minim.loadSample("audio/announcer/Winner1.mp3", 1024);
}

void LoadModels() {
  wasp = loadShape("Wasp.obj");
  target = loadShape("Coin_Skull.obj");
  trapOpen = loadShape("RobotBoss/BearTrap_Open.obj");
  trapClosed = loadShape("RobotBoss/BearTrap_Closed.obj");
  pipe = loadShape("Pipe.obj");
}

void LoadTextures() {
  elevatorFloor = loadImage("textures/elevator-floor.jpeg");
}

void draw() {
  Level1Scripts();
  background(20, 100, 200);
  camera.Update(1/frameRate);
  Level1Draw();
  for(Obstacle obstacle : obstacles) {
    obstacle.Draw();
  }
  for(Door door : doors) {
    door.Move(1/frameRate);
  }
  for(Boidling boidling : boidlings) {
    if(boidling.alive) {
      boidling.UpdatePosition();
      boidling.Draw();
    }
    boidling.GenerateParticles(1/frameRate);
  }
  pistol.GenerateSmoke(1/frameRate);
  if(player.alive && !player.won) {
    // Weapon related 
    pistol.Display();
    pistol.ShootAnimation(1/frameRate);
    pistol.ReloadAnimation(1/frameRate);
    
    // Player Related
    player.DoorCheck();
    player.DisplayHUD();
  }
  else if(!player.alive) {
    player.DisplayDeath();
  } else {
    player.DisplayVictory();
  }
  if(useMouse) {
    noCursor();
    pointer = MouseInfo.getPointerInfo();
    mouseMoved();
    MouseX = (int)pointer.getLocation().getX();
    MouseY = (int)pointer.getLocation().getY();
    if(previousMouseX == 0 && previousMouseY == 0) {
      previousMouseX = (int)pointer.getLocation().getX();
      previousMouseY = (int)pointer.getLocation().getY();
    }
    rbt.mouseMove(previousMouseX, previousMouseY);
  }
}

void keyPressed(){
  if(player.alive && !player.won) {
    camera.HandleKeyPressed();
  } else {
    // Commands for when you are dead/won
    if ( key == 'r' ) {
      jukeBox.Stop();
      setup();
    }
  }
  // let people leave this nightmare
  if ( key == 'j' ) {
      exit();
  }
}

void keyReleased() {
  if(player.alive) {
    camera.HandleKeyReleased();
  }
}

void mouseClicked() {
  if(player.alive && !player.won) {
    pistol.Shoot();
  }
}

void mouseDragged() {
  mouseMoved();
}

int previousMouseX;
int previousMouseY;
int MouseX;
int MouseY;
void mouseMoved() {
  if(!useMouse) {
    return;
  }
  if(MouseX - previousMouseX > 0) {
    camera.negativeTurn.x = 0.90;
    camera.positiveTurn.x = 0; 
  } else if(MouseX - previousMouseX < 0) {
    camera.negativeTurn.x = 0;
    camera.positiveTurn.x = -0.90; 
  } else {
    camera.negativeTurn.x = 0;
    camera.positiveTurn.x = 0;
  }
  
  if(MouseY - previousMouseY > 0) {
     camera.positiveTurn.y = 0.65;
     camera.negativeTurn.y = 0;
  } else if(MouseY - previousMouseY < 0) {
    camera.positiveTurn.y = 0;
    camera.negativeTurn.y = -0.65;
  } else {
    camera.positiveTurn.y = 0;
    camera.negativeTurn.y = 0;
  }
}

// translate matrix to be in front of player camera
void pushFPSMatrix() {
  float phi = camera.phi;
  float theta = camera.theta;
  float playerHeight = player.pHeight;
  PVector pos = camera.position;
  PVector phiMovement = new PVector(0, sin(phi), cos(phi));
  phiMovement.mult(3);
  pushMatrix();
  translate(pos.x, pos.y + playerHeight, pos.z);
  rotateY(-theta);
  rotateZ(phi);
}
