#region Header
/**
 * JsonMapper.cs
 *   JSON to .Net object and object to JSON conversions.
 *
 * The authors disclaim copyright to this source code. For more details, see
 * the COPYING file included with this distribution.
 **/
#endregion


using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Reflection;


namespace gotyejson
{
    internal struct GotyePropertyMetadata
    {
        public MemberInfo Info;
        public bool       IsField;
        public Type       Type;
    }


    internal struct GotyeArrayMetadata
    {
        private Type element_type;
        private bool is_array;
        private bool is_list;


        public Type ElementType {
            get {
                if (element_type == null)
                    return typeof (GotyeJsonData);

                return element_type;
            }

            set { element_type = value; }
        }

        public bool IsArray {
            get { return is_array; }
            set { is_array = value; }
        }

        public bool IsList {
            get { return is_list; }
            set { is_list = value; }
        }
    }


    internal struct GotyeObjectMetadata
    {
        private Type element_type;
        private bool is_dictionary;

        private IDictionary<string, GotyePropertyMetadata> properties;


        public Type ElementType {
            get {
                if (element_type == null)
                    return typeof (GotyeJsonData);

                return element_type;
            }

            set { element_type = value; }
        }

        public bool IsDictionary {
            get { return is_dictionary; }
            set { is_dictionary = value; }
        }

        public IDictionary<string, GotyePropertyMetadata> Properties {
            get { return properties; }
            set { properties = value; }
        }
    }


    public  delegate void GotyeExporterFunc    (object obj, GotyeJsonWriter writer);
    public   delegate void GotyeExporterFunc<T> (T obj, GotyeJsonWriter writer);

	public delegate object GotyeImporterFunc                (object input);
    public   delegate TValue GotyeImporterFunc<TJson, TValue> (TJson input);

    public delegate IGotyeJsonWrapper GotyeWrapperFactory ();


    public class GotyeJsonMapper
    {
        #region Fields
        private static int max_nesting_depth;

        private static IFormatProvider datetime_format;

        private static IDictionary<Type, GotyeExporterFunc> base_exporters_table;
		private static IDictionary<Type, GotyeExporterFunc> custom_exporters_table;

        private static IDictionary<Type,
                IDictionary<Type, GotyeImporterFunc>> base_importers_table;
        private static IDictionary<Type,
                IDictionary<Type, GotyeImporterFunc>> custom_importers_table;

        private static IDictionary<Type, GotyeArrayMetadata> array_metadata;
        private static readonly object array_metadata_lock = new Object ();

        private static IDictionary<Type,
                IDictionary<Type, MethodInfo>> conv_ops;
        private static readonly object conv_ops_lock = new Object ();

        private static IDictionary<Type, GotyeObjectMetadata> object_metadata;
        private static readonly object object_metadata_lock = new Object ();

        private static IDictionary<Type,
                IList<GotyePropertyMetadata>> type_properties;
        private static readonly object type_properties_lock = new Object ();

        private static GotyeJsonWriter      static_writer;
        private static readonly object static_writer_lock = new Object ();
        #endregion


        #region Constructors
        static GotyeJsonMapper ()
        {
            max_nesting_depth = 100;

            array_metadata = new Dictionary<Type, GotyeArrayMetadata> ();
            conv_ops = new Dictionary<Type, IDictionary<Type, MethodInfo>> ();
            object_metadata = new Dictionary<Type, GotyeObjectMetadata> ();
            type_properties = new Dictionary<Type,
                            IList<GotyePropertyMetadata>> ();

            static_writer = new GotyeJsonWriter ();

            datetime_format = DateTimeFormatInfo.InvariantInfo;

			base_exporters_table   = new Dictionary<Type, GotyeExporterFunc> ();
			custom_exporters_table = new Dictionary<Type, GotyeExporterFunc> ();

            base_importers_table = new Dictionary<Type,
                                 IDictionary<Type, GotyeImporterFunc>> ();
            custom_importers_table = new Dictionary<Type,
                                   IDictionary<Type, GotyeImporterFunc>> ();

            RegisterBaseExporters ();
            RegisterBaseImporters ();
        }
        #endregion


        #region Private Methods
        private static void AddArrayMetadata (Type type)
        {
            if (array_metadata.ContainsKey (type))
                return;

            GotyeArrayMetadata data = new GotyeArrayMetadata ();

            data.IsArray = type.IsArray;
            
            Type[] interfaces = type.GetInterfaces();
            for (int i = 0; i < interfaces.Length; i++) {
                if (interfaces[i].Name == "System.Collections.IList") {
                    data.IsList = true;
                    break;
                }
            }

            foreach (PropertyInfo p_info in type.GetProperties ()) {
                if (p_info.Name != "Item")
                    continue;

                ParameterInfo[] parameters = p_info.GetIndexParameters ();

                if (parameters.Length != 1)
                    continue;

                if (parameters[0].ParameterType == typeof (int))
                    data.ElementType = p_info.PropertyType;
            }

            lock (array_metadata_lock) {
                try {
                    array_metadata.Add (type, data);
                } catch (ArgumentException) {
                    return;
                }
            }
        }

        private static void AddObjectMetadata (Type type)
        {
            if (object_metadata.ContainsKey (type))
                return;

            GotyeObjectMetadata data = new GotyeObjectMetadata ();

            Type[] interfaces = type.GetInterfaces();
            for (int i = 0; i < interfaces.Length; i++)
            {
                if (interfaces[i].Name == "System.Collections.IDictionary")
                {
                    data.IsDictionary = true;
                    break;
                }
            }

            data.Properties = new Dictionary<string, GotyePropertyMetadata> ();

            foreach (PropertyInfo p_info in type.GetProperties ()) {
                if (p_info.Name == "Item") {
                    ParameterInfo[] parameters = p_info.GetIndexParameters ();

                    if (parameters.Length != 1)
                        continue;

                    if (parameters[0].ParameterType == typeof (string))
                        data.ElementType = p_info.PropertyType;

                    continue;
                }

                GotyePropertyMetadata p_data = new GotyePropertyMetadata ();
                p_data.Info = p_info;
                p_data.Type = p_info.PropertyType;

                data.Properties.Add (p_info.Name, p_data);
            }

            foreach (FieldInfo f_info in type.GetFields ()) {
                GotyePropertyMetadata p_data = new GotyePropertyMetadata ();
                p_data.Info = f_info;
                p_data.IsField = true;
                p_data.Type = f_info.FieldType;

                data.Properties.Add (f_info.Name, p_data);
            }

            lock (object_metadata_lock) {
                try {
                    object_metadata.Add (type, data);
                } catch (ArgumentException) {
                    return;
                }
            }
        }

        private static void AddTypeProperties (Type type)
        {
            if (type_properties.ContainsKey (type))
                return;

            IList<GotyePropertyMetadata> props = new List<GotyePropertyMetadata> ();

            foreach (PropertyInfo p_info in type.GetProperties ()) {
                if (p_info.Name == "Item")
                    continue;

                GotyePropertyMetadata p_data = new GotyePropertyMetadata ();
                p_data.Info = p_info;
                p_data.IsField = false;
                props.Add (p_data);
            }

            foreach (FieldInfo f_info in type.GetFields ()) {
                GotyePropertyMetadata p_data = new GotyePropertyMetadata ();
                p_data.Info = f_info;
                p_data.IsField = true;

                props.Add (p_data);
            }

            lock (type_properties_lock) {
                try {
                    type_properties.Add (type, props);
                } catch (ArgumentException) {
                    return;
                }
            }
        }

        private static MethodInfo GetConvOp (Type t1, Type t2)
        {
            lock (conv_ops_lock) {
                if (! conv_ops.ContainsKey (t1))
                    conv_ops.Add (t1, new Dictionary<Type, MethodInfo> ());
            }

            if (conv_ops[t1].ContainsKey (t2))
                return conv_ops[t1][t2];

            MethodInfo op = t1.GetMethod (
                "op_Implicit", new Type[] { t2 });

            lock (conv_ops_lock) {
                try {
                    conv_ops[t1].Add (t2, op);
                } catch (ArgumentException) {
                    return conv_ops[t1][t2];
                }
            }

            return op;
        }

        private static object ReadValue (Type inst_type, GotyeJsonReader reader)
        {
            reader.Read ();

            if (reader.Token == GotyeJsonToken.ArrayEnd)
                return null;

            if (reader.Token == GotyeJsonToken.Null) {

                if (! inst_type.IsClass)
                    throw new GotyeJsonException (String.Format (
                            "Can't assign null to an instance of type {0}",
                            inst_type));

                return null;
            }

            if (reader.Token == GotyeJsonToken.Double ||
                reader.Token == GotyeJsonToken.Int ||
                reader.Token == GotyeJsonToken.Long ||
                reader.Token == GotyeJsonToken.String ||
                reader.Token == GotyeJsonToken.Boolean) {

                Type json_type = reader.Value.GetType ();

                if (inst_type.IsAssignableFrom (json_type))
                    return reader.Value;

                // If there's a custom importer that fits, use it
                if (custom_importers_table.ContainsKey (json_type) &&
                    custom_importers_table[json_type].ContainsKey (
                        inst_type)) {

                    GotyeImporterFunc importer =
                        custom_importers_table[json_type][inst_type];

                    return importer (reader.Value);
                }

                // Maybe there's a base importer that works
                if (base_importers_table.ContainsKey (json_type) &&
                    base_importers_table[json_type].ContainsKey (
                        inst_type)) {

                    GotyeImporterFunc importer =
                        base_importers_table[json_type][inst_type];

                    return importer (reader.Value);
                }

                // Maybe it's an enum
                if (inst_type.IsEnum)
                    return Enum.ToObject (inst_type, reader.Value);

                // Try using an implicit conversion operator
                MethodInfo conv_op = GetConvOp (inst_type, json_type);

                if (conv_op != null)
                    return conv_op.Invoke (null,
                                           new object[] { reader.Value });

                // No luck
                throw new GotyeJsonException (String.Format (
                        "Can't assign value '{0}' (type {1}) to type {2}",
                        reader.Value, json_type, inst_type));
            }

            object instance = null;

            if (reader.Token == GotyeJsonToken.ArrayStart) {

                AddArrayMetadata (inst_type);
                GotyeArrayMetadata t_data = array_metadata[inst_type];

                if (! t_data.IsArray && ! t_data.IsList)
                    throw new GotyeJsonException (String.Format (
                            "Type {0} can't act as an array",
                            inst_type));

                IList list;
                Type elem_type;

                if (! t_data.IsArray) {
                    list = (IList) Activator.CreateInstance (inst_type);
                    elem_type = t_data.ElementType;
                } else {
                    list = new List<object> ();
                    elem_type = inst_type.GetElementType ();
                }

                while (true) {
                    object item = ReadValue (elem_type, reader);
                    if (reader.Token == GotyeJsonToken.ArrayEnd)
                        break;

                    list.Add (item);
                }

                if (t_data.IsArray) {
                    int n = list.Count;
                    instance = Array.CreateInstance (elem_type, n);

                    for (int i = 0; i < n; i++)
                        ((Array) instance).SetValue (list[i], i);
                } else
                    instance = list;

            } else if (reader.Token == GotyeJsonToken.ObjectStart) {

                AddObjectMetadata (inst_type);
                GotyeObjectMetadata t_data = object_metadata[inst_type];

                instance = Activator.CreateInstance (inst_type);

                while (true) {
                    reader.Read ();

                    if (reader.Token == GotyeJsonToken.ObjectEnd)
                        break;

                    string property = (string) reader.Value;

                    if (t_data.Properties.ContainsKey (property)) {
                        GotyePropertyMetadata prop_data =
                            t_data.Properties[property];

                        if (prop_data.IsField) {
                            ((FieldInfo) prop_data.Info).SetValue (
                                instance, ReadValue (prop_data.Type, reader));
                        } else {
                            PropertyInfo p_info =
                                (PropertyInfo) prop_data.Info;

                            if (p_info.CanWrite)
                                p_info.SetValue (
                                    instance,
                                    ReadValue (prop_data.Type, reader),
                                    null);
                            else
                                ReadValue (prop_data.Type, reader);
                        }

                    } else {
                        if (! t_data.IsDictionary)
                            throw new GotyeJsonException (String.Format (
                                    "The type {0} doesn't have the " +
                                    "property '{1}'", inst_type, property));

                        ((IDictionary) instance).Add (
                            property, ReadValue (
                                t_data.ElementType, reader));
                    }

                }

            }

            return instance;
        }

        private static IGotyeJsonWrapper ReadValue (GotyeWrapperFactory factory,
                                               GotyeJsonReader reader)
        {
            reader.Read ();

            if (reader.Token == GotyeJsonToken.ArrayEnd ||
                reader.Token == GotyeJsonToken.Null)
                return null;

            IGotyeJsonWrapper instance = factory ();

            if (reader.Token == GotyeJsonToken.String) {
                instance.SetString ((string) reader.Value);
                return instance;
            }

            if (reader.Token == GotyeJsonToken.Double) {
                instance.SetDouble ((double) reader.Value);
                return instance;
            }

            if (reader.Token == GotyeJsonToken.Int) {
                instance.SetInt ((int) reader.Value);
                return instance;
            }

            if (reader.Token == GotyeJsonToken.Long) {
                instance.SetLong ((long) reader.Value);
                return instance;
            }

            if (reader.Token == GotyeJsonToken.Boolean) {
                instance.SetBoolean ((bool) reader.Value);
                return instance;
            }

            if (reader.Token == GotyeJsonToken.ArrayStart) {
                instance.SetJsonType (GotyeJsonType.Array);

                while (true) {
                    IGotyeJsonWrapper item = ReadValue (factory, reader);
                    if (reader.Token == GotyeJsonToken.ArrayEnd)
                        break;

                    ((IList) instance).Add (item);
                }
            }
            else if (reader.Token == GotyeJsonToken.ObjectStart) {
                instance.SetJsonType (GotyeJsonType.Object);

                while (true) {
                    reader.Read ();

                    if (reader.Token == GotyeJsonToken.ObjectEnd)
                        break;

                    string property = (string) reader.Value;

                    ((IDictionary) instance)[property] = ReadValue (
                        factory, reader);
                }

            }

            return instance;
        }

        private static void RegisterBaseExporters ()
        {
            base_exporters_table[typeof (byte)] =
                delegate (object obj, GotyeJsonWriter writer) {
                    writer.Write (Convert.ToInt32 ((byte) obj));
                };

            base_exporters_table[typeof (char)] =
                delegate (object obj, GotyeJsonWriter writer) {
                    writer.Write (Convert.ToString ((char) obj));
                };

            base_exporters_table[typeof (DateTime)] =
                delegate (object obj, GotyeJsonWriter writer) {
                    writer.Write (Convert.ToString ((DateTime) obj,
                                                    datetime_format));
                };

            base_exporters_table[typeof (decimal)] =
                delegate (object obj, GotyeJsonWriter writer) {
                    writer.Write ((decimal) obj);
                };

            base_exporters_table[typeof (sbyte)] =
                delegate (object obj, GotyeJsonWriter writer) {
                    writer.Write (Convert.ToInt32 ((sbyte) obj));
                };

            base_exporters_table[typeof (short)] =
                delegate (object obj, GotyeJsonWriter writer) {
                    writer.Write (Convert.ToInt32 ((short) obj));
                };

            base_exporters_table[typeof (ushort)] =
                delegate (object obj, GotyeJsonWriter writer) {
                    writer.Write (Convert.ToInt32 ((ushort) obj));
                };

            base_exporters_table[typeof (uint)] =
                delegate (object obj, GotyeJsonWriter writer) {
                    writer.Write (Convert.ToUInt64 ((uint) obj));
                };

            base_exporters_table[typeof (ulong)] =
                delegate (object obj, GotyeJsonWriter writer) {
                    writer.Write ((ulong) obj);
                };
        }

        private static void RegisterBaseImporters ()
        {
            GotyeImporterFunc importer;

            importer = delegate (object input) {
                return Convert.ToByte ((int) input);
            };
            RegisterImporter (base_importers_table, typeof (int),
                              typeof (byte), importer);

            importer = delegate (object input) {
                return Convert.ToUInt64 ((int) input);
            };
            RegisterImporter (base_importers_table, typeof (int),
                              typeof (ulong), importer);

            importer = delegate (object input) {
                return Convert.ToSByte ((int) input);
            };
            RegisterImporter (base_importers_table, typeof (int),
                              typeof (sbyte), importer);

            importer = delegate (object input) {
                return Convert.ToInt16 ((int) input);
            };
            RegisterImporter (base_importers_table, typeof (int),
                              typeof (short), importer);

            importer = delegate (object input) {
                return Convert.ToUInt16 ((int) input);
            };
            RegisterImporter (base_importers_table, typeof (int),
                              typeof (ushort), importer);

            importer = delegate (object input) {
                return Convert.ToUInt32 ((int) input);
            };
            RegisterImporter (base_importers_table, typeof (int),
                              typeof (uint), importer);

            importer = delegate (object input) {
                return Convert.ToSingle ((int) input);
            };
            RegisterImporter (base_importers_table, typeof (int),
                              typeof (float), importer);

            importer = delegate (object input) {
                return Convert.ToDouble ((int) input);
            };
            RegisterImporter (base_importers_table, typeof (int),
                              typeof (double), importer);

            importer = delegate (object input) {
                return Convert.ToDecimal ((double) input);
            };
            RegisterImporter (base_importers_table, typeof (double),
                              typeof (decimal), importer);


            importer = delegate (object input) {
                return Convert.ToUInt32 ((long) input);
            };
            RegisterImporter (base_importers_table, typeof (long),
                              typeof (uint), importer);

            importer = delegate (object input) {
                return Convert.ToChar ((string) input);
            };
            RegisterImporter (base_importers_table, typeof (string),
                              typeof (char), importer);

            importer = delegate (object input) {
                return Convert.ToDateTime ((string) input, datetime_format);
            };
            RegisterImporter (base_importers_table, typeof (string),
                              typeof (DateTime), importer);
        }

        private static void RegisterImporter (
            IDictionary<Type, IDictionary<Type, GotyeImporterFunc>> table,
            Type json_type, Type value_type, GotyeImporterFunc importer)
        {
            if (! table.ContainsKey (json_type))
                table.Add (json_type, new Dictionary<Type, GotyeImporterFunc> ());

            table[json_type][value_type] = importer;
        }

        private static void WriteValue (object obj, GotyeJsonWriter writer,
                                        bool writer_is_private,
                                        int depth)
        {
            if (depth > max_nesting_depth)
                throw new GotyeJsonException (
                    String.Format ("Max allowed object depth reached while " +
                                   "trying to export from type {0}",
                                   obj.GetType ()));

            if (obj == null) {
                writer.Write (null);
                return;
            }

            if (obj is IGotyeJsonWrapper) {
                if (writer_is_private)
                    writer.TextWriter.Write (((IGotyeJsonWrapper) obj).ToJson ());
                else
                    ((IGotyeJsonWrapper) obj).ToJson (writer);

                return;
            }

            if (obj is String) {
                writer.Write ((string) obj);
                return;
            }

            if (obj is Double) {
                writer.Write ((double) obj);
                return;
            }

            if (obj is Int32) {
                writer.Write ((int) obj);
                return;
            }

            if (obj is Boolean) {
                writer.Write ((bool) obj);
                return;
            }

            if (obj is Int64) {
                writer.Write ((long) obj);
                return;
            }

            if (obj is Array) {
                writer.WriteArrayStart ();

                foreach (object elem in (Array) obj)
                    WriteValue (elem, writer, writer_is_private, depth + 1);

                writer.WriteArrayEnd ();

                return;
            }

            if (obj is IList) {
                writer.WriteArrayStart ();
                foreach (object elem in (IList) obj)
                    WriteValue (elem, writer, writer_is_private, depth + 1);
                writer.WriteArrayEnd ();

                return;
            }

            if (obj is IDictionary) {
                writer.WriteObjectStart ();
                foreach (DictionaryEntry entry in (IDictionary) obj) {
                    writer.WritePropertyName ((string) entry.Key);
                    WriteValue (entry.Value, writer, writer_is_private,
                                depth + 1);
                }
                writer.WriteObjectEnd ();

                return;
            }

            Type obj_type = obj.GetType ();

            // See if there's a custom exporter for the object
            if (custom_exporters_table.ContainsKey (obj_type)) {
				GotyeExporterFunc exporter = custom_exporters_table[obj_type];
                exporter (obj, writer);

                return;
            }

            // If not, maybe there's a base exporter
            if (base_exporters_table.ContainsKey (obj_type)) {
				GotyeExporterFunc exporter = base_exporters_table[obj_type];
                exporter (obj, writer);

                return;
            }

            // Last option, let's see if it's an enum
            if (obj is Enum) {
                Type e_type = Enum.GetUnderlyingType (obj_type);

                if (e_type == typeof (long)
                    || e_type == typeof (uint)
                    || e_type == typeof (ulong))
                    writer.Write ((ulong) obj);
                else
                    writer.Write ((int) obj);

                return;
            }

            // Okay, so it looks like the input should be exported as an
            // object
            AddTypeProperties (obj_type);
            IList<GotyePropertyMetadata> props = type_properties[obj_type];

            writer.WriteObjectStart ();
            foreach (GotyePropertyMetadata p_data in props) {
                if (p_data.IsField) {
                    writer.WritePropertyName (p_data.Info.Name);
                    WriteValue (((FieldInfo) p_data.Info).GetValue (obj),
                                writer, writer_is_private, depth + 1);
                }
                else {
                    PropertyInfo p_info = (PropertyInfo) p_data.Info;

                    if (p_info.CanRead) {
                        writer.WritePropertyName (p_data.Info.Name);
                        WriteValue (p_info.GetValue (obj, null),
                                    writer, writer_is_private, depth + 1);
                    }
                }
            }
            writer.WriteObjectEnd ();
        }
        #endregion


        public static string ToJson (object obj)
        {
            lock (static_writer_lock) {
                static_writer.Reset ();

                WriteValue (obj, static_writer, true, 0);

                return static_writer.ToString ();
            }
        }

        public static void ToJson (object obj, GotyeJsonWriter writer)
        {
            WriteValue (obj, writer, false, 0);
        }

        public static GotyeJsonData ToObject (GotyeJsonReader reader)
        {
            return (GotyeJsonData) ToWrapper (
                delegate { return new GotyeJsonData (); }, reader);
        }

        public static GotyeJsonData ToObject (TextReader reader)
        {
            GotyeJsonReader json_reader = new GotyeJsonReader (reader);

            return (GotyeJsonData) ToWrapper (
                delegate { return new GotyeJsonData (); }, json_reader);
        }

        public static GotyeJsonData ToObject (string json)
        {
            return (GotyeJsonData) ToWrapper (
                delegate { return new GotyeJsonData (); }, json);
        }

        public static T ToObject<T> (GotyeJsonReader reader)
        {
            return (T) ReadValue (typeof (T), reader);
        }

        public static T ToObject<T> (TextReader reader)
        {
            GotyeJsonReader json_reader = new GotyeJsonReader (reader);

            return (T) ReadValue (typeof (T), json_reader);
        }

        public static T ToObject<T> (string json)
        {
            GotyeJsonReader reader = new GotyeJsonReader (json);

            return (T) ReadValue (typeof (T), reader);
        }

        public static IGotyeJsonWrapper ToWrapper (GotyeWrapperFactory factory,
                                              GotyeJsonReader reader)
        {
            return ReadValue (factory, reader);
        }

        public static IGotyeJsonWrapper ToWrapper (GotyeWrapperFactory factory,
                                              string json)
        {
            GotyeJsonReader reader = new GotyeJsonReader (json);

            return ReadValue (factory, reader);
        }

        public static void RegisterExporter<T> (GotyeExporterFunc exporter)
        {
			GotyeExporterFunc exporter_wrapper =
                delegate (object obj, GotyeJsonWriter writer) {
                    exporter ((T) obj, writer);
                };

            custom_exporters_table[typeof (T)] = exporter_wrapper;
        }

        public static void RegisterImporter<TJson, TValue> (
            GotyeImporterFunc importer)
        {
            GotyeImporterFunc importer_wrapper =
                delegate (object input) {
                    return importer ((TJson) input);
                };

            RegisterImporter (custom_importers_table, typeof (TJson),
                              typeof (TValue), importer_wrapper);
        }

        public static void UnregisterExporters ()
        {
            custom_exporters_table.Clear ();
        }

        public static void UnregisterImporters ()
        {
            custom_importers_table.Clear ();
        }
    }
}
