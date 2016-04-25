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

    int order = 0;
	int index = 0;
	while (go == 1)
	{
        // Write goal position
        cout << "What do you want to do ? (-1 to quit, -2 for help)" << endl;
        cin >> order;
        if (-1 == order)
            break;
        else if (-2 == order)
        {
            cout << endl;
            cout << "Enter -1 to quit" << endl;
            cout << "Enter 1 for another test cycle" << endl;
            cout << "Enter 2 to change the speed limit " << endl;
        }
        else if (1 == order)
        {
            testCycleMode(index);
			index = (index + 1) % 2;
        }
        else if (2 == order)
        {
            cout << "What limit do you want to set ?" << endl;
            cin >> order;
            setSpeedLimit(order);
            cout << "Speed limit set to " << order << endl;
        }
	}

	// Close device
	dxl_terminate();
	cout << "Press any key to terminate..." << endl;
	_getch();
	return 0;
}