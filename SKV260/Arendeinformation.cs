using System.ComponentModel.DataAnnotations;

namespace SKV260
{
    public class Arendeinformation
    {
        [Required]
        public string Arendeagare { get; set; }

        [Required]
        public int? Period { get; set; }
    }
}
