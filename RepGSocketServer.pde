import processing.net.*;

// Silly class that emulates a 3d printer that connects over a socket to ReplicatorG. This lets
// you pretend you are printing, even if you are far from a machine (or possibly helps you test
// the software, but we will stick with the notion that you really miss your printer)

// The only thing it can do at the moment is turn G1 commands into points. More useful than you
// might think!
class RepGSocketServer {

  Client ourClient;
  Server myServer;
  
  RepGSocketServer(PApplet applet, int port) {
    myServer = new Server(applet, port);  
  }

  // If there is a complete line of text available, return it!
  String getLine() {
    // If we don't yet have a client, search for one.
    if (ourClient == null) {
      ourClient = myServer.available();
    
      // If we were successful, send it "start" so that it is happy.
      if (ourClient != null) {
        println("Got a connection! Sending start.");
        ourClient.write("start\n");
      }
    }
    
    if (ourClient != null) {
      String newLine = ourClient.readStringUntil('\n');
    
      if (newLine != null) {
        ourClient.write("ok\n");
      }
  
      return newLine;
    }
    
    return null;
  }
}
