using System;
using System.Collections.Generic;

namespace SKV260
{
    public class ExportTable
    {
        public string WorksheetName { get; set; }
        public List<ExportColumn> Cols { get; set; } = new List<ExportColumn>();
        public List<ExportRow> Rows { get; set; } = new List<ExportRow>();
    }

    public class ExportColumn
    {
        public int Ordinal { get; private set; }
        public string HeaderText { get; private set; }

        public ExportColumn(int ordinal, string headerText)
        {
            Ordinal = ordinal;
            HeaderText = headerText;
        }
    }

    public class ExportRow
    {
        public enum CellState
        {
            /// <summary>
            /// Just the value of this exported cell.
            /// </summary>
            Value,

            /// <summary>
            /// If ValueText was written to using a formatting string.
            /// </summary>
            FormattedValue,

            /// <summary>
            /// If an exception was thrown while formatting value. The ValueText will contain an error message not a formatted value.
            /// </summary>
            FormattedValueError,
        }

        public struct Cell
        {
            /// <summary>
            /// The original value of this exported cell (regardless of state).
            /// </summary>
            public readonly object Value;

            /// <summary>
            /// Either the canonical string representation of Value, a formatted value, or a formatting error message. Depends on state.
            /// </summary>
            public readonly string Text;

            public readonly CellState State;

            public Cell(object value, string text, CellState state)
            {
                this.Value = value;
                this.Text = text;
                this.State = state;
            }
        }

        private readonly Cell[] _values;

        public int Count { get { return _values.Length; } }

        public ExportRow(int count)
        {
            this._values = new Cell[count];
        }

        public Cell GetCell(int index)
        {
            return _values[index];
        }

        // getters...

        public object GetCellValue(int index)
        {
            return GetCellValue(ref _values[index]);
        }

        private static object GetCellValue(ref Cell cell)
        {
            return cell.Value;
        }

        public string GetCellText(int index)
        {
            return GetCellText(ref _values[index]);
        }

        private static string GetCellText(ref Cell cell)
        {
            return cell.Text;
        }

        public CellState GetCellState(int index)
        {
            return GetCellState(ref _values[index]);
        }

        private static CellState GetCellState(ref Cell cell)
        {
            return cell.State;
        }

        // setter...

        public void SetCell<T>(int index, T value, string format = null)
        {
            SetCell(ref _values[index], value, format);
        }

        private static void SetCell<T>(ref Cell cell, T value, string format)
        {
            // todo: culture override? this way culture is consistent per export and for foreign exports it may come hand if you can specify culture in export.

            if (string.IsNullOrEmpty(format))
            {
                cell = new Cell(value, Convert.ToString(value), CellState.Value);
            }
            else
            {
                try
                {
                    cell = new Cell(value, string.Format(format, value), CellState.FormattedValue);

                }
                catch (Exception ex)
                {
                    cell = new Cell(value, $"string.Format({value}, {format}): {ex.Message}", CellState.FormattedValueError);
                }
            }
        }
    }
}
