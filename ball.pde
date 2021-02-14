PVector gravity = new PVector(0, 0.098);

class Ball {
  float fitness;
  color bColor;
  
  // to indicate a population if this class data
  // is ready for calculations:
  boolean isReadyForReprod;
  
  int frameAge; // how old in frames this class is
  DNA dna;
  
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  ArrayList<PVector> trajectory;
  
  Ball() {
    dna = new DNA();
    
    trajectory = new ArrayList<PVector>();
    
    position = new PVector(0, height); // bottom left corner
    acceleration = new PVector();
    updatePhenotype();
    
    isReadyForReprod = false;
    frameAge = 0;
    
    bColor = color(random(0, 255), random(0, 255), random(0, 255), 170);
  }
  
  Ball(PVector initialPos, PVector initialVel) {
    position = initialPos;
    velocity = initialVel;
    acceleration = new PVector();
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  void process() {
    applyForce(gravity);
    
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
    
    frameAge++;
    
    trajectory.add(position.copy());
  }
  
  void draw() {
    push();
    noStroke();
    fill(bColor);
    ellipse(position.x, position.y, 4, 4);
    pop();
  }
  
  boolean hasTouched() {
    // return true if the ball has touched the ground
    
    if (position.y > height) {
      return true;
    }
    return false;
  }
  
  void updateFitness(PVector targetPos) {
    float dist = abs(targetPos.x - position.x);
    float dist_score = map(dist, 0, width, 1, 0);
    
    // oldest is experimentaly ~200 frames
    float time_score = map(frameAge, 0, 200, 1, 0);
    
    // give more importance to precision than to the age
    // by multiplying by 2
    fitness = map(pow(dist_score, 2) + time_score, 0, 5, 0, 1);
    
    isReadyForReprod = true;
  }
  
  Ball crossover(Ball parentB) {
    int separator = (int) random(0, dna.genes.length);
    
    Ball child = new Ball();
    for (int i = 0; i < dna.genes.length; i++) {
      // assign new genes from parentA or parentB according to separator
      child.dna.genes[i] = (i < separator)? dna.genes[i] : parentB.dna.genes[i];
    }
    
    return child;
  }
  
  void mutate(float mutationRate) {
    for (int i = 0; i < dna.genes.length; i++) {
      float r = random(0, 1);
      if (r < mutationRate) {
        dna.setRandom(i);
      }
    }
  }
  
  void updatePhenotype() {    
    // update phenotype from genotype
    
    velocity = new PVector(1, 0);
    velocity.rotate(-dna.genes[0]);
    velocity.mult(dna.genes[1]);
  
    trajectory.clear();
  }
}
