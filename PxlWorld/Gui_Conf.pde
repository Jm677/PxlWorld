float LeftBarWidth = 0.1, LeftBarHeight=1, TopBarHeight=0.1, TopBarWidth=1-LeftBarWidth;
float LeftBarX=0, LeftBarY=0, TopBarX=LeftBarWidth, TopBarY=0;
float ButtonHeight=30;
PFont GuiFont, GuiFontSmall;

int FRAME=10;
int ChartMultiplier = 4;
int SmallTextSize=10, LargeTextSize=20;
int SunFlux;
final int MinFlux = 0, MaxFlux = 2000;
boolean DrawWeatherOld, DrawVegetationOld;
String LowTemp, HighTemp;
;
Group LocalPlantGroup, PerformanceGroup, EnvironmentGroup;
Accordion accordion;
Slider TPSSlider, TPSReal, FluxSlider;
Textlabel TTLabel, FPSLabel, WeatherTimeLabel, PlantTimeLabel, TempLabel, MinTempDis, MaxTempDis;
RadioButton LocalPlants;
CheckBox ShowCheckBox;
Chart ChrtAvgTemp;
void InitGui()
{
  GuiFont=createFont("Arial", LargeTextSize);
  GuiFontSmall=createFont("Arial", SmallTextSize);
  cp5=new ControlP5(this);
  cp5.setFont(GuiFontSmall);
  LeftBarWidth*=width;
  LeftBarHeight*=height;
  TopBarHeight*=height;
  TopBarWidth*=width;
  LeftBarX*=width;
  LeftBarY*=height;
  TopBarX*=width;
  TopBarY*=height;
  int GuiIndex=0;
  LocalPlantGroup = cp5.addGroup(" ")
    .setLabel("Plants")
    .setBackgroundColor(color(0, 64))
    .setBackgroundHeight(150)
    .setHeight(int(ButtonHeight))
    .setColorBackground(PlantGroupColor)
    .setMoveable(true)
    //.setColorLabel(color(255,100))
    // .setColorForeground(color(255,100))
    //.setBackgroundColor(color(255,100));
    .setBackgroundColor(PlantGroupBackgroundColor)
    .setFont(GuiFont)
    ;

  /////////////////////////////Performance////////////////////////////////////
  PerformanceGroup = cp5.addGroup(" ")
    .setLabel("Performance")
    .setBackgroundColor(color(0, 64))
    .setBackgroundHeight(150)
    .setHeight(int(ButtonHeight))
    .setColorBackground(PerformaceGroupColor)
    .setMoveable(true)
    //.setColorLabel(color(255,100))
    //.setColorForeground(color(255,100))
    .setFont(GuiFont)
    .setBackgroundColor(PerformanceGroupBackgroundColor)
    ;

  TPSSlider=cp5.addSlider("TPSValue")
    .setPosition(FRAME, FRAME)
    //.setSize(20, 100)
    .setRange(MinTPS, MaxTPS)
    //.setNumberOfTickMarks(int(MaxTPS))
    .setGroup(PerformanceGroup)
    .setFont(GuiFontSmall)
    .setSliderMode(Slider.FIX)
    .setLabel("TPS")
    ;


  GuiIndex++;
  TPSReal=cp5.addSlider("  ")
    .setPosition(FRAME, FRAME+GuiIndex*SmallTextSize)
    //.setSize(20, 100)
    .setRange(MinTPS, MaxTPS)
    //.setNumberOfTickMarks(int(MaxTPS))
    .setGroup(PerformanceGroup)
    .setFont(GuiFontSmall)
    .setSliderMode(Slider.FIX)
    .lock()
    ;


  GuiIndex++;
  TTLabel=cp5.addTextlabel("   ")
    .setPosition(FRAME, GuiIndex*(6+SmallTextSize))
    .setValue("null")
    .setGroup(PerformanceGroup)
    .setFont(GuiFontSmall);


  GuiIndex++;
  FPSLabel=cp5.addTextlabel("    ")
    .setPosition(FRAME, GuiIndex*(6+SmallTextSize))
    .setValue("null")
    .setGroup(PerformanceGroup)
    .setFont(GuiFontSmall);


  GuiIndex+=2;
  cp5.addTextlabel("Show:")
    .setPosition(FRAME, GuiIndex*(6+SmallTextSize))
    .setValue("Show:")
    .setGroup(PerformanceGroup)
    .setFont(GuiFontSmall)
    ;
  WeatherTimeLabel=cp5.addTextlabel("WeatherTime")
    .setPosition(FRAME+80, (GuiIndex+1)*(6+SmallTextSize)-3)
    .setGroup(PerformanceGroup)
    .setFont(GuiFontSmall)
    ;
  PlantTimeLabel=cp5.addTextlabel("PlantTime")
    .setPosition(FRAME+80, (GuiIndex+2)*(6+SmallTextSize)-3)
    .setGroup(PerformanceGroup)
    .setFont(GuiFontSmall)
    ;

  GuiIndex++;

  ShowCheckBox = cp5.addCheckBox("..")
    .setGroup(PerformanceGroup)
    .setFont(GuiFontSmall)
    .setPosition(FRAME+SmallTextSize, GuiIndex*(6+SmallTextSize))
    //.setColorForeground(color(120))
    //.setColorActive(color(255))
    //.setColorLabel(color(255))
    //.setSize(SmallTextSize, SmallTextSize)
    .setItemsPerRow(1)
    .setSpacingColumn(6+SmallTextSize)
    .setSpacingRow(6)
    .addItem("Weather", 0)
    .addItem("Plants", 1)
    ;
  ShowCheckBox.getItem(1).setState(true);
  ShowCheckBox.getItem(0).setState(true);

  /////////////////////////////Environment////////////////////////////////////
  GuiIndex = 0;

  EnvironmentGroup = cp5.addGroup("Env")
    .setLabel("Environment")
    .setBackgroundColor(color(0, 64))
    .setBackgroundHeight(150)
    .setHeight(int(ButtonHeight))
    .setColorBackground(EnvironmentGroupColor)
    .setMoveable(true)
    //.setColorLabel(color(255,100))
    //.setColorForeground(color(255,100))
    .setFont(GuiFont)
    .setBackgroundColor(EnvironmentGroupBackgroundColor)
    ;

  FluxSlider=cp5.addSlider("SunFlux")
    .setPosition(FRAME, FRAME+GuiIndex*SmallTextSize)
    .setLabel("Sun Flux")
    //.setSize(20, 100)
    .setRange(MinFlux, MaxFlux)
    //.setNumberOfTickMarks(int(MaxTPS))
    .setGroup(EnvironmentGroup)
    .setFont(GuiFontSmall)
    .setSliderMode(Slider.FIX)
    ;
  GuiIndex++;
  
    MaxTempDis=cp5.addTextlabel("MaxTemp")
    .setPosition(int(LeftBarWidth)-FRAME-7*SmallTextSize, FRAME+GuiIndex*SmallTextSize)
    .setValue("null")
    .setGroup(EnvironmentGroup)
    .setFont(GuiFontSmall)
    ;
    
  GuiIndex++;

  ChrtAvgTemp = cp5.addChart("   ")
    .setPosition(FRAME, FRAME + GuiIndex * SmallTextSize + 3)
    .setSize(int(LeftBarWidth)-2*FRAME, SmallTextSize*ChartMultiplier)
    .setRange(-20, 60)
    .setView(Chart.LINE)
    .setStrokeWeight(1.5)
    .setColorCaptionLabel(color(40))
    .setGroup(EnvironmentGroup)
    ;

  ChrtAvgTemp.addDataSet("AvgTempGraph");
  ChrtAvgTemp.setData("AvgTempGraph", new float[100]);

  GuiIndex+=ChartMultiplier;

  TempLabel=cp5.addTextlabel("Temp")
    .setPosition(FRAME, FRAME+GuiIndex*SmallTextSize)
    .setValue("Temperature")
    .setGroup(EnvironmentGroup)
    .setFont(GuiFontSmall)
    ;
    
  

  MinTempDis=cp5.addTextlabel("MinTemp")
    .setPosition(int(LeftBarWidth)-FRAME-7*SmallTextSize+5, FRAME+GuiIndex*SmallTextSize)
    .setValue("null")
    .setGroup(EnvironmentGroup)
    .setFont(GuiFontSmall)
    ;

  GuiIndex++;

  //////////////////////////////////////////////////////////////////////
  cp5.getTab("default")
    .activateEvent(true)
    .setLabel("Local")
    .setId(1)
    //.setGroup(PlantGroup)
    ;
  LocalPlants=cp5.addRadioButton("");
  accordion = cp5.addAccordion("acc")
    .setPosition(LeftBarX, LeftBarY)
    .setWidth(int(LeftBarWidth))
    .setHeight(int(ButtonHeight))
    .addItem(LocalPlantGroup)
    .addItem(PerformanceGroup)
    .addItem(EnvironmentGroup)
    ;
  UpdateLocalPlantButtons();
}
void UpdateLocalPlantButtons()
{
  //LoadPlantTypes('l');
  int ItemsPerRow=3;

  int WIDTH=int(LeftBarWidth/ItemsPerRow-FRAME*(1.+1./ItemsPerRow)), HEIGHT=WIDTH;
  LocalPlants.remove();
  LocalPlants=cp5.addRadioButton("");
  LocalPlants
    .setItemsPerRow(ItemsPerRow)
    .setWidth(int(LeftBarWidth))
    .setPosition(int(FRAME), int(FRAME))
    .setGroup(LocalPlantGroup)
    .setSpacingColumn(FRAME)
    .setSpacingRow(FRAME)
    ;

  for (int i=1; i<LocalPlantTypes.size(); i++)
  {
    //println(LocalPlantTypes.size());

    PImage P=LocalPlantTypes.get(i).PIC.get();
    PGraphics PZ=createGraphics(WIDTH, HEIGHT);
    //image(P,500,500);
    P.resize(WIDTH, HEIGHT);
    PZ.beginDraw();
    PZ.set(0, 0, P);
    PZ.textSize(10);
    PZ.fill(255);
    PZ.text(LocalPlantTypes.get(i).Name, 5, PZ.height-10);
    PZ.endDraw();
    P=PZ.get();
    PImage PN=P.get();
    PN.filter(INVERT);
    PGraphics PA=createGraphics(WIDTH, HEIGHT);
    PA.beginDraw();
    PA.set(0, 0, P);
    PA.stroke(255, 0, 0);
    PA.strokeWeight(4);
    PA.noFill();
    PA.rect(0, 0, WIDTH, HEIGHT);
    PA.endDraw();
    PImage PD=PA.get();


    LocalPlants.addItem(LocalPlantTypes.get(i).Name, i);
    LocalPlants.getItem(i-1)
      .setImages(P, PN, PD)
      .setHeight(HEIGHT)
      .setWidth(WIDTH)
      ;
  }
  LocalPlantGroup.setSize(int(LeftBarWidth), HEIGHT+FRAME+floor(LocalPlantTypes.size()/ItemsPerRow*(HEIGHT+FRAME)+FRAME));
}
void controlEvent(ControlEvent theEvent) {

  if (theEvent.isFrom(LocalPlants)&&int(theEvent.getGroup().getValue())>0) {
    SetId=int(theEvent.getGroup().getValue());
    print("got an event from "+theEvent.getGroup().getValue()+"\t");


    //myColorBackground = color(int(theEvent.group().value()*50), 0, 0);
  } else if (theEvent.isFrom(ShowCheckBox))
  {
    ShowWeather=ShowCheckBox.getItem(0).getState();
    ShowVegetation=ShowCheckBox.getItem(1).getState();
  }
}
void updateGuiValues()
{
  MapData[TpsI]=TPSValue;
  TPSReal.setValue(TicksPerSecond);
  TTLabel.setValue("Ticktime: "+str(TickTime)+"ms");
  FPSLabel.setValue("FPS: "+str(int(frameRate)));
  WeatherTimeLabel.setValue(str(WeatherTime)+"ms");
  PlantTimeLabel.setValue(str(PlantTime)+"ms");
  if (ShowWeather)ShowCheckBox.getItem(0).setState(true);
  else ShowCheckBox.getItem(0).setState(false);
  if (ShowVegetation)ShowCheckBox.getItem(1).setState(true);
  else ShowCheckBox.getItem(1).setState(false);
  MapData[SunI] = SunFlux;
  if (MapData[TssI] % 10 == 0) {
    ChrtAvgTemp.unshift("AvgTempGraph", CalcAverage(Temp, 10));
    LowTemp = String.format("Tmin: %3.2f °C", MatrixExtremePoint(Temp, "MIN"));
    HighTemp = String.format("Tmax: %3.2f °C", MatrixExtremePoint(Temp, "MAX"));
    MinTempDis.setValue(LowTemp);
    MaxTempDis.setValue(HighTemp);
  }
}
