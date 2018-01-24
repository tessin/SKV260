using System;
using System.IO;

namespace SKV260
{
    class Program
    {
        static int Main(string[] args)
        {
            for (int i = 0; i < args.Length; i++)
            {
                var sourceFn = Path.GetFullPath(args[i]);
                if (!File.Exists(sourceFn))
                {
                    Console.Error.WriteLine($"cannot find file '{sourceFn}'");
                    return 1;
                }

                var destFn = Path.ChangeExtension(sourceFn, "xlsx");
                if (File.Exists(destFn))
                {
                    var overwrite = args.Length > 1 && args[args.Length - 1] == "--force";
                    if (!overwrite)
                    {
                        Console.Error.WriteLine($"file '{sourceFn}' would be overwritten. Move or delete file first");
                        return 1;
                    }
                }

                int exitCode = ExportUtils.ExportXslx(sourceFn, destFn);
                if (exitCode != 0)
                {
                    return exitCode;
                }
            }
            return 0;
        }
    }
}
