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


import winconsole;
import ground;
import snake;



int main(string[] args)
{
    int delay = 50;

    WinConsole console = new WinConsole;
    Ground ground = new Ground;
    Snake snake = new Snake(ground.playgroundCenter);

    // Let the ground know the snake's position
    ground.setSnakePosition(snake);
    ground.updateFoodToken(console);





	return 0;
}




