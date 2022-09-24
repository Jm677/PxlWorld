/*for (int i=0; i<x; i++)
       {
       for (int a=0; a<y; a++)
       {
       
       if (SecType[i][a]==1&&CheckLand(i, a, 1))
       {
       Moist[i][a]=100;
       for (int b=-WaterRadius-1; b<=WaterRadius; b++)
       {
       for (int c=-WaterRadius-1; c<=WaterRadius; c++)
       {
       if ((b!=0||c!=0)&&i+b<x&&i+b>=0&&a+c<y&&a+c>=0&&Type[i+b][a+c]!=6)
       {
       DistanceInf=(WaterRadius-sqrt(b*b+c*c))/WaterRadius;
       if (DistanceInf<0)DistanceInf=0;
       // Moistlvl=MoistInc*DistanceInf;
       //Templvl=(WaterTemp-Temp[i+b][a+c])/WaterTemp*WaterTempInf*DistanceInf;
       
       
       // Moist[i+b][a+c]+=Moistlvl;
       //Temp[i+b][a+c]+=Templvl;
       //println(Templvl);
       
       // println(i, a, i+b, a+c, Templvl);
       
       if (Moist[i+b][a+c]>100)Moist[i+b][a+c]=100;
       if (Temp[i+b][a+c]<MinTemp)Temp[i+b][a+c]=MinTemp;
       }
       }
       }
       } else if (SecType[i][a]==1) Moist[i][a]=100;
       }
       }*/
