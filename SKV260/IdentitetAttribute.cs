using System;
using System.ComponentModel.DataAnnotations;
using System.Globalization;

namespace SKV260
{
    [AttributeUsage(AttributeTargets.Property | AttributeTargets.Field, AllowMultiple = false)]
    public class IdentitetAttribute : ValidationAttribute
    {
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

        public override bool IsValid(object value)
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

        public override string FormatErrorMessage(string name)
        {
            return $"{name}: SSÅÅMMDDNNNK: Ej korrekt person-/organisations-/samordningsnummer, dvs börjar inte på 16, 18, 19 eller 20 eller innehålla inte en korrekt kontrollsiffra.";
        }
    }
}
