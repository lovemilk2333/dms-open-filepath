// https://danklinux.com/docs/dankmaterialshell/plugin-development

import QtQuick
import Quickshell // https://quickshell.org/docs/master/types/Quickshell/

QtObject {
    id: root

    property var pluginService: null

    // START disable trigger
    property string trigger: ""
    Component.onCompleted: {
        if (typeof pluginService === "undefined")
            return;

        pluginService.savePluginData("openfilepath", "trigger", "");
    }
    // END disable trigger

    function getItems(query) {
        const items = [];
        if (!query) {
            return items;
        }

        let path = "";
        let displayPath = "";

        query = query.trim();
        // NOTE: query === "~" may not work, because DMS launcher will not pass the query if query is only one special character
        const isHome = query === "~" || query === "$H" || query === "$HO" || query === "$HOM" || query === "$HOME";
        const includeHome = query.startsWith("~/");
        const likeWinePath = query.startsWith("z:\\") || query.startsWith("Z:\\");
        const likePath = query.includes("/");
        if ((likePath || likeWinePath || isHome || includeHome)) {
            path = query;
            displayPath = path;
            if (includeHome) {
                path = `$HOME${path.slice(1)}`;
            } else if (isHome) {
                path = "$HOME";
            }

            if (likeWinePath) {
                path = "/" + path.split(":\\", 2)[1];
                // no `string.replaceAll()`
                path = path.replace(/\\/g, "/");
                displayPath = path;
            }
        }

        if (path && path.length) {
            items.push({
                name: `Open filepath`,
                icon: "material:folder_open",
                comment: displayPath,
                action: path,
                categories: ["File"]
            });

            const parts = path.split('/');
            if (parts.length > 1 && !path.endsWith("/")) {
                const pathWithoutFile = parts.slice(0, -1).join('/');
                const displayPathWithoutFile = displayPath.split('/').slice(0, -1).join('/');

                items.push({
                    name: `Open parent directory`,
                    icon: "material:folder_open",
                    comment: displayPathWithoutFile,
                    action: pathWithoutFile,
                    categories: ["File"]
                });
            }
        }

        return items;
    }

    function executeItem(item) {
        if (!item?.action)
            return;
        const filepath = item.action;

        Quickshell.execDetached(['sh', '-c', `err=$(xdg-open "${filepath}" 2>&1 >/dev/null); [ $? -ne 0 ] && notify-send -a 'Open File Path' "cannot open filepath with status $?" "$err"`]);
    }
}
