import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins
import qs.Services

PluginSettings {
    id: root
    pluginId: "openFilePath"

    StyledText {
        width: parent.width
        text: "Open File Path"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        text: "This plugin has no configurable settings."
        font.pixelSize: Theme.fontSizeMedium
        color: Theme.surfaceVariantText
    }

    StringSetting {
        id: triggerSetting
        settingKey: "trigger"
        placeholder: ""
        defaultValue: ""
    }
}
