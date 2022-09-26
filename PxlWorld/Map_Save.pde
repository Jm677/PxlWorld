void SaveWorld(String Name)
{
  SaveMap(Name);
  SaveMapdata(Name);
}
void SaveMap(String Name)
{
  String path = WorldPath+"\\"+Name;
  SaveIntMatrix(Elev, path+"\\Elevation");
  SaveIntMatrix(Type,path+"\\Type");
  SaveIntMatrix(SecType,path+"\\SecType");
  SaveIntMatrix(PlantID, path+"\\PlantID");
  SaveIntMatrix(PlantAge, path+"\\PlantAge");
  SaveIntMatrix(PlantHealth, path+"\\PlantHealth");
  
  SaveFloatMatrix(Temp, path+"\\Temperatur",2);
  SaveFloatMatrix(Hum, path+"\\Humidity",2);
  SaveFloatMatrix(GroundWater,path+"\\GroundWater",4);
  SavePlants(path+"//PlantData.txt");
  SaveLocalPlants(path+"\\Plants\\");
}
void SaveIntMatrix(int[][] Matrix, String Name)
{
  int xx=Matrix.length, yy=Matrix[0].length;
 String[] S=new String[yy+1];
  println("Saving Matrix: "+Name);
 S[0]=str(xx)+" ";
 S[0]+=str(yy);
  for (int i=1; i<=yy; i++)
  {
     S[i]=str(Matrix[0][i-1])+" ";
    // print(str(Matrixx[0][i-1])+" ");
    for (int a=1; a<xx; a++)
    {
      
     S[i]+=str(Matrix[a][i-1])+" ";
     // print(str(Matrix[a][i-1])+" ");
    }
    //S[i]+=" \n";
  // println();
    
  }
  saveStrings(Name+".txt", S);
}
void SaveFloatMatrix(float[][] Matrix, String Name, int Digits)
{
  int xx=Matrix.length, yy=Matrix[0].length;
 String[] S=new String[yy+1];
 println("Saving Matrix: "+Name);
 S[0]=str(xx)+" ";
 S[0]+=str(yy);
 float div=pow(10,Digits);
  for (int i=1; i<=yy; i++)
  {
     S[i]=str(round(Matrix[0][i-1]*div)/div)+" ";
    // print(str(Matrixx[0][i-1])+" ");
    for (int a=1; a<xx; a++)
    {
      
     S[i]+=str(round(Matrix[a][i-1]*div)/div)+" ";
     // print(str(Matrix[a][i-1])+" ");
    }
    //S[i]+=" \n";
  // println();
    
  }
  saveStrings(Name+".txt", S);
}
void SaveMapdata(String Name)
{
  String[] S=new String[1];
  S[0]="";
  for(int i=0; i<MapData.length;i++)
  {
    S[0]+=str(MapData[i])+" ";
  }
  saveStrings(WorldPath+"\\"+Name+"\\"+Name+".txt",S);
  println("Saved World: "+Name);
}
