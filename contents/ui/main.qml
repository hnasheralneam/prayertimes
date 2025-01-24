import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

PlasmoidItem {
    property bool isSmall: width < (Kirigami.Units.gridUnit * 10) || height < (Kirigami.Units.gridUnit * 10)

    width: Kirigami.Units.gridUnit * 15
    height: Kirigami.Units.gridUnit * 25
    preferredRepresentation: isSmall ? compactRepresentation : fullRepresentation

    compactRepresentation: CompactRepresentation {
    }

    fullRepresentation: Column {
        id: prayerClock

        function formatTime(date, format) {
            let dateObj = new Date(date);
            let hours, mins;
            if (dateObj.getHours().toString().length < 2) hours = `0${dateObj.getHours()}`;
            else hours = `${dateObj.getHours()}`;
            if (dateObj.getMinutes().toString().length < 2) mins = `0${dateObj.getMinutes()}`;
            else mins = `${dateObj.getMinutes()}`;
            return `${hours}:${mins}`;
        }
        function parseTime(timeString) {
            let parts = timeString.split(':');
            let dateObj = new Date();
            dateObj.setHours(parseInt(parts[0], 10));
            dateObj.setMinutes(parseInt(parts[1], 10));
            dateObj.setSeconds(0);
            return dateObj;
        }

        function findHighlighted(timings) {
            fajr.color = Kirigami.Theme.neutralBackgroundColor;
            sunrise.color = Kirigami.Theme.neutralBackgroundColor;
            dhuhr.color = Kirigami.Theme.neutralBackgroundColor;
            asr.color = Kirigami.Theme.neutralBackgroundColor;
            maghrib.color = Kirigami.Theme.neutralBackgroundColor;
            isha.color = Kirigami.Theme.neutralBackgroundColor;

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
                isha.color = Kirigami.Theme.highlightColor;
                ishaTitle.color = Kirigami.Theme.neutralBackgroundColor;
                ishaTime.color = Kirigami.Theme.neutralBackgroundColor;
            }
            else if (Date.now() > parseTime(timings.Maghrib)) {
                maghrib.color = Kirigami.Theme.highlightColor;
                maghribTitle.color = Kirigami.Theme.neutralBackgroundColor;
                maghribTime.color = Kirigami.Theme.neutralBackgroundColor;
            }
            else if (Date.now() > parseTime(timings.Asr)) {
                asr.color = Kirigami.Theme.highlightColor;
                asrTitle.color = Kirigami.Theme.neutralBackgroundColor;
                asrTime.color = Kirigami.Theme.neutralBackgroundColor;
            }
            else if (Date.now() > parseTime(timings.Dhuhr)) {
                dhuhr.color = Kirigami.Theme.highlightColor;
                dhuhrTitle.color = Kirigami.Theme.neutralBackgroundColor;
                dhuhrTime.color = Kirigami.Theme.neutralBackgroundColor;
            }
            else if (Date.now() > parseTime(timings.Sunrise)) {
                sunrise.color = Kirigami.Theme.highlightColor;
                sunriseTitle.color = Kirigami.Theme.neutralBackgroundColor;
                sunriseTime.color = Kirigami.Theme.neutralBackgroundColor;
            }
            else if (Date.now() > parseTime(timings.Fajr)) {
                fajr.color = Kirigami.Theme.highlightColor;
                fajrTitle.color = Kirigami.Theme.neutralBackgroundColor;
                fajrTime.color = Kirigami.Theme.neutralBackgroundColor;
            }
        }

        function refresh_times() {
            let URL = "http://api.aladhan.com/v1/timingsByCity?city=" + Plasmoid.configuration.city + "&country=" + Plasmoid.configuration.country + "&method=2";
            request(URL, (o) => {
                if (o.status === 200) {
                    let data = JSON.parse(o.responseText).data;

                    findHighlighted(data.timings);


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

        Component.onCompleted: {
            refresh_times();
        }

        Item {
            Timer {
                interval: 3.6e+06 // repeating hourly
                running: true
                repeat: true
                onTriggered: refresh_times()
            }

        }

        Column {
            // PrayerTimeBlock {
            //     prayer: "Fajr"
            // }

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
                    color: Kirigami.Theme.neutralBackgroundColor
                    font.pixelSize: 20
                    leftPadding: 5
                }

                Text {
                    id: fajrTime

                    anchors.right: parent.right
                    text: "00:00"
                    color: Kirigami.Theme.neutralBackgroundColor
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
