using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Contacts.RNContacts
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNContactsModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNContactsModule"/>.
        /// </summary>
        internal RNContactsModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNContacts";
            }
        }
    }
}
