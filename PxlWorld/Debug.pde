long DebugStart;
void PrintTimeDebug(String Stamp)
{

  if (TimeDebug)
  {
    println(Stamp+": "+str(millis()-DebugTime)+"ms");
    DebugTime=millis();
  }
}
void StartTimeDebug()
{
  if (TimeDebug)
  {
    println("DebugStart");
    DebugTime=millis();
    DebugStart=millis();
  }
}
void EndTimeDebug()
{
  if (TimeDebug)
  {
    println("DebugEnd: "+str(millis()-DebugStart)+"ms");
    for (int i=0; i<=5; i++)println();
  }
}
