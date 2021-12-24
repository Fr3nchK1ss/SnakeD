/**
 * Authors: ThePoorEngineer, Fr3nchk1ss
 * Date: 10/2021
 */

module ground;

import core.sys.windows.windows;
import std.conv;

import coordinate;
import snake;
import iconsole;


/**
 * Ground class
 *
 * The ground is represented by a 2d array whose first dimension is Y, not X.
 * This is because reading a console is like reading a book, starting up-left and going down line by line
 *
 * Inside the ground array is the playground. Inside the playground the snake and food tokens to catch.
 */
class Ground
{
    static immutable WALL = -2; /// used in the ground array to indicate a wall
    static immutable SNAKE = -1; /// ditto
    static immutable EMPTY = 0; /// ditto
    static immutable FOOD = 1; /// ditto

    static immutable maxSide = 100; /// maximum height / width of the ground
    static immutable playgroundWidth = 77; /// playground is the part of the ground where the snake can move
    static immutable playgroundHeight = 22; /// ditto

    invariant
    {
        assert(playgroundWidth <= maxSide && playgroundHeight <= maxSide);
    }


    this()
    {
        ground = 0; // as of D2, we can not initialize matrix arrays in class body

        for (int i = 0; i <= playgroundWidth+1; ++i)
        {
            //top & bottom wall
            ground[0][i] = WALL;
            ground[playgroundHeight + 1][i] = WALL;
        }

        for (int i = 0; i <= playgroundHeight+1; ++i)
        {
            //right & left wall
            ground[i][0] = WALL;
            ground[i][playgroundWidth + 1] = WALL;
        }
    }


    /**
     * Return the center of the playground
     * UFCS name
     */
    Coordinate playgroundCenter()
    {
        return Coordinate(playgroundWidth/2, playgroundHeight/2);
    }


    /**
     * Return the number of food tokens consumed minus one
     * UFCS name
     */
    int foodCount() { return foodCounter; }


    void setSnakePosition(Snake snk)
    {/*
        for (int i = 0; i < snk.length; ++i)
        {
            Coordinate cellCoord = snk(i);
            ground[cellCoord.y][cellCoord.x] = SNAKE;
        }
*/
        foreach (Coordinate cell; snk)
        {
            ground[cell.y][cell.x] = SNAKE;
        }
    }
    unittest
    {
        Ground g = new Ground();
        Snake s = new Snake(g.playgroundCenter);
        g.setSnakePosition(s);

        import std.stdio;
        writeln("Ground setSnakePosition unittest");
        for(int y = 0; y < playgroundHeight; ++y)
        {
            for( int x = 0; x < playgroundWidth; ++x)
            {
                if ( g.ground[y][x] == SNAKE )
                    writeln("snake cell at Coordinate(", x, ",", y, ")");
            }
        }
    }


    /**
     * Put a food token on the playground at random
     */
    void updateFoodToken(IConsole console)
    {
        import std.random;

        int x, y;
        do
        {
            x = uniform(1, playgroundWidth);
            y = uniform(1, playgroundHeight);

        } while (ground[y][x] != EMPTY);

        ground[y][x] = FOOD;
        foodCounter++;

        console.gotoxy(x,y);
        console.writeln("\u2022");
    }



private:
    int foodCounter = 0;
    int[maxSide][maxSide] ground; /// usage: ground[line][column]

}
