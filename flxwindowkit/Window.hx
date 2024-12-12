// flxwindowkit/Window.hx

package;

class Window 
{
    public var width:Int;
    public var height:Int;
    public var title:String;

    // Construtor da janela
    public function new(width:Int, height:Int, title:String) {
        this.width = width;
        this.height = height;
        this.title = title;
    }

    // Método para exibir informações da janela
    public function showInfo():Void 
    {
        trace("Window Info:");
        trace("Title: " + this.title);
        trace("Width: " + this.width);
        trace("Height: " + this.height);
    }
}
