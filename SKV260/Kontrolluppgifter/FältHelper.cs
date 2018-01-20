using System;
using System.Collections.Generic;
using System.Globalization;
using System.Reflection;

namespace SKV260.Kontrolluppgifter
{
    public static class FältHelper
    {
        private static readonly Dictionary<Fältkod, FälttypAttribute> Metadata = new Dictionary<Fältkod, FälttypAttribute>();

        static FältHelper()
        {
            var fs = typeof(Fältkod).GetFields(BindingFlags.Public | BindingFlags.Static);
            foreach (var f in fs)
            {
                var fk = (Fältkod)f.GetValue(null);
                var attr = f.GetCustomAttribute<FälttypAttribute>();
                Metadata.Add(fk, attr);
            }
        }

        public static FälttypAttribute GetFälttypAttribute(Fältkod fk)
        {
            return Metadata[fk];
        }

        private static string FKId(Fältkod fk)
        {
            return $"FK{(int)fk:000}";
        }

        public static void Validate(Fältkod fk, object v)
        {
            var attr = GetFälttypAttribute(fk);
            switch (attr.Typ)
            {
                case Fälttyp.Belopp:
                    {
                        var min = 0;
                        var max = Math.Pow(10, attr.MaxLength) - 1;
                        var num = Convert.ToInt64(v, CultureInfo.InvariantCulture);
                        if (!(min <= num && num <= max))
                        {
                            throw new ArgumentException($"{FKId(fk)}: {min} - {max}");
                        }
                        break;
                    }

                case Fälttyp.Text:
                    {
                        var s = Convert.ToString(v, CultureInfo.InvariantCulture) ?? string.Empty;
                        if (!(s.Length <= attr.MaxLength))
                        {
                            throw new ArgumentException($"{FKId(fk)}: Max {attr.MaxLength} tecken.");
                        }
                        break;
                    }

                case Fälttyp.Identitet:
                    {
                        if (!IsIdentitetValid(v))
                        {
                            throw new ArgumentException($"{FKId(fk)}: SSÅÅMMDDNNNK: Ej korrekt person-/organisations-/samordningsnummer, dvs börjar inte på 16, 18, 19 eller 20 eller innehålla inte en korrekt kontrollsiffra.");
                        }
                        break;
                    }

                case Fälttyp.SpecifikationsNummer:
                    {
                        var num = Convert.ToInt64(v, CultureInfo.InvariantCulture);
                        if (!(1 <= num && num <= 9999999999))
                        {
                            throw new ArgumentException($"{FKId(fk)}: 1 - 9999999999");
                        }
                        break;
                    }
            }
        }

        private static int Luhn(string s, int startIndex, int length)
        {
            var sum = 0;
            for (var i = 0; i < length; i++)
            {
                var temp = (s[startIndex + i] - '0') << (1 - (i & 1));
                if (temp > 9) temp -= 9;
                sum += temp;
            }
            return (10 - (sum % 10)) % 10;
        }

        public static bool IsIdentitetValid(object value)
        {
            var s = Convert.ToString(value, CultureInfo.InvariantCulture) ?? string.Empty;

            // Skatteverket använder 12-siffriga organisationsnummer
            // https://sv.wikipedia.org/wiki/Organisationsnummer#12-siffriga_organisationsnummer

            if (s.StartsWith("16") || s.StartsWith("18") || s.StartsWith("19") || s.StartsWith("20"))
            {
                if (s.Length == 12)
                {
                    var y = Luhn(s, 2, 9);
                    var z = (s[11] - '0');
                    return y == z;
                }
            }

            return false;
        }

        public static bool Contains(this List<Fält> source, Fältkod fk)
        {
            foreach (var f in source)
            {
                if (f.Key == fk)
                {
                    return true;
                }
            }
            return false;
        }
    }
}
