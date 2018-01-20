using System;
using System.Globalization;
using System.Linq;

namespace SKV260.Kontrolluppgifter
{
    public static class KUHelper
    {
        public static void Borttag(KU ku)
        {
            // FK205 får bara finnas om alla fältkoder 
            // förutom FK201, FK203, FK570, FK215, FK222 och FK224 är tomma.

            foreach (var f in ku.Data.ToList())
            {
                if (!KUId.Fält.Contains(f.Key))
                {
                    ku.Data.Remove(f.Key);
                }
            }

            ku.Data.AddOrUpdateValue(Fältkod.Borttag, true);
        }

        public static void Validate(KU ku)
        {
            foreach (var item in ku.Data)
            {
                if (item.HasValue)
                {
                    var attr = FältHelper.GetFälttypAttribute(item.Key);
                    switch (attr.Typ)
                    {
                        case Fälttyp.Identitet:
                            {
                                if (!IsIdentitetValid(item.Value))
                                {
                                    throw new InvalidOperationException($"FK{(int)item.Key:000}: SSÅÅMMDDNNNK: Ej korrekt person-/organisations-/samordningsnummer, dvs börjar inte på 16, 18, 19 eller 20 eller innehålla inte en korrekt kontrollsiffra.");
                                }
                                break;
                            }
                    }
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
    }
}
