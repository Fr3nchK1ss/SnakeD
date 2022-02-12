/**
 * Authors: Fr3nchk1ss
 * Inspired by https://thepoorengineer.com/en/snake-cplusplus/
 * Review Ali Cehreli
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

    static assert(playgroundWidth <= maxSide && playgroundHeight <= maxSide);

    ///
    this()
    {
        ground = EMPTY; // as of D2.098, we can not initialize matrix arrays in class body

        foreach (i; 0 .. playgroundWidth)
        {
            //top & bottom wall
            ground[i][0] = WALL;
            ground[i][playgroundHeight-1] = WALL;
        }

        foreach (i; 0 .. playgroundHeight)
        {
            //right & left wall
            ground[0][i] = WALL;
            ground[playgroundWidth-1][i] = WALL;
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
     * Reset all cells to EMPTY except for walls
     *
     * Used in contracts / debug
     */
    void clearGround()
    {
        foreach (i; 1 .. playgroundWidth-1)
            foreach (j; 1 .. playgroundHeight-1)
                ground[i][j] = EMPTY;
    }


    /**
     * Return the first line below the playground
     * UFCS name
     */
    Coordinate playgroundBottom() { return Coordinate(0, playgroundHeight+1); }


    /**
     * Record the position of the snake in the ground[][] array
     */
    void updateSnakePosition()
    out (;isSnakeInsidePlayground, "The snake went outside the playground!")
    {
        foreach (Coordinate snkCell; snake)
            ground[snkCell.x][snkCell.y] = SNAKE;
        ground[snake.head.x][snake.head.y] = SNAKE_HEAD;
    }
    unittest
    {
        import std.stdio;
        writeln("** [Ground] updateSnakePosition() unittest **");

        Ground g = new Ground;
        assert(g.ground[playgroundCenter.x][playgroundCenter.y] == SNAKE_HEAD);
        /+
         foreach (i; 0 .. playgroundWidth)
            foreach (j; 0 .. playgroundHeight)
                if ( g.ground[i][j] == SNAKE )
                    writeln("snake cell at (", i, ",", j, ")");
        +/
    }


    /**
     * Update the position of the snake according to user input
     *
     * Only update the ground[][] array, not the display.
     * Returns: False if the snake hit a wall or itself, True otherwise
     */
    bool updateSnakePosition(Direction userDirection)
    {
        // Mark the current snake cells as dirty
        foreach (Coordinate snkCell; snake)
            ground[snkCell.x][snkCell.y] = DIRTY;

        if (!snake.updateBody(userDirection))
            return false; // Snake hit itself

        switch (ground[snake.head.x][snake.head.y])
        {
            case WALL:  // Snake hit the wall :(
                return false;
            case FOOD:  // Snake ate the food :)
                snake.growBody();
                updateSnakePosition();
                updateFoodToken();
                break;
            default:
                updateSnakePosition();
        }

        return true;
    }
    unittest
    {
        import std.stdio;
        writeln("** [Ground] updateSnakePosition(Direction) unittest **");

        Ground g = new Ground;
        // Free range snake
        assert(g.updateSnakePosition(Direction.UP));

        // put a FOOD token in front of snake head
        g.ground[g.snake.head.x][g.snake.head.y - 1] = FOOD;
        assert(g.updateSnakePosition(Direction.UP)); // Move to food
        assert(g.foodCount == 1, "wrong food count!"); // assert food eaten

        // Put a WALL in front of snake head
        g.ground[g.snake.head.x+1][g.snake.head.y] = WALL;
        assert(!g.updateSnakePosition(Direction.RIGHT)); // Move into wall
    }


    /**
     * Put a food token at random on the playground
     *
     * Only update the ground[][] array, not the display
     */
    Coordinate updateFoodToken()
    in (hasOneEmptyCell, "Ground has no more empty cell!")
    out (foodTokenPos; foodTokenPos.x > 0
                        && foodTokenPos.x < playgroundWidth
                        && foodTokenPos.y > 0
                        && foodTokenPos.y < playgroundHeight, "The food token is outsited the playground!")
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

        return Coordinate(x,y); // to be used in contract
    }
    unittest
    {
        import std.stdio;
        writeln("** [Ground] updateFoodToken() unittest **");

        Ground g = new Ground;

        /**
         * Find exactly one food or return false
         */
        bool findOneFood()
        {
            int count = 0;
            foreach (i; 0 .. playgroundWidth)
                foreach (j; 0 .. playgroundHeight)
                    if(g.ground[i][j] == FOOD)
                    {
                        //writeln ("FOOD at (", i, ",", j, ")");
                        count++;
                    }

            // There is a maximum of one food at any time on the playground
            if (count == 1) return true;

            return false;
        }

        // Look for the FOOD created in Ground ctor
        assert( findOneFood() );

        // Simulate food eaten by snake
        g.clearGround();
        g.updateFoodToken();
        assert( findOneFood() );

        // Stress test the "in" and "out" contracts
        foreach (i; 0 .. 1000)
        {
            g.clearGround();
            g.updateFoodToken();
        }
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
        foreach (i; 0 .. playgroundWidth)
            foreach (j; 0 .. playgroundHeight)
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
                        //term.write("?")
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

        foreach (i; 0 .. playgroundWidth)
            foreach (j; 0 .. playgroundHeight)
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
    enum CellType { EMPTY, WALL, SNAKE, SNAKE_HEAD, FOOD, DIRTY }; /// Named enum to enforce type for ground[][]
    alias EMPTY = CellType.EMPTY;
    alias WALL = CellType.WALL;
    alias SNAKE = CellType.SNAKE;
    alias SNAKE_HEAD = CellType.SNAKE_HEAD;
    alias FOOD = CellType.FOOD;
    alias DIRTY = CellType.DIRTY;

    static immutable maxSide = 100; /// maximum height / width of the ground
    static immutable playgroundWidth = 60; /// Ground where the snake can move
    static immutable playgroundHeight = 20; /// ditto
    static immutable playgroundCenter = Coordinate(playgroundWidth/2, playgroundHeight/2); ///

    CellType [maxSide][maxSide] ground; /// usage: ground[line][column]
    int foodCounter = 0;

    Snake snake = new Snake(playgroundCenter);


    /**
     * Contract function
     */
    bool isSnakeInsidePlayground()
    {
        foreach (Coordinate snkCell; snake)
            if ( ! (snkCell.x > 0
                && snkCell.x < playgroundWidth
                && snkCell.y > 0
                && snkCell.y < playgroundHeight))
            return false;

        return true;
    }


    /**
     * Contract function
     */
    bool hasOneEmptyCell()
    {
        foreach (i; 0 .. playgroundWidth)
            foreach (j; 0 .. playgroundHeight)
                if(ground[i][j] == EMPTY)
                    return true;

        return false;
    }

}
