using System;
using System.IO;

namespace SKV260
{
    class Program
    {
        static int Main(string[] args)
        {
            var sourceFn = Path.GetFullPath(args[0]);
            if (!File.Exists(sourceFn))
            {
                Console.Error.WriteLine($"cannot find file '{sourceFn}'");
                return 1;
            }

            var destFn = Path.ChangeExtension(sourceFn, "xlsx");
            if (File.Exists(destFn))
            {
                var overwrite = args.Length > 1 && args[1] == "--force";
                if (!overwrite)
                {
                    Console.Error.WriteLine($"file '{sourceFn}' would be overwritten. Move or delete file first");
                    return 1;
                }
            }

            return ExportUtils.ExportXslx(sourceFn, destFn);
        }
    }
}
