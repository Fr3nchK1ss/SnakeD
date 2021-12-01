/**
 * Authors: ThePoorEngineer, Fr3nchk1ss
 * Date: 10/2021
 */

module ground;

import core.sys.windows.windows;
import std.conv;

import source.coordinate;
import source.game;
import source.snake;
/*
import snake;
*/


class Ground
{
    static immutable WALL = -2;
    static immutable SNAKE = -1;
    static immutable NOTHING = 0;
    static immutable FOOD = 1;

    this()
    {
        ground = 0; // as of D2, we can not initialize matrix arrays in class body

        for (int i = 0; i <= Game.playgroundWidth+1; ++i)
        {
            //top & bottom wall
            ground[0][i] = WALL;
            ground[Game.playgroundHeight + 1][i] = WALL;
        }

        for (int i = 0; i <= Game.playgroundHeight+1; ++i)
        {
            //right & left wall
            ground[i][0] = WALL;
            ground[i][Game.playgroundWidth + 1] = WALL;
        }
    }


    /**
     * Place a food token randomly on the playground
     */
    void updateFoodToken()
    {
        int x, y;
        do
        {
            x = 3% Game.playgroundWidth + 1;
            y = 3% Game.playgroundHeight + 1;
        } while (ground[y][x] != NOTHING);

        ground[y][x] = FOOD;
        //foodCounter++;
        //goto(x,y)
        // cout << "\u2022";
    }


    void setSnakePosition(Snake snk)
    {
        for (int i = 0; i < snk.getLength; ++i)
        {
            Coordinate segmentCoord = snk(i);
            ground[segmentCoord.y][segmentCoord.x] = SNAKE; // TODO: verify array order in Dlang
        }
    }


private:
    int[Game.maxSide][Game.maxSide] ground;

}
