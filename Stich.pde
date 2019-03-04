class Stich{
  PVector vel;
  PVector location;
  PVector lastLoc;

  PVector nextLoc;
  PVector acc;
  float gravity = 100;
  float mass = 1.1;
  float k = 20;
  float fill = 255;
  ArrayList<Link>links = new ArrayList();

  float kv = 50;
  float forceY;
  float forceX;
  
  boolean pinned = false;
  PVector pinLocation = new PVector(0,0,0);
  
  Stich(PVector loc) { 
    location = new PVector(loc.x,loc.y,loc.z);
    lastLoc = new PVector(loc.x,loc.y,loc.z);
    acc = new PVector(0,0,0);
    vel = new PVector(0,0,0);
    nextLoc = new PVector(0,0,0);
  }
  
  void update(float dt){
    if(pinned){
      return;
    }

    PVector force = new PVector(0,mass*gravity,0);
    this.applyForce(force);

    vel.x = location.x - lastLoc.x;
    vel.z = location.z - lastLoc.z;
    vel.y = location.y - lastLoc.y + grav.y;
    acc.sub(PVector.mult(vel,k/mass));
    nextLoc.x = location.x + vel.x + .5 * acc.x * dt * dt;
    nextLoc.y = location.y + vel.y + .5 * acc.y * dt * dt;
    nextLoc.z = location.z + vel.z + .5 * acc.z * dt * dt;
    lastLoc.set(location);
    location.set(nextLoc);
    acc.set(0,0,0);

  }
 
  void removeLink (Link lnk) {
    links.remove(lnk);
  }  
  void applyForce(PVector force){
    PVector f = force;
    f.div(mass);
    acc.add(f);
  }
  void display() {
    //float px = 800 * (location.z / -location.z);
    //float py = 800 * (location.y / -location.z);
    //fill(255,0,0);
    //ellipse(px-3,py-3,6,6);
   // stroke(0,fill,0);

   // fill(255,0,0);
    if(links.size() > 0){
      for(int i = 0; i < links.size(); i++){        
        links.get(i).draw();        
      }
    }else{
      stroke(0,fill,0);
      strokeWeight(1);
      point(location.x,location.y,location.z);
    }
    
  }

  void attachTo (Stich P, float restingDist, float stiff) {
    Link lnk = new Link(this, P, restingDist, stiff, P.mass);
    links.add(lnk);
  }
  
  void solve(){
 
    for(int i = 0; i < links.size(); i++){
      links.get(i).calculatePull();
    }
    if(pinned){
      location.x = pinLocation.x;
      location.y = pinLocation.y;
      location.z = pinLocation.z;
    }
  }
  void checkEdges(){

    if(location.x > width || location.x < 0){
      vel.x *= -0.01;
    }
    if(location.y > floor - 1){
      location.y = 2 * (floor - 1) - location.y;
      vel.y *= -0.01;
    }
      
  }
  void pinTo (PVector location) {
    pinned = true;
    pinLocation.set(location);
  }
}
