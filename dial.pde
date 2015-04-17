import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.signals.*;

import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import processing.dxf.*;

boolean record;


Minim minim;
AudioOutput out;

float x, y, z;
float speed;
float theta = 0;
float radius = 200;
float centerX, centerY;
int index = 1;
int num = 1024;

ArrayList pins;

Dial[] dials;
 
void setup() {
  
  size(600, 600,P3D);
  centerX = width/2;
  centerY = height/2;
  smooth();

  dials = new Dial[num];
  
  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
  
  for(int i=0; i<1024; i++){
     dials[i] = new Dial();
  }
  
  pins = new ArrayList();
  
  speed = .001;
    
}
 
void draw() {
  background(0);
  drawGrid(width/2, height/2);
 
  noFill();
  ellipse(width/2, height/2, 2*radius, 2*radius);
  ellipse(width/2, height/2, 210, 210);
  ellipse(width/2, height/2, 250, 250);
  
  
    if(mousePressed) {
    float fov = PI/3.0; 
    float cameraZ = (height/2.0) / tan(fov/2.0); 
    perspective(fov, float(width)/float(height), cameraZ/2.0, cameraZ*2.0); 
  } else {
    ortho(0, width, 0, height); 
  }
/*    for (int i=0; i<16; i++) {
    ellipses[i] = new Ellipse(radius+i);
    ellipses[i].display();
    ellipses[i].display();
  }
*/

//  rotateY(mouseX*10f/width*TWO_PI);
//  rotateX(mouseY*10f/height*TWO_PI);
//  rotateZ(mouseY*10f/height*TWO_PI);
  
  x = cos(theta)*radius+centerX;
  y = sin(theta)*radius+centerY;
  z = -key*10;
  noStroke();
  fill(255);
  ellipse(x, y, 20, 20);
 
  theta = theta + speed;
  text("music bracelet ", 20, 30);
  text("Angle in Radians = "+theta, 20, 50);
  text("Angle in Degrees = "+degrees(theta), 20, 70);
  text("Radius = "+radius, 20, 90);  
  
  for(int i=0; i<1024; i++){
    if(dials[i].okToShow ){
      //dials[i].display(); 
    }
    
   if (record) {
    beginRaw(DXF, "output.dxf");
  }

  // Do all your drawing here
  if (record) {
    endRaw();
    record = false;
  }
    
  }
  
  for(int i=0; i<pins.size(); i++){
   
   Dial dial = (Dial) pins.get(i); 
   dial.display();
    
  }
  

if (keyPressed) {
  
  
      Dial d = new Dial();
      d.curx =x;
      d.cury = y;
      d.curz = z;
      
      pins.add(d);
    
      

      dials[index].curx = x;
      dials[index].cury = y;
      dials[index].curz = z;
     // dials[index].curz = dials[index].curz- key*5;
      dials[index].okToShow = true;
       
     
      index++;
       
     SineWave mySine;
     MyNote newNote;
 
  float pitch = 0;
  switch(key) {
    case '1': pitch = 262; break;
    case '2': pitch = 277; break;
    case '3': pitch = 294; break;
    case '4': pitch = 311; break;
    case '5': pitch = 330; break;
    case '6': pitch = 349; break;
    case '7': pitch = 370; break;
    case '8': pitch = 392; break;
    case '9': pitch = 415; break;
    case '0': pitch = 440; break;
    case 'q': pitch = 466; break;
    case 'w': pitch = 494; break;
    case 'e': pitch = 523; break;
    case 'r': pitch = 554; break;
    case 't': pitch = 587; break;
    case 'y': pitch = 622; break;
    case 'u': pitch = 659; break;
  }
     
      if (pitch > 0) {
      newNote = new MyNote(pitch, 0.2);
   }
     
   

  if (key == 'd') {
       radius = radius + .1;
      }
  if (key == 'x') {
       radius = radius - .1;
    }
   
   
  if (key == 's') {
    record = true;
  }
  
    if(key == 'a') {
    setup();
  }

 /* 
      
     else{
       
      //     dials[index].move();
     //      dials[index].display();
       

      
     }*/
  }     
  
}
 
void drawGrid(float x, float y) {
  
  stroke(255);
  line(width/2, 0, width/2, width);
  line(0, height/2, height, height/2);
  
  for (int z = 0; z <= width; z +=10) {
    
    for (int q = 0; q <= 0; q +=10) {
      
      line(z, height/2+5, z, height/2-5);
    }
  }
  
  
  for (int q = 0; q <= height; q +=10) {
    
    for (int z = 0; z <= 0; z +=10) {
      
      line(width/2+5, q, width/2-5, q);
    }
  }
}

void stop()
{
  out.close();
  minim.stop();
  
  super.stop();
}
 
class MyNote implements AudioSignal
{
     private float freq;
     private float level;
     private float alph;
     private SineWave sine;
      
     MyNote(float pitch, float amplitude)
     {
         freq = pitch;
         level = amplitude;
         sine = new SineWave(freq, level, out.sampleRate());
         alph = 0.9;
         out.addSignal(this);
     }
 
     void updateLevel()
     {
         level = level * alph;
         sine.setAmp(level);
          
         if (level < 0.01) {
             out.removeSignal(this);
         }
     }
      
     void generate(float [] samp)
     {
         sine.generate(samp);
         updateLevel();
     }
      
    void generate(float [] sampL, float [] sampR)
    {
        sine.generate(sampL, sampR);
        updateLevel();
    }
 
}
