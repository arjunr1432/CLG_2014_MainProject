#include <Servo.h> 

int ang1=45,ang2=90,ang3=90,ang4=90,ang5=180,ang6=0;
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
   myservo1.attach(3);
   myservo2.attach(5);
   myservo3.attach(6);
   myservo4.attach(9);
   myservo5.attach(10);
   myservo6.attach(11);
  
   
  
}

void loop()  {
 str = "";
 
 
        myservo1.write(ang1);
        myservo2.write(ang2);
        myservo3.write(ang3);
        myservo4.write(ang4);
        myservo5.write(ang5);
        myservo6.write(ang6);
        
  if ( Serial.available() == 25 ) 
  {
      
    while((rd=Serial.read())!='#')
    {
    str +=rd; 
    }  
    str +=rd;
   
    if(str.startsWith("$") && (str.endsWith("#")) && str.length() == 25)
      {
        
        ang1=(str.substring(1,4)).toInt();
        ang2=(str.substring(5,8)).toInt();
        ang3=(str.substring(9,12)).toInt();
        ang4=(str.substring(13,16)).toInt();
        ang5=(str.substring(17,20)).toInt();
        ang6=(str.substring(21,24)).toInt();
        
        
        
      } 
    
  }
 
  
}

