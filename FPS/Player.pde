enum State
{
    LAND, AIR
};

class Player {
  int health;
  float pHeight = -450;
  boolean alive;
  int quoteIdx;
  boolean won;
  PImage crossHair, healthIcon, ammoIcon;
  Door nearByDoor;
  AudioPlayer death;
  AudioSample[] hurt;
  
  Player() {
    health = 100;
    alive = true;
    won = false;
    quoteIdx = int(random(quotes.length));
    
    crossHair = loadImage("images/crosshair.png");
    healthIcon = loadImage("images/health.png");
    ammoIcon = loadImage("images/ammo.png");
    crossHair.resize(45, 45);
    healthIcon.resize(30, 30);
    ammoIcon.resize(30, 30);
    LoadAudio();
  }
  
  void LoadAudio() {
    death = minim.loadFile("audio/death.mp3", 1024);
    hurt = new AudioSample[]{
      minim.loadSample("audio/hurt-1.mp3", 1024),
      minim.loadSample("audio/hurt-2.mp3", 1024),
      minim.loadSample("audio/hurt-3.mp3", 1024)
    };
  }
  
  void TakeFallDamage(float speed) {
    speed = abs(speed);
    if(speed > 60) {
      TakeDamage(25);
    }
  }
  
  float timeToHurt = 1.5;
  float timeSinceHurt = 0;
  boolean playHurt = true;
  void HurtAudioTimer() {
    timeSinceHurt += 1/frameRate;
    if(timeSinceHurt > timeToHurt) {
      timeSinceHurt = 0;
      playHurt = true;
    }
  }
  
  void TakeDamage(int damage) {
    if(!alive) {
      return;
    }
    health -= damage;
    if(health <= 0) {
      death.play();
      health = 0;
      alive = false;
      pHeight = -25;
      jukeBox.Play(gameOverSong);
      camera.StopMovement();
    } else {
      AudioSample noise = hurt[int(random(0,3))];
      if(playHurt) {
        noise.trigger();
        playHurt = false;
      }
    }
  }
  
  void DoorCheck() {
    for(Door door : doors) {
      if(door.NearBy(camera.position)) {
        nearByDoor = door;
        return;
      }
    }
    nearByDoor = null;
  }
  
  void DisplayHUD() {
    pushFPSMatrix();
    translate(20, 0 ,0);
    rotateY(-PI/2);
    scale(.02);
    textSize(60);
    
    // Health text
    if (health > 75) {
      fill(#2cf93e);
    } else if(health > 40) {
      fill(#e0ed36);
    } else {
      fill(#f71313);
    }
    image(healthIcon, -550 - healthIcon.width, 350 - healthIcon.height);
    text(String.valueOf(health), -550, 350);
    
    // Ammo text
    fill(#7c7171);
    image(ammoIcon, 475 - ammoIcon.width, 350 - ammoIcon.height);
    text(String.valueOf(pistol.bullets), 475, 350);
    
    // cross hair
    image(crossHair, -crossHair.width/2, -crossHair.height/2);
    
    // door prompt
    if(nearByDoor != null) {
      textSize(20);
      fill(#e1f450);
      text("Press E to open/close door", -100, 300);
    }
    
    popMatrix();
  }
  
  // Info to display when player dies
  void DisplayDeath(){
    pushFPSMatrix();
    translate(20, 0 ,0);
    rotateY(-PI/2);
    scale(.02);
    textSize(40);
    // Hyper realistic red screen
    fill(#dd1a08, 150);
    square(-1000,-1000, 3000);
    // Stupid Quote
    fill(#ffffff);
    text(String.valueOf(quotes[quoteIdx]), -550, 0);
    text("Press J to quit application", -550, 100);
    popMatrix();
  } 
  
    // Info to display when player dies
  void DisplayVictory(){
    pushFPSMatrix();
    translate(20, 0 ,0);
    rotateY(-PI/2);
    scale(.02);
    textSize(40);
    fill(#24cfe5, 150);
    square(-1000,-1000, 3000);
    // Stupid Quote
    fill(#ffffff);
    text("You did it, you won!", -550, 0);
    text("Press J to quit application", -550, 100);
    popMatrix();
  } 
}

String[] quotes = {"\"Disgrace them in front of they squad\" - Rock Lee",
                 "\"Calcalcutta\" - Dr.Bombay",
                 "\"If the floor is wet, it is fresh\" - Slick",
                 "\"Piddle paddle bring me a large candle\" - Big Rich",
                 "\"Hey hey guys its me Donzi\" - Donzi",
                 "\"Fourth Style\" - Michael A La Mode"};
