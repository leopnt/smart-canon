class DNA {
  // we could give genes a random Vector here
  // but my point was to train by separating
  // genes data from the actual phenotype
  float[] genes;
  
  DNA() {
    genes = new float[2];
    genes[0] = random(0, PI/2); // fire angle
    genes[1] = random(0, 10); // initial velocity magnitude
  }
  
  void setRandom(int i) {
    switch(i) {
      case 0:
        genes[0] = random(0, PI/2);
        break;
      case 1:
        genes[1] = random(0, 10);
        break;
    }
  }
}
