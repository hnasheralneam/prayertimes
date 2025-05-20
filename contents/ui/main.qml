import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

PlasmoidItem {
    readonly property bool isVertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    property bool isSmall: width < (Kirigami.Units.gridUnit * 10) || height < (Kirigami.Units.gridUnit * 10)
    property int languageIndex: Plasmoid.configuration.languageIndex !== undefined ? Plasmoid.configuration.languageIndex : 0

    width: Kirigami.Units.gridUnit * 15
    height: Kirigami.Units.gridUnit * 22
    preferredRepresentation: isSmall ? compactRepresentation : fullRepresentation

    //     Layout.minimumWidth: isVertical ? 0 : compactRow.implicitWidth
    //     Layout.maximumWidth: isVertical ? Infinity : Layout.minimumWidth
    //     Layout.preferredWidth: isVertical ? -1 : Layout.minimumWidth

    //     Layout.minimumHeight: isVertical ? label.height : Kirigami.Theme.smallFont.pixelSize
    //     Layout.maximumHeight: isVertical ? Layout.minimumHeight : Infinity
    //     Layout.preferredHeight: isVertical ? Layout.minimumHeight : Kirigami.Units.iconSizes.sizeForLabels * 2

    // compactRepresentation: MouseArea {
    //     id: compactRoot

    //     width: Kirigami.Units.gridUnit * 15
    //     property bool wasExpanded
    //     onPressed: wasExpanded = root.expanded
    //     onClicked: root.expanded = !wasExpanded

    //     Row {
    //         id: compactRow

    //         anchors.centerIn: parent
    //         spacing: Kirigami.Units.smallSpacing

    //         Kirigami.Icon {
    //             id: icon

    //             anchors.verticalCenter: parent.verticalCenter
    //             height: Layout.minimumHeight
    //             width: height

    //             source: Plasmoid.icon || "plasma"
    //             visible: true
    //         }

    //         Label {
    //             id: label

    //             width: Kirigami.Units.gridUnit * 15
    //             height: Layout.minimumHeight

    //             text: "hai there"
    //             textFormat: Text.PlainText
    //             horizontalAlignment: Text.AlignHCenter
    //             verticalAlignment: Text.AlignVCenter
    //             wrapMode: Text.NoWrap
    //             fontSizeMode: root.isVertical ? Text.HorizontalFit : Text.VerticalFit
    //             font.pixelSize: tooSmall ? Kirigami.Theme.defaultFont.pixelSize : Kirigami.Units.iconSizes.roundedIconSize(Kirigami.Units.gridUnit * 2)
    //             minimumPointSize: Kirigami.Theme.smallFont.pointSize
    //             visible: true
    //         }
    //     }
    // }

    Connections {
        target: Plasmoid
        onConfigurationChanged: {
            languageUpdate();  // Update language when configuration is altered
        }
    }
    compactRepresentation: CompactRepresentation {
    }

    fullRepresentation: Column {
        id: prayerClock

        function languageUpdate() {
            languageIndex = Plasmoid.configuration.languageIndex; // change language
        }


        function to12HourTime(timeString, isActive) {
            if (isActive) {  // if checkbox is active, convert to 12-hour format
                let parts = timeString.split(':');
                let hours =  parseInt(parts[0], 10);
                let minutes = parseInt(parts[1], 10);
                let period = hours >= 12 ? "PM" : "AM";
                hours = hours % 12 || 12;
                if (minutes > 9) {
                    return `${hours}:${minutes} ${period}`;
                } else {
                    return `${hours}:0${minutes} ${period}`;
                }
            } else {  // no change
                return timeString;
            }
        }


        function parseTime(timeString) {
            let parts = timeString.split(':');
            let dateObj = new Date();
            dateObj.setHours(parseInt(parts[0], 10));
            dateObj.setMinutes(parseInt(parts[1], 10));
            dateObj.setSeconds(0);
            return dateObj;
        }


        function getPrayerName(languageIndex, prayer) {
            if (languageIndex === 0) {
                return prayer;
            } else {
                let arabicPrayers = {
                    "Fajr": "الفجر",
                    "Sunrise": "الشروق",
                    "Dhuhr": "الظهر",
                    "Asr": "العصر",
                    "Maghrib": "المغرب",
                    "Isha": "العشاء"
                }
                return arabicPrayers[prayer];
            }
        }


        function findHighlighted(timings) {
            fajr.color = "transparent";
            sunrise.color = "transparent";
            dhuhr.color = "transparent";
            asr.color = "transparent";
            maghrib.color = "transparent";
            isha.color = "transparent";
            fajrTitle.color = Kirigami.Theme.textColor;
            sunriseTitle.color = Kirigami.Theme.textColor;
            dhuhrTitle.color = Kirigami.Theme.textColor;
            asrTitle.color = Kirigami.Theme.textColor;
            maghribTitle.color = Kirigami.Theme.textColor;
            ishaTitle.color = Kirigami.Theme.textColor;
            fajrTime.color = Kirigami.Theme.textColor;
            sunriseTime.color = Kirigami.Theme.textColor;
            dhuhrTime.color = Kirigami.Theme.textColor;
            asrTime.color = Kirigami.Theme.textColor;
            maghribTime.color = Kirigami.Theme.textColor;
            ishaTime.color = Kirigami.Theme.textColor;
            if (Date.now() > parseTime(timings.Isha)) {
                fajr.color = Kirigami.Theme.highlightColor;
                fajrTitle.color = Kirigami.Theme.neutralBackgroundColor;
                fajrTime.color = Kirigami.Theme.neutralBackgroundColor;
            }
            else if (Date.now() > parseTime(timings.Maghrib)) {
                isha.color = Kirigami.Theme.highlightColor;
                ishaTitle.color = Kirigami.Theme.neutralBackgroundColor;
                ishaTime.color = Kirigami.Theme.neutralBackgroundColor;
            } else if (Date.now() > parseTime(timings.Maghrib)) {
                maghrib.color = Kirigami.Theme.highlightColor;
                maghribTitle.color = Kirigami.Theme.neutralBackgroundColor;
                maghribTime.color = Kirigami.Theme.neutralBackgroundColor;
            } else if (Date.now() > parseTime(timings.Asr)) {
                asr.color = Kirigami.Theme.highlightColor;
                asrTitle.color = Kirigami.Theme.neutralBackgroundColor;
                asrTime.color = Kirigami.Theme.neutralBackgroundColor;
            } else if (Date.now() > parseTime(timings.Dhuhr)) {
                dhuhr.color = Kirigami.Theme.highlightColor;
                dhuhrTitle.color = Kirigami.Theme.neutralBackgroundColor;
                dhuhrTime.color = Kirigami.Theme.neutralBackgroundColor;
            } else if (Date.now() > parseTime(timings.Sunrise)) {
                sunrise.color = Kirigami.Theme.highlightColor;
                sunriseTitle.color = Kirigami.Theme.neutralBackgroundColor;
                sunriseTime.color = Kirigami.Theme.neutralBackgroundColor;
            } else if (Date.now() > parseTime(timings.Fajr)) {
                fajr.color = Kirigami.Theme.highlightColor;
                fajrTitle.color = Kirigami.Theme.neutralBackgroundColor;
                fajrTime.color = Kirigami.Theme.neutralBackgroundColor;
            }
        }


        function refresh_times() {
            let URL = "https://api.aladhan.com/v1/timingsByCity/timingsByCity?city=" + Plasmoid.configuration.city + "&country=" + Plasmoid.configuration.country + "&method="  + Plasmoid.configuration.method + "&school=" + Plasmoid.configuration.school;
            request(URL, (o) => {
                if (o.status === 200) {
                    let data = JSON.parse(o.responseText).data;
                    findHighlighted(data.timings);

                    let isActive = Plasmoid.configuration.hourFormat;
                    fajrTime.text = to12HourTime(data.timings.Fajr, isActive);
                    sunriseTime.text = to12HourTime(data.timings.Sunrise, isActive);
                    dhuhrTime.text = to12HourTime(data.timings.Dhuhr, isActive);
                    asrTime.text = to12HourTime(data.timings.Asr, isActive);
                    maghribTime.text = to12HourTime(data.timings.Maghrib, isActive);
                    ishaTime.text = to12HourTime(data.timings.Isha, isActive);
                } else {
                    console.log("Some error has occurred");
                }
            });
        }


        function request(url, callback) {
            let xhr = new XMLHttpRequest();
            xhr.onreadystatechange = (function(myxhr) {
                return function() {
                    if (myxhr.readyState === 4)
                        callback(myxhr);

                };
            })(xhr);
            xhr.open("GET", url);
            xhr.send();
        }


        Component.onCompleted: {
            refresh_times();
        }

        Item {
            Timer {
                interval: 300000 // repeat every 5 minutes
                running: true
                repeat: true
                onTriggered: refresh_times()
            }

        }

        Column {
            width: parent.width * 5 / 6
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                id: titleLabel

                text: languageIndex === 0 ? "Prayer Times" : "مواقيت الصلاة"
                font.pixelSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: subtitleLabel

                text: Plasmoid.configuration.city + ", " + Plasmoid.configuration.country
                font.pixelSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
            }

            MenuSeparator {
                topPadding: 10
                bottomPadding: 10
            }

            Rectangle {
                id: fajr
                width: parent.width
                color: Kirigami.Theme.neutralBackgroundColor
                height: 28
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    layoutDirection: languageIndex === 0 ? Qt.LeftToRight : Qt.RightToLeft

                    Label {
                        id: fajrTitle
                        text: getPrayerName(languageIndex, "Fajr")
                        Layout.alignment: Qt.AlignLeft
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 5 : 0
                        rightPadding: languageIndex === 0 ? 0 : 5
                    }

                    Label {
                        id: fajrTime

                        text: "00:00"
                        Layout.alignment: Qt.AlignRight
                        color: Kirigami.Theme.textColor;
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 0 : 5
                        rightPadding: languageIndex === 0 ? 5 : 0
                    }
                }

            }

            MenuSeparator {
                topPadding: 5
                bottomPadding: 5

                contentItem: Rectangle {
                    implicitHeight: 1
                    color: Kirigami.Theme.disabledTextColor
                    opacity: 0.2
                }

            }

            Rectangle {
                id: sunrise
                width: parent.width
                color: Kirigami.Theme.neutralBackgroundColor
                height: 28
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    layoutDirection: languageIndex === 0 ? Qt.LeftToRight : Qt.RightToLeft

                    Label {
                        id: sunriseTitle
                        text: getPrayerName(languageIndex, "Sunrise")
                        Layout.alignment: Qt.AlignLeft
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 5 : 0
                        rightPadding: languageIndex === 0 ? 0 : 5

                    }

                    Label {
                        id: sunriseTime

                        text: "00:00"
                        Layout.alignment: Qt.AlignRight
                        color: Kirigami.Theme.textColor;
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 0 : 5
                        rightPadding: languageIndex === 0 ? 5 : 0
                    }
                }

            }

            MenuSeparator {
                topPadding: 5
                bottomPadding: 5

                contentItem: Rectangle {
                    implicitHeight: 1
                    color: Kirigami.Theme.disabledTextColor
                    opacity: 0.2
                }

            }

            Rectangle {
                id: dhuhr
                width: parent.width
                color: Kirigami.Theme.neutralBackgroundColor
                height: 28
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    layoutDirection: languageIndex === 0 ? Qt.LeftToRight : Qt.RightToLeft

                    Label {
                        id: dhuhrTitle
                        text: getPrayerName(languageIndex, "Dhuhr")
                        Layout.alignment: Qt.AlignLeft
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 5 : 0
                        rightPadding: languageIndex === 0 ? 0 : 5

                    }

                    Label {
                        id: dhuhrTime

                        text: "00:00"
                        Layout.alignment: Qt.AlignRight
                        color: Kirigami.Theme.textColor;
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 0 : 5
                        rightPadding: languageIndex === 0 ? 5 : 0
                    }
                }

            }

            MenuSeparator {
                topPadding: 5
                bottomPadding: 5

                contentItem: Rectangle {
                    implicitHeight: 1
                    color: Kirigami.Theme.disabledTextColor
                    opacity: 0.2
                }

            }

            Rectangle {
                id: asr
                width: parent.width
                color: Kirigami.Theme.neutralBackgroundColor
                height: 28
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    layoutDirection: languageIndex === 0 ? Qt.LeftToRight : Qt.RightToLeft

                    Label {
                        id: asrTitle
                        text: getPrayerName(languageIndex, "Asr")
                        Layout.alignment: Qt.AlignLeft
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 5 : 0
                        rightPadding: languageIndex === 0 ? 0 : 5

                    }

                    Label {
                        id: asrTime

                        text: "00:00"
                        Layout.alignment: Qt.AlignRight
                        color: Kirigami.Theme.textColor;
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 0 : 5
                        rightPadding: languageIndex === 0 ? 5 : 0
                    }
                }

            }

            MenuSeparator {
                topPadding: 5
                bottomPadding: 5

                contentItem: Rectangle {
                    implicitHeight: 1
                    color: Kirigami.Theme.disabledTextColor
                    opacity: 0.2
                }

            }

            Rectangle {
                id: maghrib
                width: parent.width
                color: Kirigami.Theme.neutralBackgroundColor
                height: 28
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    layoutDirection: languageIndex === 0 ? Qt.LeftToRight : Qt.RightToLeft

                    Label {
                        id: maghribTitle
                        text: getPrayerName(languageIndex, "Maghrib")
                        Layout.alignment: Qt.AlignLeft
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 5 : 0
                        rightPadding: languageIndex === 0 ? 0 : 5

                    }

                    Label {
                        id: maghribTime

                        text: "00:00"
                        Layout.alignment: Qt.AlignRight
                        color: Kirigami.Theme.textColor;
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 0 : 5
                        rightPadding: languageIndex === 0 ? 5 : 0
                    }
                }

            }

            MenuSeparator {
                topPadding: 5
                bottomPadding: 5

                contentItem: Rectangle {
                    implicitHeight: 1
                    color: Kirigami.Theme.disabledTextColor
                    opacity: 0.2
                }

            }

            Rectangle {
                id: isha
                width: parent.width
                color: Kirigami.Theme.neutralBackgroundColor
                height: 28
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    layoutDirection: languageIndex === 0 ? Qt.LeftToRight : Qt.RightToLeft

                    Label {
                        id: ishaTitle
                        text: getPrayerName(languageIndex, "Isha")
                        Layout.alignment: Qt.AlignLeft
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 5 : 0
                        rightPadding: languageIndex === 0 ? 0 : 5

                    }

                    Label {
                        id: ishaTime

                        text: "00:00"
                        Layout.alignment: Qt.AlignRight
                        color: Kirigami.Theme.textColor;
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 0 : 5
                        rightPadding: languageIndex === 0 ? 5 : 0
                    }
                }

            }

            MenuSeparator {
                topPadding: 10
                bottomPadding: 10
            }

            Button {
                text: i18n("Refresh times")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: refresh_times()
            }

        }
    }
}
