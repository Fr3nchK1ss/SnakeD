/**
 * Authors: Fr3nchk1ss
 * Date: 10/2021
 */

module main;

import core.thread;
import std.conv;
import std.datetime.stopwatch;
import std.stdio;
import std.uni;

import ground;
import snake;


int main()
{
	Ground ground = new Ground;
	Snake snake = new Snake(ground.playgroundCenter);
	ground.setSnakePosition(snake);

	// Using https://code.dlang.org/packages/arsd-official%3Aterminal
	auto terminal = Terminal(ConsoleOutputType.linear);
	auto input = RealTimeConsoleInput(&terminal, ConsoleInputFlags.allInputEventsWithRelease);
	ground.initDisplay(terminal);

	bool isPlaying = true;
	while (isPlaying)
	{
		Direction userDirection = Direction.UNDEFINED;

		/*
		 * We use a stopwatch and kbhit() because the snake shall move every 500ms
		 * even if the player does not give any new direction.
		 * A player reaction time is around 200ms, allowing for a couple of input.
		 */
		immutable sw = StopWatch(AutoStart.yes);
		while (sw.peek.total!"msecs" < 500)
		{
			if (input.kbhit()) switch (input.getch())
			{
				case KeyboardEvent.Key.UpArrow:
					userDirection = Direction.UP;
					break;
				case KeyboardEvent.Key.DownArrow:
					userDirection = Direction.DOWN;
					break;
				case KeyboardEvent.Key.LeftArrow:
					userDirection = Direction.LEFT;
					break;
				case KeyboardEvent.Key.RightArrow:
					userDirection = Direction.RIGHT;
					break;
				case KeyboardEvent.Key.escape:
					isPlaying = false;
					break;

				default:
					break;
			}

			Thread.sleep(10.msecs);
		}
		writeln("snake update, direction ", userDirection, " ", sw.peek.total!"msecs");

	}

	return 0;
}

