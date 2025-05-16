/*
    SPDX-FileCopyrightText: 2013 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.20 as Kirigami

Item {
    id: nextPrayerRepresentation

    Label {
        id: nextPrayer
        text: "magrib at 4:72 pm"
        color: Kirigami.Theme.textColor
        font.pixelSize: Kirigami.Units.iconSizes.small
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        Layout.fillWidth: true
    }
}
