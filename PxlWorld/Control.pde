void keyPressed()
{
  switch(keyCode)
  {
  case RIGHT:
    SetId++;

    break;
  case LEFT:
    SetId--;
    if (SetId<1)SetId=1;

    break;
  case UP:
    LocalPlantTypeSel=true;
    break;
  case DOWN:
    LocalPlantTypeSel=false;
    break;
  }
  switch(key)
  {
  case 'ü':
    Weatherstation[0]=0;
    break;
  case '+':
    MapData[SeaWaterI]*=1.1;
    break;
  case 'h':
    MapData[SunI]+=50;
    println(int(MapData[SunI]));
    break;
  case 'c':
    MapData[SunI]-=50;
    println(int(MapData[SunI]));
    break;
  case '-':
    MapData[SeaWaterI] *=0.9;
    break;
  case's':
    {
      SaveWorld(WorldName);
      break;
    }
  case'm':
    {
      Overlay=2;
      break;
    }
  case'n':
    {
      Overlay=1;
      break;
    }
  case'b':
    {
      Overlay=0;
      break;
    }
  case'v':
    {

      if (!ShowVegetation)ShowVegetation=true;
      else ShowVegetation=false;
      break;
    }
  case't':
    {

      if (!TimeDebug)TimeDebug=true;
      else TimeDebug=false;
      break;
    }
  case'w':
    {
      if (!ShowWeather)ShowWeather=true;
      else ShowWeather=false;

      break;
    }
  case'p':
    {
      if (!Pause)Pause=true;
      else Pause=false;

      break;
    }
  case',':
    {
      Overlay=3;
      break;
    }
  case'.':
    {
      Overlay=4;
      break;
    }

  case 'l':
    {
      LoadWorld("World1");
      break;
    }
  case 'L':
    {
      LocalPlantTypeSel=true;
      break;
    }
  case 'G':
    {
      LocalPlantTypeSel=false;
      break;
    }
  case 'S':
    {
      SaveLocalPlantType(SetId, PlantsPath);
      break;
    }
  }
  //println("Sealvl: " +str(Sealvl));
  updateMapProp();
}
void mouseReleased()
{
  int X=int(float(mouseX-MapsZeroX)/Maps.width*MapData[MapWidthI]), Y=int(float(mouseY-MapsZeroY)/Maps.height*int(MapData[MapHeightI]));
  if (mouseButton==LEFT)
  {
    int p=0;

    PrintMapData(X, Y);
    /*for ( Plant g : Plants)
     {
     if (g.X==X&&g.Y==Y)
     {
     p++;
     }
     }
     if(p>1)print(" Multiple Plants! ("+str(p)+")");*/
    println();
  } else if (mouseButton==RIGHT)
  {

    if (PlantID[X][Y]==0&&SetId!=0)
    {
      PlantSet[0]=X;
      PlantSet[1]=Y;
      PlantSet[2]=SetId;
    }
  } else
  {
    Weatherstation[0]=X;
    Weatherstation[1]=Y;
  }
}
void mousePressed()
{
  DragStartX=mouseX;
  DragStartY=mouseY;
}
void mouseDragged()
{
  if (!cp5.isMouseOver())
  {
    if (mouseButton==LEFT)
    {
      MapsZeroXF+=mouseX-DragStartX;
      DragStartX=mouseX;
      MapsZeroYF+=mouseY-DragStartY;
      DragStartY=mouseY;
      CheckBoundaries();
    }
  }
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  Zoom+=e/10.;
  if (Zoom<ZoomMin)Zoom=ZoomMin;
  else if (Zoom>ZoomMax)Zoom=ZoomMax;
  println(Zoom);
}
