// A simple 3D model made out of lines

// Borrowing code from here: http://wiki.processing.org/w/1,000,000_points_in_OpenGL_using_Vertex_Arrays

import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import com.sun.opengl.util.*;
import processing.opengl.*;
import java.nio.*;



class GCodeDrawing {
  
  FloatBuffer vBuffer;
  FloatBuffer cBuffer;

  // pan, zoom and rotate
  float tx = 0, ty = 0;
  float sc = 1;
  float a = 0.0;

  // Maximum lines we can handle
  int MAXLINES = 1000000;
  int lineCount;

  color offColor = color(20,100,20);
  color onColor = color(20,20,240);
  
  color currentColor = offColor;
  PVector lastPoint = new PVector(0,0,0);
  
  // true if our model is loaded
  boolean finalized;
  
  GCodeDrawing() {
    lineCount = 0;
    finished = false;
    
    vBuffer = BufferUtil.newFloatBuffer(MAXLINES * 3);
    cBuffer = BufferUtil.newFloatBuffer(MAXLINES * 3);
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
    else if (code.hasCode('M')) {
      if (code.getCodeValue('M') == 101) {
          currentColor = onColor;
          addPoint(lastPoint);
      }
      else if (code.getCodeValue('M') == 103) {
          currentColor = offColor;
          addPoint(lastPoint);
      }
    }
  }
  
  
  void addPoint(PVector point) {
    // Add the point
    vBuffer.put(point.x);
    vBuffer.put(point.y);
    vBuffer.put(point.z);
    
    lastPoint = point;

    // Random color???
    cBuffer.put(red(currentColor)/255);
    cBuffer.put(green(currentColor)/255);
    cBuffer.put(blue(currentColor)/255);

    lineCount++;
    println(lineCount);
  }
  
  
  void finalize() {
    vBuffer.rewind();
    cBuffer.rewind();
    
    PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  // g may change
    GL gl = pgl.beginGL();  // always use the GL object returned by beginGL
    
    gl.glEnableClientState(GL.GL_VERTEX_ARRAY);
    gl.glVertexPointer(3, GL.GL_FLOAT, 0, vBuffer);
 
    gl.glEnableClientState(GL.GL_COLOR_ARRAY);
    gl.glColorPointer(3, GL.GL_FLOAT, 0, cBuffer);
    
    pgl.endGL();
    
    finalized = true;
  }
  
  void draw() { 
    if (finalized) {   
      PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  // g may change
      GL gl = pgl.beginGL();  // always use the GL object returned by beginGL
 
      gl.glPushMatrix();
      gl.glTranslatef(width/2, height/2, 0);
      gl.glScalef(sc,sc,sc);
      gl.glRotatef(a, 0.0, 0.0, 1.0);
      gl.glTranslatef(-width/2, -height/2, 0);
      gl.glTranslatef(tx,ty, 0);
 
      gl.glPointSize(2.0);
 
      gl.glDrawArrays(GL.GL_LINE_STRIP, 0, lineCount);
 
      gl.glPopMatrix();
 
      pgl.endGL();
    }
  }
}
