/**
 * Authors: Fr3nchk1ss
 * Inspired by https://thepoorengineer.com/en/snake-cplusplus/
 * Date: 10/2021
 */

module snake;

import std.conv;

import coordinate;
import ground;


/// Direction is to be used with unitMotion
enum Direction { RIGHT=0    , LEFT, UP, DOWN, UNDEFINED}


class Snake
{
    invariant
    {
        assert(body[0].x >= 0 && body[0].x < Ground.playgroundWidth);
        assert(body[0].y >= 0 && body[0].y < Ground.playgroundHeight);
    }


    this(Coordinate center)
    out {
        // The new snake must fit in the playground
        assert(body.length <= Ground.playgroundWidth/2 - 1);
    }
    do
    {
        body = new Coordinate[4];
        body[0] = center;

        // Draw the starting body
        for (int i = 1; i < body.length; ++i)
            body[i] = body[i-1] - unitMotion[m_direction];

    }
    unittest
    {
        import std.stdio;
        writeln("** Snake ctor unittest **");

        Ground g = new Ground();
        Snake s = new Snake(g.playgroundCenter);
        assert(s.body.length == 4 && s.direction == Direction.RIGHT);
        /+
        foreach_reverse (cell; s.body)
            writeln(cell);
        +/
    }


    /**
     * Make the expression "foreach (cell; snake)" possible
     *
     * Basic boilerplate code for opApply
     * The body of a foreach becomes the special delegate "dg"
     */
    int opApply( int delegate(Coordinate) dg) const
    {
        int result;
        foreach (cell; body)
        {
            result = dg(cell);

            if (result)
                break;
        }

        return result;
    }


    /**
     * UFCS name
     */
    Coordinate head() { return body[0]; }


    /**
     * Update body according to user input
     */
    void updateBody(Direction direction)
    {
        Coordinate[] previous = body.dup;

        // update head
        body[0] = body[0] + unitMotion[direction];

        // update remaining body
        body[1..$] = previous[0..$-1];
    }


private:
    Direction m_direction; // TODO: necessary?
    Coordinate[] body; /// The body of the snake is a continuous line of cells
    Coordinate[5] unitMotion = [{1,0}  /*RIGHT*/,
                                {-1,0} /*LEFT*/,
                                {0,-1} /*UP*/,
                                {0,1}  /*DOWN*/,
                                {0,0} /*UNDEFINED*/];

}
