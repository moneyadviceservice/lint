var Foo = {};
(function (namespace) {
    "use strict";

    var nully = null;
    if (nully == null) {
        return 'nully';
    }

    namespace.bar = function () {
        return 'bar';
    };

    return namespace;
}(Foo));

Foo.bar();
