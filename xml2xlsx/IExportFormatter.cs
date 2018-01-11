using System.Collections.Generic;
using System.IO;

namespace xml2xlsx
{
    public interface IExportFormatter
    {
        string FileExtension { get; }
        void Serialize(IEnumerable<ExportTable> list, Stream outputStream);
    }
}
