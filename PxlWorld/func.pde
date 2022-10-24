boolean CheckType(int i, int a, int type, int Range)
{
  for (int X=-Range; X<=Range; X++)
  {
    for (int Y=-Range; Y<=Range; Y++)
    {
      if ((X+i>=0)&&(X+i<MapData[MapWidthI])&&(Y+a)>=0&&(Y+a)<int(MapData[MapHeightI])&&(i!=0||a!=0)&&Type[i+X][a+Y]==type)return true;
    }
  }
  return false;
}
boolean CheckLand(int i, int a, int Range)
{
  for (int X=-Range; X<=Range; X++)
  {
    for (int Y=-Range; Y<=Range; Y++)
    {
      if ((X+i>=0)&&(X+i<MapData[MapWidthI])&&(Y+a)>=0&&(Y+a)<int(MapData[MapHeightI])&&(i!=0||a!=0)&&Type[i+X][a+Y]!=6)return true;
    }
  }
  return false;
}
int Distance(int x1, int y1, int x2, int y2)
{
  return int(sqrt(pow(x2-x1, 2)+pow(y2-y1, 2)));
}

int CoordX(int xx)
{
  return int(float(xx-MapsZeroX)/Maps.width*int(MapData[MapWidthI]));
}
int CoordY(int yy)
{
  return int(float(yy-MapsZeroY)/Maps.height*int(MapData[MapHeightI]));
}
float[][] IntToFloat(int[][]i)
{
  float[][]f =new float[i.length][i[0].length];
  //println(i[0].length);
  for (int a=0; a<f.length; a++)
  {
    for (int b=0; b<f[0].length; b++)
    {
      f[a][b]=i[a][b];
    }
  }
  return f;
}
int[][] FloatToInt(float[][]i)
{
  int[][]f =new int[i.length][i[0].length];
  for (int a=0; a<f.length; a++)
  {
    for (int b=0; b<f[0].length; b++)
    {
      f[a][b]=round(i[a][b]);
    }
  }
  return f;
}
boolean CheckArea(int xx, int yy, int xx1, int yy1, int xx2, int yy2)
{
  if (xx>=xx1&&xx<=xx2&&yy>=yy1&&yy<=yy2) return true;
  else return false;
}
int CountType(int type)
{
  int C=0;
  for (int i=0; i<int(MapData[MapWidthI]); i++)
  {
    for (int a=0; a<int(MapData[MapHeightI]); a++)

    {
      // println(Type[i][a]);
      if (Type[i][a]==type)
      {

        C++;
      }
    }
  }

  return C;
}
void CountTypes(boolean print)
{
  for (int b=0; b<CountTypes.length; b++)CountTypes[b]=0;
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<int(MapData[MapHeightI]); a++)
    {

      CountTypes[Type[i][a]]++;
    }
  }
  if (print)println(CountTypes);
}
float CountData(float[][] data)
{
  float D=0;
  int xx=data.length, yy=data[0].length;
  for (int i=0; i<xx; i++)
  {
    for (int a=0; a<yy; a++)
    {
      D+=data[i][a];
    }
  }
  return D;
}
float MatrixExtremePoint(float[][] data, String MINMAX)
{
  float D=0;
  int xx=data.length, yy=data[0].length;
  boolean Max=false;
  if(MINMAX.equals("MAX"))Max=true;
  else Max=false;
  for (int i=0; i<xx; i++)
  {
    for (int a=0; a<yy; a++)
    {
      if(Max&&data[i][a]>D)D=data[i][a];
      else if(!Max&&data[i][a]<D)D=data[i][a];
    }
  }
  return D;
}
float CalcAverage(float[][] data, int Interval)
{
  float D=0;
  int xx=data.length, yy=data[0].length;
  for (int i=0; i<xx; i+=Interval)
  {
    for (int a=0; a<yy; a+=Interval)
    {
      D+=data[i][a];
    }
  }
  return D/(xx/Interval*yy/Interval);
}
float[][] Smooth(float[][] array, float Agr)
{


  int yy=array[0].length, xx=array.length;
  float F=CountData(array)/xx/yy;
  //println(array[0]);
  float Fault;
  float[][] f=new float[xx][yy];
  f=array;
  for (int i=0; i<xx; i++)
  {
    for (int a=0; a<yy; a++)
    {
      f[i][a]+=(F-f[i][a])*Agr;
    }
  }

  Fault=F-CountData(array)/xx/yy;
  if (abs(Fault)>0.01)
  {
    println("Attention! SmoothAlgorythm is causing Fault!");
    println(Fault);
  }
  return f;
}
PGraphics Window(PGraphics IN, int x1, int y1, int x2, int y2)
{
  if (x1<0)x1=0;
  if (y1<0)y1=0;
  if (y2>IN.height)y2=IN.height;
  if (x2>IN.width)x2=IN.width;
  int WIDTH=abs(x2-x1), HEIGHT=abs(y2-y1);
  //println(WIDTH,HEIGHT);
  PGraphics OUT=createGraphics(WIDTH, HEIGHT);
  OUT.beginDraw();
  OUT.loadPixels();
  /// DebugTime=millis();
  for (int i=x1; i<x2; i++)
  {
    for (int a=y1; a<y2; a++)
    {
      OUT.pixels[(a-y1)*WIDTH+(i-x1)]=IN.get(i, a);
    }
  }
  //println("Composite: "+str(millis()-DebugTime));
  OUT.updatePixels();
  OUT.endDraw();
  return OUT;
}
void PrintMapData(int X, int Y)
{
  println("X: "+str(X)+" Y: "+str(Y)+"\n Type: "+str(Type[X][Y])+"\n SecType: "+str(SecType[X][Y])+"\n   Water: "+
    str(GroundWater[X][Y])+"\n   Moisture: "+str(GroundWater[X][Y]/WaterVol[Type[X][Y]]*100)+"%\n   Temperture: "+
    str( Temp[X][Y])+"°C\n   Elevation: "+str( Elev[X][Y])+"m\n   PlantId: "+str(PlantID[X][Y])+"\n   PlantAge:  "+str(PlantAge[X][Y])+"\n   PlantHealth: "+
    str(PlantHealth[X][Y])+"\n   HumiditY: "+str(Hum[X][Y]/AirVol(X, Y)*100)+"%\n   Air Moisture: "+str(Hum[X][Y])+"\n   Height over Sealvl: "+str(Elev[X][Y]-Sealvl)
    +"\n   Rain: "+str(Rain[X][Y])+"\n\n   SeaWater: "+str(MapData[SeaWaterI])+"\n  Sealevel: "+str(Sealvl));
}
String LocalPlantsPath()
{
  return (WorldPath()+"\\Plants\\");
}
String WorldPath()
{
  return WorldPath+"\\"+WorldName;
}



PImage MakeColor(PImage IN, int Stage, int Spec, color C)
{
  PImage Temp;
  PGraphics TempG=createGraphics(IN.width, IN.height);
  TempG.beginDraw();
  for (int i=0; i<IN.width; i++)
  {
    for (int a=0; a<IN.height; a++)
    {
      color TempC=IN.get(i, a);
      color TempCnew=color(map(Stage, 0, Spec, red(TempC), red(C)),map(Stage, 0, Spec, green(TempC), green(C)),map(Stage, 0, Spec, blue(TempC), blue(C)),alpha(TempC));
      TempG.set(i,a,TempCnew);
    }
  }
  TempG.endDraw();
  Temp=TempG.get();



  return Temp;
}
