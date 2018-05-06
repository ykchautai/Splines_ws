class Hermite{
  
  ArrayList<Vector> controlPoints;
  ArrayList<Vector> printPoints;
  float nPoints;
  
  public Hermite(float nPoints, ArrayList<Vector> controlPoints){
    printPoints = new ArrayList<Vector>();
    this.controlPoints = controlPoints;
    this.nPoints = nPoints;
    generateCurve();
  }
  
  private void generateCurve(){
     for(int i=0; i < 7; i++){
       for(float t = 0; t <= 1.0; t += 0.001){
         evaluation(controlPoints.get(i), controlPoints.get(i+1), controlPoints.get(i), controlPoints.get(i+1), t);
      }
     }   
  }
  
  private void evaluation(Vector P0, Vector P1, Vector M0, Vector M1, float t){
    M0 = function(1,t,M0);
    M1 = function(3,t,M1);
    P0 = function(0,t,P0);
    P1 = function(2,t,P1);
    
    printPoints.add( new Vector((P0.x()+P1.x()+M0.x()+M1.x()),(P0.y()+P1.y()+M0.y()+M1.y())) );
  }
  
  private Vector function(int cs, float t, Vector point){
     float h = 0;
     switch(cs){
       case 0:
        h = (1+(2*t))*pow((1-t),2);
       break;
       case 1:
        h = t*pow((1-t),2);
       break;
       case 2:
        h = pow(t,2)*(3-(2*t));
       break;
       case 3:
        h = pow(t,2)*(t-1);
       break;
     }
     return new Vector(point.x()*h, point.y()*h);
  }
  
  private Vector getPoint(Vector a, Vector b){
    float x = b.x() - a.x();  
    float y = b.y() - a.y();  
    return new Vector(x,y);  
  }
}
