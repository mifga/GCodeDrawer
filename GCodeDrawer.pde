import peasy.*;
import processing.opengl.*;
import controlP5.*;

PeasyCam cam;
ControlP5 controlP5;
PMatrix3D currCameraMatrix;
PGraphics3D g3;

RepGSocketServer server;
GCodeDrawing drawing;

void setup() {
  size(800,800,OPENGL);
  g3 = (PGraphics3D)g;
  smooth();
  frameRate(30);
  
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);

  controlP5 = new ControlP5(this);
  controlP5.addButton("Load_File",10,100,60,80,20);
//  controlP5.addButton("buttonValue",4,100,90,80,20);
  
  controlP5.setAutoDraw(false);

  drawing = new GCodeDrawing();

//  server = new RepGSocketServer(this, 2000);

  String fileName = selectInput();
  if (fileName != null) {
    loadFile(fileName);
  }
  
  // Just load a file since we can't get buttons to work, etc
//  loadFile("/home/matt/MakerBot/repg_workspace/ReplicatorG/dist/linux/replicatorg-${replicatorg.version}/examples/wfu_cbi_skull.gcode");
//  loadFile("C:\\Users\\matt.mets\\Downloads\\outhouse_110220m.gcode");
//  loadFile("C:\\Users\\matt.mets\\repos\\3d-Models\\keepon_headhat\\keepon_headhat.gcode");
}

void loadFile(String filename) {
  // Replace this with your file.
  BufferedReader reader = createReader(filename);
  
  if (reader == null) {
    return;
  }
  
  drawing = new GCodeDrawing();
  
  String line;
  try {
    while(true) {
//    for (String line : reader) {
      line = reader.readLine();
      
      if( line == null ) {
        break;
      }
      
      drawing.processCommand(line);
    }
  } catch (IOException e) {
  }
  
  drawing.finalize();
}

void processServerCommands() {
  String command = server.getLine();
    
  while (command != null) {
    println(command);
    drawing.processCommand(command);
    
    command = server.getLine();
  }
}

void draw() {
  
  // First, look for new commands.
//  processServerCommands();

  // Now do the drawing.
  background(0);
  drawing.draw();

  gui(); 
}

void gui() {
//   hint(DISABLE_DEPTH_TEST);
   currCameraMatrix = new PMatrix3D(g3.camera);
   camera();
   controlP5.draw();
   g3.camera = currCameraMatrix;
//   hint(ENABLE_DEPTH_TEST);
}

void controlEvent(ControlEvent theEvent) {
  println(theEvent.controller().id());
}

public void Load_File(int theValue) {
  println(theValue);
  String fileName = selectInput();
  if (fileName != null) {
    loadFile(fileName);
  }
}

