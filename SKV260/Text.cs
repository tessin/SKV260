using System;

namespace SKV260
{
    public struct Text
    {
        public static implicit operator Text(string s)
        {
            return new Text(s);
        }

        public static implicit operator string(Text text)
        {
            return text.Value;
        }

        public static string Normalize(string s)
        {
            if (s != null)
            {
                var trimmed = s.Trim();
                if (trimmed.Length > 0)
                {
                    return trimmed;
                }
            }
            return null;
        }

        public bool HasValue => Value != null;
        public readonly string Value;

        public bool IsEmpty => Value == null;

        public Text(string s)
        {
            this.Value = Normalize(s);
        }

        public override string ToString()
        {
            return Value;
        }
    }
}
