#include <Servo.h> 

int ang1,ang2;
String str;
char rd;
Servo myservo1;
Servo myservo2;
Servo myservo3;



void setup()  {
   Serial.begin(9600);
   Serial.println( "Arduino started recieving bytes via XBee" );
   myservo1.attach(3);
   myservo2.attach(5);
  
   
   // set the data rate for the SoftwareSerial port
 //  xbee.begin( 9600 );
}

void loop()  {
 str = "";
  if ( Serial.available() == 9 ) 
  {
      
    while((rd=Serial.read())!='#')
    {
    str +=rd; 
    }  
    str +=rd;
   
    if(str.startsWith("$") && (str.endsWith("#")) && str.length() == 9)
      {
        
        ang1=(str.substring(1,4)).toInt();
        ang2=(str.substring(5,8)).toInt();
        
        if(ang1<180 && ang1>0 && ang2 <180 && ang2>0 )
        {
        myservo1.write(ang1);
        myservo2.write(ang2);
      
        }
        
        Serial.print(ang1);
        Serial.print(" ");
        Serial.println(ang2);
       
      } 
    
  }
 
  
}

