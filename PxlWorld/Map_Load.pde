void LoadWorld(String Name)
{
  MapsZeroX=0;
  MapsZeroY=0;
  FirstTick=false;
  ResetWorldData();
  LoadMapData(Name);
  InitMap(false);
  LoadMap(Name);
  createMap(false);
  //LoadLocalPlantTypes(Name);
  background(200);
  println("Loaded World: "+Name);

}
void LoadMap(String Name)
{
  Plants=new ArrayList<Plant>();
  Plants1=new ArrayList<Plant>();
  println("Map: "+Name+" wird geladen");
  ResetWorldData();
  String path=WorldPath+"\\"+Name;
  Elev=LoadIntMatrix(path+"\\Elevation");
  Type=LoadIntMatrix(path+"\\Type");
  SecType=LoadIntMatrix(path+"\\SecType");
  PlantID=LoadIntMatrix(path+"\\PlantID");
  PlantAge=LoadIntMatrix(path+"\\PlantAge");
  PlantHealth=LoadIntMatrix(path+"\\PlantHealth");

  Temp=LoadFloatMatrix(path+"\\Temperatur");
  Hum=LoadFloatMatrix(path+"\\Humidity");
  GroundWater=LoadFloatMatrix(path+"\\GroundWater");
  LoadPlants();
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<int(MapData[MapHeightI]); a++)
    {
      TypeOld[i][a]=100;
      //if (PlantID[i][a]!=0)Plants.add(new Plant(PlantID[i][a], i, a));
    }
  }
  //updateMapProp();
}
void LoadMapData(String Name)
{
  println("LoadMapData: "+Name);
  String[] Lines=loadStrings(WorldPath+"\\"+Name+"\\"+Name+".txt");
  String[] words=Lines[0].split(" ");
  int a=0;
  for (int i=0; i<MapData.length; i++)
  {
    MapData[i]=float(words[i]);
  }
  println(MapData);
}
int[][] LoadIntMatrix(String Name)
{
  print("LoadMatrix: "+Name+" [");
  String[] Lines=loadStrings(Name+".txt"), word;

  int xx, yy;
  word=Lines[0].split(" ");
  xx=int(word[0]);
  yy=int(word[1]);
  // println(xx,yy);
  int[][] R=new int[xx][yy];
  for (int i =1; i <yy+1; i++)
  {
    //println(Lines[i]);
    if (i%yy/10==0)print(".");
    word=Lines[i].split(" ");
    for (int a = 0; a < xx; a++)
    {
      R[a][i-1]=int(word[a]);
      //println(R[a][i-1]);
    }
  }
  println("]");

  return R;
}
float[][] LoadFloatMatrix(String Name)
{
  print("LoadMatrix: "+Name+" [");
  String[] Lines=loadStrings(Name+".txt"), word;

  int xx, yy;
  word=Lines[0].split(" ");
  xx=int(word[0]);
  yy=int(word[1]);
  // println(xx,yy);
  float[][] R=new float[xx][yy];
  for (int i =1; i <yy+1; i++)
  {
    if (i%yy/10==0)print(".");
    //println(Lines[i]);
    word=Lines[i].split(" ");
    for (int a = 0; a < xx; a++)
    {
      R[a][i-1]=float(word[a]);
    }
  }
  println("]");
  return R;
}
