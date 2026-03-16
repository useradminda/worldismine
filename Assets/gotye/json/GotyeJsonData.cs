#region Header
/**
 * JsonData.cs
 *   Generic type to hold JSON data (objects, arrays, and so on). This is
 *   the default type returned by JsonMapper.ToObject().
 *
 * The authors disclaim copyright to this source code. For more details, see
 * the COPYING file included with this distribution.
 **/
#endregion


using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;


namespace gotyejson
{
    public class GotyeJsonData : IGotyeJsonWrapper, IEquatable<GotyeJsonData>
    {
        #region Fields
        private IList<GotyeJsonData>               inst_array;
        private bool                          inst_boolean;
        private double                        inst_double;
        private int                           inst_int;
        private long                          inst_long;
        private IDictionary<string, GotyeJsonData> inst_object;
        private string                        inst_string;
        private string                        json;
        private GotyeJsonType                      type;

        // Used to implement the IOrderedDictionary interface
        private IList<KeyValuePair<string, GotyeJsonData>> object_list;
        #endregion


        #region Properties
        public int Count {
            get { return EnsureCollection ().Count; }
        }

        public bool IsArray {
            get { return type == GotyeJsonType.Array; }
        }

        public bool IsBoolean {
            get { return type == GotyeJsonType.Boolean; }
        }

        public bool IsDouble {
            get { return type == GotyeJsonType.Double; }
        }

        public bool IsInt {
            get { return type == GotyeJsonType.Int; }
        }

        public bool IsLong {
            get { return type == GotyeJsonType.Long; }
        }

        public bool IsObject {
            get { return type == GotyeJsonType.Object; }
        }

        public bool IsString {
            get { return type == GotyeJsonType.String; }
        }
        #endregion


        #region ICollection Properties
        int ICollection.Count {
            get {
                return Count;
            }
        }

        bool ICollection.IsSynchronized {
            get {
                return EnsureCollection ().IsSynchronized;
            }
        }

        object ICollection.SyncRoot {
            get {
                return EnsureCollection ().SyncRoot;
            }
        }
        #endregion


        #region IDictionary Properties
        bool IDictionary.IsFixedSize {
            get {
                return EnsureDictionary ().IsFixedSize;
            }
        }

        bool IDictionary.IsReadOnly {
            get {
                return EnsureDictionary ().IsReadOnly;
            }
        }

        ICollection IDictionary.Keys {
            get {
                EnsureDictionary ();
                IList<string> keys = new List<string> ();

                foreach (KeyValuePair<string, GotyeJsonData> entry in
                         object_list) {
                    keys.Add (entry.Key);
                }

                return (ICollection) keys;
            }
        }

        ICollection IDictionary.Values {
            get {
                EnsureDictionary ();
                IList<GotyeJsonData> values = new List<GotyeJsonData> ();

                foreach (KeyValuePair<string, GotyeJsonData> entry in
                         object_list) {
                    values.Add (entry.Value);
                }

                return (ICollection) values;
            }
        }

        public bool ContainsKey(string key)
        {
            foreach (KeyValuePair<string, GotyeJsonData> entry in
                     object_list)
            {
               if(entry.Key.CompareTo(key) == 0)
                    return true;
            }

            return false;
        }
        #endregion



        #region IJsonWrapper Properties
        bool IGotyeJsonWrapper.IsArray {
            get { return IsArray; }
        }

        bool IGotyeJsonWrapper.IsBoolean {
            get { return IsBoolean; }
        }

        bool IGotyeJsonWrapper.IsDouble {
            get { return IsDouble; }
        }

        bool IGotyeJsonWrapper.IsInt {
            get { return IsInt; }
        }

        bool IGotyeJsonWrapper.IsLong {
            get { return IsLong; }
        }

        bool IGotyeJsonWrapper.IsObject {
            get { return IsObject; }
        }

        bool IGotyeJsonWrapper.IsString {
            get { return IsString; }
        }
        #endregion


        #region IList Properties
        bool IList.IsFixedSize {
            get {
                return EnsureList ().IsFixedSize;
            }
        }

        bool IList.IsReadOnly {
            get {
                return EnsureList ().IsReadOnly;
            }
        }
        #endregion


        #region IDictionary Indexer
        object IDictionary.this[object key] {
            get {
                return EnsureDictionary ()[key];
            }

            set {
                if (! (key is String))
                    throw new ArgumentException (
                        "The key has to be a string");

                GotyeJsonData data = ToJsonData (value);

                this[(string) key] = data;
            }
        }
        #endregion


        //#region IOrderedDictionary Indexer
        //object IOrderedDictionary.this[int idx] {
        //    get {
        //        EnsureDictionary ();
        //        return object_list[idx].Value;
        //    }

        //    set {
        //        EnsureDictionary ();
        //        JsonData data = ToJsonData (value);

        //        KeyValuePair<string, JsonData> old_entry = object_list[idx];

        //        inst_object[old_entry.Key] = data;

        //        KeyValuePair<string, JsonData> entry =
        //            new KeyValuePair<string, JsonData> (old_entry.Key, data);

        //        object_list[idx] = entry;
        //    }
        //}
        //#endregion


        #region IList Indexer
        object IList.this[int index] {
            get {
                return EnsureList ()[index];
            }

            set {
                EnsureList ();
                GotyeJsonData data = ToJsonData (value);

                this[index] = data;
            }
        }
        #endregion


        #region Public Indexers
        public GotyeJsonData this[string prop_name] {
            get {
                EnsureDictionary ();
                return inst_object[prop_name];
            }

            set {
                EnsureDictionary ();

                KeyValuePair<string, GotyeJsonData> entry =
                    new KeyValuePair<string, GotyeJsonData> (prop_name, value);

                if (inst_object.ContainsKey (prop_name)) {
                    for (int i = 0; i < object_list.Count; i++) {
                        if (object_list[i].Key == prop_name) {
                            object_list[i] = entry;
                            break;
                        }
                    }
                } else
                    object_list.Add (entry);

                inst_object[prop_name] = value;

                json = null;
            }
        }

        public GotyeJsonData this[int index] {
            get {
                EnsureCollection ();

                if (type == GotyeJsonType.Array)
                    return inst_array[index];

                return object_list[index].Value;
            }

            set {
                EnsureCollection ();

                if (type == GotyeJsonType.Array)
                    inst_array[index] = value;
                else {
                    KeyValuePair<string, GotyeJsonData> entry = object_list[index];
                    KeyValuePair<string, GotyeJsonData> new_entry =
                        new KeyValuePair<string, GotyeJsonData> (entry.Key, value);

                    object_list[index] = new_entry;
                    inst_object[entry.Key] = value;
                }

                json = null;
            }
        }
        #endregion


        #region Constructors
        public GotyeJsonData ()
        {
        }

        public GotyeJsonData (bool boolean)
        {
            type = GotyeJsonType.Boolean;
            inst_boolean = boolean;
        }

        public GotyeJsonData (double number)
        {
            type = GotyeJsonType.Double;
            inst_double = number;
        }

        public GotyeJsonData (int number)
        {
            type = GotyeJsonType.Int;
            inst_int = number;
        }

        public GotyeJsonData (long number)
        {
            type = GotyeJsonType.Long;
            inst_long = number;
        }

        public GotyeJsonData (object obj)
        {
            if (obj is Boolean) {
                type = GotyeJsonType.Boolean;
                inst_boolean = (bool) obj;
                return;
            }

            if (obj is Double) {
                type = GotyeJsonType.Double;
                inst_double = (double) obj;
                return;
            }

            if (obj is Int32) {
                type = GotyeJsonType.Int;
                inst_int = (int) obj;
                return;
            }

            if (obj is Int64) {
                type = GotyeJsonType.Long;
                inst_long = (long) obj;
                return;
            }

            if (obj is String) {
                type = GotyeJsonType.String;
                inst_string = (string) obj;
                return;
            }

            throw new ArgumentException (
                "Unable to wrap the given object with JsonData");
        }

        public GotyeJsonData (string str)
        {
            type = GotyeJsonType.String;
            inst_string = str;
        }
        #endregion


        #region Implicit Conversions
        public static implicit operator GotyeJsonData (Boolean data)
        {
            return new GotyeJsonData (data);
        }

        public static implicit operator GotyeJsonData (Double data)
        {
            return new GotyeJsonData (data);
        }

        public static implicit operator GotyeJsonData (Int32 data)
        {
            return new GotyeJsonData (data);
        }

        public static implicit operator GotyeJsonData (Int64 data)
        {
            return new GotyeJsonData (data);
        }

        public static implicit operator GotyeJsonData (String data)
        {
            return new GotyeJsonData (data);
        }
        #endregion


        #region Explicit Conversions
        public static explicit operator Boolean (GotyeJsonData data)
        {
            if (data.type != GotyeJsonType.Boolean)
                throw new InvalidCastException (
                    "Instance of JsonData doesn't hold a double");

            return data.inst_boolean;
        }

        public static explicit operator Double (GotyeJsonData data)
        {
            if (data.type != GotyeJsonType.Double)
                throw new InvalidCastException (
                    "Instance of JsonData doesn't hold a double");

            return data.inst_double;
        }

        public static explicit operator Int32 (GotyeJsonData data)
        {
            if (data.type != GotyeJsonType.Int)
                throw new InvalidCastException (
                    "Instance of JsonData doesn't hold an int");

            return data.inst_int;
        }

        public static explicit operator Int64 (GotyeJsonData data)
        {
            if (data.type == GotyeJsonType.Int)
                return data.inst_int;

            if (data.type != GotyeJsonType.Long)
                throw new InvalidCastException (
                    "Instance of JsonData doesn't hold an int");

            return data.inst_long;
        }

        public static explicit operator String (GotyeJsonData data)
        {
            if (data.type != GotyeJsonType.String)
                throw new InvalidCastException (
                    "Instance of JsonData doesn't hold a string");

            return data.inst_string;
        }
        #endregion


        #region ICollection Methods
        void ICollection.CopyTo (Array array, int index)
        {
            EnsureCollection ().CopyTo (array, index);
        }
        #endregion


        #region IDictionary Methods
        void IDictionary.Add (object key, object value)
        {
            GotyeJsonData data = ToJsonData (value);

            EnsureDictionary ().Add (key, data);

            KeyValuePair<string, GotyeJsonData> entry =
                new KeyValuePair<string, GotyeJsonData> ((string) key, data);
            object_list.Add (entry);

            json = null;
        }

        void IDictionary.Clear ()
        {
            EnsureDictionary ().Clear ();
            object_list.Clear ();
            json = null;
        }

        bool IDictionary.Contains (object key)
        {
            return EnsureDictionary ().Contains (key);
        }

        IDictionaryEnumerator IDictionary.GetEnumerator ()
        {
            return EnsureDictionary().GetEnumerator();
        }

        void IDictionary.Remove (object key)
        {
            EnsureDictionary ().Remove (key);

            for (int i = 0; i < object_list.Count; i++) {
                if (object_list[i].Key == (string) key) {
                    object_list.RemoveAt (i);
                    break;
                }
            }

            json = null;
        }
        #endregion


        #region IEnumerable Methods
        IEnumerator IEnumerable.GetEnumerator ()
        {
            return EnsureCollection ().GetEnumerator ();
        }
        #endregion


        #region IJsonWrapper Methods
        bool IGotyeJsonWrapper.GetBoolean ()
        {
            if (type != GotyeJsonType.Boolean)
                throw new InvalidOperationException (
                    "JsonData instance doesn't hold a boolean");

            return inst_boolean;
        }

        double IGotyeJsonWrapper.GetDouble ()
        {
            if (type != GotyeJsonType.Double)
                throw new InvalidOperationException (
                    "JsonData instance doesn't hold a double");

            return inst_double;
        }

        int IGotyeJsonWrapper.GetInt ()
        {
            if (type != GotyeJsonType.Int)
                throw new InvalidOperationException (
                    "JsonData instance doesn't hold an int");

            return inst_int;
        }

        long IGotyeJsonWrapper.GetLong ()
        {
            if (type != GotyeJsonType.Long)
                throw new InvalidOperationException (
                    "JsonData instance doesn't hold a long");

            return inst_long;
        }

        string IGotyeJsonWrapper.GetString ()
        {
            if (type != GotyeJsonType.String)
                throw new InvalidOperationException (
                    "JsonData instance doesn't hold a string");

            return inst_string;
        }

        void IGotyeJsonWrapper.SetBoolean (bool val)
        {
            type = GotyeJsonType.Boolean;
            inst_boolean = val;
            json = null;
        }

        void IGotyeJsonWrapper.SetDouble (double val)
        {
            type = GotyeJsonType.Double;
            inst_double = val;
            json = null;
        }

        void IGotyeJsonWrapper.SetInt (int val)
        {
            type = GotyeJsonType.Int;
            inst_int = val;
            json = null;
        }

        void IGotyeJsonWrapper.SetLong (long val)
        {
            type = GotyeJsonType.Long;
            inst_long = val;
            json = null;
        }

        void IGotyeJsonWrapper.SetString (string val)
        {
            type = GotyeJsonType.String;
            inst_string = val;
            json = null;
        }

        string IGotyeJsonWrapper.ToJson ()
        {
            return ToJson ();
        }

        void IGotyeJsonWrapper.ToJson (GotyeJsonWriter writer)
        {
            ToJson (writer);
        }
        #endregion


        #region IList Methods
        int IList.Add (object value)
        {
            return Add (value);
        }

        void IList.Clear ()
        {
            EnsureList ().Clear ();
            json = null;
        }

        bool IList.Contains (object value)
        {
            return EnsureList ().Contains (value);
        }

        int IList.IndexOf (object value)
        {
            return EnsureList ().IndexOf (value);
        }

        void IList.Insert (int index, object value)
        {
            EnsureList ().Insert (index, value);
            json = null;
        }

        void IList.Remove (object value)
        {
            EnsureList ().Remove (value);
            json = null;
        }

        void IList.RemoveAt (int index)
        {
            EnsureList ().RemoveAt (index);
            json = null;
        }
        #endregion


        //#region IOrderedDictionary Methods
        //IDictionaryEnumerator IOrderedDictionary.GetEnumerator ()
        //{
        //    EnsureDictionary ();

        //    return new OrderedDictionaryEnumerator (
        //        object_list.GetEnumerator ());
        //}

        //void IOrderedDictionary.Insert (int idx, object key, object value)
        //{
        //    string property = (string) key;
        //    JsonData data  = ToJsonData (value);

        //    this[property] = data;

        //    KeyValuePair<string, JsonData> entry =
        //        new KeyValuePair<string, JsonData> (property, data);

        //    object_list.Insert (idx, entry);
        //}

        //void IOrderedDictionary.RemoveAt (int idx)
        //{
        //    EnsureDictionary ();

        //    inst_object.Remove (object_list[idx].Key);
        //    object_list.RemoveAt (idx);
        //}
        //#endregion


        #region Private Methods
        private ICollection EnsureCollection ()
        {
            if (type == GotyeJsonType.Array)
                return (ICollection) inst_array;

            if (type == GotyeJsonType.Object)
                return (ICollection) inst_object;

            throw new InvalidOperationException (
                "The JsonData instance has to be initialized first");
        }

        private IDictionary EnsureDictionary ()
        {
            if (type == GotyeJsonType.Object)
                return (IDictionary) inst_object;

            if (type != GotyeJsonType.None)
                throw new InvalidOperationException (
                    "Instance of JsonData is not a dictionary");

            type = GotyeJsonType.Object;
            inst_object = new Dictionary<string, GotyeJsonData> ();
            object_list = new List<KeyValuePair<string, GotyeJsonData>> ();

            return (IDictionary) inst_object;
        }

        private IList EnsureList ()
        {
            if (type == GotyeJsonType.Array)
                return (IList) inst_array;

            if (type != GotyeJsonType.None)
                throw new InvalidOperationException (
                    "Instance of JsonData is not a list");

            type = GotyeJsonType.Array;
            inst_array = new List<GotyeJsonData> ();

            return (IList) inst_array;
        }

        private GotyeJsonData ToJsonData (object obj)
        {
            if (obj == null)
                return null;

            if (obj is GotyeJsonData)
                return (GotyeJsonData) obj;

            return new GotyeJsonData (obj);
        }

        private static void WriteJson (IGotyeJsonWrapper obj, GotyeJsonWriter writer)
        {
            if (obj.IsString) {
                writer.Write (obj.GetString ());
                return;
            }

            if (obj.IsBoolean) {
                writer.Write (obj.GetBoolean ());
                return;
            }

            if (obj.IsDouble) {
                writer.Write (obj.GetDouble ());
                return;
            }

            if (obj.IsInt) {
                writer.Write (obj.GetInt ());
                return;
            }

            if (obj.IsLong) {
                writer.Write (obj.GetLong ());
                return;
            }

            if (obj.IsArray) {
                writer.WriteArrayStart ();
                foreach (object elem in (IList) obj)
                    WriteJson ((GotyeJsonData) elem, writer);
                writer.WriteArrayEnd ();

                return;
            }

            if (obj.IsObject) {
                writer.WriteObjectStart ();

                foreach (DictionaryEntry entry in ((IDictionary) obj)) {
                    writer.WritePropertyName ((string) entry.Key);
                    WriteJson ((GotyeJsonData) entry.Value, writer);
                }
                writer.WriteObjectEnd ();

                return;
            }
        }
        #endregion


        public int Add (object value)
        {
            GotyeJsonData data = ToJsonData (value);

            json = null;

            return EnsureList ().Add (data);
        }

        public void Clear ()
        {
            if (IsObject) {
                ((IDictionary) this).Clear ();
                return;
            }

            if (IsArray) {
                ((IList) this).Clear ();
                return;
            }
        }

        public bool Equals (GotyeJsonData x)
        {
            if (x == null)
                return false;

            if (x.type != this.type)
                return false;

            switch (this.type) {
            case GotyeJsonType.None:
                return true;

            case GotyeJsonType.Object:
                return this.inst_object.Equals (x.inst_object);

            case GotyeJsonType.Array:
                return this.inst_array.Equals (x.inst_array);

            case GotyeJsonType.String:
                return this.inst_string.Equals (x.inst_string);

            case GotyeJsonType.Int:
                return this.inst_int.Equals (x.inst_int);

            case GotyeJsonType.Long:
                return this.inst_long.Equals (x.inst_long);

            case GotyeJsonType.Double:
                return this.inst_double.Equals (x.inst_double);

            case GotyeJsonType.Boolean:
                return this.inst_boolean.Equals (x.inst_boolean);
            }

            return false;
        }

        public GotyeJsonType GetJsonType ()
        {
            return type;
        }

        public void SetJsonType (GotyeJsonType type)
        {
            if (this.type == type)
                return;

            switch (type) {
            case GotyeJsonType.None:
                break;

            case GotyeJsonType.Object:
                inst_object = new Dictionary<string, GotyeJsonData> ();
                object_list = new List<KeyValuePair<string, GotyeJsonData>> ();
                break;

            case GotyeJsonType.Array:
                inst_array = new List<GotyeJsonData> ();
                break;

            case GotyeJsonType.String:
                inst_string = default (String);
                break;

            case GotyeJsonType.Int:
                inst_int = default (Int32);
                break;

            case GotyeJsonType.Long:
                inst_long = default (Int64);
                break;

            case GotyeJsonType.Double:
                inst_double = default (Double);
                break;

            case GotyeJsonType.Boolean:
                inst_boolean = default (Boolean);
                break;
            }

            this.type = type;
        }

        public string ToJson ()
        {
            if (json != null)
                return json;

            StringWriter sw = new StringWriter ();
            GotyeJsonWriter writer = new GotyeJsonWriter (sw);
            writer.Validate = false;

            WriteJson (this, writer);
            json = sw.ToString ();

            return json;
        }

        public void ToJson (GotyeJsonWriter writer)
        {
            bool old_validate = writer.Validate;

            writer.Validate = false;

            WriteJson (this, writer);

            writer.Validate = old_validate;
        }

        public override string ToString ()
        {
            switch (type) {
            case GotyeJsonType.Array:
                return "JsonData array";

            case GotyeJsonType.Boolean:
                return inst_boolean.ToString ();

            case GotyeJsonType.Double:
                return inst_double.ToString ();

            case GotyeJsonType.Int:
                return inst_int.ToString ();

            case GotyeJsonType.Long:
                return inst_long.ToString ();

            case GotyeJsonType.Object:
                return "JsonData object";

            case GotyeJsonType.String:
                return inst_string;
            }

            return "Uninitialized JsonData";
        }
    }


    internal class GotyeOrderedDictionaryEnumerator : IDictionaryEnumerator
    {
        IEnumerator<KeyValuePair<string, GotyeJsonData>> list_enumerator;


        public object Current {
            get { return Entry; }
        }

        public DictionaryEntry Entry {
            get {
                KeyValuePair<string, GotyeJsonData> curr = list_enumerator.Current;
                return new DictionaryEntry (curr.Key, curr.Value);
            }
        }

        public object Key {
            get { return list_enumerator.Current.Key; }
        }

        public object Value {
            get { return list_enumerator.Current.Value; }
        }


        public GotyeOrderedDictionaryEnumerator (
            IEnumerator<KeyValuePair<string, GotyeJsonData>> enumerator)
        {
            list_enumerator = enumerator;
        }


        public bool MoveNext ()
        {
            return list_enumerator.MoveNext ();
        }

        public void Reset ()
        {
            list_enumerator.Reset ();
        }
    }
}
