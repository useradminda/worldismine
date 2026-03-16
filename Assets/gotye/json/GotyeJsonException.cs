#region Header
/**
 * JsonException.cs
 *   Base class throwed by LitJSON when a parsing error occurs.
 *
 * The authors disclaim copyright to this source code. For more details, see
 * the COPYING file included with this distribution.
 **/
#endregion


using System;


namespace gotyejson
{
    public class GotyeJsonException : Exception
    {
        public GotyeJsonException () : base ()
        {
        }

        internal GotyeJsonException (GotyeParserToken token) :
            base (String.Format (
                    "Invalid token '{0}' in input string", token))
        {
        }

        internal GotyeJsonException (GotyeParserToken token,
                                Exception inner_exception) :
            base (String.Format (
                    "Invalid token '{0}' in input string", token),
                inner_exception)
        {
        }

        internal GotyeJsonException (int c) :
            base (String.Format (
                    "Invalid character '{0}' in input string", (char) c))
        {
        }

        internal GotyeJsonException (int c, Exception inner_exception) :
            base (String.Format (
                    "Invalid character '{0}' in input string", (char) c),
                inner_exception)
        {
        }


        public GotyeJsonException (string message) : base (message)
        {
        }

        public GotyeJsonException (string message, Exception inner_exception) :
            base (message, inner_exception)
        {
        }
    }
}
