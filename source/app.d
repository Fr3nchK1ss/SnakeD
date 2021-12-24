/**
 * Authors: ThePoorEngineer, Fr3nchk1ss
 * Date: 10/2021
 * https://thepoorengineer.com/en/snake-cplusplus/
 */

module main;

import std.conv;
import std.stdio;
import std.uni;
// Windows
import core.sys.windows.windows;

import ground;
import snake;


/**
 * Simulate a first round to initialize the game
 */
void firstRound()
{
	
}


int main()
{
	immutable delay = 50;

	version(Windows)
	{
		import winconsole;
		WinConsole console = new WinConsole;
	}
	else version(linux)
	{
		import nixconsole;
		NixConsole console = new NixConsole;
	}
	else
		static assert(0, "OS not supported!");

	Ground ground = new Ground;
	Snake snake = new Snake(ground.playgroundCenter);

	// Let the ground know the snake's position
	ground.setSnakePosition(snake);
	ground.updateFoodToken(console);

	// make a thread to fetch user input
	// while (true)
	//   if ( delay passed )
	//     if (user input)
	//       move snake in given direction
	//     else
	//       keep moving in same direction

	return 0;
}





