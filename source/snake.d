/**
 * Authors: ThePoorEngineer, Fr3nchk1ss
 * Date: 10/2021
 */

module snake;

import core.sys.windows.windows;
import std.conv;


import coordinate;
import ground;

/// Direction is to be used with unitMotion
enum Direction { RIGHT, LEFT, UP, DOWN };


class Snake
{
    this(Coordinate center)
    {
        body.length = 4;
        body[0] = center;

        // Draw the body
        for (int i = 1; i < body.length; ++i)
            body[i] = body[i-1] - unitMotion[direction];

    }
    unittest
    {
        Ground g = new Ground();
        Snake s = new Snake(g.playgroundCenter);
        assert(s.length == 4 && s.direction == Direction.init);
    }


    /**
     * Implemented so that snake(i) returns the coordinate body[i]
     */
    Coordinate opCall(int bodySegment)
    {
        return body[bodySegment];
    }


    /**
     * Getter for length
     * Universal Function Call Syntax
     */
    ulong length() { return body.length; }


    /**
     * Update body according to user input
     */
    void updateBody(int delay)
    {
        Coordinate[] previous = body[];

        // update head
        body[0] = body[0] + unitMotion[direction];
    	
        // update remaining body
        body[1..$] = previous[0..$-1];

    }


private:
    int direction = Direction.init;
    Coordinate[] body;
    Coordinate[4] unitMotion = [{1,0}  /*RIGHT*/,
                                {-1,0} /*LEFT*/,
                                {0,-1} /*UP*/,
                                {0,1}  /*DOWN*/];

}
