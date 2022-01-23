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
    auto terminal = Terminal(ConsoleOutputType.linear); /// using arsd module
    auto input = RealTimeConsoleInput(&terminal, ConsoleInputFlags.allInputEventsWithRelease);

    Ground ground = new Ground; ///
    ground.initDisplay(terminal);

    Direction userDirection = Direction.RIGHT; /// Snake starts facing East
    bool isPlaying = true; /// Game on!
    bool isPause = false; ///


    /// displayScore delegate
    void displayScore()
    {
        terminal.moveTo(ground.playgroundBottom.x, ground.playgroundBottom.y);
        terminal.writeln("  Score : ", ground.foodCount);
    }

    /// gameOver delegate
    void gameOver()
    {
        displayScore;
        terminal.writeln("***** GAME OVER! *****");
        isPlaying = false;
    }

    /// game loop
    while (isPlaying)
    {
        /// previousDirection: do not allow the snake to crawl on its own body
        immutable previousDirection = userDirection;

        immutable sw = StopWatch(AutoStart.yes);
        while (sw.peek.total!"msecs" < 300)
        {
            /*
             * We use a stopwatch and kbhit() because the snake shall move every 300ms
             * even if the player does not give any new direction.
             * A player reaction time is around 200ms
             */
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
                case KeyboardEvent.Key.ScrollLock :
                    isPause = !isPause;
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

        if (isPause)
            continue;

        if (ground.update(terminal, userDirection))
            displayScore;
        else
            gameOver;

    }

    return 0;
}

