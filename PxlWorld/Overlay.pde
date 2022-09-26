
void DrawOverlay()
{
  if (Overlay!=0)
  {
    if (OverlayIndexOld!=Overlay)
    {
      ReDrawOverlay=true;
      OverlayIndexOld=Overlay;
    } else ReDrawOverlay=false;
    OverlayPic.beginDraw();
    //OverlayPic.clear();
    OverlayPic.noStroke();

    switch(Overlay)
    {

    case 1: //Temp
      {
        for (int i=0; i<MapData[MapWidthI]; i++)
        {
          for (int a=0; a<int(MapData[MapHeightI]); a++)
          {
            float Fill=map(Temp[i][a], 0, 30, 0, 255);
            if (abs(int(Fill)-OverlayOld[i][a])>10||ReDrawOverlay)
            {
              OverlayOld[i][a]=int(Fill);
              OverlayPic.fill(Fill, 0, 0);
              OverlayPic.rect(i*w, a*w, w, w);
            }
          }
        }
        break;
      }
    case 2: //GroundWater
      {
        for (int i=0; i<MapData[MapWidthI]; i++)
        {
          for (int a=0; a<int(MapData[MapHeightI]); a++)
          {
            float Fill= map(GroundWater[i][a], 0, WaterVol[Type[i][a]], 0, 255);
            if (abs(int(Fill)-OverlayOld[i][a])>10||ReDrawOverlay)
            {
              OverlayOld[i][a]=int(Fill);
              if (SecType[i][a]==1)OverlayPic.fill(WaterColor);
              else OverlayPic.fill(0, Fill, 0);
              OverlayPic.rect(i*w, a*w, w, w);
            }
          }
        }
        break;
      }
    case 3: //Hum
      {
        for (int i=0; i<MapData[MapWidthI]; i++)
        {
          for (int a=0; a<int(MapData[MapHeightI]); a++)
          {
            float Av=AirVol(i, a);
            float Fill= map(Hum[i][a], 0, Av, 0, 255);
            if (abs(int(Fill)-OverlayOld[i][a])>10||ReDrawOverlay)
            {
              OverlayOld[i][a]=int(Fill);
              if (Hum[i][a]<Av)
              {
                OverlayPic.fill(0, Fill, 0);
              } else if (Rain[i][a])
              {
                OverlayPic.fill(0, 0, 255);
              } else
              {
                OverlayPic.fill( map(Hum[i][a], Av, Av*2, 100, 255), 0, 0);
              }
              OverlayPic.rect(i*w, a*w, w, w);
            }
          }
        }
        break;
      }
          case 4: //Hum
      {
        for (int i=0; i<MapData[MapWidthI]; i++)
        {
          for (int a=0; a<int(MapData[MapHeightI]); a++)
          {
            color Fill=color(0);
            if(CheckGround(SetId,i,a)) Fill=color(0,255,0);
            else Fill=color(255,0,0);
            if(PlantID[i][a]==SetId)Fill=color(0,0,255);
             if (int(Fill)!=OverlayOld[i][a]||ReDrawOverlay)
            {
              OverlayOld[i][a]=int(Fill);
              OverlayPic.fill(Fill);
              OverlayPic.rect(i*w, a*w, w, w);
            }
          }
        }
        break;
      }
    }
    OverlayPic.endDraw();
    OverlayImg=OverlayPic.get();
    OverlayReady=true;
  }
}
