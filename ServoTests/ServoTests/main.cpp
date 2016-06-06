// Windows version
#include <windows.h>
#include <iostream>
#include <conio.h>
#include "dynamixel.h"
#include "functions.h"

#pragma comment(lib, "dynamixel.lib")

using namespace std;

int main()
{
	// Open device
    if (initDevice() == 0)
		return 0;
    int go = 1;

    // Limit speed
    int speed = 0;
    cout << "What max speed do you want to set ?(-1 to quit)" << endl;
    cout << "40 seems to be a good value, 0 for no limit" << endl;
    cin >> speed;
	  if (-1 == speed)
		  go = 0;
      else
		setSpeedLimit(speed);

    int order = 0;
	int index = 0;
	int typeOfTest = 1;
	while (go == 1)
	{
        // Write goal position
		printInfos();
        cin >> order;
        if (-1 == order)
            break;
        else if (-2 == order)
        {
			printInfos();
        }
        else if (1 == order)
        {
			if (1 == typeOfTest)
			{
				int range[] = { 1700, 2000 };
				testCycleMode(index, range);
				index = (index + 1) % 2;
			}
			else if (2 == typeOfTest)
			{
				int range[] = { 1550, 3600 };
				testCycleMode(index, range);
				index = (index + 1) % 2;
			}
			else if (3 == typeOfTest)
			{
				manualMode();
			}
			else
			{
				break;
			}
        }
        else if (2 == order)
        {
            cout << "What limit do you want to set ?" << endl;
			cout << "40 seems to be a good value, 0 for no limit" << endl;
            cin >> order;
            setSpeedLimit(order);
            cout << "Speed limit set to " << order << endl;
        }
		else if (3 == order)
		{
			cout << "What test you would like to conduct ?" << endl;
			cout << "Enter 1 for the torque test" << endl;
			cout << "Enter 2 for the movement test" << endl;
			cout << "Enter 3 for manual mode" << endl;
			cin >> typeOfTest;
			cout << "Test type changed to " << typeOfTest << endl;
		}
		else if (4 == order)
		{
			cout << "Resetting servo" << endl;
			resetServo();
		}
	}

	// Close device
	dxl_terminate();
	cout << "Press any key to terminate..." << endl;
	_getch();
	return 0;
}
