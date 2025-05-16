import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

PlasmoidItem {

    property bool isSmall: width < (Kirigami.Units.gridUnit * 10) || height < (Kirigami.Units.gridUnit * 10)
    property int languageIndex: Plasmoid.configuration.languageIndex !== undefined ? Plasmoid.configuration.languageIndex : 0

    width: Kirigami.Units.gridUnit * 15
    height: Kirigami.Units.gridUnit * 25
    preferredRepresentation: isSmall ? compactRepresentation : fullRepresentation

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
                fajr.color = Kirigami.Theme.highlightColor;
                fajrTitle.color = Kirigami.Theme.neutralBackgroundColor;
                fajrTime.color = Kirigami.Theme.neutralBackgroundColor;
            }
            else if (Date.now() > parseTime(timings.Maghrib)) {
                isha.color = Kirigami.Theme.highlightColor;
                ishaTitle.color = Kirigami.Theme.neutralBackgroundColor;
                ishaTime.color = Kirigami.Theme.neutralBackgroundColor;
            }
            else if (Date.now() > parseTime(timings.Asr)) {
                maghrib.color = Kirigami.Theme.highlightColor;
                maghribTitle.color = Kirigami.Theme.neutralBackgroundColor;
                maghribTime.color = Kirigami.Theme.neutralBackgroundColor;
            }
            else if (Date.now() > parseTime(timings.Dhuhr)) {
                asr.color = Kirigami.Theme.highlightColor;
                asrTitle.color = Kirigami.Theme.neutralBackgroundColor;
                asrTime.color = Kirigami.Theme.neutralBackgroundColor;
            }
            else if (Date.now() > parseTime(timings.Sunrise)) {
                dhuhr.color = Kirigami.Theme.highlightColor;
                dhuhrTitle.color = Kirigami.Theme.neutralBackgroundColor;
                dhuhrTime.color = Kirigami.Theme.neutralBackgroundColor;
            }
            else if (Date.now() > parseTime(timings.Fajr)) {
                sunrise.color = Kirigami.Theme.highlightColor;
                sunriseTitle.color = Kirigami.Theme.neutralBackgroundColor;
                sunriseTime.color = Kirigami.Theme.neutralBackgroundColor;
            }
        }


        function refresh_times() {
            let URL = "https://api.aladhan.com/v1/timingsByCity/timingsByCity?city=" + Plasmoid.configuration.city + "&country=" + Plasmoid.configuration.country + "&method="  + Plasmoid.configuration.method;
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
                interval: 3.6e+06 // repeating hourly
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
                text: "Refresh times"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: refresh_times()
            }
        }
    }
}
