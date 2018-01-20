using System.ComponentModel.DataAnnotations;

namespace SKV260
{
    public class Arendeinformation
    {
        private Text _Arendeagare;

        [Required]
        public string Arendeagare { get { return _Arendeagare; } set { _Arendeagare = value; } }

        [Required]
        public int? Period { get; set; }
    }
}
