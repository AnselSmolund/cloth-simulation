import peasy.*;

PeasyCam cam;
ArrayList<Thread> threads;
ArrayList<Stich> particles;

Ball ball;

PVector grav = new PVector(0,.01,0);
int yStart = -400;
Floor f;
int floor = 200;
float mass = 10;
float restLen = 5;
int rows = 70;
int cols = 70;
float k = 1.5; // stretchiness of the cloth
float rx = 0, ry = 0, rz = 0, scale = 1;
PImage img;

float windAngle;
float dt = 0.05;
void setup() {
  size(800, 800, P3D);
  lights();
  img = loadImage("cloth.jpg");
  ball = new Ball(new PVector(0,-800,0));
  

  threads = new ArrayList<Thread>();
  particles = new ArrayList<Stich>();
  cam = new PeasyCam(this, 0,-200,0, 800);
  cam.setMinimumDistance(300);
  cam.setMaximumDistance(800);
  cam.setSuppressRollRotationMode(); 
  f = new Floor();
  int midWidth = -200;
  windAngle = 0;
  for(int i = 0; i <= rows; i++){
    for(int j = 0; j <= cols; j++){
      Stich b = new Stich(new PVector((midWidth + j * restLen),(i * restLen + yStart),0));    
      if(j!=0){
        b.attachTo(particles.get(particles.size()-1), restLen,k);
      }
      if(i!=0){
        b.attachTo(particles.get((i-1) * (cols + 1) + j),restLen,k);
      }      
      if(i == 0 && j == 0){
        b.location.z = 300;
        b.pinTo(b.location);
      }
      if(i == rows && j == 0){
        b.pinTo(new PVector(b.location.x,yStart,-300));
      }
      if(i == 0 && j == cols){
        b.location.z = 300;
        b.pinTo(b.location);
      }
      if(i == rows && j == cols){
        b.pinTo(new PVector(b.location.x,yStart,-300));
      }
      particles.add(b);           
    }
  }
}


void draw() {
  windAngle += 0.01;
  background(255);

  f.display();

  ball.display();
  ball.update(dt);
  
  for(int i = 0; i < 50; i++){
    ball.checkEdges();
  }

  for(int i = 0; i < 15; i++){
    for(int j = 0; j < particles.size(); j++){

      particles.get(j).solve();
      particles.get(j).checkEdges();
    }
  }
  if(keyPressed){
    if(key == 'd'){
      for(int i = 0; i < particles.size(); i++){
        particles.get(i).pinned = false;
      }
    }
    if(key == 'r'){
      setup();
    }
  }
  for(int i = 0; i < particles.size(); i++){
    Stich b = particles.get(i);
    if(keyPressed && keyCode == SHIFT){
      b.applyForce(new PVector(0,100,0));
    }

    b.applyForce(new PVector(0,0, 0));
    b.update(dt);
  }

      
  for(int i = 0; i < particles.size(); i++){
   // text(i,particles.get(i).location.x,particles.get(i).location.y,particles.get(i).location.z);
    if(i%2 == 0){
      strokeWeight(1);
      stroke(148,0,211);
    }else{
      stroke(255,223,0);
    }
    particles.get(i).display();
  }  

  
}




    

class Floor{
  void display(){
    beginShape(QUADS);
    stroke(0);
    fill(0);

    vertex(-400,floor,-400);
    vertex(-400,floor,400);
    vertex(400,floor,400);
    vertex(400,floor,-400);

    endShape();
  }
}

class Link {
  float restingLen;
  float k; 
  float tug1;
  float tug2;
  float mass;
  Stich b1;
  Stich b2;

  Link (Stich b1_, Stich b2_, float restingDist, float stiff, float mass_) {
    b1 = b1_;
    b2 = b2_;  
    restLen = restingDist;
    k = stiff;
    mass = mass_;
    tug1 = (1/mass * 1/(mass*2)) * k;
    tug2 = (1/mass * 1/(mass*2)) * k;
  }
  
  void calculatePull () {
    float dx = b2.location.x - b1.location.x;
    float dy = b2.location.y - b1.location.y;
    float dz = b2.location.z - b1.location.z;  
    PVector delta = new PVector(dx*-1,dy*-1,dz*-1);
    float d = sqrt(dx*dx + dy*dy + dz * dz);
    float difference = (restLen- d) / d;
    b1.location.add(PVector.mult(delta, tug1 * difference));
    b2.location.sub(PVector.mult(delta, tug2 * difference));
  }

  void draw () {
    line(b1.location.x, b1.location.y, b1.location.z, b2.location.x, b2.location.y,b2.location.z);
  }

}
