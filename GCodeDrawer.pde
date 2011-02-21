import peasy.*;
import processing.opengl.*;
//import controlP5.*;

// ControlP5 controlP5;
// ControlWindow controlWindow;

PeasyCam cam;

RepGSocketServer server;
GCodeDrawing drawing;


void setup() {
  size(800,800,OPENGL);
  smooth();
  frameRate(30);
  
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);

  drawing = new GCodeDrawing();

//  server = new RepGSocketServer(this, 2000);

  // Just load a file since we can't get buttons to work, etc
//  loadFile("/home/matt/MakerBot/repg_workspace/ReplicatorG/dist/linux/replicatorg-${replicatorg.version}/examples/wfu_cbi_skull.gcode");
  loadFile("C:\\Users\\matt.mets\\Downloads\\windii.gcode");
//  loadFile("C:\\Users\\matt.mets\\repos\\3d-Models\\keepon_headhat\\keepon_headhat.gcode");
  
  println("done!");
}

void loadFile(String filename) {
  // Replace this with your file.
  BufferedReader reader = createReader(filename);
  String line;
  
  try {
    while(true) {
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
  lights();
  background(0);
  drawing.draw();
}

