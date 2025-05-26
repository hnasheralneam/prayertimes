import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.notification 1.0

PlasmoidItem {
    readonly property bool isVertical: true
    property bool isSmall: width < (Kirigami.Units.gridUnit * 10) || height < (Kirigami.Units.gridUnit * 10)
    property int languageIndex: Plasmoid.configuration.languageIndex !== undefined ? Plasmoid.configuration.languageIndex : 0

    width: Kirigami.Units.gridUnit * 15
    height: Kirigami.Units.gridUnit * 22
    preferredRepresentation: isSmall ? compactRepresentation : fullRepresentation

    // Layout.minimumWidth: isVertical ? Kirigami.Units.gridUnit * 15 : compactRow.implicitWidth
    // Layout.maximumWidth: isVertical ? Infinity : Layout.minimumWidth
    // Layout.preferredWidth: isVertical ? -1 : Layout.minimumWidth

    // Layout.minimumHeight: isVertical ? Kirigami.Units.gridUnit * 22 : Kirigami.Theme.smallFont.pixelSize
    // Layout.maximumHeight: isVertical ? Layout.minimumHeight : Infinity
    // Layout.preferredHeight: isVertical ? Layout.minimumHeight : Kirigami.Units.iconSizes.sizeForLabels * 2

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

    compactRepresentation: CompactRepresentation {
    }

    fullRepresentation: Column {
        id: prayerClock
        property var times: ({})
        property string lastActivePrayer: ""
        property string activePrayer: ""

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
        function highlightActivePrayer(timings) {
            // assuming all timings are for current day
            var currentPrayer = "";
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

            if (Date.now() > parseTime(timings.Fajr) && Date.now() < parseTime(timings.Sunrise)) {
                currentPrayer = "Fajr";
                fajr.color = Kirigami.Theme.highlightColor;
                fajrTitle.color = Kirigami.Theme.neutralBackgroundColor;
                fajrTime.color = Kirigami.Theme.neutralBackgroundColor;
            } else if (Date.now() > parseTime(timings.Sunrise) && Date.now() < parseTime(timings.Dhuhr)) {
                currentPrayer = "Sunrise";
                sunrise.color = Kirigami.Theme.highlightColor;
                sunriseTitle.color = Kirigami.Theme.neutralBackgroundColor;
                sunriseTime.color = Kirigami.Theme.neutralBackgroundColor;
            } else if (Date.now() > parseTime(timings.Dhuhr) && Date.now() < parseTime(timings.Asr)) {
                currentPrayer = "Dhuhr";
                dhuhr.color = Kirigami.Theme.highlightColor;
                dhuhrTitle.color = Kirigami.Theme.neutralBackgroundColor;
                dhuhrTime.color = Kirigami.Theme.neutralBackgroundColor;
            } else if (Date.now() > parseTime(timings.Asr) && Date.now() < parseTime(timings.Maghrib)) {
                currentPrayer = "Asr";
                asr.color = Kirigami.Theme.highlightColor;
                asrTitle.color = Kirigami.Theme.neutralBackgroundColor;
                asrTime.color = Kirigami.Theme.neutralBackgroundColor;
            } else if (Date.now() > parseTime(timings.Maghrib) && Date.now() < parseTime(timings.Isha)) {
            currentPrayer = "Maghrib";
                maghrib.color = Kirigami.Theme.highlightColor;
                maghribTitle.color = Kirigami.Theme.neutralBackgroundColor;
                maghribTime.color = Kirigami.Theme.neutralBackgroundColor;
            } else {
                currentPrayer = "Isha";
                isha.color = Kirigami.Theme.highlightColor;
                ishaTitle.color = Kirigami.Theme.neutralBackgroundColor;
                ishaTime.color = Kirigami.Theme.neutralBackgroundColor;
            }

            lastActivePrayer = activePrayer;
            activePrayer = currentPrayer;

            if (lastActivePrayer !== currentPrayer && Plasmoid.configuration.notifications) {
                var notification = notificationComponent.createObject(parent);
                notification.title = "It's " + activePrayer + " time";
                notification.sendEvent();
            }

            return currentPrayer;
        }
        function fetchTimes(callback) {
            let URL = "https://api.aladhan.com/v1/timingsByCity/timingsByCity?city=" + Plasmoid.configuration.city + "&country=" + Plasmoid.configuration.country + "&method=" + Plasmoid.configuration.method + "&school=" + Plasmoid.configuration.school;
            request(URL, (o) => {
                if (o.status === 200) {
                    let data = JSON.parse(o.responseText).data;
                    times = data.timings;
                    times.date = data.date.gregorian.date;
                    if (callback) callback(data.timings);
                } else {
                    if (Plasmoid.configuration.notifications) {
                        var notification = notificationComponent.createObject(parent);
                        notification.title = "Could not update times. Are you connected to the internet?";
                        notification.sendEvent();
                    }

                    if (getFormattedDate(new Date()) != times.date) {
                        times = {
                            "Fajr": "00:00",
                            "Sunrise": "00:00",
                            "Dhuhr": "00:00",
                            "Asr": "00:00",
                            "Maghrib": "00:00",
                            "Isha": "00:00"
                        }
                        updateDisplay();
                    }
                }
            });
        }
        function updateDisplay(timings) {
            var prayerTimes = timings || times;
            highlightActivePrayer(prayerTimes);

            let isActive = Plasmoid.configuration.hourFormat;
            fajrTime.text = to12HourTime(prayerTimes.Fajr, isActive);
            sunriseTime.text = to12HourTime(prayerTimes.Sunrise, isActive);
            dhuhrTime.text = to12HourTime(prayerTimes.Dhuhr, isActive);
            asrTime.text = to12HourTime(prayerTimes.Asr, isActive);
            maghribTime.text = to12HourTime(prayerTimes.Maghrib, isActive);
            ishaTime.text = to12HourTime(prayerTimes.Isha, isActive);
        }
        function request(url, callback) {
            let xhr = new XMLHttpRequest();
            xhr.onreadystatechange = (function(myxhr) {
                return () => {
                    if (myxhr.readyState === 4) callback(myxhr);
                };
            })(xhr);
            xhr.open("GET", url);
            xhr.send();
        }
        function getFormattedDate(givenDate) {
            const today = givenDate;
            const day = String(today.getDate()).padStart(2, "0");
            const month = String(today.getMonth() + 1).padStart(2, "0");
            const year = today.getFullYear();
            return `${day}-${month}-${year}`;
        }



        // onload
        Component.onCompleted: {
            fetchTimes(updateDisplay);
            Plasmoid.configuration.valueChanged.connect((key, value) => {
                fetchTimes(updateDisplay);
            });
        }
        // loop
        Item {
            Timer {
                property string activePrayer: ""
                interval: 30000 // repeat every 30 seconds
                running: true
                repeat: true
                onTriggered: () => {
                    // what it should do
                    // is look at the times, decides if it needs to actually fetch new times
                    // if it does get new, if not check if it is time for a new prayer then notify and update highlight
                    // all above code should be run when loaded as well

                    // FIRST - save time just for today, and in loop check if it's a different day then fetch new times


                    // data structure: store an array of prayer time days
                    // update api url to fetch for current day

                    // if there are no active prayer times (meaning was disconnected from internet but connected now) fetch them


                    if (times && Object.keys(times).length > 0 && getFormattedDate(new Date()) === times.date) {
                        updateDisplay(times);
                    } else {
                        fetchTimes(updateDisplay);
                    }
                }
            }
        }


        // Notification element
        Component {
            id: notificationComponent
            Notification {
                componentName: "plasma_workspace"
                eventId: "notification"
                // text: "Prayer Times Widget"
                autoDelete: true
            }
        }

        // Title, Location and Prayer Elements
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


            // Prayer times, refresh button

            // a Repeater with this list model could be used to dynamically create the prayer time elements
            // property var prayerModel: [
            //     { name: "Fajr", id: "fajr" },
            //     { name: "Sunrise", id: "sunrise" },
            //     { name: "Dhuhr", id: "dhuhr" },
            //     { name: "Asr", id: "asr" },
            //     { name: "Maghrib", id: "maghrib" },
            //     { name: "Isha", id: "isha" }
            // ]


            Rectangle {
                id: fajr
                width: parent.width
                color: "transparent"
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
                        leftPadding: languageIndex === 0 ? 0 : Kirigami.Units.gridUnit * .25
                        rightPadding: languageIndex === 0 ? Kirigami.Units.gridUnit * .25 : 0
                    }

                    Label {
                        id: fajrTime

                        text: "00:00"
                        Layout.alignment: Qt.AlignRight
                        color: Kirigami.Theme.textColor;
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 0 : Kirigami.Units.gridUnit * .25
                        rightPadding: languageIndex === 0 ? Kirigami.Units.gridUnit * .25 : 0
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
                color: "transparent"
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
                        leftPadding: languageIndex === 0 ? 0 : Kirigami.Units.gridUnit * .25
                        rightPadding: languageIndex === 0 ? Kirigami.Units.gridUnit * .25 : 0
                    }

                    Label {
                        id: sunriseTime

                        text: "00:00"
                        Layout.alignment: Qt.AlignRight
                        color: Kirigami.Theme.textColor;
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 0 : Kirigami.Units.gridUnit * .25
                        rightPadding: languageIndex === 0 ? Kirigami.Units.gridUnit * .25 : 0
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
                color: "transparent"
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
                        leftPadding: languageIndex === 0 ? 0 : Kirigami.Units.gridUnit * .25
                        rightPadding: languageIndex === 0 ? Kirigami.Units.gridUnit * .25 : 0
                    }

                    Label {
                        id: dhuhrTime

                        text: "00:00"
                        Layout.alignment: Qt.AlignRight
                        color: Kirigami.Theme.textColor;
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 0 : Kirigami.Units.gridUnit * .25
                        rightPadding: languageIndex === 0 ? Kirigami.Units.gridUnit * .25 : 0
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
                color: "transparent"
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
                        leftPadding: languageIndex === 0 ? 0 : Kirigami.Units.gridUnit * .25
                        rightPadding: languageIndex === 0 ? Kirigami.Units.gridUnit * .25 : 0
                    }

                    Label {
                        id: asrTime

                        text: "00:00"
                        Layout.alignment: Qt.AlignRight
                        color: Kirigami.Theme.textColor;
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 0 : Kirigami.Units.gridUnit * .25
                        rightPadding: languageIndex === 0 ? Kirigami.Units.gridUnit * .25 : 0
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
                color: "transparent"
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
                        leftPadding: languageIndex === 0 ? 0 : Kirigami.Units.gridUnit * .25
                        rightPadding: languageIndex === 0 ? Kirigami.Units.gridUnit * .25 : 0
                    }

                    Label {
                        id: maghribTime

                        text: "00:00"
                        Layout.alignment: Qt.AlignRight
                        color: Kirigami.Theme.textColor;
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 0 : Kirigami.Units.gridUnit * .25
                        rightPadding: languageIndex === 0 ? Kirigami.Units.gridUnit * .25 : 0
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
                color: "transparent"
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
                        leftPadding: languageIndex === 0 ? 0 : Kirigami.Units.gridUnit * .25
                        rightPadding: languageIndex === 0 ? Kirigami.Units.gridUnit * .25 : 0
                    }

                    Label {
                        id: ishaTime

                        text: "00:00"
                        Layout.alignment: Qt.AlignRight
                        color: Kirigami.Theme.textColor;
                        font.pixelSize: 20
                        leftPadding: languageIndex === 0 ? 0 : Kirigami.Units.gridUnit * .25
                        rightPadding: languageIndex === 0 ? Kirigami.Units.gridUnit * .25 : 0
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
                onClicked: {
                    if (times && Object.keys(times).length > 0 && getFormattedDate(new Date()) === times.date) {
                        updateDisplay(times);
                        if (Plasmoid.configuration.notifications) {
                            var notification = notificationComponent.createObject(parent);
                            notification.title = "Refreshing prayer times";
                            notification.sendEvent();
                        }
                    } else {
                        fetchTimes(updateDisplay);
                    }
                }
            }
        }
    }
}
