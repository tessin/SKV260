using System.Collections.Generic;
using System.IO;

namespace SKV260
{
    public interface IExportFormatter
    {
        string FileExtension { get; }
        void Serialize(IEnumerable<ExportTable> list, Stream outputStream);
    }
}
