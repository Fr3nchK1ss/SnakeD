/**
 * Authors: Fr3nchk1ss
 * Inspired by https://thepoorengineer.com/en/snake-cplusplus/
 * Date: 10/2021
 */

module ground;

public import arsd.terminal;
import std.conv;

import coordinate;
import snake;



/**
 * Ground class
 *
 * The ground is represented by a 2d array
 *
 * Inside the ground array is the playground. Inside the playground the snake and food tokens to catch.
 */
class Ground
{
    enum { EMPTY, WALL, SNAKE, SNAKE_HEAD, FOOD };

    static immutable maxSide = 100; /// maximum height / width of the ground
    static immutable playgroundWidth = 77; /// Ground where the snake can move
    static immutable playgroundHeight = 22; /// ditto
    static immutable playgroundCente = Coordinate(playgroundWidth/2, playgroundHeight/2);

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
            ground[i][0] = WALL;
            ground[i][playgroundHeight + 1] = WALL;
        }

        for (int i = 0; i <= playgroundHeight+1; ++i)
        {
            //right & left wall
            ground[0][i] = WALL;
            ground[playgroundWidth + 1][i] = WALL;
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


    /**
     * Register the position of the snake on the playground
     */
    void setSnakePosition(Snake snk)
    {
        foreach (Coordinate snkCell; snk)
        {
            ground[snkCell.x][snkCell.y] = SNAKE;
        }
        ground[snk.head.x][snk.head.y] = SNAKE_HEAD;
    }
    unittest
    {
        import std.stdio;
        writeln("** Ground setSnakePosition unittest **");

        Ground g = new Ground();
        Snake s = new Snake(g.playgroundCenter);
        g.setSnakePosition(s);
        assert(g.ground[g.playgroundCenter.x][g.playgroundCenter.y] == SNAKE);
        /+
        for( int x = 0; x < playgroundWidth; ++x)
            for(int y = 0; y < playgroundHeight; ++y)
                if ( g.ground[x][y] == SNAKE )
                    writeln("snake cell at (", x, ",", y, ")");
        +/
    }


    /**
     * Put a food token at random on the playground
     */
    void updateFoodToken(ref Terminal terminal)
    {
        import std.random;

        int x, y;
        do
        {
            x = uniform(1, playgroundWidth);
            y = uniform(1, playgroundHeight);

        } while (ground[x][y] != EMPTY);

        ground[x][y] = FOOD;
        foodCounter++;

        terminal.moveTo(x,y);
        terminal.writeln("\u2022");
    }


    /**
     * Display ground[][] on the terminal
     */
    void initDisplay(ref Terminal terminal)
    {
        updateFoodToken(terminal); // put a first food token in ground[][]

        terminal.clear();
        for( int i = 0; i <= playgroundWidth+1; ++i)
            for(int j = 0; j <= playgroundHeight+1; ++j)
            {
                terminal.moveTo(i,j);
                switch(ground[i][j])
                {
                    case EMPTY:
                        terminal.write(" ");
                        break;
                    case WALL:
                        terminal.write("\u25FB");
                        break;
                    case SNAKE:
                        terminal.write("\u00A4");
                        break;
                    case SNAKE_HEAD:
                        terminal.write("\u03A6");
                        break;
                    default:
                        break;
                }
            }
        terminal.writeln();

    }


private:
    int foodCounter = 0;
    int[maxSide][maxSide] ground; /// usage: ground[column][line]

}
