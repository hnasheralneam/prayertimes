import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

PlasmoidItem {
   width: Kirigami.Units.gridUnit * 15
   height: Kirigami.Units.gridUnit * 25

   property bool isSmall: width < (Kirigami.Units.gridUnit * 10) || height < (Kirigami.Units.gridUnit * 10)

   preferredRepresentation: isSmall ? compactRepresentation : fullRepresentation

   compactRepresentation: CompactRepresentation { }

   fullRepresentation: Column {
        id: prayerClock

        function refresh_times() {
            let URL = "http://api.aladhan.com/v1/timingsByCity?city=" + Plasmoid.configuration.city + "&country=" + Plasmoid.configuration.country + "&method=2";
            request(URL, (o) => {
                if (o.status === 200) {
                    let data = JSON.parse(o.responseText).data;
                    fajrTime.text = data.timings.Fajr;
                    sunriseTime.text = data.timings.Sunrise;
                    dhuhrTime.text = data.timings.Dhuhr;
                    asrTime.text = data.timings.Asr;
                    maghribTime.text = data.timings.Maghrib;
                    ishaTime.text = data.timings.Isha;
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

        Item {
            Timer {
                interval: 3600000; running: true; repeat: true // repeating hourly
                onTriggered: refresh_times();
            }
        }

        Component.onCompleted: {
            refresh_times();
        }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                id: titleLabel

                text: "Prayer Times"
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

            // PrayerTimeBlock {
            //     prayer: "Fajr"
            // }
            
            Rectangle {
                id: fajr

                width: parent.width
                color: Kirigami.Theme.highlightColor
                height: 28
                radius: 8

                Text {
                    id: fajrTitle

                    fontSizeMode: Text.Fit
                    text: "Fajr"
                    color: Kirigami.Theme.textColor
                    font.pixelSize: 20
                    leftPadding: 5
                }

                Text {
                    id: fajrTime

                    anchors.right: parent.right
                    text: "00:00"
                    color: Kirigami.Theme.textColor
                    font.pixelSize: 20
                    rightPadding: 5
                }

            }
            
            MenuSeparator {
                topPadding: 5
                bottomPadding: 5

                contentItem: Rectangle {
                    implicitHeight: 1
                    color: Kirigami.Theme.disabledTextColor
                }

            }

            Rectangle {
                id: sunrise

                width: parent.width
                color: Kirigami.Theme.neutralBackgroundColor
                height: 28
                radius: 8

                Text {
                    id: sunriseTitle

                    fontSizeMode: Text.Fit
                    text: "Sunrise"
                    color: Kirigami.Theme.textColor
                    font.pixelSize: 20
                    leftPadding: 5
                }

                Text {
                    id: sunriseTime

                    anchors.right: parent.right
                    text: "00:00"
                    color: Kirigami.Theme.textColor
                    font.pixelSize: 20
                    rightPadding: 5
                }

            }

            MenuSeparator {
                topPadding: 5
                bottomPadding: 5

                contentItem: Rectangle {
                    implicitHeight: 1
                    color: Kirigami.Theme.disabledTextColor
                }

            }

            Rectangle {
                id: dhuhr

                width: parent.width
                color: Kirigami.Theme.neutralBackgroundColor
                height: 28
                radius: 8

                Text {
                    id: dhuhrTitle

                    fontSizeMode: Text.Fit
                    text: "Dhuhr"
                    color: Kirigami.Theme.textColor
                    font.pixelSize: 20
                    leftPadding: 5
                }

                Text {
                    id: dhuhrTime

                    anchors.right: parent.right
                    text: "00:00"
                    color: Kirigami.Theme.textColor
                    font.pixelSize: 20
                    rightPadding: 5
                }

            }

            MenuSeparator {
                topPadding: 5
                bottomPadding: 5

                contentItem: Rectangle {
                    implicitHeight: 1
                    color: Kirigami.Theme.disabledTextColor
                }

            }

            Rectangle {
                id: asr

                width: parent.width
                color: Kirigami.Theme.neutralBackgroundColor
                height: 28
                radius: 8

                Text {
                    id: asrTitle

                    fontSizeMode: Text.Fit
                    text: "Asr"
                    color: Kirigami.Theme.textColor
                    font.pixelSize: 20
                    leftPadding: 5
                }

                Text {
                    id: asrTime

                    anchors.right: parent.right
                    text: "00:00"
                    color: Kirigami.Theme.textColor
                    font.pixelSize: 20
                    rightPadding: 5
                }

            }

            MenuSeparator {
                topPadding: 5
                bottomPadding: 5

                contentItem: Rectangle {
                    implicitHeight: 1
                    color: Kirigami.Theme.disabledTextColor
                }

            }

            Rectangle {
                id: maghrib

                width: parent.width
                color: Kirigami.Theme.neutralBackgroundColor
                height: 28
                radius: 8

                Text {
                    id: maghribTitle

                    fontSizeMode: Text.Fit
                    text: "Maghrib"
                    color: Kirigami.Theme.textColor
                    font.pixelSize: 20
                    leftPadding: 5
                }

                Text {
                    id: maghribTime

                    anchors.right: parent.right
                    text: "00:00"
                    color: Kirigami.Theme.textColor
                    font.pixelSize: 20
                    rightPadding: 5
                }

            }

            MenuSeparator {
                topPadding: 5
                bottomPadding: 5

                contentItem: Rectangle {
                    implicitHeight: 1
                    color: Kirigami.Theme.disabledTextColor
                }

            }

            Rectangle {
                id: isha

                width: parent.width
                color: Kirigami.Theme.neutralBackgroundColor
                height: 28
                radius: 8

                Text {
                    id: ishaTitle

                    fontSizeMode: Text.Fit
                    text: "Isha"
                    color: Kirigami.Theme.textColor
                    font.pixelSize: 20
                    leftPadding: 5
                }

                Text {
                    id: ishaTime

                    anchors.right: parent.right
                    text: "00:00"
                    color: Kirigami.Theme.textColor
                    font.pixelSize: 20
                    rightPadding: 5
                }

            }

            MenuSeparator {
                topPadding: 10
                bottomPadding: 10
            }

            Button {
                text: "Refresh times"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: refresh_times()
            }

        }

    }
}
