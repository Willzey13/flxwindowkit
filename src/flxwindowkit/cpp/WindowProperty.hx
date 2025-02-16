package flxwindowkit.cpp;

import flxwindow.*;
import flixel.FlxG;

/**
 * This code allows for dynamically changing the border color of a window. It provides a simple and efficient method 
 * to modify the appearance of a window's border using Haxe. The code is designed to be used in Haxe projects and 
 * integrates seamlessly with HaxePunk or other frameworks that support window manipulation.
 *
 * This specific implementation is part of a larger library that I, Willzey, created in 2024. It is an innovative 
 * approach to customizing window elements, especially focusing on updating or modifying the window's border color 
 * based on specific user input or system events.
 *
 * By utilizing this method, you gain the ability to visually enhance your application's window, making it more 
 * interactive and visually appealing to end users. The logic behind this method ensures efficient performance while 
 * allowing for easy customization. The border color change is seamless and can be applied instantly to create 
 * dynamic effects within your application.
 *
 * Please note that this code is protected by copyright law. By using or distributing this code, you acknowledge 
 * that it is the intellectual property of Willzey. Any form of redistribution or modification of this code requires 
 * permission. I am grateful that you are utilizing my method for updating or modifying the window's appearance, 
 * and I appreciate your interest in this work. 
 *
 * Copyright © 2024 Willzey. All rights reserved.
 */

class Border
{
	/**
	 * The `color` variable holds the current color for the window's border. 
	 * Initially, it is set to 'white', but can be changed to any valid color 
	 * that is supported by the `setBorderColor` method.
	 */
	public var color:String = 'white';

	/**
	 * The `new()` function is the constructor for the `Border` class. 
	 * In this case, it is intentionally left empty, as no specific initialization logic 
	 * is required when creating an instance of `Border`. However, this constructor 
	 * is essential as it defines how a new instance of `Border` is created.
	 * 
	 * While this constructor does not contain any custom logic, it still provides the 
	 * ability to create an instance of `Border` with its default state. The `color` variable 
	 * is automatically initialized to `'white'` as specified in the class declaration, 
	 * so no further setup is needed when a `Border` object is instantiated.
	 * 
	 * This constructor can be expanded in the future if additional initialization 
	 * logic is required for new `Border` instances.
	 */
	public function new() {} 

	/**
	 * This method is used to set the border color of the window. 
	 * It takes a string `color` as input, and depending on the value of 
	 * `color`, it will call platform-specific functions to modify the window's border.
	 *
	 * The method works by checking if the passed `color` matches a predefined set of values.
	 * If the value is found, the border color will be updated accordingly.
	 *
	 * Available color options:
	 * - 'black' or 'dark': Sets the window border to black.
	 * - 'white' or 'light': Sets the window border to white.
	 * 
	 * The `color` variable is updated based on the input, and the appropriate action is triggered 
	 * to change the appearance of the window's border.
	 */
	public function setBorderColor(color:String):Void
	{
		// Updates the `color` variable with the chosen color
		this.color = color;
		// Outputs a message indicating the chosen color is being processed
		Utils.coloredTrace('Processing the color of the chosen border...', 'magenta');
		
		// Check the `color` and apply the appropriate border color change based on the value
		#if cpp
			// If color is 'dark', 'escuro', 'preto' or 'black', set the window border to black
			if (['dark', 'escuro', 'preto', 'black'].contains(color))
			{
				// Calls a method to apply the dark mode to the window border (black)
				WindowCppUtil.setWindowColorMode(true);
				// Outputs a message indicating that the border color has been changed to black
				Utils.coloredTrace('Ready the color of the game window border has been changed to Black!!', 'green');
			}
			// If color is 'white', 'light', 'branco' or 'claro', set the window border to white
			else if (['white', 'light', 'branco', 'claro'].contains(color))
			{
				// Calls a method to apply the light mode to the window border (white)
				WindowCppUtil.setWindowColorMode(true);
				// Outputs a message indicating that the border color has been changed to white
				Utils.coloredTrace('Ready the color of the game window border has been changed to White!!', 'green');
			}
		#end
	}
}

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

class WindowCppUtil
{
	/**
	 * This method sets the color mode for the window's border.
	 * It accepts a boolean parameter `isDark`, which determines whether the border
	 * will be set to dark or light mode.
	 * 
	 * If `isDark` is true, it applies a dark border color (black). If false, it applies a light border (white).
	 * This function is platform-specific and will only run on Windows.
	 */
	public static function setWindowColorMode(isDark:Bool) 
	{
		#if windows
			// Platform-specific code to change the window color mode using Windows API
			untyped __cpp__('
				// Determines whether to use dark mode or light mode based on the `isDark` value
				int darkModeValue = isDark ? 1 : 0;
				// Gets the handle of the active window
				HWND window = GetActiveWindow();
				// Applies the color mode to the window (dark or light)
				if (S_OK != DwmSetWindowAttribute(window, 19, &darkModeValue, sizeof(darkModeValue))) {
					DwmSetWindowAttribute(window, 20, &darkModeValue, sizeof(darkModeValue));
				}
				// Updates the window with the new color setting
				UpdateWindow(window);
			', isDark); 
		#end
	}

	/**
	 * Call this function for changing the value alpha of window of windows
	 * @param a 
	 */
	public static function setAlpha(a:Float)
	{
		#if windows
			// Garante que o valor de a esteja no intervalo [0.0, 1.0]
			var alpha = Math.min(1.0, Math.max(0.0, a));
			
			untyped __cpp__('
				// Obtém a janela ativa
				HWND hwnd = GetActiveWindow();
				if (hwnd != nullptr)
				{
					// Define o estilo da janela para permitir transparência
					LONG_PTR style = GetWindowLongPtr(hwnd, GWL_EXSTYLE);
					SetWindowLongPtr(hwnd, GWL_EXSTYLE, style | WS_EX_LAYERED);
	
					// Define a transparência da janela
					BYTE bAlpha = (BYTE)(alpha * 255); // Converte α para o intervalo [0, 255]
					SetLayeredWindowAttributes(hwnd, 0, bAlpha, LWA_ALPHA);
				}
			', alpha);
		#end
	}

	public static function setWidth(width:Int):Void
	{
		#if windows
			untyped __cpp__('
				HWND hwnd = GetActiveWindow();
				if (hwnd != nullptr) {
					RECT rect;
					GetWindowRect(hwnd, &rect);
					int newWidth = {0};
					int height = rect.bottom - rect.top;
					SetWindowPos(hwnd, NULL, rect.left, rect.top, newWidth, height, SWP_NOZORDER | SWP_NOMOVE);
				}
			', width);
		#end
	}

	public static function animateWindowResize(initialWidth:Float, initialHeight:Float, finalWidth:Float, finalHeight:Float, duration:Float):Void
	{
		#if windows
		var steps:Int = Math.ceil(duration * 60);
		var widthStep:Float = (finalWidth - initialWidth) / steps;
		var heightStep:Float = (finalHeight - initialHeight) / steps;
		var currentWidth:Float = initialWidth;
		var currentHeight:Float = initialHeight;
		var screenWidth:Int = FlxG.width;
		var screenHeight:Int = FlxG.height;
	
		for (i in 0...steps)
		{
			currentWidth += widthStep;
			currentHeight += heightStep;
	
			var x:Int = Math.round((screenWidth - currentWidth) / 2) + 100;
			var y:Int = Math.round((screenHeight - currentHeight) / 2) + 70;
	
			untyped __cpp__('
				HWND hwnd = GetActiveWindow();
				if (hwnd != nullptr) {
					SetWindowPos(hwnd, NULL, {0}, {1}, {2}, {3}, SWP_NOZORDER);
				}
			', x, y, currentWidth, currentHeight);
			Sys.sleep(1 / 60);
		}
		#end
	}
	

	public static function setHeight(height:Int):Void
	{
		#if windows
			untyped __cpp__('
				HWND hwnd = GetActiveWindow();
				if (hwnd != nullptr) {
					RECT rect;
					GetWindowRect(hwnd, &rect);
					int newHeight = {0};
					int width = rect.right - rect.left;
					SetWindowPos(hwnd, NULL, rect.left, rect.top, width, newHeight, SWP_NOZORDER | SWP_NOMOVE);
				}
			', height);
		#end
	}
}
