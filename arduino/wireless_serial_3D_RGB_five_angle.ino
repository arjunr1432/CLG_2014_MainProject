#include <Servo.h> 

int ang1,ang2,ang3,ang4,ang5;
String str;
char rd;
Servo myservo1;
Servo myservo2;
Servo myservo3;
Servo myservo4;
Servo myservo5;
Servo myservo6;


void setup()  {
   Serial.begin(9600);
   Serial.println( "Arduino started recieving bytes via XBee" );
   myservo1.attach(3);
   myservo2.attach(5);
   myservo3.attach(6);
   myservo4.attach(9);
   myservo5.attach(10);
   myservo6.attach(11);
   
   myservo5.write(180);
   myservo4.write(90);
   
   // set the data rate for the SoftwareSerial port
 //  xbee.begin( 9600 );
}

void loop()  {
 str = "";
  if ( Serial.available() == 21 ) 
  {
      
    while((rd=Serial.read())!='#')
    {
    str +=rd; 
    }  
    str +=rd;
   
    if(str.startsWith("$") && (str.endsWith("#")) && str.length() == 21)
      {
        
        ang1=(str.substring(1,4)).toInt();
        ang2=(str.substring(5,8)).toInt();
        ang3=(str.substring(9,12)).toInt();
        ang4=(str.substring(13,16)).toInt();
        ang5=(str.substring(17,20)).toInt();
      
        
        myservo1.write(ang1);
        myservo2.write(ang2);
        myservo3.write(ang3);
        myservo4.write(90);
        myservo5.write(ang4);
        myservo6.write(ang5);
        
        
        Serial.print(ang1);
        Serial.print(" ");
        Serial.print(ang2);
        Serial.print(" ");
        Serial.print(ang3);
        Serial.print(" ");
        Serial.print(ang4);
        Serial.print(" ");
        Serial.println(ang5);
        
        
        
               
      } 
    
  }
 
  
}

