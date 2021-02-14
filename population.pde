class Population {
  float mutationRate;
  Ball[] population;
  int numberOfReady;
  ArrayList<Ball> matingPool;
  int generation;
  
  Population(int size) {
    // initialize population
    population = new Ball[size];
    for (int i = 0; i < size; i++) {
      population[i] = new Ball();
    }
    
    matingPool = new ArrayList<Ball>();
    numberOfReady = 0;
    mutationRate = 0.01;
    generation = 0;
  }
  
  Ball pickParent() {
    int randomPicker = (int) random(0, matingPool.size());
    return matingPool.get(randomPicker);
  }
  
  void run() {
    
    // physics phase for each ball
    for (int i = 0; i < population.length; i++) {
      Ball b = population[i];
      if (!b.hasTouched() && !b.isReadyForReprod) {
        b.process();
        b.draw();
      } else if (b.hasTouched() && !b.isReadyForReprod) {
        // pre-reproduction phase
        b.updateFitness(targetPos);
        numberOfReady++;
      }
    }
    
    drawTraj(getBestTraj());
    
    // waiting that each ball has completed physics phase
    if (numberOfReady == population.length) {
      
      // selection
      matingPool.clear();
      for (int i = 0; i < population.length; i++) {
        int n = int(population[i].fitness * 100.0);
        for (int j = 0; j < n; j++) {
          matingPool.add(population[i]);
        }
      }
      
      // reproduction
      for (int i = 0; i < population.length; i++) {
        Ball parentA = pickParent();
        Ball parentB = pickParent();
        
        population[i] = parentA.crossover(parentB);
        population[i].mutate(mutationRate);
        
        // child is ready to get his new body from genotype
        population[i].updatePhenotype();
      }
      numberOfReady = 0;
      generation++;
    }
  }
  
  void drawTraj(ArrayList<PVector> bestTraj) {
    push();
    noFill();
    stroke(255, 0, 0);
    beginShape();
    for (int i = 0; i < bestTraj.size(); i++) {
      vertex(bestTraj.get(i).x, bestTraj.get(i).y);
    }
    endShape();
    pop();
  }
  
  ArrayList<PVector> getBestTraj() {
    Ball best = new Ball();
    float bestFitness = 0;
    for (int i = 0; i < population.length; i++) {
      if (population[i].fitness > bestFitness) {
        best = population[i];
        bestFitness = population[i].fitness;
      }
    }
    return best.trajectory;
  }
}

public static ArrayList<PVector> cloneList(ArrayList<PVector> list) {
    ArrayList<PVector> clone = new ArrayList<PVector>(list.size());
    for (PVector item : list) clone.add(item.copy());
    return clone;
}
