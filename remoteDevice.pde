import oscP5.*;
import netP5.*;
import java.awt.Robot;
import java.awt.event.*;

// importing
Robot rbt;
OscP5 oscP5;
NetAddress remoteLocation;

int x, y, clicked;  // x and y are coordinates, "clicked" is mouse-clicked information (0 or 1)

int start; 

void setup() {
  fullScreen();    // This has to be done in order to get the right height and width and the window will be closed instantly.
  background(0);   // Black seemed better for an instantly-closed window
  
  try {
    rbt = new Robot();      // A library that simulates mouse moves
  } catch(Exception e) {
    e.printStackTrace();
}

  oscP5 = new OscP5(this, 12000);
  remoteLocation = new NetAddress("192.168.1.101", 12000);  // Customize!
  surface.setVisible(false);  // close the window
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkTypetag("iii")) {   // look for three coming int values    
    x = theOscMessage.get(0).intValue();     // declare x, y and "clicked" vars as the coming int values
    y = theOscMessage.get(1).intValue();
    clicked = theOscMessage.get(2).intValue();
  }
}

// TODO: Make mouse wheel work
// TODO: Right click
// TODO: Change the click and movement method (Remove the feature of click from the button and use the button for changing left to right click or wheel etc.)


void draw() {  
  rbt.mouseMove(x*5/3, height-(y*5/3));    // move mouse by a ratio of 5/3
  
  if (boolean(clicked)) {
    clicked = 0;
    
    rbt.mousePress(InputEvent.BUTTON1_DOWN_MASK);
    
    delay(5); // a 'just in case' delay between "mouse press" and "mouse release"
    
    rbt.mouseRelease(InputEvent.BUTTON1_DOWN_MASK);
    delay(200);  // this will prevent accidental double clicks
  }
  // println("x:",x, "y:",y, "click:",clicked);
}
