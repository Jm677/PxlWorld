
void drawMap()
{
  //println(Overlay);
  if (Overlay==0||true)
  {
    Maps.beginDraw();
    Maps.noStroke();
    color Fill=0;
    for (int i=0; i<MapData[MapWidthI]; i++)
    {
      for (int a=0; a<MapData[MapHeightI]; a++)
      {
        //println(i+MapsZeroX/w,a+MapsZeroY/w);
        boolean change=false;
        if (SecType[i][a]==0&&Type[i][a]!=TypeOld[i][a])
        {
          //println("Type");
          change=true;
          switch(Type[i][a])
          {

          case 1:
            float EF=map(round(Elev[i][a]/Troplines), round(int(Sealvl)/Troplines), round(MaxElev/Troplines), 1, 0);
            Fill=color(EF*red(DirtColor), EF*green(DirtColor), EF*blue(DirtColor));
            break;
          case 2:
            float EFS=map(round(Elev[i][a]/Troplines), round(int(MapData[DirtlvlI])/Troplines), round(MaxElev/Troplines), 1, 0);
            Fill=color(red(StoneColor)*EFS, green(StoneColor)*EFS, blue(StoneColor)*EFS);
            break;
          case 3:

            break;
          case 4:

            break;

          case 5:

            break;
          case 6:


            break;
          }
  
          TypeOld[i][a]=Type[i][a];
        }
        if (SecType[i][a]!=SecTypeOld[i][a])
        {
          //println("SecType");
          change=true;
          SecTypeOld[i][a]=SecType[i][a];
          switch(SecType[i][a])
          {

          case 1: //Water
            Fill=color(0, map(Sealvl-Elev[i][a], 0, Sealvl-MinElev, green(WaterColor), 0), blue(WaterColor));
            break;
          case 2:
            //float EFSn=map(round(Elev[i][a]/Troplines), round(Mtnlvl/Troplines), round(MaxElev/Troplines), 0.8, 1.7);
            Fill=color((SnowColor));
            break;
          case 3:
            Fill=color(IceColor);
            break;
          case 4:

            break;

          case 5:

            break;
          case 6:
            break;
          }
     
          
        }
        if(change)
        {
          Maps.fill(Fill);
          Maps.rect(i*w, a*w, w, w);
        }
      }
    }
    // println(millis()-Time);

   Maps.endDraw();

   
    //  Map=Maps.get(0,0,width,height);
    //Map.resize(int(MapWidth*Zoom), int(int(MapData[1])*Zoom));
    //image(Map,MapsZeroX, MapsZeroY, width,height);
    //if (!nothing) set(MapsZeroX, MapsZeroY, Maps);

    Mapupdate=false;
  }
}
