package cpp;



#if windows
@:buildXml('
	<target id="haxe">
		<lib name="dwmapi.lib" if="windows" />
	</target>
	')
	@:cppFileCode('
		#include <Windows.h>
		#include <dwmapi.h>
		#include <winuser.h>
	')
#elseif linux
	@:cppFileCode("#include <stdio.h>")
#end

class Border
{
	public var color:String = 'white';
	public function setBorderColor(color:String):Void
	{
		this.color = color;
		trace('Processing the color of the chosen border...');
		
		#if cpp
			if (['dark', 'escuro', 'preto', 'black'].contains(color))
			{
				cppWindow.setWindowColorMode(true);
				trace('Ready the color of the game window border has been changed to Black!!');
			}
			else if (['white', 'light', 'branco', 'claro'].contains(color))
			{
				cppWindow.setWindowColorMode(true);
				trace('Ready the color of the game window border has been changed to White!!');
			}
		#end
	}
}

class cppWindow
{
	public static function setWindowColorMode(isDarkMode:Bool) 
	{
		#if windows
			untyped __cpp__('
				int darkModeValue = isDarkMode ? 1 : 0;
				HWND window = GetActiveWindow();
				if (S_OK != DwmSetWindowAttribute(window, 19, &darkModeValue, sizeof(darkModeValue))) {
					DwmSetWindowAttribute(window, 20, &darkModeValue, sizeof(darkModeValue));
				}
				UpdateWindow(window);
			', isDarkMode); 
		#end
	}
}