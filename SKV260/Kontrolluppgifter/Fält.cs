using System;
using System.Diagnostics;
using System.Globalization;

namespace SKV260.Kontrolluppgifter
{
    [DebuggerDisplay("FK{(int)Key:000}={Value}")]
    public struct Fält
    {
        public Fältkod Key { get; }
        public object Value { get; set; }

        public bool HasValue => Value != null;
        public bool IsEmpty => Value == null;

        public Fält(Fältkod k, object v = null)
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
