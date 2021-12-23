/**
 * Authors: Fr3nchk1ss
 * Date: 12/2021
 */

module nixconsole;

static import std.stdio;

import iconsole;


class NixConsole : IConsole
{
    /**
     * See IConsole for description
     */
    bool isConsole(int fd)
    {
        //import core.sys.posix.unistd.isatty;
        //return cast(bool) isatty(fd);
        return true;
    }

    /**
     * See IConsole for description
     */
    string readln()
    {
        if(isConsole(0))
            return std.stdio.readln();

        assert(0);
    }

    /**
     * See IConsole for description
     */
    void writeln(string s)
    {
        std.stdio.writeln(s);
    }

    /**
     * See IConsole for description
     */
    void clearScreen()
    {
        import core.stdc.stdlib: system;
        system("clear");
    }

    /**
     * See IConsole for description
     */
    bool gotoxy(int column, int row)
    {
        std.stdio.write("%c[%d;%df",0x1B,row,column);
        return true;
    }

}
