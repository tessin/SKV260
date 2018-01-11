using System;
using System.Diagnostics;
using System.Globalization;

namespace SKV260.Kontrolluppgifter
{
    [DebuggerDisplay("FK{Key}={Value}")]
    public class Fält
    {
        /// <summary>
        /// Fältkod, FKxxx, t.ex. FK215
        /// </summary>
        public int Key { get; set; }
        public object Value { get; set; }

        public bool HasValue => Value != null;
        public bool IsEmpty => Value == null;

        public Fält(int k, object v = null)
        {
            this.Key = k;
            this.Value = v;
        }

        public override string ToString()
        {
            return Convert.ToString(Value, CultureInfo.InvariantCulture) ?? string.Empty;
        }
    }
}
