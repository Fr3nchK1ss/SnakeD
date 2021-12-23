/**
 * Authors: Adam Ruppe, ThePoorEngineer, Fr3nchk1ss
 * Date: 10/2021
 * http://dpldocs.info/this-week-in-d/Blog.Posted_2019_11_25.html#unicode
 *
 * TODO: Create a console interface to allow the same program on Linux later on
 */

module winconsole;

import core.sys.windows.windows;
import std.conv;

import iconsole;

version(Windows)
{

/**
 * Handle writing and reading in a Windows console, moving to x/y, etc.
 */
class WinConsole : IConsole
{
    bool isConsole(int fd)
    {
        auto hConsole = GetStdHandle(fd == 0 ? STD_INPUT_HANDLE : STD_OUTPUT_HANDLE);
        return GetFileType(hConsole) == FILE_TYPE_CHAR;
    }


    string readln()
    {
        if(isConsole(0))
        {
            // if in a console, we want to use ReadConsoleW and convert that input data to UTF-8 to return.

            wchar[] input;
            wchar[2048] staticBuffer;
            // this loops because the buffer might be too small for a line
            // (though I doubt that will actually happen)
            while(input.length == 0 || input[$ - 1] != '\n') {
                // if we are on a second loop, we need to copy the input
                // away so the next write doesn't smash data we must store
                if(input.ptr is staticBuffer.ptr)
                    input = input.dup;
                DWORD chars = staticBuffer.length;
                if(!ReadConsoleW(GetStdHandle(STD_INPUT_HANDLE), staticBuffer.ptr, chars, &chars, null))
                    throw new Exception("read stdin failed " ~ to!string(GetLastError()));
                if(input is null)
                    input = staticBuffer[0 .. chars];
                else
                    input ~= staticBuffer[0 .. chars];
            }

            char[] buffer;
            auto got = WideCharToMultiByte(CP_UTF8, 0, input.ptr, cast(int) input.length, null, 0, null, null);
            if(got == 0)
                throw new Exception("conversion preparation failed " ~ to!string(GetLastError()));
            buffer.length = got;

            got = WideCharToMultiByte(CP_UTF8, 0, input.ptr, cast(int) input.length, buffer.ptr, cast(int) buffer.length, null, null);
            if(got == 0)
                throw new Exception("conversion actual failed " ~ to!string(GetLastError()));

            // drop the terminator, or maybe you can convert it
            // from \r\n to \n or whatever.
            auto ret = cast(string) buffer[0 .. got];
            if(ret.length && ret[$ - 1] == 10)
                ret = ret[0 .. $ - 1];
            if(ret.length && ret[$ - 1] == 13)
                ret = ret[0 .. $ - 1];
            return ret;
        } else {
            // for pipe or file redirection, just use the normal
            // thing, utf-8 may be cool there, but you should do
            // whatever is best for interoperability there.
            import std.stdio;
            return stdin.readln(); // maybe trim the \n too btw
        }
    }


    void writeln(string s)
    {
        // again, it is important to branch on output
        // being the console or redirected.
        if(isConsole(1)) {
            wchar[2048] staticBuffer;
            wchar[] buffer = staticBuffer[];
            DWORD i = 0;

            // in here I do the conversion in D instead of
            // using the Windows function, since I know it is
            // going UTF-8 to UTF-16, but you could do
            // it the other way too.
            foreach(wchar c; s) {
                if(i + 2 >= buffer.length)
                    buffer.length = buffer.length * 2;
                buffer[i++] = c;
            }
            if(i + 2 > buffer.length)
                buffer.length = buffer.length + 2;
            // adding the new line
            buffer[i++] = 13;
            buffer[i++] = 10;
            DWORD actual;
            // and now calling the wide char function
            if(!WriteConsoleW(GetStdHandle(STD_OUTPUT_HANDLE), buffer.ptr, i, &actual, null))
                throw new Exception("write console failed " ~ to!string(GetLastError()));
        } else {
            // non-console should still be utf-8, let it work normally
            // or whatever for interop (WriteConsoleW would fail here anyway)
            import std.stdio;
            stdout.writeln(s);
        }
    }


    void clearScreen()
    {
        HANDLE hStdOut;
        CONSOLE_SCREEN_BUFFER_INFO csbi;
        DWORD   count;
        DWORD   cellCount;
        COORD   homeCoords = { 0,0 };

        hStdOut = GetStdHandle(STD_OUTPUT_HANDLE);
        if (hStdOut == INVALID_HANDLE_VALUE)
                return;

        /* Get the number of cells and cell attributes in the current buffer */
        if (!GetConsoleScreenBufferInfo(hStdOut, &csbi))
                return;
        cellCount = csbi.dwSize.X * csbi.dwSize.Y;

        /* Fill the entire buffer with spaces */
        if (!FillConsoleOutputCharacter(
                hStdOut,     // handle to console screen buffer
                cast(TCHAR)' ', //character to write to the buffer
                cellCount,   //number of cells to write to
                homeCoords,  //coordinates of first cell
                &count,      // receives the number of characters written
                ))
                return;

        /* Fill the entire buffer with the current colors and attribute */
        if (!FillConsoleOutputAttribute(
                                        hStdOut,
                                        csbi.wAttributes,
                                        cellCount,
                                        homeCoords,
                                        &count))
                return;

        /* Move the cursor home */
        SetConsoleCursorPosition(hStdOut, homeCoords);
    }

    /**
     * Move the cursor to coordinates x y
     */
    bool gotoxy(int column, int row)
    {
        HANDLE hStdOut;
        COORD coord;

        hStdOut = GetStdHandle(STD_OUTPUT_HANDLE);
        if (hStdOut == INVALID_HANDLE_VALUE)
            return false;

        coord.X = to!short(column);
        coord.Y = to!short(row);
        return SetConsoleCursorPosition(hStdOut, coord) >= 1;
    }
/+
    unittest
    {
        HANDLE hStdOut;
        COORD x20y30 = COORD(20,25); // TODO: randomize (20,30) between playground max values
        WinConsole console = new WinConsole;

        // test gotoxy
        assert( console.gotoxy(20, 30), "gotoxy returned false!" );

        CONSOLE_SCREEN_BUFFER_INFO csbi;
        GetConsoleScreenBufferInfo(hStdOut, &csbi);
        assert( csbi.dwCursorPosition == x20y30, "Can not go to position (x,y)!" );

        console.writeln("\u2022");
    }
+/
}

} // version
