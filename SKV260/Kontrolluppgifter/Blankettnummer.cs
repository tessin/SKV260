using System;

namespace SKV260.Kontrolluppgifter
{
    // Vilka blankettnummer som hänger i hop med vilka KU 
    // finns dokumenterat i "Bilaga 2b - tabellerna från bilaga 2, 3.1"

    public class BlankettnummerAttribute : Attribute
    {
        public int Nummer { get; }

        public BlankettnummerAttribute(int nummer)
        {
            this.Nummer = nummer;
        }
    }
}
