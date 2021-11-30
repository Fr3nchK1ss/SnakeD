/**
 * Authors: ThePoorEngineer, Fr3nchk1ss
 * Date: 10/2021
 */

module snake;

import core.sys.windows.windows;
import std.conv;


import coordinate;
import ground;

enum Direction { RIGHT, LEFT, UP, DOWN };


/**
 * The ground
 */
class Snake
{
    this()
    {
        body[0].x = Ground.playgroundWidth/2;
        body[0].y = Ground.playgroundHeight/2;

        // Draw the body
        for (int i = 1; i < length; ++i)
            body[i] = body[i-1] - unitMotion[direction];
    }
    unittest
    {
        Snake s = new Snake();

        assert(s.length == 4 && s.foodCounter == 0 && s.direction == Direction.init);
    }


    /**
     * ?
     */
    void updateBody(int delay)
    {
        Coordinate[Ground.playgroundWidth*Ground.playgroundHeight] previous;
        for(int i = 0; i < length; ++i)
            previous[i] = body[i];

        //if (input != )

    }

/+
    void updateFood();
    void firstDraw();
    int getFoodCounter();
+/
private:
    int length = 4;
    // Ground.playgroundWidth*Ground.playgroundHeight is the max body length
    Coordinate[Ground.playgroundWidth*Ground.playgroundHeight] body;
    Coordinate[4] unitMotion = [{1,0} /*RIGHT*/,
                                {-1,0} /*LEFT*/,
                                {0,-1} /*UP*/,
                                {0,1} /*DOWN*/];
    int direction = Direction.init;
    int foodCounter = 0;

    int[4] dx = 0;
    int[4] dy = 0;

}
