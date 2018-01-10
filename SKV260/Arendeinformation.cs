using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
