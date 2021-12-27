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
    auto terminal = Terminal(ConsoleOutputType.linear);
    auto input = RealTimeConsoleInput(&terminal, ConsoleInputFlags.allInputEventsWithRelease);

    Ground ground = new Ground;
    ground.initDisplay(terminal);

    Direction userDirection = Direction.RIGHT;
    bool isPlaying = true;
    while (isPlaying)
    {
        /// previousDirection: do not allow the snake to crawl on its own body
        immutable previousDirection = userDirection;

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
                    if (previousDirection != Direction.DOWN)
                        userDirection = Direction.UP;
                    break;
                case KeyboardEvent.Key.DownArrow:
                    if (previousDirection != Direction.UP)
                        userDirection = Direction.DOWN;
                    break;
                case KeyboardEvent.Key.LeftArrow:
                    if (previousDirection != Direction.RIGHT)
                        userDirection = Direction.LEFT;
                    break;
                case KeyboardEvent.Key.RightArrow:
                    if (previousDirection != Direction.LEFT)
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
        //writeln("snake update, direction ", userDirection, " ", sw.peek.total!"msecs");

        ground.update(terminal, userDirection);

    }

    return 0;
}

