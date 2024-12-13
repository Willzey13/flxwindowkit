package flxwindowkit;

class Utils
{
    public static function coloredTrace(message:String, color:String):Void
    {
        var colorCode:String = (
            switch (color.toLowerCase()) 
            {
                case "red": "\x1b[31m";
                case "green": "\x1b[32m";
                case "yellow": "\x1b[33m";
                case "blue": "\x1b[34m";
                case "magenta": "\x1b[35m";
                case "cyan": "\x1b[36m";
                default: "\x1b[0m"; // Default (no color)
            }
        );

        return trace(colorCode + message + "\x1b[0m");
    }
}