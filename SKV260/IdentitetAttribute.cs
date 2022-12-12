using SKV260.Kontrolluppgifter;
using System;
using System.ComponentModel.DataAnnotations;

namespace SKV260
{
    [AttributeUsage(AttributeTargets.Property | AttributeTargets.Field, AllowMultiple = false)]
    public class IdentitetAttribute : ValidationAttribute
    {
        public override bool IsValid(object value)
        {
            return FältHelper.IsIdentitetValid(value);
        }

        public override string FormatErrorMessage(string name)
        {
            return $"{name}: SSÅÅMMDDNNNK: Ej korrekt person-/organisations-/samordningsnummer, dvs börjar inte på 16, 18, 19 eller 20 eller innehålla inte en korrekt kontrollsiffra.";
        }
    }
}
