/**
 * Authors: Fr3nchk1ss
 * Inspired by https://thepoorengineer.com/en/snake-cplusplus/
 * Date: 10/2021
 */

module snake;

import std.conv;

import coordinate;


/// Direction is to be used with unitMotion
enum Direction { RIGHT, LEFT, UP, DOWN}


/**
 * A snake
 */
class Snake
{
    ///
    this(Coordinate center)
    do
    {
        body = new Coordinate[startingLength];

        body[0] = center; // Head
        foreach (i; 1 .. cast(int)body.length)
            body[i] = body[i-1] - unitMotion[Direction.RIGHT];

    }
    unittest
    {
        import std.stdio;
        writeln("** [Snake] this() unittest **");
        Snake s = new Snake(Coordinate(10,10));
        assert(s.body.length == s.startingLength);
        /+
        foreach_reverse (cell; s.body)
            writeln(cell);
        +/
    }


    /**
     * Make the expression "foreach (cell; snake)" possible
     *
     * Boilerplate code for opApply
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
     * Move body according to user input
     */
    bool updateBody(Direction direction)
    in {
        // The snake shall not backtrack on itself
        assert(body[0] + unitMotion[direction] != body[1]);
    }
    do
    {
        immutable Coordinate newHead = body[0] + unitMotion[direction];

        // The snake can not crawl on any part of its own body
        foreach ( const cell; body )
        {
            if(newHead == cell)
                return false;
        }

        immutable Coordinate[] previous = body.dup;

        body[0] = newHead; // update head
        body[1..$] = previous[0..$-1]; // update remaining body
        previousTail = previous[$-1]; // save tail if needed for growth

        return true;
    }
    unittest
    {
        import std.stdio;
        writeln("** [Snake] updateBody() unittest **");
        Snake s = new Snake(Coordinate(10,10));
        assert(s.startingLength <= 10); // hardcoded

        s.updateBody(Direction.DOWN);
        assert(s.previousTail == Coordinate(10-(s.startingLength-1),10));

        assert(s.body.length == s.startingLength);  // Length unchanged
        assert(s.head == Coordinate(10, 10+1));     // Head moved down
        foreach (i; 1 .. cast(int)s.body.length)    // Remaining body translated by 1
            assert(s.body[i] == Coordinate(10+1-i, 10));
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

        Snake s = new Snake(Coordinate(100,100));
        assert(s.startingLength <= 100);

        assert(s.body[$-1] == Coordinate(100-(s.startingLength-1),100)); // Tail where expected
        s.updateBody(Direction.RIGHT);
        s.growBody();

        assert(s.body.length == s.startingLength+1);
        assert(s.body[$-1] == Coordinate(100-(s.startingLength-1),100)); // update + grow left tail unchanged
    }


private:
    Coordinate[] body; /// The body of the snake is a continuous line of cells
    immutable startingLength = 4;
    Coordinate previousTail = Coordinate(-1, -1);/// Variable needed for the snake growth
    Coordinate[5] unitMotion = [{1,0}  /*RIGHT*/,
                                {-1,0} /*LEFT*/,
                                {0,-1} /*UP*/,
                                {0,1}  /*DOWN*/];

}
