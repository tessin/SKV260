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
                if (!KUId.Identifikatorer.Contains(f.Key))
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
                    try
                    {
                        FältHelper.Validate(item.Key, item.Value);
                    }
                    catch (Exception ex)
                    {
                        throw new InvalidOperationException($"KUxx innehåller felaktiga uppgifter", ex);
                    }
                }
            }
        }

    }
}
