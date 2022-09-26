class PlantData
{
  String Name;
  int Id, GroundWaterMin, GroundWaterMax, TempMin, TempMax, HeightMin, HeightMax, FertilityRate, FertilityRadius, Live, Livespan;
  color C;
  PImage[] Pic=new PImage[10];
  PlantData(String name, int id, int moistMin, int moistMax, int tempMin, int tempMax, int heightMin, int heightMax, int fertilityRate, int fertilityRadius, int live, int livespan, PImage pic)
  {
    if (name!="0")
    {
      //println("new Plant was added: "+name);
      println("new Plant was added:  \n Name: "+name+"\n Id: "+str(id)+"\n GroundWater: "+str(moistMin)+"-"+str(moistMax)+"\n Temp: "+str(tempMin)+"-"+str(tempMax)+
        "\n Height: "+str(heightMin)+"-"+str(heightMax)+"\n FertilityRate: "+str(fertilityRate)+"\n FertilityRadius: "+str(fertilityRadius)+"\n Live: "+str(live)+"\n Livespan: "+str(Livespan));
      Pic[0]=pic;
      Pic[0].resize(w, w);
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

  String getData(boolean SetIdToZero)
  {
    int idd=0;
    if (!SetIdToZero)idd=Id;

    return Name+" "+str(idd)+" "+str(GroundWaterMin)+" "+str(GroundWaterMax)+" "+str(TempMin)+" "+str(TempMax)+" "+str(HeightMin)+" "+str(HeightMax)+" "+str(FertilityRate)+" "+str(FertilityRadius)+" "+str(Live)+" "+str(Livespan);
  }
}
void NewPlant(String Name, int id, int moistMin, int moistMax, int tempMin, int tempMax, int heightMin, int heightMax, int fertilityRate, int fertilityRadius, int live, int livespan)
{

  String S[]={Name+" "+str(id)+" "+str(moistMin)+" "+str(moistMax)+" "+str(tempMin)+" "+str(tempMax)+" "+str(heightMin)+" "+str(heightMax)+" "+str(fertilityRate)+" "+str(fertilityRadius)+" "+str(live)+" "+str(livespan)};
  saveStrings(LokalPlantsPath()+"\\"+str(id)+Name+"\\"+Name+".txt", S);
}
void LoadLocalPlantTypes(String Name)
{
  print("LoadingLocalPlantTypes..    ");
  String Path=WorldPath+"\\"+Name+"\\Plants";
  java.io.File folder = new java.io.File(Path);
  String[] list = folder.list();


  if (list !=null)
  {
    PImage pic;
    println("found "+str(list.length)+" Planttypes in : "+Path);
    LocalPlantTypes.add(new PlantData("0", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, null));
    Maxid=int(str(list[list.length-1].charAt(0)));
    if (Maxid!=list.length)println("Attention! Fault in Plant Data System!");
    for (int i=1; i<=list.length; i++)
    {
      println("read Plant: "+list[i-1]);
      String[] Lines=loadStrings(Path+"\\"+list[i-1]+"\\"+list[i-1]+".txt"), word;
      //println(list[i]);
      if (Lines[0]!=null)
      {
        word=Lines[0].split(" ");

        int a=0, id=int(word[1]);
        if (id!=i)
        {
          println("Fault in Plant System! Added Dummie at: "+str(i));
          LocalPlantTypes.add(i, new PlantData("0", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, null));
        }
        pic=loadImage(Path+"\\"+str(id)+" "+word[0]+"\\"+str(id)+" "+word[0]+".png");
        LocalPlantTypes.add(id, new PlantData(word[a++], int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), pic));
      } else println("Fehler beim lesen von: "+list[i]);
    }
  } else println("no Plants found");
  PlantTypes.addAll(LocalPlantTypes);
}
void LoadGlobalPlantTypes()
{
  print("LoadingGlobalPlantTypes..    ");
  String Path=PlantsPath;
  java.io.File folder = new java.io.File(Path);
  String[] list = folder.list();
  GlobalPlantTypes.add(new PlantData("0", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, null));

  if (list !=null)
  {
    PImage pic;
    println("found "+str(list.length)+" Planttypes in : "+Path);
    int PlantTypeSize=PlantTypes.size();
    for (int i=0; i<list.length; i++)
    {
      println("read Plant: "+list[i]);
      String[] Lines=loadStrings(Path+"\\"+list[i]+"\\"+list[i]+".txt"), word;
      //println(list[i]);
      int a=0;
      if (Lines[0]!=null)
      {
        word=Lines[0].split(" ");
        pic=loadImage(Path+"\\"+word[0]+"\\"+word[0]+".png");
        GlobalPlantTypes.add( new PlantData(word[a++], 2000-a+a+++i+1, int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), int(word[a++]), pic));
      } else println("Fehler beim lesen von: "+list[i]);
    }
  } else println("no Plants found");
  //PlantTypes.addAll(GlobalPlantTypes);
}
void SaveLocalPlants(String path)
{
  for (PlantData PT : LocalPlantTypes)
  {
    if (PT.Name!="0")
    {
      String S[]={PT.Name+" "+str(PT.Id)+" "+str(PT.GroundWaterMin)+" "+str(PT.GroundWaterMax)+" "+str(PT.TempMin)+" "+str(PT.TempMax)+" "+str(PT.HeightMin)+" "+str(PT.HeightMax)+" "+str(PT.FertilityRate)+" "+str(PT.FertilityRadius)+" "+str(PT.Live)+" "+str(PT.Livespan)};
      //saveStrings(DataPath+"Plants\\"+PT.Name+"\\"+PT.Name+".txt", S);
      saveStrings(path+"\\"+str(PT.Id)+" "+PT.Name+"\\"+str(PT.Id)+" "+PT.Name+".txt", S);
      PT.Pic[0].save(path+"\\"+str(PT.Id)+" "+PT.Name+"\\"+str(PT.Id)+" "+PT.Name+".png");
    }
  }
}
void LoadLokalPlantsToGlobal(int Id, String Path)
{



  java.io.File Global = new java.io.File(Path);

  String[] GlobalList = Global.list();
  boolean There=false;
  String Name=LocalPlantTypes.get(Id).Name;
  String plantPath=Path+Name;
  println("Saving local PlantType: "+Name+" to: "+plantPath);
  if (GlobalList !=null)
  {

    println("found "+str(GlobalList.length)+" Planttypes in : "+Path);

    for (int i=0; i<GlobalList.length; i++)
    {
      //println("read Plant: "+GlobalList[i]);
      String[] Lines=loadStrings(Path+"\\"+GlobalList[i]+"\\"+GlobalList[i]+".txt"), word;
      if (Lines[0]!=null)
      {
        word=Lines[0].split(" ");
        println(word[0], Name);
        if (word[0].equals(Name))
        {

          There=true;
          break;
        }
      } else println("Fehler beim lesen von: "+GlobalList[i]);
    }
    if (There) println("Name already occupied");
    else {
      PlantData P=LocalPlantTypes.get(Id);
      P.Pic[0].save(plantPath+"\\"+Name+".png");
      String S[]=new String[1];
      S[0]=P.getData(true);
      println(S[0]);
      saveStrings(plantPath+"\\"+Name+".txt", S);
    }
  } else println("no Plants found");
}
