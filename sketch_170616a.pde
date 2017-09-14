// number of particles displays
final static int N = 500; 
final static color[] cols = { 
  #FF8A85, #FFD700, #749D9D, #FCF5B3, #B39500, #272429
};
// collective particles
ArrayList<Particle> particles = new ArrayList<Particle>(N);
void setup() {
  size(800, 800);
  noFill();
  smooth(8);
  strokeWeight(1);
  background(0, 25, 0);
  // initialize particles
  for (int i=10; i<N; i++) {
    particles.add( new Particle(i) );
  }
}
// initialize time
float time = 10.0;

void draw() {
  for (Particle p : particles) {
 
    // vectors name and on screen direction
    float lovex = 0.0;
    float lovey = 0.0;
 
    for (Particle o : particles) {
      // do not compare with yourself
      if (p.id != o.id) {
        // calculate vector to get distance and direction
        PVector v = new PVector(o.x-p.x, o.y-p.y);
        float distance = v.mag();
        float angle = v.heading();
 
        // love speed 
        float love = 1.0 / distance*PI;
        // hate covering area
        if (distance<0.0) love = -love;
        // ambuigity of particles
        love *= p.moodSimilarity(o);
        love *= 2.5;
 
        lovex += love * cos(angle);
        lovey += love * sin(angle);
      } 
 
      p.dx = lovex/2 ;
      p.dy = lovey;
    }
  }
 
  // update and draw
  for (Particle p : particles) {
    p.update();
    p.draw();
  }
  time += 1.101;
}
 
class Particle {
  // position
  float x, y;
  // velocity
  float dx, dy;
  // id
  int id;
  // life length
  float age;
  // some random color
  color c = cols[(int)random(cols.length)];
  
  // mood factor
  float mood;
 
  void reset() {
    // distribute initial point on the ring, more near the outer edge, distorted
    float angle = random(TWO_PI);
    float r = 5.0*randomGaussian() + (width/2-100)*(1.0-pow(random(1.0), 7.0));
    x = cos(angle*PI)*r;
    y = sin(angle*PI)*r;
    // set random age
    age = (int)random(100, 2000);
    calcMood();
    
  }
 
  void draw() {
    stroke(c,50);
    point(x+width/2, y+height/2);
    stroke(c,100);
    point(x /2 +time , y /2+time);
    point(x /2 -time , y /2-time);
  }
 
  // update position with externally calculated speed
  // check also age
  void update() {
    if(--age < 200) {
      reset();
    } else {
      x += dx;
      y += dy;
      calcMood();
    }
  }
 
  Particle(int i) {
    id = i;
    reset();
  }
  
  // pulsing also view     return 10.0-abs(p.mood-this.mood);
  float moodSimilarity(Particle p) {
    return 1.0-abs(p.mood-this.mood);
  }
  
  // calculate current mood
  private void calcMood() {
    mood = sin (noise(x/2.0,y/10.0,time)*TWO_PI); 
  }
 }
