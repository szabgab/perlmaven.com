# Mock STDIN

In Perl we can create a scalar variable containing some string and then we can open a file-handle for reading to "read" the content of that variable.
We can then assign this file-handler to `STDIN` thereby allowing us to prepare what the rest of the code will see on the STDIN. Without the need for someone
to type text and without the need to setup shell redirection.

{% embed include file="src/examples/mock-stdin/t/echo.t" %}


