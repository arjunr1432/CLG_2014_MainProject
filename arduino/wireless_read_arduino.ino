#include <SoftwareSerial.h>

//SoftwareSerial xbee(2, 3); // RX, TX
int  pingPong = 1;
char a;
void setup()  {
   Serial.begin(9600);
   Serial.println( "Arduino started recieving bytes via XBee" );

   // set the data rate for the SoftwareSerial port
 //  xbee.begin( 9600 );
}

void loop()  {
  // send character via XBee to other XBee connected to Mac
  // via USB cable
  if ( Serial.available() > 0) {
      a = Serial.read();
  
      //--- display the character just sent on console ---
      Serial.println( a );
  }
 
  //--- switch LED on Arduino board every character sent---
//  if ( pingPong == 0 )
//    digitalWrite(13, LOW);
//  else
//    digitalWrite(13, HIGH);
//  pingPong = 1 - pingPong;
//  delay( 1000 );
}
