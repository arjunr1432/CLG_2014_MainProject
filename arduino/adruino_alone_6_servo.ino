// Sweep
// by BARRAGAN <http://barraganstudio.com> 
// This example code is in the public domain.


#include <Servo.h> 
 
Servo myservo,myservo2,myservo3,myservo4,myservo5,myservo6;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
 
int pos = 0;    // variable to store the servo position 
 
void setup() 
{ 
  myservo.attach(3);  // attaches the servo on pin 9 to the servo object 
  myservo2.attach(5);
  myservo3.attach(6);
  myservo4.attach(9);
  myservo5.attach(10);
  myservo6.attach(11);
  
//    myservo.write(90);              // tell servo to go to position in variable 'pos' 
//    
//    myservo2.write(90);              // tell servo to go to position in variable 'pos' 
//
//    myservo3.write(90);              // tell servo to go to position in variable 'pos' 
//
//    myservo4.write(90);              // tell servo to go to position in variable 'pos' 
//
//    myservo5.write(90);              // tell servo to go to position in variable 'pos' 
//
//    myservo6.write(0);              // tell servo to go to position in variable 'pos' 

} 
 
 
void loop() 
{ 
                      
    myservo.write(90);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
    myservo2.write(0);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
    myservo3.write(90);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
    myservo4.write(90);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
    myservo5.write(90);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
    myservo6.write(0);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
  
} 
