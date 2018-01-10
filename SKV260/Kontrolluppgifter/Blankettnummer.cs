using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SKV260.Kontrolluppgifter
{
    public class BlankettnummerAttribute : Attribute
    {
        public int Nummer { get; }

        public BlankettnummerAttribute(int nummer)
        {
            this.Nummer = nummer;
        }
    }
}
