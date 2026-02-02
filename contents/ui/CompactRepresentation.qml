// /*
//     SPDX-FileCopyrightText: 2013 Marco Martin <mart@kde.org>

//     SPDX-License-Identifier: GPL-2.0-or-later
// */

// import QtQuick 2.15
// import QtQuick.Controls 2.15
// import QtQuick.Layouts 1.15

// import org.kde.plasma.core as PlasmaCore
// import org.kde.plasma.plasmoid 2.0
// import org.kde.kirigami 2.20 as Kirigami


// Kirigami.Icon {
//     id: defaultCompactRepresentation

//     property PlasmoidItem plasmoidItem
//     readonly property bool inPanel: [PlasmaCore.Types.TopEdge, PlasmaCore.Types.RightEdge, PlasmaCore.Types.BottomEdge, PlasmaCore.Types.LeftEdge]
//         .includes(Plasmoid.location)

//     Layout.minimumWidth: {
//         switch (Plasmoid.formFactor) {
//         case PlasmaCore.Types.Vertical:
//             return 0;
//         case PlasmaCore.Types.Horizontal:
//             return height;
//         default:
//             return Kirigami.Units.gridUnit * 3;
//         }
//     }

//     Layout.minimumHeight: {
//         switch (Plasmoid.formFactor) {
//         case PlasmaCore.Types.Vertical:
//             return width;
//         case PlasmaCore.Types.Horizontal:
//             return 0;
//         default:
//             return Kirigami.Units.gridUnit * 3;
//         }
//     }

//     source: Plasmoid.icon || "plasma"
//     active: mouseArea.containsMouse

//     activeFocusOnTab: true

//     Keys.onPressed: event => {
//         switch (event.key) {
//         case Qt.Key_Space:
//         case Qt.Key_Enter:
//         case Qt.Key_Return:
//         case Qt.Key_Select:
//             Plasmoid.activated();
//             event.accepted = true; // BUG 481393: Prevent system tray from receiving the event
//             break;
//         }
//     }

//     Accessible.name: Plasmoid.title
//     Accessible.description: plasmoidItem.toolTipSubText ?? ""
//     Accessible.role: Accessible.Button

//     MouseArea {
//         id: mouseArea

//         property bool wasExpanded: false

//         anchors.fill: parent
//         hoverEnabled: true
//         onPressed: wasExpanded = plasmoidItem.expanded
//         onClicked: mouse => {
//             if (mouse.button === Qt.MiddleButton) {
//                 defaultCompactRepresentation.plasmoidItem.Plasmoid.secondaryActivated();
//             } else {
//                 defaultCompactRepresentation.plasmoidItem.expanded = !wasExpanded;
//             }
//         }
//     }
// }

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami 2.20 as Kirigami

Item {
    id: root

    property var displayTimes: ({})
    property string activePrayer
    property PlasmoidItem plasmoidItem
    property int languageIndex: 0

    readonly property int maxCompactLabelPixelSize: Kirigami.Theme.defaultFont.pixelSize
    readonly property int minCompactLabelPixelSize: 8

    PlasmaComponents.Label {
        anchors.fill: parent
        anchors.margins: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.NoWrap

        font.pixelSize: {
            let calculatedSize = Math.floor(root.height * 0.7);
            return Math.max(root.minCompactLabelPixelSize, Math.min(calculatedSize, root.maxCompactLabelPixelSize));
        }
        text: getPrayerName(languageIndex, getNextPrayer(activePrayer)) + " " + displayTimes[getNextPrayer(activePrayer).toLowerCase()]
    }

    function getNextPrayer(prayer) {
        var prayers = ["Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha"];
        var index = prayers.indexOf(prayer);
        if (index === -1 || index === prayers.length - 1) return prayers[0];
        return prayers[index + 1]
    }

    MouseArea {
        id: mouseArea
        property bool wasExpanded: false
        anchors.fill: parent
        hoverEnabled: true
        onPressed: wasExpanded = root.plasmoidItem ? root.plasmoidItem.expanded : false
        onClicked: mouse => {
            if (root.plasmoidItem) {
                root.plasmoidItem.expanded = !wasExpanded
            }
        }
    }
}
