/**
 * Splines.
 *
 * Here we use the interpolator.keyFrames() nodes
 * as control points to render different splines.
 *
 * Press ' ' to change the spline mode.
 * Press 'g' to toggle grid drawing.
 * Press 'c' to toggle the interpolator path drawing.
 */

import frames.input.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

// global variables
// modes: 0 natural cubic spline; 1 Hermite;
// 2 (degree 7) Bezier; 3 Cubic Bezier
int mode;

Scene scene;
Interpolator interpolator;
OrbitNode eye;
boolean drawGrid = true, drawCtrl = true;

//Choose P3D for a 3D scene, or P2D or JAVA2D for a 2D scene
String renderer = P3D;

void setup() {
  size(800, 800, renderer);
  scene = new Scene(this);
  eye = new OrbitNode(scene);
  eye.setDamping(0);
  scene.setEye(eye);
  scene.setFieldOfView(PI / 3);
  //interactivity defaults to the eye
  scene.setDefaultGrabber(eye);
  scene.setRadius(150);
  scene.fitBallInterpolation();
  interpolator = new Interpolator(scene, new Frame());
  // framesjs next version, simply go:
  //interpolator = new Interpolator(scene);

  // Using OrbitNodes makes path editable
  for (int i = 0; i < 8; i++) {
    Node ctrlPoint = new OrbitNode(scene);
    ctrlPoint.randomize();
    interpolator.addKeyFrame(ctrlPoint);
  }
}

void draw() {
  background(175);
  if (drawGrid) {
    stroke(255, 255, 0);
    scene.drawGrid(200, 50);
  }
  if (drawCtrl) {
    fill(255, 0, 0);
    stroke(255, 0, 255);
    for (Frame frame : interpolator.keyFrames())
      scene.drawPickingTarget((Node)frame);
  } else {
    fill(255, 0, 0);
    stroke(255, 0, 255);
    scene.drawPath(interpolator);
  }
 
  // implement me
  // draw curve according to control polygon an mode
  // To retrieve the positions of the control points do:
  // for(Frame frame : interpolator.keyFrames())
  //   frame.position();
  ArrayList<Vector> nPoints = new ArrayList<Vector>();
  for(Frame frame : interpolator.keyFrames()) {
    nPoints.add(frame.position());
  }
  
  //cdraw(nPoints);

  switch(mode){
  case 0:
    Natural natural = new Natural(8, nPoints);
    cdraw(natural.printPoints);
  break;
  case 1:
    Hermite hermite = new Hermite(8, nPoints);
    cdraw(hermite.printPoints);
  break;
  case 2:
    Bezier bezierThree = new Bezier(8, 3, nPoints);
    cdraw(bezierThree.printPoints);
  break;
  case 3:
    Bezier bezierSeven = new Bezier(8, 7, nPoints);
    cdraw(bezierSeven.printPoints);
  break;
  }
}

void keyPressed() {
  if (key == ' ')
    mode = mode < 3 ? mode+1 : 0;
  if (key == 'g')
    drawGrid = !drawGrid;
  if (key == 'c')
    drawCtrl = !drawCtrl;
}

void cdraw(ArrayList<Vector> points){
  strokeWeight(1);
  stroke(50,100,150);
  for(int i = 0; i < points.size()-1; i ++){
      Vector Pi = points.get(i);
      Vector Pj = points.get(i+1);
      line(Pi.x(),Pi.y(),Pi.z(),Pj.x(), Pj.y(),Pj.z());
  }
}
