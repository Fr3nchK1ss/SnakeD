/**
 * Authors: Fr3nchk1ss
 * Inspired by https://thepoorengineer.com/en/snake-cplusplus/
 * Date: 10/2021
 */

module snake;

import std.conv;

import coordinate;


/// Direction is to be used with unitMotion
enum Direction { RIGHT=0, LEFT, UP, DOWN, UNDEFINED}


class Snake
{

    this(Coordinate center)
    in {
        assert(bodyLength >= 4);
    }
    do
    {
        body = new Coordinate[bodyLength];

        // Draw the starting body
        body[0] = center;

        for (int i = 1; i < body.length; ++i)
            body[i] = body[i-1] - unitMotion[Direction.RIGHT];

    }
    unittest
    {
        import std.stdio;
        writeln("** [Snake] this() unittest **");

        Snake s = new Snake(Coordinate(10,10));
        assert(s.body.length == s.bodyLength);
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
    //TODO unittest


    /**
     * UFCS name
     */
    Coordinate head() { return body[0]; }


    /**
     * Update body according to user input
     */
    void updateBody(Direction direction)
    in {
        // The snake must not backtrack on itself
        assert(body[0] + unitMotion[direction] != body[1]);
        // The snake must not crawl over itself TODO
        //foreach ( const cell; body )
        //    assert(body[0] + unitMotion[direction] != cell);
    }
    do
    {
        Coordinate[] previous = body.dup;

        // update head
        body[0] = body[0] + unitMotion[direction];

        // update remaining body
        body[1..$] = previous[0..$-1];
        previousTail = previous[$-1];
    }
    unittest
    {
        import std.stdio;
        writeln("** [Snake] updateBody() unittest **");
        Snake s = new Snake(Coordinate(10,10));

        s.updateBody(Direction.DOWN);
        assert(s.body.length == s.bodyLength);
        assert(s.head == Coordinate(10, 11));
        assert(s.body[1] == Coordinate(10,10)
                && s.body[2] == Coordinate(9,10)
                && s.body[3] == Coordinate(8,10));
        assert(s.previousTail == Coordinate(7,10));
    }


    /**
     * Add one cell at the end of the body
     *
     * Called if a food token has been eaten
     */
    void growBody()
    in {
        // updateBody() must be called a first time before any call to growBody()
        assert(previousTail != Coordinate(-1, -1));
    }
    do
    {
        body.length += 1;
        body[$-1] = previousTail;
    }
    unittest
    {
        import std.stdio;
        writeln("** [Snake] growBody() unittest **");

        Snake s = new Snake(Coordinate(200,200)); // assume bodyLength == 4
        s.updateBody(Direction.RIGHT); // should be body[$-1] == 198
        s.growBody(); // should be bodyLength == 5, body[$-1] == 197

        assert(s.body.length == s.bodyLength+1);
        assert(s.body[$-1] == Coordinate(197,200));
    }


private:
    Coordinate[] body; /// The body of the snake is a continuous line of cells
    immutable bodyLength = 4;
    Coordinate previousTail = Coordinate(-1, -1);/// Needed for the snake to grow
    Coordinate[5] unitMotion = [{1,0}  /*RIGHT*/,
                                {-1,0} /*LEFT*/,
                                {0,-1} /*UP*/,
                                {0,1}  /*DOWN*/,
                                {0,0} /*UNDEFINED*/];

}
