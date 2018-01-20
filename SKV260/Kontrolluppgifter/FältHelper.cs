using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

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
    }
}
