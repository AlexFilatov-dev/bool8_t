#include "bool8_t/bool8_t.hpp"

// create the default instance. All flags is false
bool8_t bool8;

void setup()
{
	// change the flags
	bool8.flag0 = true;
	bool8.flag3 = true;

	// write the all flags using overloaded operator []	
	Serial.println("bool8_t flags:");
	for (int i = 0; i < bool8.flagCount(); ++i)
	{
	    Serial.print(i);
	    Serial.print(") ");
	    Serial.println(bool8[i]);
	}

	// set value for the all flags
	bool8 = false;
	if (!bool8)
		Serial.println("All flags of the bool8 is false");

	// inverse flags
	bool8.inverse();
	if (bool8)
		Serial.println("All flags of the bool8 is true");
}

void loop()
{
}