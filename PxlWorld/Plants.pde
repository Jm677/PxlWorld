class Plant
{
  int X, Y, Id, GroundWaterMin, GroundWaterMax, TempMax, TempMin, HeightMax, HeightMin, FertilityRate, FertilityRadius, Toughness, Livespan;
  int Live, Age, Health;
  int TicksSinceRep, FertTrys;
  String Name, Save;
  color C;
  PImage[] Pic=new PImage[10];
  int HealthIndex, HealthIndexOld=10, MAXXOLD, MAXYOLD;
  int Randomx, Randomy;
  boolean InArea=true;
  public boolean dead;

  Plant(int id, int x, int y)
  {
    X=x;
    Y=y;
    Id=id;
    Randomx=round(0);
    Randomy=round(0);
    if (Id>=2000)
    {
      boolean There=false;
      int PlantIndex=0;
      for (PlantData P : LocalPlantTypes)
      {
        //println("comparing: "+P.Name+" and "+GlobalPlantTypes.get(Id-2000).Name);
        if (P.Name==GlobalPlantTypes.get(Id-2000).Name) {
          //println("Hit");
          There=true;
          PlantIndex=P.Id;
          println(PlantIndex);
          break;
        }
      }
      if (!There)
      {
        GlobalPlantTypes.get(Id-2000).Id=LocalPlantTypes.size();
        LocalPlantTypes.add(GlobalPlantTypes.get(Id-2000));
        Id=LocalPlantTypes.size()-1;
      
      }
      else
      {
        Id=PlantIndex;
        LocalPlantTypeSel=true;
        SetId=Id;
        println(LocalPlantTypes.get(SetId).Name);
      }
    }
    loadData();
  }
  String Data()
  {
    return(str(X)+" "+str(Y)+" "+str(Id)+" "+str(Health)+" "+str(Live)+" "+str(Age)+" "+str(Livespan)+" "+str(TicksSinceRep));
  }
  void loadData()
  {
    PlantData P=LocalPlantTypes.get(Id);
    Name=P.Name;
    GroundWaterMin=LocalPlantTypes.get(Id).GroundWaterMin;
    GroundWaterMax=P.GroundWaterMax;
    TempMin=P.TempMin;
    TempMax=P.TempMax;
    HeightMax=P.HeightMax;
    HeightMin=P.HeightMin;
    FertilityRate=P.FertilityRate;
    FertilityRadius=P.FertilityRadius;
    Live=P.Live;
    Livespan=round(random(1-LivespanVariation, 1+LivespanVariation)*P.Livespan);
    TicksSinceRep=int(random(0, 1)*FertilityRate);
    Pic=P.Pic;
    

    if (PlantHealth[X][Y]==0)PlantHealth[X][Y]=Live;
    // println(PlantAge[X][Y],PlantHealth[X][Y]);
  }
  void die()
  {
    PlantID[X][Y]=0;
  }
  void update()
  {

    Age++;
    PlantID[X][Y]=Id;
    if (SecType[X][Y]!=1&&GroundWater[X][Y]>=GroundWaterMin&&GroundWater[X][Y]<=GroundWaterMax&&Temp[X][Y]>=TempMin&&Temp[X][Y]<=TempMax&&Elev[X][Y]>=HeightMin&&Elev[X][Y]<=HeightMax&&Age<=Livespan-Toughness&&!(CheckSur(1, 0, Id, X, Y)&&CheckSurounding))
    {
      Health+=1;
    } else
    {
      Health-=1;
    }
    if (Health<=0)
    {
      Health=0;
      dead=true;
    } else if (Health>Live) Health=Live;
  }
  boolean CheckSur(int Range, int Max, int Id, int xx, int yy)
  {
    boolean Search;
    int Index=0;
    if (Max>(Range+1)*(Range+1))Search=true;
    else Search=false;
    for (int i=-Range; i<=Range; i++)
    {
      for (int a=-Range; a<=Range; a++)
      {
        if (a!=0||i!=0)
        {
          if (Search)
          {
            if (xx+i>=0&&xx+i<int(MapData[MapWidthI])&&yy+a>=0&&yy+a<int(MapData[MapHeightI])&&PlantID[xx+i][yy+a]!=Id)Index++;
          } else
          {
            if (xx+i>=0&&xx+i<int(MapData[MapWidthI])&&yy+a>=0&&yy+a<int(MapData[MapHeightI])&&PlantID[xx+i][yy+a]==Id)Index++;
          }
          if (Index>Max)return true;
        }
      }
    }
    return false;
  }
  void reproduce()
  {

    TicksSinceRep++;
    if (TicksSinceRep>=FertilityRate&&Health>=0.9*Live)
    {
      TicksSinceRep=0;
      int i=0, a=0;
      do
      {
        i=round(random(-1, 1)*float(FertilityRadius));
        a=round(random(-1, 1)*float(FertilityRadius));
        //println(i,a,FertilityRadius,random(-1, 1));
      }
      while (i==0&&a==0);

      if (X+i>=0&&X+i<MapData[MapWidthI]&&Y+a>=0&&Y+a<int(MapData[MapHeightI])&&PlantID[X+i][Y+a]==0&&SecType[X+i][Y+a]!=1&&SecType[X+i][Y+a]!=3&&GroundWater[X+i][Y+a]>=GroundWaterMin&&GroundWater[X+i][Y+a]<=GroundWaterMax&&Temp[X+i][Y+a]>=TempMin&&Temp[X+i][Y+a]<=TempMax&&Elev[X+i][Y+a]>=HeightMin&&Elev[X+i][Y+a]<=HeightMax&&!(CheckSur(1, 0, Id, X+i, Y+a)&&CheckSurounding))
      {
        FertTrys++;
        PlantID[X][Y]=Id;
        PlantAge[X][Y]=0;
        Plants1.add(new Plant(Id, X+i, Y+a));

        // Vegetation.beginDraw();
        // display();
        //Vegetation.endDraw();

        // println("new Plant at "+str(X+i)+" "+str(Y+a));
      }
    }
  }

  void display()
  {
    /*if (MAXXOLD!=MAXX||MAXYOLD!=MAXY)
     {
     MAXXOLD=MAXX;
     MAXYOLD=MAXY;
     if (CheckArea(X, Y, MINX, MINY, MAXX, MAXY))InArea=true;
     else InArea=false;
     }
     if (InArea)
     {
     */
    HealthIndex=floor(map(Health, 0, Live, 9, 0));
    if (HealthIndexOld!=HealthIndex)
    {
      HealthIndexOld=HealthIndex;
      Vegetation.set( X*w+Randomx, Y*w+Randomy, Pic[9]);
      Vegetation.set( X*w, Y*w, Pic[HealthIndex]);
    }
    // }
  }
}
void SavePlants(String Path)
{
  String[] S=new String[Plants.size()];
  int Index=0;
  for ( Plant P : Plants)
  {
    S[Index]=P.Data();
    Index++;
  }
  saveStrings(Path, S);
}
void redrawPlants()
{


  Vegetation.beginDraw();
  Vegetation.noStroke();
  for (Plant p : Plants)
  {
    p.display();
    //p.reproduce();
  }
  Vegetation.endDraw();
}
void PlantManagment()
{
  if (Plants.size()>0)
  {
    for (Plant p : Plants)
    {
      p.reproduce();
    }


    Plants.addAll(Plants1);
    Plants1=new ArrayList<Plant>();


    int[] DeadPlants=new int[0];
    int Index=0, DeadIndex=0;
    for (Plant p : Plants)
    {
      p.update();
      if (p.dead)
      {
        DeadPlants=expand(DeadPlants, DeadIndex+1);
        DeadPlants[DeadIndex]=Index;
        PlantID[p.X][p.Y]=0;
        DeadIndex++;
      }
      Index++;
    }



    // DebugTime=millis();

    if (ShowVegetation)redrawPlants();

    //if (TimeDebug)println("Redraw Plants: "+str(millis()-DebugTime));

    if (Plants.size()>0)
    {
      for ( int i=DeadIndex-1; i>=0; i--)
      {
        Plants.remove(DeadPlants[i]);
      }
    }
  }
}
