class Bezier{
   
  float nPoints;
  int grade;
  ArrayList<Vector> controlPoints;
  ArrayList<Vector> printPoints;
  
  Bezier(float nPoints, int grade, ArrayList<Vector> controlPoints){
    this.grade = grade;
    this.nPoints = nPoints;
    printPoints = new ArrayList<Vector>();
    this.controlPoints = controlPoints;
    grade();
  }
  
  void grade(){
    //implementar dinamico
    ArrayList<ArrayList<Vector>> puntos = new ArrayList<ArrayList<Vector>>();
    if(grade == 3){
        ArrayList<Vector> a = new ArrayList<Vector>();
        for(int i = 0; i < 4; i++){
          a.add(controlPoints.get(i));
        }
        ArrayList<Vector> b = new ArrayList<Vector>();
        for(int i = 3; i < 8; i++){
          b.add(controlPoints.get(i));
        }

        puntos.add(a);
        puntos.add(b);
    }else if(grade == 7){
      ArrayList<Vector> pts = new ArrayList<Vector>();
      for(int i = 0; i < 8; i++){
        pts.add(controlPoints.get(i));
      }
      puntos.add(pts);
    }
     getPrintPoints(puntos);
  }
  
  private void getPrintPoints(ArrayList<ArrayList<Vector>> puntos){
    
    float a = 0.001;
      for(ArrayList p: puntos){
        for(float t = 0; t <= 1.0; t += a){
          curve(p,t);
      }
    }    
  }
  
  public ArrayList<Vector> curve(ArrayList<Vector> points, float t){
      ArrayList<Vector>rtPoints = new ArrayList<Vector>();

      for(int i=0; i<points.size()-1; i++){
        rtPoints.add(getPoint(points.get(i),points.get(i+1), t));
      }
      if(rtPoints.size() > 1)
        curve(rtPoints, t);
      else if(rtPoints.size() == 1){
        printPoints.add(rtPoints.get(0));
      }
      
      return rtPoints;      
  }
  
  private Vector getPoint(Vector a, Vector b, float t){
    float x = (1-t)*a.x() + t*b.x();  
    float y = (1-t)*a.y() + t*b.y();  
    float z = (1-t)*a.z() + t*b.z();  
    return new Vector(x,y,z);  
  }

}
