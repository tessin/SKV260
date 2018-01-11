using ClosedXML.Excel;
using System.Collections.Generic;
using System.IO;

namespace xml2xlsx
{
    public class XlsxExportFormatter : IExportFormatter
    {
        public string FileExtension { get { return "xlsx"; } }

        public void Serialize(IEnumerable<ExportTable> source, Stream outputStream)
        {
            var wb = new XLWorkbook();
            var n = 1;
            foreach (var tbl in source)
            {
                var ws = wb.Worksheets.Add(tbl.WorksheetName ?? $"Sheet{n}");
                Serialize(tbl, ws);
                n++;
            }
            wb.SaveAs(outputStream);
        }

        private void Serialize(ExportTable tbl, IXLWorksheet ws)
        {
            var rowNum = 1;

            // The Excel API uses one based indexes.
            var width = tbl.Cols.Count;
            for (var col = 1; col <= width; col++)
            {
                var cell = ws.Cell(rowNum, col);
                cell.Value = tbl.Cols[col - 1].HeaderText;
                cell.Style.Border.BottomBorder = XLBorderStyleValues.Thick;
                cell.Style.Fill.BackgroundColor = XLColor.FromArgb(0xFF, 0xE9, 0xE9, 0xE9);
                cell.Style.Font.Bold = true;
            }
            rowNum++;

            foreach (var row in tbl.Rows)
            {
                for (var col = 1; col <= width; col++)
                {
                    var cell = ws.Cell(rowNum, col);
                    cell.SetValue(row.GetCellValue(col - 1));
                    var border = cell.Style.Border;
                    border.LeftBorder = XLBorderStyleValues.Thin;
                    border.RightBorder = XLBorderStyleValues.Thin;
                    border.BottomBorder = XLBorderStyleValues.Thin;
                    border.TopBorder = XLBorderStyleValues.Thin;
                    if (rowNum % 2 == 1)
                    {
                        cell.Style.Fill.BackgroundColor = XLColor.FromArgb(0xFF, 0xF9, 0xF9, 0xF9);
                    }
                }
                rowNum++;
            }

            ws.Columns().AdjustToContents();
            ws.Rows().AdjustToContents();
        }
    }
}
