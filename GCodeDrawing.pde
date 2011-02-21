// A simple 3D 

class GCodeDrawing {
  //ArrayList points;
  ArrayList<PVector> points;

  // Just to make a simple gradiant for coloring
  float maxZ;
  
  GCodeDrawing() {
    points = new ArrayList<PVector>();
    
    maxZ = 0;
  }
  
  // We only understand one command, and it is a fully specified G1 command (x+y+z)
  void processCommand(String command) {
    GCode code = new GCode(command);

    if (code.hasCode('G')) {
      if (code.getCodeValue('G') == 1 && code.hasCode('X')) {
        addPoint(new PVector((int)code.getCodeValue('X'),
                             (int)code.getCodeValue('Y'),
                             (int)code.getCodeValue('Z')));
      }
    } 
  }
  
  
  void addPoint(PVector point) {
    if (point.z > maxZ)
      maxZ = point.z;
      
    points.add(point);
  }
  
  void draw() {
    stroke(255);
    strokeWeight(1);   // Thicker
    if (points.size() > 1) {
      for(int i = 0; i < points.size() - 1; i++) {
        PVector start = points.get(i);
        PVector end = points.get(i+1);
        
        stroke(0,0,128+128*(start.z/maxZ));
        line(start.x, start.y, start.z, end.x, end.y, end.z);
      }
    }
  
//    pushMatrix();
//    translate(0,0,20);
  //  fill(0,0,255);
  //  box(5);
//    popMatrix();    
  }
}
