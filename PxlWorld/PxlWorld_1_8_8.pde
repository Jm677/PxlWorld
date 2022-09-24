import controlP5.*;
import java.util.List;
import java.io.FileFilter;

ControlP5 cp5;
boolean Debug=false;
String WorldName="World1";
String WorldPath=("\\Saves\\");

String DataPath=("\\Data\\");
String PlantsPath=("\\"+DataPath+"\\Plants\\");
String SketchPath;
PGraphics Maps, Vegetation, OverlayPic, Weather, Mask,Stats;
PImage   Map, Erase, Window, OverlayImg;
ArrayList<Plant>Plants=new ArrayList<Plant>();
ArrayList<Plant>Plants1=new ArrayList<Plant>();
ArrayList<PlantData>PlantTypes=new ArrayList<PlantData>();
int   w=5, MapsZeroX, MapsZeroY, MapsZeroXF, MapsZeroYF, MapsZeroXOld, MapsZeroYOld;
float PerlinFactor=50;

int SealvlOld;

//////////////////Map Start Properties////////////////////////////////
int MapWidth=640, MapHeight=360 ; //Save
int Sealvl=110;
int Dirtlvl=170; //Save
int MaxElev=255, MinElev=40;
int WaterTemp=10;
int MinTemp=-10, MaxTemp=40;
int Sun=500; //Save
float[] Wind={1, 1}; //Save
int Tps=100; //Save
int Tss; //Ticksincestart  //Save
////////////////////////////////////////////////////////////////
int ih=0;
int  SeaWater;//Save
int MapWidthI=ih++, MapHeightI=ih++, DirtlvlI=ih++, SeaWaterI=ih++, SunI=ih++, WindXI=ih++, WindYI=ih++, TpsI=ih++, TssI=ih++;
float[] MapData={MapWidth, MapHeight, Dirtlvl, SeaWater, Sun, Wind[0], Wind[1], Tps, Tss}; //MapWidth, MapHeight, Sealvl, Sun, WindX, WindY,Tps,Ticks since Start
////////////Terrain//////////////////////////////


int[] CountTypes=new int[7]; ///Increase when adding new Type!!!
// 0=nothing, 1=Dirt, 2=EStone, 3=Empty, 4=Empty,5=Empty, 6=Empty
float DrainFactor=0.01/*0.01*/, VapoFactor=0.05/*0.1*/, VolumeFactor=30, SunFactor=0.1, EmissionFactor=0.07;                                           ///increase/decrease influence of Vapor and Drain
float WaterVolAir= 0.1*VolumeFactor;       //Max Water in Air at 20 °C; 0 at -18°C;
int SmoothTickRate=10;
float SmoothFactor=SmoothTickRate; //Compensation for Smoothfunc beeing called only 10th tick
float TempSmooth=0.0005*SmoothFactor, HumSmooth=0.01*SmoothFactor, GroundWaterSmooth=0.01*SmoothFactor;

///For SecType
// 0=nothing, 1=Water, 2=Snow, 3=Ice, 4=Empty,5=Empty, 6=Empty
float[] SecWaterDrain={0, 1, 0, 0.1, 0, 0.1, 0};                                                                                                   //Water that runs back to Sea per Tick and in relation to Elevation.
float[] SecWaterVapo={0, 0.6, 0, 0.7, 0, 0.8, 1};                                                                                                 //Water that Vaporizes per Tick at 20°C
float[] SecSunAbs={0, 1*SunFactor, 1*SunFactor, 1*SunFactor, 1*SunFactor, 1*SunFactor, 0.8*SunFactor};                                                //Sun Absorbtion[°C*Elev/(SunFlux*Tick)]
float[] SecWaterVol={0, 0.4*VolumeFactor, 0.8*VolumeFactor, 0.4*VolumeFactor, 1*VolumeFactor, 0.01*VolumeFactor, 1*VolumeFactor};                  //WatterVolume in T Absolut (Water is Multiplied by Sealvl-MinElev)
float[] SecStdEm={0, 1*EmissionFactor, 1*EmissionFactor, 1*EmissionFactor, 1*EmissionFactor, 1*EmissionFactor, 1*EmissionFactor};                     //Standard Energie Emssion [°C/Tick]



//For GroundType
// 0=nothing, 1=Dirt, 2=Stone, 3=Empty, 4=Empty,5=Empty, 6=Empty
float[] WaterDrain={0, 1, 0, 0.1, 0, 0.1, 0};                                                                                                   //Water that runs back to Sea per Tick and in relation to Elevation.
float[] WaterVapo={0, 0.6, 0, 0.7, 0, 0.8, 1};                                                                                                 //Water that Vaporizes per Tick at 20°C
float[] SunAbs={0, 1*SunFactor, 1*SunFactor, 1*SunFactor, 1*SunFactor, 1*SunFactor, 0.8*SunFactor};                                                //Sun Absorbtion[°C*Elev/(SunFlux*Tick)]
float[] WaterVol={0, 0.4*VolumeFactor, 0.8*VolumeFactor, 0.4*VolumeFactor, 1*VolumeFactor, 0.01*VolumeFactor, 1*VolumeFactor};                  //WatterVolume in T Absolut (Water is Multiplied by Sealvl-MinElev)
float[] StdEm={0, 1*EmissionFactor, 1*EmissionFactor, 1*EmissionFactor, 1*EmissionFactor, 1*EmissionFactor, 1*EmissionFactor};                     //Standard Energie Emssion [°C/Tick]


int WaterDrainReach=7;                                                                                                                           //Elev over Sealvl at wich no Water is Drained


int SnowTemp=0;
int WaterRadius=10;//Radius for GroundWater
int GroundWaterInc=5;//GroundWater increase per Water in WaterRadius
int WaterTempInf=0; //influence Water on Temp
float DesertGroundWater=0.1, DesertTemp=35; //Moisture for Desert
/////////////////////////////////////////

float RainRate=0.05;
float RainEnd=0.6, RainStart=1.7;
int[] WaterPerLayer;//Shows place for Water per Layer
int[][][] DataInt;
int Elev[][];
boolean Rain[][];
float GroundWater[][], Temp[][], Hum[][];
int Type[][], SecType[][], PlantID[][], PlantAge[][], PlantHealth[][];
int TypeOld[][], SecTypeOld[][];
int OverlayOld[][];
float HumOld[][];
float LandWater;

int OverlayIndexOld;
boolean ReDrawOverlay;
int MINX=0, MINY=0, MAXX=int(MapData[MapWidthI]), MAXY=int(MapData[MapHeightI]);
int[] PlantSet=new int[3];
float Zoom=1;
float ZoomMin=0.6, ZoomMax=2;
float LivespanVariation=1;
boolean MapReady, Mapupdate;

int Overlay=0;
boolean reDraw;
int DragStartX, DragStartY;
boolean Drag;
int TicksPerSecond;
long TPSTime;

long TpsTime, CompTime, DebugTime;
long Time;
int TickTime;
Textlabel TPS;
int TicksPerSecondCounter;

int CompositeTps=5;
int Mpt=60; //Ingame Minutes per Tick
int IngameTime;


boolean TimeDebug=false;
int SetId=4;
int Maxid;
boolean Tick, Ticked, TickEnd=true, CompEnd=true, FirstTick, OverlayReady,StatsReady;
boolean CheckSurounding=false; //Dont gorw next to each other
int[] Weatherstation={0, 0};
int Troplines=4;
boolean Multithreading=true;

boolean ShowWeather=true, ShowVegetation=true;
boolean Pause;
void setup()
{

  cp5=new ControlP5(this);
  if (Tps<CompositeTps)CompositeTps=Tps;
  size(2000, 1000);
  frameRate(120);
  Erase=loadImage(DataPath+"Erase.png");
  Stats=createGraphics(60,100);
  TPS=cp5.addTextlabel("TPS");
  //fullScreen();
  SketchPath=sketchPath();
  println(SketchPath);
  WorldPath=SketchPath+WorldPath;
  PlantsPath=SketchPath+PlantsPath;
  DataPath=SketchPath+DataPath;
  //smooth(2);
  InitMap(true);
  NewPlant("Tanne", 4, 0, 100, -10, 30, 100, 130, 3, 6, 100, 100);
  NewPlant("Edelweiss", 3, 0, 30, -10, 10, 160, 175, 30, 3, 30, 100);
  NewPlant("Lilie", 2, 0, 100, -10, 30, 100, 255, 1, 6, 100, 100);
  NewPlant("Birke", 1, 5, 80, 0, 30, 100, 255, 30, 8, 100, 1000);
  LoadPlantTypes();
  LoadMap(WorldName);

  // redrawPlants();
}

void draw()
{
  //println(CompEnd, TickEnd);
  //SeaWater+=100000;

  ////////////////////Tick///////////////////////////////////
  if (!Pause&&millis()-TpsTime>=1000/MapData[TpsI]&&TickEnd)
  {
    TpsTime=millis();

    if (TickEnd&&Multithreading)
    {
      thread("Tick");
      //thread("DrawOverlay");
    } else if (TickEnd&&!Multithreading)
    {
      Tick();
    }
  }
  /////////////////////////////////////////////////////
  if (!Pause&&millis()-CompTime>1000/CompositeTps&&FirstTick)
  {
    CompTime=millis();
    if (Multithreading&&CompEnd)thread("Composite");
    else if (!Multithreading)Composite();
  }
  if(millis()-CompTime>3000) CompEnd=true;


  //////////////////Draw////////////////////

  //Mask=Maps.get(-MapsZeroX,-MapsZeroY,-MapsZeroX+Maps.width,-MapsZeroY+Maps.width);


  if (Map!=null&&Overlay==0)
  {
    //background(0);
    set( MapsZeroX, MapsZeroY,Map);

  }
  if (Overlay!=0&&OverlayReady)
  {
    //background(0);
    set( MapsZeroX, MapsZeroY, OverlayImg);
  }
  if(StatsReady)set(0,0,Stats);
  //if (Map!=null)image(Map, MapsZeroX, MapsZeroY);

  ///////////////////////////////////////////



  //////////////////Analyse/////////////////////
  if (millis()-TPSTime>1000)
  {
    TPSTime=millis();
    TicksPerSecond=TicksPerSecondCounter;
    TicksPerSecondCounter=0;
    if (Weatherstation[0]!=0)
    {
      int X=Weatherstation[0], Y=Weatherstation[1];
      PrintMapData(X, Y);
    }
    Stats.beginDraw();
    Stats.background(0, 200);
    Stats.fill(255);
    Stats.textSize(12);
    Stats.text("TT: "+str(TickTime)+"ms\n"+"Tps: "+str(TicksPerSecond)+"\n"+PlantTypes.get(SetId).Name+"\n Day: "+Tss*Mpt/60/24+"\n FPS: "+str(int(frameRate)), 5, 15);
    Stats.endDraw();
    StatsReady=true;
  }

  ////////////////////////////////////////
}
void Composite()
{
  CompEnd=false;
  Mask.beginDraw();
  if (Overlay==0&&FirstTick&&Maps!=null&&Mask!=null)
  {
    Mask.set( 0, 0, Maps);
   if(ShowVegetation)Mask.image( Vegetation, 0, 0);
    if(ShowWeather)Mask.image( Weather, 0, 0);
  }

  Mask.endDraw();
  Map=Mask.get();
  CompEnd=true;
}
void Tick()
{
  TickEnd=false;
  if (PlantSet[0]!=0)
  {
    Plants.add(new Plant(PlantSet[2], PlantSet[0], PlantSet[1]));
    for (int i=0; i<PlantSet.length; i++)PlantSet[i]=0;
  }
  StartTimeDebug();
  MapData[TssI]++;
  TicksPerSecondCounter++;
  PlantManagment();
  PrintTimeDebug("PlantManagment");
  updateMapProp();
  PrintTimeDebug("updateMapProp");
  if (Overlay==0)drawMap();
  PrintTimeDebug("drawMap");
  PushWind();
  PrintTimeDebug("PushWind");
  if(ShowWeather)DrawWeather();
  PrintTimeDebug("DrawWeather");
  DrawOverlay();
  PrintTimeDebug("DrawOverlay");
  TickTime=int(millis()-TpsTime);
  if(!FirstTick)CompTime=millis();
  FirstTick=true;
  TickEnd=true;
  EndTimeDebug();
}
