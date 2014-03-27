using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
 
class png2bmp {
    static void Main(string[] args) {
        foreach (string f in Directory.GetFiles(".", "*.png")) {
		    Image.FromFile(f).Save(f.Replace(".png", ".bmp"), ImageFormat.Bmp);
        }
    }
}
