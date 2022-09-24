class PlantData
{
  String Name;
  int Id, GroundWaterMin, GroundWaterMax, TempMin, TempMax, HeightMin, HeightMax, FertilityRate, FertilityRadius, Live, Livespan;
  color C;
  PImage[] Pic=new PImage[10];
  PlantData(String name, int id, int moistMin, int moistMax, int tempMin, int tempMax, int heightMin, int heightMax, int fertilityRate, int fertilityRadius, int live, int livespan)
  {
    if (name!="0")
    {
      println("new Plant was added: "+name);
      /*println("new Plant was added:  \n Name: "+name+"\n Id: "+str(id)+"\n GroundWater: "+str(moistMin)+"-"+str(moistMax)+"\n Temp: "+str(tempMin)+"-"+str(tempMax)+
        "\n Height: "+str(heightMin)+"-"+str(heightMax)+"\n FertilityRate: "+str(fertilityRate)+"\n FertilityRadius: "+str(fertilityRadius)+"\n Live: "+str(live)+"\n Livespan: "+str(Livespan));*/
      Pic[0]=loadImage(PlantsPath+"\\"+str(id)+" "+name+"\\"+str(id)+" "+name+".png");
      Pic[0].resize(w,w);
      if (Pic!=null)
      {
        println(" Picture loaded!");
        for (int i=1; i<9; i++)
        {
          Pic[i]=Pic[0].get();
          Pic[i].resize(5-i/2, 5-i/2);
        }
        Pic[9]=Erase;
      } else println(" failed to load Picture!");
    }
    GroundWaterMin=moistMin;
    GroundWaterMax=moistMax;
    TempMin=tempMin;
    TempMax=tempMax;
    HeightMax=heightMax;
    HeightMin=heightMin;
    FertilityRate=fertilityRate;
    FertilityRadius=fertilityRadius;
    Name=name;
    Live=live;
    Livespan=livespan;
    Id=id;
  }
}
void NewPlant(String Name, int id, int moistMin, int moistMax, int tempMin, int tempMax, int heightMin, int heightMax, int fertilityRate, int fertilityRadius, int live, int livespan)
{

  String S[]={Name+" "+str(id)+" "+str(moistMin)+" "+str(moistMax)+" "+str(tempMin)+" "+str(tempMax)+" "+str(heightMin)+" "+str(heightMax)+" "+str(fertilityRate)+" "+str(fertilityRadius)+" "+str(live)+" "+str(livespan)};
  saveStrings(PlantsPath+"\\"+id+" "+Name+"\\"+id+" "+Name+".txt", S);
}
