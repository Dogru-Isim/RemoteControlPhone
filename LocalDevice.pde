import netP5.*;
import oscP5.*;
import ketai.net.*;
import ketai.sensors.*;

PGraphics da;    // dragging area (moves mouse)
PGraphics ca;    // clicking area (clicks)

OscP5 oscP5;
KetaiSensor sensor;

NetAddress remoteLocation;

int PORT = 12000; // the communication port

int textSize = 36;  // background text size (local and remote ip addrs)

int daHeight;
int caHeight;
int caLocation;

int daBackground = 0;        // dragging area's color
int circleColor = 255;       // indicator circle's color
int caBackground = 255;      // clicking area's color
int clickedBackground = 230; // the ca color when it's touched

int circleSize = 100;        // the size of our circle

String myIPAddress;
String remoteAddress = "192.168.1.105"; // remote device

int x, y; // we will send these coordinates

void setup() {
  fullScreen();
  
  daHeight = height*6/7;   // the height of the clicking area
  caHeight = height/7;     // the height of the clicking area
  caLocation = height*6/7;  // starting point of ca

  // create the dragging and clicking areas
  da = createGraphics(width, daHeight); // dragging area
  ca = createGraphics(width, caHeight); // clicking area
  
  da.circle(da.width/2, da.height/2, circleSize); // create the mouse indicator
  
  sensor = new KetaiSensor(this);
  orientation(PORTRAIT);
  textAlign(CENTER, CENTER);
  textSize(textSize);
  initNetworkConnection();
  sensor.start();
}

void draw() {
  
  da.beginDraw();
  da.background(daBackground);           // dragging area will be dark
  da.fill(circleColor);                  // the circle will be white
  da.circle(mouseX, mouseY, circleSize); // the circle will follow our finger
  da.endDraw();

  ca.beginDraw();
  ca.background(caBackground); // clicking area will be white
  
  // change button color when pressed
  if (mouseY > da.height) {
    ca.background(clickedBackground);
    if (!mousePressed) {
      ca.background(caBackground);
    }
  ca.endDraw();
  }
  
  // show the dragging and the clicking area
  image(da, 0, 0);               // image(width, height);
  image(ca, 0, caLocation);
  
  // display a text which tells the remote and host devices' ip addrs
  text("Local IP Address: \n" + myIPAddress + "\n\n" +
       "Remote IP Address: \n" + remoteAddress, width/2, height/2);
  
  OscMessage myMessage = new OscMessage("accelerometerData");

  // if we are in the dragging area, then don't send clicking signal
  if (mouseY <= da.height) {
                    // a phone is vertical, a monitor is horizontal  
    x = mouseY;     // store x and you coordinates so the next
    y = mouseX;     // "else" statement won't be messed up
                        
                        // a phone is vertical but a computer isn't so
    myMessage.add(x);   // if we want to hold our phone horizontally, 
    myMessage.add(y);   // the x and y coordinates must change.
                        // This will be on the computer side
    myMessage.add(0);
  } else { // if we are in the clicking area, then send click signal
    
    // same thing as above
    if (mousePressed) {
    myMessage.add(x);
    myMessage.add(y);
    myMessage.add(1);
    } else if (!mousePressed) { 
      // stop clicking when we release our finger
        myMessage.add(x);
        myMessage.add(y);
        myMessage.add(0);  // send 0 so we stop clicking
                           // when we release our finger
      }
    }

  oscP5.send(myMessage, remoteLocation);
}

void initNetworkConnection() {
  oscP5 = new OscP5(this, PORT);
  remoteLocation = new NetAddress(remoteAddress, PORT);
  myIPAddress = KetaiNet.getIP();
}

// ** my values **
// da.width is 720
// da.height is 1281

// ca.width is 720
// ca.height is 183

// height variable is 1465
// width variable is 720
 
