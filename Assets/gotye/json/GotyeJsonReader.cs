#region Header
/**
 * JsonReader.cs
 *   Stream-like access to JSON text.
 *
 * The authors disclaim copyright to this source code. For more details, see
 * the COPYING file included with this distribution.
 **/
#endregion


using System;
using System.Collections.Generic;
using System.IO;
using System.Text;


namespace gotyejson
{
    public enum GotyeJsonToken
    {
        None,

        ObjectStart,
        PropertyName,
        ObjectEnd,

        ArrayStart,
        ArrayEnd,

        Int,
        Long,
        Double,

        String,

        Boolean,
        Null
    }


    public class GotyeJsonReader
    {
        #region Fields
        private static IDictionary<int, IDictionary<int, int[]>> parse_table;

        private Stack<int>    automaton_stack;
        private int           current_input;
        private int           current_symbol;
        private bool          end_of_json;
        private bool          end_of_input;
        private GotyeLexer         lexer;
        private bool          parser_in_string;
        private bool          parser_return;
        private bool          read_started;
        private TextReader    reader;
        private bool          reader_is_owned;
        private object        token_value;
        private GotyeJsonToken     token;
        #endregion


        #region Public Properties
        public bool AllowComments {
            get { return lexer.AllowComments; }
            set { lexer.AllowComments = value; }
        }

        public bool AllowSingleQuotedStrings {
            get { return lexer.AllowSingleQuotedStrings; }
            set { lexer.AllowSingleQuotedStrings = value; }
        }

        public bool EndOfInput {
            get { return end_of_input; }
        }

        public bool EndOfJson {
            get { return end_of_json; }
        }

        public GotyeJsonToken Token {
            get { return token; }
        }

        public object Value {
            get { return token_value; }
        }
        #endregion


        #region Constructors
        static GotyeJsonReader ()
        {
            PopulateParseTable ();
        }

        public GotyeJsonReader (string json_text) :
            this (new StringReader (json_text), true)
        {
        }

        public GotyeJsonReader (TextReader reader) :
            this (reader, false)
        {
        }

        private GotyeJsonReader (TextReader reader, bool owned)
        {
            if (reader == null)
                throw new ArgumentNullException ("reader");

            parser_in_string = false;
            parser_return = false;

            read_started = false;
            automaton_stack = new Stack<int> ();
            automaton_stack.Push ((int) GotyeParserToken.End);
            automaton_stack.Push ((int) GotyeParserToken.Text);

            lexer = new GotyeLexer (reader);

            end_of_input = false;
            end_of_json  = false;

            this.reader = reader;
            reader_is_owned = owned;
        }
        #endregion


        #region Static Methods
        private static void PopulateParseTable ()
        {
            parse_table = new Dictionary<int, IDictionary<int, int[]>> ();

            TableAddRow (GotyeParserToken.Array);
            TableAddCol (GotyeParserToken.Array, '[',
                         '[',
                         (int) GotyeParserToken.ArrayPrime);

            TableAddRow (GotyeParserToken.ArrayPrime);
            TableAddCol (GotyeParserToken.ArrayPrime, '"',
                         (int) GotyeParserToken.Value,

                         (int) GotyeParserToken.ValueRest,
                         ']');
            TableAddCol (GotyeParserToken.ArrayPrime, '[',
                         (int) GotyeParserToken.Value,
                         (int) GotyeParserToken.ValueRest,
                         ']');
            TableAddCol (GotyeParserToken.ArrayPrime, ']',
                         ']');
            TableAddCol (GotyeParserToken.ArrayPrime, '{',
                         (int) GotyeParserToken.Value,
                         (int) GotyeParserToken.ValueRest,
                         ']');
            TableAddCol (GotyeParserToken.ArrayPrime, (int) GotyeParserToken.Number,
                         (int) GotyeParserToken.Value,
                         (int) GotyeParserToken.ValueRest,
                         ']');
            TableAddCol (GotyeParserToken.ArrayPrime, (int) GotyeParserToken.True,
                         (int) GotyeParserToken.Value,
                         (int) GotyeParserToken.ValueRest,
                         ']');
            TableAddCol (GotyeParserToken.ArrayPrime, (int) GotyeParserToken.False,
                         (int) GotyeParserToken.Value,
                         (int) GotyeParserToken.ValueRest,
                         ']');
            TableAddCol (GotyeParserToken.ArrayPrime, (int) GotyeParserToken.Null,
                         (int) GotyeParserToken.Value,
                         (int) GotyeParserToken.ValueRest,
                         ']');

            TableAddRow (GotyeParserToken.Object);
            TableAddCol (GotyeParserToken.Object, '{',
                         '{',
                         (int) GotyeParserToken.ObjectPrime);

            TableAddRow (GotyeParserToken.ObjectPrime);
            TableAddCol (GotyeParserToken.ObjectPrime, '"',
                         (int) GotyeParserToken.Pair,
                         (int) GotyeParserToken.PairRest,
                         '}');
            TableAddCol (GotyeParserToken.ObjectPrime, '}',
                         '}');

            TableAddRow (GotyeParserToken.Pair);
            TableAddCol (GotyeParserToken.Pair, '"',
                         (int) GotyeParserToken.String,
                         ':',
                         (int) GotyeParserToken.Value);

            TableAddRow (GotyeParserToken.PairRest);
            TableAddCol (GotyeParserToken.PairRest, ',',
                         ',',
                         (int) GotyeParserToken.Pair,
                         (int) GotyeParserToken.PairRest);
            TableAddCol (GotyeParserToken.PairRest, '}',
                         (int) GotyeParserToken.Epsilon);

            TableAddRow (GotyeParserToken.String);
            TableAddCol (GotyeParserToken.String, '"',
                         '"',
                         (int) GotyeParserToken.CharSeq,
                         '"');

            TableAddRow (GotyeParserToken.Text);
            TableAddCol (GotyeParserToken.Text, '[',
                         (int) GotyeParserToken.Array);
            TableAddCol (GotyeParserToken.Text, '{',
                         (int) GotyeParserToken.Object);

            TableAddRow (GotyeParserToken.Value);
            TableAddCol (GotyeParserToken.Value, '"',
                         (int) GotyeParserToken.String);
            TableAddCol (GotyeParserToken.Value, '[',
                         (int) GotyeParserToken.Array);
            TableAddCol (GotyeParserToken.Value, '{',
                         (int) GotyeParserToken.Object);
            TableAddCol (GotyeParserToken.Value, (int) GotyeParserToken.Number,
                         (int) GotyeParserToken.Number);
            TableAddCol (GotyeParserToken.Value, (int) GotyeParserToken.True,
                         (int) GotyeParserToken.True);
            TableAddCol (GotyeParserToken.Value, (int) GotyeParserToken.False,
                         (int) GotyeParserToken.False);
            TableAddCol (GotyeParserToken.Value, (int) GotyeParserToken.Null,
                         (int) GotyeParserToken.Null);

            TableAddRow (GotyeParserToken.ValueRest);
            TableAddCol (GotyeParserToken.ValueRest, ',',
                         ',',
                         (int) GotyeParserToken.Value,
                         (int) GotyeParserToken.ValueRest);
            TableAddCol (GotyeParserToken.ValueRest, ']',
                         (int) GotyeParserToken.Epsilon);
        }

        private static void TableAddCol (GotyeParserToken row, int col,
                                         params int[] symbols)
        {
            parse_table[(int) row].Add (col, symbols);
        }

        private static void TableAddRow (GotyeParserToken rule)
        {
            parse_table.Add ((int) rule, new Dictionary<int, int[]> ());
        }
        #endregion


        #region Private Methods
        private void ProcessNumber (string number)
        {
            if (number.IndexOf ('.') != -1 ||
                number.IndexOf ('e') != -1 ||
                number.IndexOf ('E') != -1) {

                double n_double;
                if (Double.TryParse (number, out n_double)) {
                    token = GotyeJsonToken.Double;
                    token_value = n_double;

                    return;
                }
            }

            int n_int32;
            if (Int32.TryParse (number, out n_int32)) {
                token = GotyeJsonToken.Int;
                token_value = n_int32;

                return;
            }

            long n_int64;
            if (Int64.TryParse (number, out n_int64)) {
                token = GotyeJsonToken.Long;
                token_value = n_int64;

                return;
            }

            // Shouldn't happen, but just in case, return something
            token = GotyeJsonToken.Int;
            token_value = 0;
        }

        private void ProcessSymbol ()
        {
            if (current_symbol == '[')  {
                token = GotyeJsonToken.ArrayStart;
                parser_return = true;

            } else if (current_symbol == ']')  {
                token = GotyeJsonToken.ArrayEnd;
                parser_return = true;

            } else if (current_symbol == '{')  {
                token = GotyeJsonToken.ObjectStart;
                parser_return = true;

            } else if (current_symbol == '}')  {
                token = GotyeJsonToken.ObjectEnd;
                parser_return = true;

            } else if (current_symbol == '"')  {
                if (parser_in_string) {
                    parser_in_string = false;

                    parser_return = true;

                } else {
                    if (token == GotyeJsonToken.None)
                        token = GotyeJsonToken.String;

                    parser_in_string = true;
                }

            } else if (current_symbol == (int) GotyeParserToken.CharSeq) {
                token_value = lexer.StringValue;

            } else if (current_symbol == (int) GotyeParserToken.False)  {
                token = GotyeJsonToken.Boolean;
                token_value = false;
                parser_return = true;

            } else if (current_symbol == (int) GotyeParserToken.Null)  {
                token = GotyeJsonToken.Null;
                parser_return = true;

            } else if (current_symbol == (int) GotyeParserToken.Number)  {
                ProcessNumber (lexer.StringValue);

                parser_return = true;

            } else if (current_symbol == (int) GotyeParserToken.Pair)  {
                token = GotyeJsonToken.PropertyName;

            } else if (current_symbol == (int) GotyeParserToken.True)  {
                token = GotyeJsonToken.Boolean;
                token_value = true;
                parser_return = true;

            }
        }

        private bool ReadToken ()
        {
            if (end_of_input)
                return false;

            lexer.NextToken ();

            if (lexer.EndOfInput) {
                Close ();

                return false;
            }

            current_input = lexer.Token;

            return true;
        }
        #endregion


        public void Close ()
        {
            if (end_of_input)
                return;

            end_of_input = true;
            end_of_json  = true;

            if (reader_is_owned)
                reader.Dispose();

            reader = null;
        }

        public bool Read ()
        {
            if (end_of_input)
                return false;

            if (end_of_json) {
                end_of_json = false;
                automaton_stack.Clear ();
                automaton_stack.Push ((int) GotyeParserToken.End);
                automaton_stack.Push ((int) GotyeParserToken.Text);
            }

            parser_in_string = false;
            parser_return    = false;

            token       = GotyeJsonToken.None;
            token_value = null;

            if (! read_started) {
                read_started = true;

                if (! ReadToken ())
                    return false;
            }


            int[] entry_symbols;

            while (true) {
                if (parser_return) {
                    if (automaton_stack.Peek () == (int) GotyeParserToken.End)
                        end_of_json = true;

                    return true;
                }

                current_symbol = automaton_stack.Pop ();

                ProcessSymbol ();

                if (current_symbol == current_input) {
                    if (! ReadToken ()) {
                        if (automaton_stack.Peek () != (int) GotyeParserToken.End)
                            throw new GotyeJsonException (
                                "Input doesn't evaluate to proper JSON text");

                        if (parser_return)
                            return true;

                        return false;
                    }

                    continue;
                }

                try {

                    entry_symbols =
                        parse_table[current_symbol][current_input];

                } catch (KeyNotFoundException e) {
                    throw new GotyeJsonException ((GotyeParserToken) current_input, e);
                }

                if (entry_symbols[0] == (int) GotyeParserToken.Epsilon)
                    continue;

                for (int i = entry_symbols.Length - 1; i >= 0; i--)
                    automaton_stack.Push (entry_symbols[i]);
            }
        }

    }
}
