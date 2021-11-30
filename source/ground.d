/**
 * Authors: ThePoorEngineer, Fr3nchk1ss
 * Date: 10/2021
 */

module ground;

import core.sys.windows.windows;
import std.conv;


/**
 * The ground
 */
class Ground
{
    immutable WALL = -2;
    static immutable maxSide = 100;
    static immutable playgroundWidth = 77;
    static immutable playgroundHeight = 22;

    this()
    {
        ground = 0; // as of D2, we can not initialize matrix arrays in class body
    }

    /**
     * initialize a virtual square playground
     */
    void initGround()
    {
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

private:
    int[maxSide][maxSide] ground;

}
