namespace SKV260.Kontrolluppgifter
{
    public abstract class KU
    {
        /// <summary>
        /// Innehåller all fält data, ett fält behöver inte vara ifyllt för att det förekommer i denna dictionary, 
        /// kontrollera alltid Fält.HasValue om fält information faktiskt finns.
        /// </summary>
        public FältData Data { get; } = new FältData();

        public KUId GetId()
        {
            return new KUId(this);
        }

        public abstract KULayout GetLayout();
    }
}
