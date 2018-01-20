using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace SKV260.Kontrolluppgifter
{
    public class FältData : IEnumerable<Fält>
    {
        private readonly Dictionary<Fältkod, Fält> _dict = new Dictionary<Fältkod, Fält>();

        public FältData()
        {
        }

        public FältData(IEnumerable<Fält> source)
        {
            foreach (var f in source)
            {
                _dict.Add(f.Key, f);
            }
        }

        public Fält this[Fältkod fk]
        {
            get { return _dict[fk]; }
            set { _dict[fk] = value; }
        }

        public bool Contains(Fältkod key)
        {
            return _dict.ContainsKey(key);
        }

        public void Remove(Fältkod key)
        {
            _dict.Remove(key);
        }

        public T GetValueOrDefault<T>(Fältkod fk, T defaultValue = default(T))
        {
            if (_dict.TryGetValue(fk, out var f))
            {
                return (T)f.Value;
            }
            return defaultValue;
        }

        public void AddOrUpdateValue(Fältkod fk, object v)
        {
            if (v is string)
            {
                v = Text.Normalize((string)v);
            }

            if (v != null)
            {
                FältHelper.Validate(fk, v);
            }

            if (_dict.ContainsKey(fk))
            {
                _dict[fk] = new Fält(fk, v);
            }
            else
            {
                _dict.Add(fk, new Fält(fk, v));
            }
        }

        public List<Fält> Subset(Fältkod[] subset)
        {
            var list = new List<Fält>();
            foreach (var item in _dict)
            {
                if (subset.Contains(item.Key))
                {
                    list.Add(item.Value);
                }
            }
            return list;
        }

        public List<Fält> Except(Fältkod[] except)
        {
            var list = new List<Fält>();
            foreach (var item in _dict)
            {
                if (except.Contains(item.Key))
                {
                    continue;
                }
                list.Add(item.Value);
            }
            return list;
        }

        public IEnumerator<Fält> GetEnumerator()
        {
            return _dict.Values.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }
}
