@:cppInclude('windows.h')
class WallpaperChanger {
    /**
     * code by guisende hhehehah :nerdlaugh:
     * @param path
     * @param absolute
     * @return
     */
    public static function changeWallpaper(path:String, ?absolute:Bool):Bool {
        if (!absolute) path = Paths.imageTwo(path);
        return #if windows untyped __cpp__('SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, (void*){0}.c_str(), SPIF_UPDATEINIFILE)', sys.FileSystem.absolutePath(path)) #else false #end;
    }
}