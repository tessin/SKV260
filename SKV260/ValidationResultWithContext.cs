using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace SKV260
{
    public class ValidationResultWithContext
    {
        public ValidationContext Context { get; }
        public List<ValidationResult> ValidationResults { get; } = new List<ValidationResult>();

        public ValidationResultWithContext(object instance)
        {
            Context = new ValidationContext(instance);
        }

        public bool Validate()
        {
            return Validator.TryValidateObject(Context.ObjectInstance, Context, ValidationResults, true);
        }
    }
}
