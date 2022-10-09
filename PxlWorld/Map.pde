boolean testmap=false; //<>// //<>//
int t=10;

void ResetWorldData()
{
  Elev=new int[int(MapData[MapWidthI])][int(MapData[MapHeightI])];
  Type=new int[int(MapData[MapWidthI])][int(MapData[MapHeightI])];
  SecType=new int[int(MapData[MapWidthI])][int(MapData[MapHeightI])];
  PlantID=new int[int(MapData[MapWidthI])][int(MapData[MapHeightI])];
  PlantAge=new int[int(MapData[MapWidthI])][int(MapData[MapHeightI])];
  PlantHealth=new int[int(MapData[MapWidthI])][int(MapData[MapHeightI])];



  GroundWater=new float[int(MapData[MapWidthI])][int(MapData[MapHeightI])];
  Temp=new float[int(MapData[MapWidthI])][int(MapData[MapHeightI])];
  Hum=new float[int(MapData[MapWidthI])][int(MapData[MapHeightI])];


  HumOld=new float[int(MapData[MapWidthI])][int(MapData[MapHeightI])];//not Saved
  Rain=new boolean[int(MapData[MapWidthI])][int(MapData[MapHeightI])];//not Saved
  SecTypeOld=new int[int(MapData[MapWidthI])][int(MapData[MapHeightI])];//not Saved
  TypeOld=new int[int(MapData[MapWidthI])][int(MapData[MapHeightI])];//not Saved
  OverlayOld=new int[int(MapData[MapWidthI])][int(MapData[MapHeightI])];//not Saved
  WeatherOld=new color[int(MapData[MapWidthI])][int(MapData[MapHeightI])];//not Saved
}
void InitMap(boolean NewWorld)
{

  CreateGraphics();

  if (NewWorld)
  {
    ResetWorldData();
  }
  createMap(NewWorld);
  updateMapProp();

  //InitWaterPerLayer();
  //drawMap();

  //CountTypes(true);
  // println(CountType(6));
  //println(x*y);
}
void CreateGraphics()
{
  Maps= createGraphics(int(MapData[MapWidthI]*w), int(MapData[MapHeightI]*w));
  Vegetation=createGraphics(int(MapData[MapWidthI]*w), int(MapData[MapHeightI]*w));
  OverlayPic=createGraphics(int(MapData[MapWidthI]*w), int(MapData[MapHeightI]*w));
  Mask=createGraphics(int(MapData[MapWidthI]*w), int(MapData[MapHeightI]*w));
  Weather=createGraphics(int(MapData[MapWidthI]*w), int(MapData[MapHeightI]*w));
}
void createMap(boolean NewWorld)
{

  if (NewWorld)
  {
    InitElev();
    InitGroundTypes();
    InitTemp();
    InitSecTypes(); //Init SecTypes
  }
  InitWaterPerLayer();//Calc Space for Water
  if (NewWorld)
  {
    InitSeaWater();//Calc Seawater based on Sealvl
    InitGroundWater();             //Calc Waterlvl on Land and substract it from Sealvl
  }




  if (Debug)println("Seawater after Landfill: "+(MapData[SeaWaterI]));
}


void updateMapProp()
{
  CalcTemp();
  if (MapData[TssI]%10==0)CalcSealvl();
  CalcGroundWater();
  CalcRain();
  if (MapData[TssI]%SmoothTickRate==0)CalcSmoothing();
  if (MapData[TssI]%10==0)CalcSecTypes();
}
