using System.IO;

namespace SKV260
{
    static class DirectoryHelper
    {
        public static string FindFirst(string path)
        {
            var xs = new[] {
                "files",
                "../../files",
            };

            foreach (var x in xs)
            {
                var fn = Path.GetFullPath(Path.Combine(x, path));
                if (Directory.Exists(fn))
                {
                    return fn;
                }
            }

            return null;
        }
    }
}
