var Foo = {};
(function (namespace) {
    "use strict";

    var truthy = true;
    if (truthy == true) {
        return 'truthy';
    }

    namespace.bar = function () {
        return 'bar';
    };

    return namespace;
}(Foo));

Foo.bar();
