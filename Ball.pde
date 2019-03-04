class Ball{
  PVector vel;
  PVector loc;
  PVector acc;
  int count = 0;
  float mass;
  float radius;
  Ball(PVector location){
    loc = new PVector(location.x,location.y,location.z);
    vel = new PVector(0,0,0);
    acc = new PVector(0,0,0);
    mass = 100;

  }

  void update(float dt){
    if(!mousePressed){
      loc.y = mouseY - height/2;
      loc.x = mouseX - width/2;
    }
    vel.add(acc);
    loc.add(vel);
    acc.mult(0);
  }
  void applyForce(PVector force){
    PVector f = PVector.div(force,mass);
    acc.add(f);
  }  
  void checkEdges(){
    for(int i = 0; i < particles.size(); i++){
        Stich s = particles.get(i);
        PVector tmp = new PVector();
        tmp.x = s.location.x;
        tmp.y = s.location.y;
        tmp.z = s.location.z;

        tmp.x -= loc.x;
        tmp.y -= loc.y;
        tmp.z -= loc.z;
      
        float dist = sqrt(tmp.x * tmp.x + tmp.y * tmp.y + tmp.z * tmp.z);      
        if(dist <= mass + 5){
          //count++;
          //if(count > 100){
          //  for(int j = 0; j < s.links.size(); j++){
          //    s.removeLink(s.links.get(j));
          //  }
          //}
          float diff = mass - dist;
          tmp.normalize();

          s.location.add(tmp);
        }
        
        //if(ballX == netX && ballY == netY){
        //    vel.y=-1;             
        //    s.applyForce(new PVector(0,500,0));
        //}   
    } 
  } 


  void display(){
    noStroke();
    lights();
    //fill(127);
    translate(loc.x,loc.y,loc.z);
    fill(255,0,127);
    sphere(mass);
    translate(-loc.x,-loc.y,-loc.z);
  }
}
