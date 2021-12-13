/**
 * Authors: Fr3nchk1ss
 * Date: 12/2021
 */

module console;


abstract class Console
{
    /**
     * Detects if the output is a console, or something else.
     */
    protected bool isConsole(int fd);
    /**
     * Read a line
     */
    string readln();
    /**
     * write a line starting at cursor position
     */
    void writeln(string s);
    /**
     * Clear the console view
     */
    void clearScreen();
    /**
     * Move the console cursor to coordinates x y
     */
    bool gotoxy(int column, int row);

}
