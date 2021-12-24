/**
 * Authors: Fr3nchk1ss
 * Date: 10/2021
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
	// Using https://code.dlang.org/packages/arsd-official%3Aterminal
	auto terminal = Terminal(ConsoleOutputType.linear);

	Ground ground = new Ground;
	Snake snake = new Snake(ground.playgroundCenter);

	// Let the ground know the snake's position
	ground.setSnakePosition(snake);
	ground.updateFoodToken(terminal);


	// while (true)
	//   if ( delay passed )
	//     if (user input)
	//       move snake in given direction
	//     else
	//       keep moving in same direction

	return 0;
}





