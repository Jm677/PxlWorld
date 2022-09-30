float LeftBarWidth = 0.1, LeftBarHeight=1, TopBarHeight=0.1, TopBarWidth=1-LeftBarWidth;
float LeftBarX=0, LeftBarY=0, TopBarX=LeftBarWidth, TopBarY=0;
float ButtonHeight=30;
PFont GuiFont;
Group LocalPlantGroup;
Accordion accordion;
float ColorAlpha=230;
color PlantGroupColor=color(102, 204, 0, ColorAlpha);
RadioButton LocalPlants;
void InitGui()
{
  GuiFont=createFont("Arial", 20);
  cp5=new ControlP5(this);
  cp5.setFont(GuiFont);
  LeftBarWidth*=width;
  LeftBarHeight*=height;
  TopBarHeight*=height;
  TopBarWidth*=width;
  LeftBarX*=width;
  LeftBarY*=height;
  TopBarX*=width;
  TopBarY*=height;
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
    ;
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
    ;
  UpdateLocalPlantButtons();
}
void UpdateLocalPlantButtons()
{
  //LoadPlantTypes('l');
  int ItemsPerRow=3;
  int FRAME=10;
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
  }
}
