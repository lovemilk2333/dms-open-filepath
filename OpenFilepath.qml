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
        const likeWindowsPath = query.includes(":\\");
        const likeWinePath = likeWindowsPath && (query.startsWith("z:\\") || query.startsWith("Z:\\"));
        const likePath = query.includes("/");
        if ((likePath || likeWindowsPath || isHome || includeHome)) {
            path = query;
            displayPath = path;
            if (includeHome) {
                path = `$HOME${path.slice(1)}`;
            } else if (isHome) {
                path = "$HOME";
            }

            if (likeWindowsPath) {
                // replace `\` to `/`
                path = path.replace(/\\/g, "/");

                // if is wine path, replace `z:\` to `/`
                if (likeWinePath) {
                    path = "/" + path.split(":/", 2)[1];
                }

                displayPath = path;
            }
        }

        if (path && path.length) {
            items.push({
                name: `Open filepath`,
                icon: "material:folder_open",
                comment: displayPath,
                action: "open::" + path,
                categories: ["File"]
            }, {
                name: `Copy filepath to clipboard`,
                icon: "material:content_copy",
                comment: displayPath,
                action: "copy::" + path,
                categories: ["File"]
            });

            const parts = path.split('/');
            // parts.length > 1 && !path.endsWith("/")
            if (parts.length > 1) {
                const pathWithoutFile = parts.slice(0, -1).join('/');
                const displayPathWithoutFile = displayPath.split('/').slice(0, -1).join('/');

                items.push({
                    name: `Open parent directory`,
                    icon: "material:folder_open",
                    comment: displayPathWithoutFile,
                    action: "open::" + pathWithoutFile,
                    categories: ["File"]
                });
            }
        }

        return items;
    }

    readonly property var actions: {
        "open": filepath => Quickshell.execDetached(['sh', '-c', `err=$(xdg-open "${filepath}" 2>&1 >/dev/null); [ $? -ne 0 ] && notify-send -a 'Open File Path' "cannot open filepath with status $?" "$err"`]),
        "copy": filepath => Quickshell.execDetached(['wl-copy', filepath])
    }

    function executeItem(item) {
        if (!item?.action)
            return;
        const [action, filepath] = item.action.split("::", 2);

        if (!filepath || !filepath.length)
            return;

        const actionExecuter = actions[action];

        if (typeof actionExecuter === "function") {
            actionExecuter(filepath);
        }
    }
}
