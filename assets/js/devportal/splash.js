(function () {
    "use strict";
    window.setTimeout(function () {
        const el = document.getElementById("splash");
        if (!el) {
            return void 0;
        }
        el.style.opacity = "1";
    }, 200);
}());
window.__removeSplash = (callback) => {
    // Remove the splash loader
    const splash = document.getElementById("splash");
    setTimeout(() => {
        if (splash) {
            if (splash.style.opacity === "1") {
                // ensure a minimum splash loader animation time before animating it out to avoid flickering in/out
                splash.style.opacity = "0";
                setTimeout(() => {
                    splash.remove();
                    callback();
                }, 250);
            } else {
                // splash was not visible so just call callback after removing
                splash.remove();
                callback();
            }
        } else {
            // no splash found so just call callback
            callback();
        }
    }, 1000);
};