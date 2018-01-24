using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SKV260
{
    public class BlankettCollection : IEnumerable<Blankett>
    {
        private readonly Dictionary<string, Blankett> _dict = new Dictionary<string, Blankett>();

        public int Count => _dict.Count;

        public void Add(Blankett blankett)
        {
            _dict.Add(blankett.Blankettinnehall.GetId().ToString(), blankett);
        }

        public bool TryGet(string id, out Blankett blankett)
        {
            return _dict.TryGetValue(id, out blankett);
        }

        public IEnumerator<Blankett> GetEnumerator()
        {
            return _dict.Values.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }
}
