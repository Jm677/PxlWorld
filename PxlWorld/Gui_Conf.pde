float LeftBarWidth = 0.1, LeftBarHeight=1, TopBarHeight=0.1, TopBarWidth=1-LeftBarWidth;
float LeftBarX=0, LeftBarY=0, TopBarX=LeftBarWidth, TopBarY=0;
float ButtonHeight=30;
PFont GuiFont, GuiFontSmall;

int FRAME=10;
int SmallTextSize=10, LargeTextSize=20;
boolean DrawWeatherOld, DrawVegetationOld;
;
Group LocalPlantGroup, PerformanceGroup;
Accordion accordion;
Slider TPSSlider, TPSReal;
Textlabel TTLabel, FPSLabel, WeatherTimeLabel,PlantTimeLabel;
RadioButton LocalPlants;
CheckBox ShowCheckBox;
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
    .setBackgroundColor(PerformanceGroupBackgroundColor);
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
}
