(function(){
    "use strict";

    this.Calc = function () {
        return Object.freeze({
            add: function(x, y) { return x + y; },
            div: function(x, y) { return x / y; },
            version: 0.01,
        });
        
    }();

}).call(this);

