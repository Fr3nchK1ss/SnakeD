/**
 * Authors: Fr3nchk1ss
 * Date: 11/2021
 */

module coordinate;


/**
 * Define a typical x / y point
 */
struct Coordinate
{
    int x; /// x is a console column number
    int y; /// y is a console line number and increases when going down

    invariant
    {
        // console coordinate must not be negative
        assert ( 0 <= x && 0 <= y);
    }


    ///
    bool opEquals(const Coordinate c) const
    {
        return x == c.x && y == c.y;
    }
    unittest
    {
        assert( Coordinate(123, 456) == Coordinate(123, 456), "Coordinate opEquals does not yield expected result!");
        assert( Coordinate(123, 456) != Coordinate(1, 456), "Coordinate opEquals does not yield expected result!");
    }


    ///
    Coordinate opBinary(string op)(const Coordinate rhs) const
    {
        static if (op == "+")
        {
            return Coordinate(x+rhs.x, y+rhs.y);
        }
        else static if (op == "-")
        {
            return Coordinate(x-rhs.x, y-rhs.y);
        }
        else
            static assert(0, "Operator "~op~" not implemented");

    }
    unittest
    {
        immutable Coordinate coord11 = {1, 1};
        immutable Coordinate coord22 = {2, 2};

        assert( coord22 + coord11 == Coordinate(3, 3), "Coordinate op+ does not yield expected result!");
        assert( coord22 - coord11 == coord11, "Coordinate op- does not yield expected result!");
    }
}
