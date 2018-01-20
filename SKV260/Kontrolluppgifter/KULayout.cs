namespace SKV260.Kontrolluppgifter
{
    public struct KULayout
    {
        public readonly Fältkod[] Kontrolluppgifter;
        public readonly Fältkod[] Inkomsttagare;
        public readonly Fältkod[] Uppgiftslamnare;

        public KULayout(Fältkod[] kontrolluppgifter, Fältkod[] inkomsttagare, Fältkod[] uppgiftslamnare)
        {
            this.Kontrolluppgifter = kontrolluppgifter;
            this.Inkomsttagare = inkomsttagare;
            this.Uppgiftslamnare = uppgiftslamnare;
        }
    }
}
