void InitTypeOld()
{
  println("Init OldTypes");
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<int(MapData[MapHeightI]); a++)
    {
      TypeOld[i][a]=100;
    }
  }
}
////////////////////////////////////////////////////////////////

void InitSecTypes()
{
  println("Init SecTypes");
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<int(MapData[MapHeightI]); a++)
    {
      if (Elev[i][a]<=Sealvl)
      {
        SecType[i][a]=1;
      }
    }
  }
}
////////////////////////////////////////////////////////////////

void InitGroundTypes()
{
  println("Init GroundTypes");
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<int(MapData[MapHeightI]); a++)
    {
      if (Elev[i][a]<=int(MapData[DirtlvlI])) Type[i][a]=1;
      else if (Elev[i][a]>int(MapData[DirtlvlI])) Type[i][a]=2;
    }
  }
}
////////////////////////////////////////////////////////////////

void CalcSecTypes()
{
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<MapData[MapHeightI]; a++)
    {
      if (Elev[i][a]<=Sealvl)SecType[i][a]=1;   // to Water
      else SecType[i][a]=0; //to Dirt
      if (SecType[i][a]==1&&Temp[i][a]<=SnowTemp)SecType[i][a]=3;      //to Ice
      else if (SecType[i][a]!=1&&Temp[i][a]<=SnowTemp)SecType[i][a]=2;      //to Snow

      if (SecType[i][a]==0&&SecType[i][a]!=SecTypeOld[i][a])TypeOld[i][a]=100;
    }
  }
}
////////////////////////////////////////////////////////////////////////
void InitElev()
{
  println("Init Elevation");
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<MapData[MapHeightI]; a++)
    {
      Elev[i][a]=round(map(noise(i/PerlinFactor, a/PerlinFactor), 0, 1, MinElev, MaxElev));
      //println(Elev[i][a]);
    }
  }
}
////////////////////////////////////////////////////////////////////////
void InitTemp()
{
  println("Init Temperatur");
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<MapData[MapHeightI]; a++)
    {
      if (SecType[i][a]==1) Temp[i][a]=WaterTemp;
      else
      {
        Temp[i][a]=round(map(Elev[i][a], Sealvl, 200, WaterTemp, MinTemp));
        if (Temp[i][a]<MinTemp)Temp[i][a]=MinTemp;
        else if (Temp[i][a]>MaxTemp)Temp[i][a]=MaxTemp;
      }
      //println(Temp[i][a]);
    }
  }
}

////////////////////////////////////////////////////////////////////////

void InitGroundWater()
{
  println("Init Groundwater");
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<MapData[MapHeightI]; a++)
    {
    if(SecType[i][a]!=1)
    {
      float M=map(Elev[i][a]-Sealvl, 0, MaxElev-Sealvl, WaterVol[Type[i][a]], 0);
      //println(Type[i][a]);
      if (M<0)M=0;
      MapData[SeaWaterI]-=M;
      GroundWater[i][a]=M;
    } else GroundWater[i][a]=WaterVol[Type[i][a]];
    }
  }
}
//////////////////////////////////////////////////////////////////////////////
void InitSeaWater()
{
  println("Init SeaWater");
  MapData[SeaWaterI]=0;
  if (Debug)println("Initialize SeaWater");
  // println(Sealvl);
  for (int i=0; i<Sealvl; i++)
  {
    MapData[SeaWaterI]+=WaterPerLayer[i];
  }
  if (Debug)println("Seawater: "+str(MapData[SeaWaterI]));
}


//////////////////////////////////////////////////////////////////
void InitWaterPerLayer()
{
  println("Init InitWaterperLayer");
  float F=0;
  WaterPerLayer=new int[MaxElev];
  if (Debug)println("Init WaterPerLayer. Analyzing "+str(WaterPerLayer.length)+" Layers");
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<MapData[MapHeightI]; a++)
    {
      WaterPerLayer[Elev[i][a]]+=SecWaterVol[1];
    }
  }
  for (int i=1; i<WaterPerLayer.length; i++)
  {
    WaterPerLayer[i]+=WaterPerLayer[i-1];
  }
  if (Debug)print("Free Waterspace per Layer: ");
  //println(WaterPerLayer);
}

/////////////////////////////////////////////////////
void CalcRain()
{
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<MapData[MapHeightI]; a++)
    {
      float Av=Hum[i][a]/AirVol(i, a);
      if (Av>=RainStart)
      {
        Rain[i][a]=true;
      } else if (Av<=RainEnd)Rain[i][a]=false;
    }
  }
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<MapData[MapHeightI]; a++)
    {
      float Avr=RainRate*map(Hum[i][a]/AirVol(i, a), 0, 2, 0, 1);
      if (Rain[i][a])
      {
        Hum[i][a]-=Avr;
        GroundWater[i][a]+=Avr;
      }
    }
  }
}
/////////////////////////////////////////////////////////////////////////
void CalcGroundWater()
{
  /////Air///
  float hu=0, mo=0;
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<MapData[MapHeightI]; a++)
    {
      if (SecType[i][a]!=1)
      {
        float S=map(Temp[i][a], 0, 20, 0, WaterVapo[Type[i][a]])*VapoFactor;
        //if(CoordX(mouseX)==i&&CoordX(mouseY)==a)println(S);
        if (S<0)S=0;
        if (GroundWater[i][a]<S)
        {
          hu+=GroundWater[i][a];
          Hum[i][a]+=GroundWater[i][a];
          mo-=GroundWater[i][a];
          GroundWater[i][a]=0;
        } else {
          hu+=S;
          mo-=S;
          GroundWater[i][a]-=S;
          Hum[i][a]+=S;
        }
      }
    }
  }
  if (mo+hu!=0)println("Fault in CalcGroundWater!");

  ///Ground//////
  float F=0, m=0;
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<MapData[MapHeightI]; a++)
    {
      if (SecType[i][a]!=1)
      {
        //println(Elev[i][a]-Sealvl);
        float M=map(Elev[i][a]-Sealvl, WaterDrainReach, MaxElev-Sealvl+WaterDrainReach, 0, WaterDrain[Type[i][a]])*DrainFactor; //Drain to Sea

        if (GroundWater[i][a]<M&&M>0)
        {
          F+=GroundWater[i][a];
          m-=GroundWater[i][a];
          GroundWater[i][a]=0;
        } else if (GroundWater[i][a]>=WaterVol[Type[i][a]]-M&&M>0)
        {
          F-=WaterVol[Type[i][a]]-GroundWater[i][a];
          m+=WaterVol[Type[i][a]]-GroundWater[i][a];
          GroundWater[i][a]=WaterVol[Type[i][a]];
        } else {
          GroundWater[i][a]-=M;
          m-=M;
          F+=M;
        }
      }
    }
  }
  if (m+F!=0)println("Fault in CalcGroundWater!");
  MapData[SeaWaterI]+=F;
}
///////////////////////////////////////////////
void CalcSmoothing()
{
  Hum=Smooth(Hum, HumSmooth);
  GroundWater=Smooth(GroundWater, GroundWaterSmooth);
  Temp=Smooth(Temp, TempSmooth);
}
////////////////////////////////////////////////////////////////////////
void CalcTemp()
{
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<MapData[MapHeightI]; a++)
    {
      int E=Elev[i][a];
      if (E<Sealvl)E=Sealvl;
      float Flux=(SunAbs[Type[i][a]]*map(SunFlux(i, a), 0, 1000, 0, 1)*map(Elev[i][a], Sealvl, MaxElev, 1, 0))-StdEm[Type[i][a]]*map(Temp[i][a], -18, 50, 0, 1);
      Temp[i][a]+=Flux;
    }
  }
  //println(Flux-Flux/2,Temp[i][a]);
}
////////////////////////////////////////////////////////////////////////

void CalcSealvl()
{
  if (MapData[SeaWaterI]<0)MapData[SeaWaterI]=0;
  float WaterLeft=MapData[SeaWaterI];
  Sealvl=0;
  //if (Debug) println("Calculating Sealvl");

  for (int i=0; i<WaterPerLayer.length; i++)
  {
    WaterLeft-=WaterPerLayer[i];
    //println(WaterLeft,i);
    Sealvl++;
    if (WaterLeft<=0)break;
  }
  // if (Debug)println("Sealvl: "+str(Sealvl));
}
