using System;

namespace SKV260.Kontrolluppgifter
{
    public class FälttypAttribute : Attribute
    {
        public Fälttyp Typ { get; }
        public int MaxLength { get; }

        public FälttypAttribute(Fälttyp typ)
        {
            if (typ == Fälttyp.Okänd) throw new ArgumentOutOfRangeException(nameof(typ));
            Typ = typ;
        }

        public FälttypAttribute(Fälttyp typ, int maxLength)
            : this(typ)
        {
            MaxLength = maxLength;
        }
    }
}
