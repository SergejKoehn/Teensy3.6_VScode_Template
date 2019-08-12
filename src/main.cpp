#include "Arduino.h"        
#include "Audio.h"
#include <Wire.h>
#include <SPI.h>
#include <SD.h>
#include <SerialFlash.h>

const int SDchipSelect = BUILTIN_SDCARD;
File directory;
File myfile;

void printDirectory(File dir, int numTabs) 
{
   while(true) 
   {
     File entry =  dir.openNextFile();

     if (! entry) 
     {
       // no more files
       //Serial.println("**nomorefiles**");
       break;
     }

     for (uint8_t i=0; i<numTabs; i++) 
     {
       Serial.print('\t');
     }

     Serial.print(entry.name());

     if (entry.isDirectory()) 
     {
       Serial.println("/");
       printDirectory(entry, numTabs+1);
     } 
     else
     {
       // files have sizes, directories do not
       Serial.print("\t\t");
       Serial.println(entry.size(), DEC);
     }

     entry.close();
     delay(200);
   }
}

void setup() 
{
  Serial.begin(9600);

  Serial.print("Initializing SD card...");

  if (!SD.begin(SDchipSelect)) {
    Serial.println("initialization failed!");
    return;
  }
  Serial.println("initialization done.");
  directory = SD.open("/");
  printDirectory(directory, 1);
}

void loop() 
{
  Serial.println("Hello World Home DIR!!!");
  delay(1000);
}
