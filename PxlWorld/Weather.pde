int SunFlux(int i, int a)
{
  float H=Hum[i][a]/AirVol(i, a);
  if (H>2)H=2;
  else if (H<1)H=1;
  return int(map(H, 1, 2, 1, 0.5)*int(MapData[SunI]));
}
float AirVol(int i, int a)
{

  float A=WaterVolAir*map(Temp[i][a], -18, 20, 0, 1);
  if (A<0.01)A=0.01;
  return A;
}

color[][] WeatherOld;
void DrawWeather()
{

  //Weather.smooth(5);
  Weather.beginDraw();
  //Weather.clear();
  Weather.noStroke();

  float H=0;
  for (int i=0; i<MapData[MapWidthI]; i++)
  {
    for (int a=0; a<int(MapData[MapHeightI]); a++)
    {
      float Av=AirVol(i, a);
      color Fill;
      if (abs(HumOld[i][a]-Hum[i][a]/Av)>=0.2)
      {
        Weather.set(i*w,a*w,Erase);
        HumOld[i][a]=Hum[i][a]/Av;
        H=Hum[i][a]/Av;
        if (H>2)H=2;
    
        if(H>1)Fill=color(map(H, 1, 2, 255, 100), map(H, 1, 2, 130, 230));
        else Fill=color(255,0);
        if(Fill!=WeatherOld[i][a])
        {
          Weather.fill(Fill);
          WeatherOld[i][a]=Fill;
          Weather.rect(i*w, a*w, w, w);
        }
      }
    }
  }
  
  Weather.endDraw();
  
  //Weather.filter(BLUR);
  
}
long[] LastPush=new long[2];
long WindTickCount;
void PushWind()
{
  WindTickCount++;
  //  println(WindTickCount);
  if (WindTickCount-LastPush[0]>=abs(1/MapData[WindXI]))
  {
    LastPush[0]=WindTickCount;
    float[] z=new float[int(MapData[MapHeightI])];
    if (MapData[WindXI]<0)
    {
      z=Hum[0];

      for (int i=0; i<MapData[MapWidthI]-1; i++)
      {

        Hum[i]=Hum[i+1];
      }
      Hum[int(MapData[MapWidthI])-1]=z;
    } else if ( MapData[WindXI]>0)
    {
      z=Hum[int(MapData[MapWidthI])-1];
      for (int i=int(MapData[MapWidthI])-1; i>0; i--)
      {

        Hum[i]=Hum[i-1];
      }
      Hum[0]=z;
    }
  }
  if (WindTickCount-LastPush[1]>=abs(1/MapData[WindYI]))
  {
    LastPush[1]=WindTickCount;
    float[] z=new float[int(MapData[MapWidthI])];
    if (MapData[WindYI]<0)
    {


      for (int i=0; i<MapData[MapWidthI]; i++)
      {
        z[i]=Hum[i][0];
      }
      for (int a=0; a<MapData[MapWidthI]; a++)
      {
        for (int i=0; i<int(MapData[MapHeightI])-1; i++)
        {

          Hum[a][i]=Hum[a][i+1];
        }
      }

      for (int i=0; i<int(MapData[MapHeightI]); i++)
      {
        Hum[i][int(MapData[MapHeightI])-1]=z[i];
      }
    } else if ( MapData[WindYI]>0)
    {

      for (int i=0; i<MapData[MapWidthI]; i++)
      {
        z[i]=Hum[i][int(MapData[MapHeightI])-1];
      }
      for (int a=0; a<MapData[MapWidthI]; a++)
      {
        for (int i=int(MapData[MapHeightI])-1; i>0; i--)
        {

          Hum[a][i]=Hum[a][i-1];
        }
      }

      for (int i=0; i<int(MapData[MapHeightI]); i++)
      {
        Hum[i][0]=z[i];
      }
    }
  }
}
