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
	if (initDevice(DEFAULT_PORTNUM, DEFAULT_BAUDNUM) == 0)
		return 0;

	// Choose mode
	int mode = selectMode();

	int go = 1;
	while (go == 1)
	{
		cout << "Press any key to continue!(press ESC to quit)" << endl;
		if (_getch() == 0x1b)
			break;

		// Write goal position
		switch (mode) {
		case 1:
			manualMode();
			break;
		case 2:
			go = 0;
			break;
		default:
			break;
		}
	}

	// Close device
	dxl_terminate();
	cout << "Press any key to terminate..." << endl;
	_getch();
	return 0;
}