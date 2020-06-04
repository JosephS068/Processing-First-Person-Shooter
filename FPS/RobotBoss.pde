import java.util.PriorityQueue;

class RobotBoss {
  // SHAPES
  PShape head;
  PShape body;
  PShape sword;
  PShape shield;
  PVector pos;
  float bossHeight = -500;
  float angleXZ;
  int pointNum = 180;
  float epsilon = 5;  
  int maxConnectionRadius = 1500;
  Point destination;
  int pathPos;
  Path globalPath; 
  ArrayList<Point> points = new ArrayList<Point>();
  ArrayList<Connection> connections = new ArrayList<Connection>();
  boolean alive;
  int life;
  Entity headHitBox;
  Entity legHitBox;
  ArrayList<BearTrap> traps = new ArrayList<BearTrap>();
  boolean invincible;
  
  RobotBoss(PVector pos) {
    this.pos = pos;
    head = loadShape("RobotBoss/Skull.obj");
    body = loadShape("RobotBoss/Armor_Black.obj");
    sword = loadShape("RobotBoss/Sword_big.obj");
    shield = loadShape("RobotBoss/Shield_Celtic_Golden.obj");
    angleXZ = 0;
    int i = 0;
    
    Point start = new Point(0, new PVector(pos.x, pos.y, pos.z), 0);
    Point goal = new Point(0, new PVector(camera.position.x, 0, camera.position.z), 0);
    
    while(points.size() <= pointNum){
      PVector pointPos = new PVector(random(-8500, 500), 0, random(-14500, -6500));
      Point move = new Point(i, pointPos, PVector.sub(goal.pos, pointPos).mag() * epsilon);
      GenerateConnections(move);
      points.add(move);
      i++;
    }
    GenerateConnections(start);
    points.add(start);
    
    GenerateConnections(goal);
    points.add(goal);
    pathPos = 0;
    alive = true;
    // Hitboxes
    headHitBox = new Entity(new PVector(pos.x, pos.y + bossHeight, pos.z), 80);
    legHitBox = new Entity(new PVector(pos.x, pos.y - 75, pos.z), 150);
    life = 18;
    invincible = false;
  }
  
  void CheckCollision(PVector bulletStart, PVector bulletEnd) {
    headHitBox.CheckCollision(bulletStart, bulletEnd);
    legHitBox.CheckCollision(bulletStart, bulletEnd);
    if(headHitBox.hit) {
      if(invincible) {
        blocked.trigger();
        return;
      }
      headHitBox.hit = false;
      life -= 3;
      robotHeadDamage.trigger();
    }
    
    if(legHitBox.hit) {
      if(invincible) {
        blocked.trigger();
        return;
      }
      headHitBox.hit = false;
      life -= 1;
      robotLegDamage.trigger();
    }
    
    if(life < 0) {
      alive = false;
      traps.removeAll(traps);
    }
  }
  
  float timeBetweenTeleports = 10;
  float timeSinceTeleport = 0;
  void TeleportCheck() {
    timeSinceTeleport += 1/frameRate;
    if(timeSinceTeleport > timeBetweenTeleports) {
      timeSinceTeleport = 0;
      int point = int(random(0, points.size()-2));
      PVector nextLocation  = points.get(point).pos;
      while(PVector.sub(nextLocation, camera.position).mag() < 800) {
        point = int(random(0, points.size()-2));
        nextLocation  = points.get(point).pos;
      }
      teleport.trigger();
      pos.x = nextLocation.x;
      pos.y = nextLocation.y;
      pos.z = nextLocation.z;
    }
  }
  
  float timeBetweenTraps = 0.5;
  float timeSinceTraps = 0;
  void SpawnTrap() {
    timeSinceTraps += 1/frameRate;

    if(timeSinceTraps > timeBetweenTraps) {
      timeSinceTraps = 0;
      trapDrop.trigger();
      traps.add(new BearTrap(new PVector(pos.x, pos.y, pos.z)));
    }
  }
  
  float timeBetweenShield = 3;
  float timeSinceShield = 0;
  void InvicibleCheck() {
     timeSinceShield += 1/frameRate;
     
     if(timeSinceShield > timeBetweenShield) {
       shieldUp.trigger();
       timeSinceShield = 0;
       invincible = !invincible;
     }
  }
  
  float swordChange = 0;
  void UpdatePosition() {
    if(destination == null) {
      return;
    }
    if(PVector.sub(pos, points.get(points.size()-1).pos).mag() < 300 && destination.id == points.size()-1){
      return;
    }
    
    if(PVector.sub(pos, destination.pos).mag() < 25) {
      pathPos++;
      Connection nextConnection = globalPath.connections.get(pathPos);
      if(nextConnection.firstPoint == destination) {
        destination = nextConnection.secondPoint;
      } else {
        destination = nextConnection.firstPoint;
      }
    }
    PVector playerForce = PVector.sub(destination.pos, pos).normalize().mult(30);
    pos.add(playerForce);
    headHitBox.pos.x = pos.x;
    headHitBox.pos.z = pos.z;
    legHitBox.pos.x = pos.x;
    legHitBox.pos.z = pos.z;
  }
  
  float toToExectue = 1;
  float executionTime = 0;
  void UpdatePlan() {
    if(executionTime > toToExectue) {
      executionTime = 0;
      GenerateNewPlan();
    } else {
      executionTime += 1/frameRate;
    }
  }
  
  void GenerateNewPlan() {
    Point goal = points.get(points.size() - 1);
    for(Connection connection : goal.connections) {
      if(connection.firstPoint == goal) {
        connection.secondPoint.connections.remove(connection);
      } else {
        connection.firstPoint.connections.remove(connection);
      }
      connections.remove(connection);
    }
    points.remove(goal);
    
    Point start = points.get(points.size() - 1);
    for(Connection connection : start.connections) {
      if(connection.firstPoint == start) {
        connection.secondPoint.connections.remove(connection);
      } else {
        connection.firstPoint.connections.remove(connection);
      }
      connections.remove(connection);
    }
    points.remove(start);
    
    start = new Point(points.size(), new PVector(pos.x, pos.y, pos.z), 0);
    GenerateConnections(start);
    points.add(start);
    
    goal = new Point(points.size(), new PVector(camera.position.x, 0, camera.position.z), 0);
    GenerateConnections(goal);
    points.add(goal);
    
    // Update A* heurisitc
    for(int i=0; i<points.size()-2; i++) {
      points.get(i).distanceToGoal = PVector.sub(goal.pos, points.get(i).pos).mag() * epsilon;
    }
    pathPos = 0;
    SearchGraph();
  }
  
  //GRAPH SEARCH
  void SearchGraph() {
    PriorityQueue<Path> paths = new PriorityQueue<Path>();
    Point start = points.get(points.size()-2);
    if(start.connections.size() == 0) {
      return;
    }
    if(points.get(points.size()-1).connections.size() == 0) {
      return;
    }
    
    // A STAR SEARCH
    paths = new PriorityQueue<Path>();
    
    for(Connection connection : start.connections) {
      Path newPath = new Path();
      newPath.currentPoint = start;
      newPath.addConnection(connection);
      paths.add(newPath);
    }
    
    globalPath = Search(paths);
    if(globalPath.connections.get(0).firstPoint == points.get(points.size() - 2)) {
      destination = globalPath.connections.get(0).secondPoint;
    } else {
      destination = globalPath.connections.get(0).firstPoint;
    }
    
    for(Connection connection : globalPath.connections) {
      connection.visited = true;
    }
  }
  
  Path Search(PriorityQueue<Path> paths) {
    while(true) {
      Path currentPath = paths.poll();
      if(currentPath.currentPoint.id == points.size()-1) {
        return currentPath;
      }
      for(Connection connection : currentPath.currentPoint.connections) {
        Path newPath = new Path(currentPath);
        newPath.addConnection(connection);
        paths.add(newPath);
      }
    }
  }
  
  float timeToDamage = 0.2;
  float damageTime = 0;
  void DamagePlayer() {
    if(PVector.sub(pos, camera.position).mag() < 600) {
      damageTime += 1/frameRate;
      if(damageTime > timeToDamage) {
        damageTime = 0;
        player.TakeDamage(2);
      }
    }
  }
  
  void UpdateAngle() {
    PVector result = PVector.sub(camera.position, pos);
    PVector xUnit = new PVector(1,0);
    PVector xzVector = new PVector(result.x, result.z);
    angleXZ = PVector.angleBetween(xUnit, xzVector);
    if(result.z < 0) {
      angleXZ = -angleXZ;
    }
    
    // sword position update
    if(alive) {
      swordChange += (1/frameRate) * 2 * PI;
      if(swordChange > (2 * PI)) {
        swordChange = 0;
      }
    }
  }
  
  void Draw() {
    lights();
    pushMatrix();
    translate(pos.x, pos.y + bossHeight, pos.z);
    rotateZ(PI);
    scale(200);
    rotateY(angleXZ - PI/2);
    if(!alive) {
      head.setFill(#f93725);
    }
    shape(head);
    popMatrix();
    
    pushMatrix();
    translate(pos.x, pos.y + bossHeight + 175, pos.z);
    rotateZ(PI);
    scale(250);
    rotateY(angleXZ - PI/2);
    shape(body);
    popMatrix();
    
    // "Legs"
    noStroke();
    pushMatrix();
    fill(#46473e);
    translate(pos.x, pos.y - 75, pos.z);
    sphere(150);
    popMatrix();
    
    // shields
    if(invincible) {
      float shieldAngle = 2*PI/4;
      for(int i=1; i<=5; i++) {
      pushMatrix();
      translate(pos.x, pos.y + bossHeight + 135, pos.z);
      rotateX(PI/2);
      rotateZ(shieldAngle * i);
      translate(0, 200, 0);
      rotateX(-PI/2);
      scale(200);
      shape(shield);
      popMatrix();
      }
    }
    
    float swordAngle = 2*PI/8;
    //println(swordChange);
    // Drawing Sword
    for(int i=1; i<=9; i++) {
      pushMatrix();
      translate(pos.x, pos.y + bossHeight + 135, pos.z);
      rotateX(PI/2);
      rotateZ(swordAngle * i + swordChange);
      translate(0, 100, 0);
      scale(175);
      shape(sword);
      popMatrix();
    }
    
    // Traps
    for(BearTrap trap : traps) {
      trap.Draw();
    }    
    
    stroke(1);
    noLights();
  }
  
  void GenerateConnections(Point currentPoint) {
    for(Point point : points) {
      if (currentPoint != point) {
        float distance = PVector.sub(currentPoint.pos, point.pos).mag();
        if(distance < maxConnectionRadius && !ConnectionExists(currentPoint, point)) {
          Connection newConnection = new Connection(currentPoint, point, distance);
          connections.add(newConnection);
          currentPoint.connections.add(newConnection);
          point.connections.add(newConnection);
        }
      }
    }
  }
  
  boolean ConnectionExists(Point currentPoint, Point point) {
    for(Connection connection : connections) {
      if (connection.firstPoint == point && connection.secondPoint == currentPoint){
        return true;
      }
    }
    return false;
  }
}
//
// CLASSES RELATED TO POITS AND CONNECTIONS
//
class Point {
  int id;
  PVector pos;
  float distanceToGoal;
  ArrayList<Connection> connections = new ArrayList<Connection>();
  
  Point (int id, PVector pos, float distanceToGoal) {
    this.id = id;
    this.pos = pos;
    this.distanceToGoal = distanceToGoal;
  } 
  
  void Draw() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    box(100);
    popMatrix();
  }
}

class Connection {
  Point firstPoint;
  Point secondPoint;
  ArrayList<PVector> alongLine = new ArrayList<PVector>();
  float distance;
  boolean visited;
  
  Connection (Point firstPoint, Point secondPoint, float distance) {
    this.firstPoint = firstPoint;
    this.secondPoint = secondPoint;
    this.distance = distance;
    this.visited = false;
  } 
}

class Path implements Comparable<Path>{
  ArrayList<Connection> connections = new ArrayList<Connection>();
  Point currentPoint;
  float totalCost = 0;
  float nextPointToGoal;
  Path(){}
  
  Path(Path path) {
    this.connections = new ArrayList<Connection>(path.connections);
    totalCost = path.totalCost;
    currentPoint = path.currentPoint;
  }
  
  void addConnection(Connection connection) {
    totalCost += connection.distance;
    connections.add(connection);
    if(connection.firstPoint == currentPoint) {
      currentPoint = connection.secondPoint;
      nextPointToGoal = connection.firstPoint.distanceToGoal;
    } else {
      currentPoint = connection.firstPoint;
      nextPointToGoal = connection.secondPoint.distanceToGoal;
    }
  }
  
  int compareTo(Path path) {
    if((totalCost+nextPointToGoal)==(path.totalCost+path.nextPointToGoal)){
      return 0;  
    } else if((totalCost+currentPoint.distanceToGoal) > (path.totalCost+path.currentPoint.distanceToGoal)){
      return 1;  
    } else {  
      return -1;  
    }
  }
}
