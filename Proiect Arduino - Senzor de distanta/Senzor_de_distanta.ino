//definire pinuri
const int echo_pin = 9;
const int trig_pin= 10;
const int led = 13;
const int buzzer = 11;

//definire variabile
long duration;
int distance;
int safetyDistance;

void setup() {
  // put your setup code here, to run once:
  pinMode(echo_pin, INPUT);  // se declara pinii folositii si ce fel de tip au IN/OUT
  pinMode(trig_pin, OUTPUT);
  pinMode(led, OUTPUT);
  pinMode(buzzer, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
digitalWrite(trig_pin, LOW);
delayMicroseconds(2);
digitalWrite(trig_pin, HIGH);
delayMicroseconds(10);
digitalWrite(trig_pin, LOW);

duration = pulseIn(echo_pin, HIGH);

distance = duration*0.034/2;

//digitalWrite(buzzer, LOW);
//delay(1000);
//digitalWrite(buzzer, HIGH);
//tone(buzzer, 440);
//delay(1000);


safetyDistance = distance;
if(safetyDistance <= 20)
{
  //digitalWrite(buzzer, HIGH);
  tone(buzzer, 800);
  digitalWrite(led, HIGH);
}
else
{
  noTone(buzzer); 
  digitalWrite(led, LOW);
}

/*
tone(buzzer, 300);
delay(1000);
*/

Serial.print("Distanta: ");
Serial.println(distance);

/*
tone(buzzer, 400);
delay(1000);

noTone(buzzer);
delay(1000);
*/

}
