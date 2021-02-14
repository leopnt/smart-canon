PVector targetPos;
Population p;

void setup() {
  size(800, 300);
  frameRate(120);
  
  targetPos = new PVector(0.8 * width, height);
  p = new Population(100);
}

void draw() {
  background(220);
  
  textSize(32);
  fill(0, 0, 0);
  text("Generation: ", p.generation, 10, 30); 
  
  // draw target
  push();
  fill(255, 0, 0);
  ellipse(targetPos.x, targetPos.y, 20, 20);
  pop();
  p.run();
}

void keyPressed() {
  // move target
  
  if (key == CODED) {
    if (keyCode == LEFT) {
      targetPos.x -= 10;
    } else if (keyCode == RIGHT) {
      targetPos.x += 10;
    } 
  }
}
