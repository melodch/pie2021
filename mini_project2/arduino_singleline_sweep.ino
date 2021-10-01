#include <Servo.h>

const int irPin =  A0;
const int maxPanAngle = 50;
Servo panServo;
Servo tiltServo;

// setup function to initialize hardware and software
void setup()
{
  // start the serial port
  long baudRate = 9600;
  Serial.begin(baudRate);

  pinMode(irPin, INPUT);
  tiltServo.attach(6);
  panServo.attach(7);
}

void loop() 
{
  float panInterval;
  tiltServo.write(30);
  
  // loop: read voltage at each pan angle, then send it from the Arduino to the Matlab program
    for (panInterval = 0; panInterval <= maxPanAngle; panInterval=panInterval+1.5) {
      
      panServo.write(panInterval);
      
      // get voltage reading from ir sensor
      float ir_voltage = analogRead(irPin);
      float distance = (ir_voltage - 658.41)/-7.5797; // convert voltage to distance with calibration

      // transmit one line of text to Matlab with 2 numeric values
      Serial.print(distance);     Serial.print(",");
      Serial.println(panInterval);
      
      // delay after sending data so the serial connection is not over run
      delay(500);
  }
}
