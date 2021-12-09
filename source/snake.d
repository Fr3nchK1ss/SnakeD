/**
 * Authors: ThePoorEngineer, Fr3nchk1ss
 * Date: 10/2021
 */

module snake;

import core.sys.windows.windows;
import std.conv;

import coordinate;

enum Direction { RIGHT, LEFT, UP, DOWN };


class Snake
{
    this(Coordinate center)
    {
		body.length = 4;
        body[0] = center;

        // Draw the body
        for (int i = 1; i < length; ++i)
            body[i] = body[i-1] - unitMotion[direction];

    }
    unittest
    {
        Snake s = new Snake;
        assert(s.length == 4 && s.foodCounter == 0 && s.direction == Direction.init);
    }


    Coordinate opCall(int bodySegment)
    {
        return body[bodySegment];
    }

    int getLength() { return length; }


    /**
     * ?
     */
    void updateBody(int delay)
    {
        Coordinate[] previous;
        for(int i = 0; i < length; ++i)
            previous[i] = body[i];

        //if (input != )

    }


private:
    int direction = Direction.init;
    int length = 4;
    Coordinate[] body;
    Coordinate[4] unitMotion = [{1,0}  /*RIGHT*/,
                                {-1,0} /*LEFT*/,
                                {0,-1} /*UP*/,
                                {0,1}  /*DOWN*/];

}
