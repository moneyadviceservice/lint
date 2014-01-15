var Foo = {};
(function (namespace) {
    "use strict";

    namespace.bar = function () {
        return 'bar'
    };

    return namespace;
}(Foo));

Foo.bar();
