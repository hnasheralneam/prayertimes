import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

Rectangle {
    id: prayerBlock

    width: parent.width
    color: Kirigami.Theme.highlightColor
    height: 28
    radius: 8

    Text {
        id: prayerTitle

        fontSizeMode: Text.Fit
        text: prayer
        color: isNextPrayer ? Kirigami.Theme.textColor : Kirigami.Theme.neutralBackgroundColor
        font.pixelSize: 20
        leftPadding: 5
    }

    Text {
        id: prayerTime

        anchors.right: parent.right
        text: "00:00"
        color: Kirigami.Theme.textColor
        font.pixelSize: 20
        rightPadding: 5
    }

    property string prayer
    property bool isNextPrayer: false
}
