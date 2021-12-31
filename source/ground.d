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
 * The ground is represented by a 2d array. Inside the array is the playground area including
 * the WALL, the SNAKE and the FOOD.
 */
class Ground
{

    invariant { assert(playgroundWidth <= maxSide && playgroundHeight <= maxSide); }

    ///
    this()
    {
        ground = 0; // as of D2, we can not initialize matrix arrays in class body

        for (int i = 0; i <= playgroundWidth; ++i)
        {
            //top & bottom wall
            ground[i][0] = WALL;
            ground[i][playgroundHeight] = WALL;
        }

        for (int i = 0; i <= playgroundHeight+1; ++i)
        {
            //right & left wall
            ground[0][i] = WALL;
            ground[playgroundWidth][i] = WALL;
        }

        updateSnakePosition(); // Put the snake on the ground
        updateFoodToken(); // Put a first food token on ground
    }


    /**
     * Return the number of food tokens consumed minus one
     * UFCS name
     */
    int foodCount() { return foodCounter-1; }


    /**
     * Return the number of food tokens consumed minus one
     * UFCS name
     */
    Coordinate playgroundBottom() { return Coordinate(0, playgroundHeight+1); }

    /**
     * Record the position of the snake in the 2d ground array
     */
    void updateSnakePosition()
    out
    {
        foreach (Coordinate snkCell; snake)
        {
            // Error if snake reaches outside the WALL
            assert(snkCell.x >= 0 && snkCell.x <= playgroundWidth);
            assert(snkCell.y >= 0 && snkCell.y <= playgroundHeight);
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
        writeln("** [Ground] setSnakePosition() unittest **");

        Ground g = new Ground;
        assert(g.ground[playgroundCenter.x][playgroundCenter.y] == SNAKE_HEAD);
        /+
        for( int x = 1; x < playgroundWidth; ++x)
            for(int y = 1; y < playgroundHeight; ++y)
                if ( g.ground[x][y] == SNAKE )
                    writeln("snake cell at (", x, ",", y, ")");
        +/
    }


    /**
     * Update the position of the snake according to user input
     *
     * Only update the ground[][] 2d array, not the display
     * Returns: False if the snake hit a wall or itself, True otherwise
     */
    bool updateSnakePosition(Direction userDirection)
    {
        // Mark the snake cells "dirty"
        foreach (Coordinate snkCell; snake)
            ground[snkCell.x][snkCell.y] = DIRTY;

        //TODO should be placed at beginnig of func?
        snake.updateBody(userDirection); // TODO should return false if eat itself

        switch (ground[snake.head.x][snake.head.y])
        {
            case WALL:  // Snake hit the wall
            case DIRTY: // Snake hit its won body
                return false;
            case FOOD:
                snake.growBody();
                updateSnakePosition();
                updateFoodToken();
                break;
            default:
                updateSnakePosition();
        }

        return true;
    }


    /**
     * Put a food token at random on the playground
     *
     * Only update the ground[][] 2d array, not the display
     */
    Coordinate updateFoodToken()
    out (foodTokenPos) {
        assert(foodTokenPos.x > 0 && foodTokenPos.x < playgroundWidth
                && foodTokenPos.y > 0 && foodTokenPos.y < playgroundHeight);
    }
    do
    {
        import std.random;

        int x, y;
        do
        {
            x = uniform(1, playgroundWidth - 1); // 1 and -1 to account for the walls
            y = uniform(1, playgroundHeight - 1);

        } while (ground[x][y] != EMPTY);

        ground[x][y] = FOOD;
        foodCounter++;

        return Coordinate(x,y); // return value to be used in contract
    }


    /**
     * Display initial ground[][] data in the terminal
     *
     * Architecture wise, we could reverse caller/parameter, ie have a member function of Terminal
     * so that we can call term.initDisplay(ground). But Terminal is a struct and can not be
     * subclassed. Also this construction allows to output to another io by overloading initDisplay.
     */
    void initDisplay(ref Terminal term)
    {
        term.clear();
        for( int i = 0; i <= playgroundWidth; ++i)
            for(int j = 0; j <= playgroundHeight; ++j)
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
     * Update the display according to ground[][] data and user input
     *
     * This is the game loop main function. For architecture, see initDisplay().
     * Returns: False if snake hit a wall or itself, True otherwise
     */
    bool update(ref Terminal term, Direction userDirection)
    {
        if( !updateSnakePosition(userDirection) )
            return false;

        for( int i = 0; i <= playgroundWidth; ++i)
            for(int j = 0; j <= playgroundHeight; ++j)
            {
                switch(ground[i][j])
                {
                    case DIRTY:
                        term.moveTo(i,j);
                        term.write(" ");
                        ground[i][j] = EMPTY;
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

        return true;
    }


private:
    enum CellType { EMPTY, WALL, SNAKE, SNAKE_HEAD, FOOD, DIRTY }; /// Cell type
    alias EMPTY = CellType.EMPTY;
    alias WALL = CellType.WALL;
    alias SNAKE = CellType.SNAKE;
    alias SNAKE_HEAD = CellType.SNAKE_HEAD;
    alias FOOD = CellType.FOOD;
    alias DIRTY = CellType.DIRTY;

    static immutable maxSide = 100; /// maximum height / width of the ground
    static immutable playgroundWidth = 47; /// Ground where the snake can move
    static immutable playgroundHeight = 22; /// ditto
    static immutable playgroundCenter = Coordinate(playgroundWidth/2, playgroundHeight/2); ///

    CellType [maxSide][maxSide] ground; /// usage: ground[line][column]
    int foodCounter = 0;

    Snake snake = new Snake(playgroundCenter);
}
