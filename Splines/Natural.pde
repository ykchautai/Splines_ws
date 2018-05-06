public class Natural{
  //glxinfo
  float x[][];
  float y[][];
  float z[][];
  float nPoints;
  ArrayList<Vector> printPoints;
  ArrayList<Vector> controlPoints;
  
  Natural(float nPoints, ArrayList<Vector> controlPoints){
    this.nPoints = nPoints;
    printPoints = new ArrayList<Vector>();
    this.controlPoints = controlPoints;
    x = new float[controlPoints.size()][4];
    y = new float[controlPoints.size()][4];
    z = new float[controlPoints.size()][4];
    matrixExtraction();
    pointsGenerator();
    
  }
  
    void matrixExtraction(){
      int size = controlPoints.size();
      Matrix tridiagonal = matGenerator(size);
      double[][]bx = new double[size][1];
      double[][]by = new double[size][1];
      double[][]bz = new double[size][1];
      
      for(int i = 1; i<size-1; i++){
        Vector a = controlPoints.get(i-1);
        Vector b = controlPoints.get(i+1);
        bx[i][0] = 3*(b.x()-a.x());
        by[i][0] = 3*(b.y()-a.y()); 
        bz[i][0] = 3*(b.z()-a.z()); 
      }
    
      bx[0][0] = 3*(controlPoints.get(1).x()-controlPoints.get(0).x());
      bx[size-1][0] = 3*(controlPoints.get(size-1).x() - controlPoints.get(size-2).x());
      
      by[0][0] = 3*(controlPoints.get(1).y()-controlPoints.get(0).y());
      by[size-1][0] = 3*(controlPoints.get(size-1).y() - controlPoints.get(size-2).y());
      
      bz[0][0] = 3*(controlPoints.get(1).z()-controlPoints.get(0).z());
      bz[size-1][0] = 3*(controlPoints.get(size-1).z() - controlPoints.get(size-2).z());
      
      Matrix mbx = new Matrix(bx);
      Matrix mby = new Matrix(by);
      Matrix mbz = new Matrix(bz);
      
      Matrix mdx = tridiagonal.solve(mbx);
      Matrix mdy = tridiagonal.solve(mby);
      Matrix mdz = tridiagonal.solve(mbz);
      
      
      for(int i = 0; i<size-1; i++){
        x[i][0] = controlPoints.get(i).x();
        x[i][1] = (float)mdx.data[i][0];
        x[i][2] = (float)(3*(controlPoints.get(i+1).x() - controlPoints.get(i).x()) - 2*mdx.data[i][0] - mdx.data[i+1][0]);
        x[i][3] = (float)(2*(controlPoints.get(i).x() - controlPoints.get(i+1).x()) + mdx.data[i][0] + mdx.data[i+1][0]);
        
        y[i][0] = controlPoints.get(i).y();
        y[i][1] = (float)mdy.data[i][0];
        y[i][2] = (float)(3*(controlPoints.get(i+1).y() - controlPoints.get(i).y()) - 2*mdy.data[i][0] - mdy.data[i+1][0]);
        y[i][3] = (float)(2*(controlPoints.get(i).y() - controlPoints.get(i+1).y()) + mdy.data[i][0] + mdy.data[i+1][0]);
        
        z[i][0] = controlPoints.get(i).z();
        z[i][1] = (float)mdz.data[i][0];
        z[i][2] = (float)(3*(controlPoints.get(i+1).z() - controlPoints.get(i).z()) - 2*mdz.data[i][0] - mdz.data[i+1][0]);
        z[i][3] = (float)(2*(controlPoints.get(i).z() - controlPoints.get(i+1).z()) + mdz.data[i][0] + mdz.data[i+1][0]);
      }
  }
  
  
  
  Matrix matGenerator(int size){
    double[][] matrix = new double[size][size];
    for(int i = 0; i < size; i++){
      for(int j = 0; j < size; j++){
        matrix[i][j] = 0;
      }
      if(i == 0){
        matrix[i][i] = 2;
        matrix[i][i+1] = 1;
      }else if(i == size - 1){
        matrix[i][i] = 2;
        matrix[i][i-1] = 1;
      }else{
        matrix[i][i-1] = 1;
        matrix[i][i] = 4;
        matrix[i][i+1] = 1;
      }
    }
    
    /*System.out.println("--------------------------------------");
    for(int i = 0; i < size; i++){
      for(int j = 0; j<size; j++){
        System.out.print(matrix[i][j] + "  ");
      }
      System.out.print("\n");
    }*/
      
    return new Matrix(matrix);
  }
  
  private void pointsGenerator(){
    float a = 0.001;
    for(int i = 0; i < controlPoints.size()-1; i++){
      for(float t = 0; t <= 1.0; t += a){
        float px = formula(x[i][0],x[i][1],x[i][2],x[i][3], t); 
        float py = formula(y[i][0],y[i][1],y[i][2],y[i][3], t);
        float pz = formula(z[i][0],z[i][1],z[i][2],z[i][3], t);
        printPoints.add(new Vector(px,py,pz));
        
      }
    }
  }
  
  private float formula(float a, float b, float c, float d, float t){
    return a+(b*t)+(c*pow(t,2))+(d*pow(t,3));
  }

}
