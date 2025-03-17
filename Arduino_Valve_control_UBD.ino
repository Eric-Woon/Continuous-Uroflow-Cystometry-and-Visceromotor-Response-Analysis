

int ctrlinput = A1;    
int ch1 = 1;      // select the pin for the LED
int ch2 = 2; 
int ch3 = 3;      // select the pin for the LED
int ch4 = 4; 
int ch5 = 5;      // select the pin for the LED


int ctrlV = 0;  // variable to store the value coming from the sensor
int mult=1024/5;

void setup() {
  // declare the ledPin as an OUTPUT:
  pinMode(ch1, OUTPUT);
  pinMode(ch2, OUTPUT);
  pinMode(ch3, OUTPUT);
  pinMode(ch4, OUTPUT);
  pinMode(ch5, OUTPUT);
}

void loop() {
  // read the value from the input control signal:
  ctrlV = analogRead(ctrlinput);
  
 if (ctrlV>0.8*mult && ctrlV<1.2*mult)
{
   digitalWrite(ch1, HIGH);
   digitalWrite(ch2, LOW);
   digitalWrite(ch3, LOW);
   digitalWrite(ch4, LOW);
   digitalWrite(ch5, LOW);
}
else if (ctrlV>1.8*mult && ctrlV<2.2*mult)
{
  digitalWrite(ch2, HIGH);
  digitalWrite(ch1, LOW);
  digitalWrite(ch3, LOW);
  digitalWrite(ch4, LOW);
  digitalWrite(ch5, LOW);
}
else if (ctrlV>2.3*mult && ctrlV<2.7*mult)
{
  digitalWrite(ch3, HIGH);
  digitalWrite(ch1, LOW);
  digitalWrite(ch2, LOW);
  digitalWrite(ch4, LOW);
  digitalWrite(ch5, LOW);
}
else if (ctrlV>2.8*mult && ctrlV<3.2*mult)
{
  digitalWrite(ch4, HIGH);
  digitalWrite(ch1, LOW);
  digitalWrite(ch2, LOW);
  digitalWrite(ch3, LOW);
  digitalWrite(ch5, LOW);
}
else if (ctrlV>3.3*mult && ctrlV<3.7*mult)
{
  digitalWrite(ch5, HIGH);
  digitalWrite(ch1, LOW);
  digitalWrite(ch2, LOW);
  digitalWrite(ch3, LOW);
  digitalWrite(ch4, LOW);
}
else
{
  digitalWrite(ch1, LOW);
  digitalWrite(ch2, LOW);
  digitalWrite(ch3, LOW);
  digitalWrite(ch4, LOW);
  digitalWrite(ch5, LOW);
}
 
}

