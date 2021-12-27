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
 * The ground is represented by a 2d array. Inside the array is the playground area.
 * Inside the playground the snake and food tokens to catch.
 */
class Ground
{
    enum { EMPTY, WALL, SNAKE, SNAKE_HEAD, FOOD, DIRTY }; /// Cell type

    static immutable maxSide = 100; /// maximum height / width of the ground
    static immutable playgroundWidth = 77; /// Ground where the snake can move
    static immutable playgroundHeight = 22; /// ditto
    static immutable playgroundCenter = Coordinate(playgroundWidth/2, playgroundHeight/2); ///

    invariant { assert(playgroundWidth <= maxSide && playgroundHeight <= maxSide); }

    ///
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

        updateSnakePosition(); // Put the snake on the ground
        updateFoodToken(); // Put a first food token on ground
    }


    /**
     * Return the number of food tokens consumed minus one
     * UFCS name
     */
    int foodCount() { return foodCounter; }


    /**
     * Record the position of the snake in the 2d ground array
     */
    void updateSnakePosition()
    out
    {
        foreach (Coordinate snkCell; snake)
        {
            // Error if snake reaches outside the WALL
            assert(snkCell.x > 0 && snkCell.x < playgroundWidth+2);
            assert(snkCell.y > 0 && snkCell.y < playgroundHeight+2);
        }
    }
    do
    {
        foreach (Coordinate snkCell; snake)
            ground[snkCell.x][snkCell.y] = SNAKE;

        ground[snake.head.x][snake.head.y] = SNAKE_HEAD;
    }
    unittest
    {
        import std.stdio;
        writeln("** Ground setSnakePosition unittest **");

        Ground g = new Ground;
        assert(g.ground[playgroundCenter.x][playgroundCenter.y] == SNAKE_HEAD);
        /+
        for( int x = 0; x < playgroundWidth; ++x)
            for(int y = 0; y < playgroundHeight; ++y)
                if ( g.ground[x][y] == SNAKE )
                    writeln("snake cell at (", x, ",", y, ")");
        +/
    }


    /**
     * Update the position of the snake according to user input
     *
     * Only update the 2d array, not the terminal
     */
    void updateSnakePosition(Direction userDirection)
    {
        // Mark the snake cells "dirty"
        foreach (Coordinate snkCell; snake)
            ground[snkCell.x][snkCell.y] = DIRTY;

        snake.updateBody(userDirection);
        updateSnakePosition(); // Draw new snake
    }


    /**
     * Put a food token at random on the playground
     *
     * Only update the 2d array, not the terminal
     */
    void updateFoodToken()
    out {
        assert(foodTokenPos.x <= playgroundWidth
                && foodTokenPos.y <= playgroundHeight);
    }
    do
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

        foodTokenPos = Coordinate(x,y);
    }


    /**
     * Display initial ground[][] data in the terminal
     *
     */
    void initDisplay(ref Terminal term)
    {
        term.clear();
        for( int i = 0; i <= playgroundWidth+1; ++i)
            for(int j = 0; j <= playgroundHeight+1; ++j)
            {
                term.moveTo(i,j);
                switch(ground[i][j])
                {
                    case EMPTY:
                        term.write(" ");
                        break;
                    case WALL:
                        term.write("\u25FB");
                        break;
                    case SNAKE:
                        term.write("\u00A4");
                        break;
                    case SNAKE_HEAD:
                        term.write("\u03A6");
                        break;
                    case FOOD:
                        term.write("\u2022");
                        break;
                    default:
                        break;
                }
            }
        term.writeln();
    }


    /**
     * Update the terminal according to ground[][] data and user input
     *
     * Game loop main func
     */
    void update(ref Terminal term, Direction userDirection)
    {
        updateSnakePosition(userDirection);
        if( snake.head == foodTokenPos )
        {
            import std.stdio;
            write("I love mice!");
            // snake.grow()
        }
        // else if snake hits the wall
        // else if snake eats itself

        for( int i = 1; i <= playgroundWidth; ++i)
            for(int j = 1; j <= playgroundHeight; ++j)
            {
                switch(ground[i][j])
                {
                    case DIRTY:
                        term.moveTo(i,j);
                        term.write(" ");
                        break;
                    case SNAKE:
                        term.moveTo(i,j);
                        term.write("\u00A4");
                        break;
                    case SNAKE_HEAD:
                        term.moveTo(i,j);
                        term.write("\u03A6");
                        break;
                    case FOOD:
                        term.moveTo(i,j);
                        term.write("\u2022");
                        break;
                    default:
                        break;
                }
            }
        term.moveTo(0,playgroundHeight+2);
        term.writeln();
    }

private:
    int[maxSide][maxSide] ground; /// usage: ground[column][line]
    int foodCounter = 0;

    Snake snake = new Snake(playgroundCenter);
    Coordinate foodTokenPos;
}
