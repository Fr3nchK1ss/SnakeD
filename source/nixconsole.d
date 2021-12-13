/**
 * Authors: Fr3nchk1ss
 * Date: 12/2021
 */

module nixconsole;

static import std.stdio;

import console;


class NixConsole : Console
{

    override protected bool isConsole(int fd)
    {
        //import core.sys.posix.unistd.isatty;
        //return cast(bool) isatty(fd);
        return true;
    }

    override string readln()
    {
        if(isConsole(0))
            return std.stdio.readln();

        assert(0);
    }

    override void writeln(string s)
    {
        std.stdio.writeln(s);
    }

    override void clearScreen()
    {
        import core.stdc.stdlib: system;
        system("clear");
    }

    override bool gotoxy(int column, int row)
    {
        std.stdio.write("%c[%d;%df",0x1B,row,column);
        return true;
    }

}
