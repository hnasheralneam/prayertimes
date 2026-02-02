import QtQuick 2.0
import QtQuick.Controls 2.0
import org.kde.kirigami 2.5 as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_city: cityField.text
    property alias cfg_country: countryField.text
    // property alias cfg_smallStyle: smallStyleField.currentValue
    property alias cfg_notifications: notificationsCheckBox.checked
    property alias cfg_hourFormat: hourFormatCheckBox.checked
    property alias cfg_method: methodField.currentIndex
    property alias cfg_school: schoolField.currentIndex
    property alias cfg_languageIndex: languageField.currentIndex
    property string cfg_locationType
    property string cfg_latitude: ""
    property string cfg_longitude: ""
    property string cfg_ipCity: ""

    Kirigami.FormLayout {
         Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Location")
        }        ButtonGroup {
            id: locationTypeGroup
            buttons: [cityRadio, autoRadio, coordsRadio]
        }

        RadioButton {
            id: cityRadio
            text: i18n("City")
            property string locationValue: "city"
            checked: cfg_locationType === "city"
            onCheckedChanged: {
                if (checked) {
                    cfg_locationType = locationValue
                }
            }
        }

        TextField {
            id: cityField
            Kirigami.FormData.label: i18n("City:")
            placeholderText: i18n("eg. New York")
            visible: cityRadio.checked
        }
        TextField {
            id: countryField
            Kirigami.FormData.label: i18n("Country:")
            placeholderText: i18n("eg. United States")
            visible: cityRadio.checked
        }

        RadioButton {
            id: autoRadio
            text: i18n("Automatic")
            property string locationValue: "automatic"
            checked: cfg_locationType === "automatic"
            onCheckedChanged: {
                if (checked) {
                    cfg_locationType = locationValue
                }
            }
        }

        Button {
            text: i18n("Fetch Coordinates")
            visible: autoRadio.checked
            onClicked: {
                var xhr = new XMLHttpRequest();
                xhr.open("GET", "http://ip-api.com/json", true);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        if (xhr.status === 200) {
                            var response = JSON.parse(xhr.responseText);
                            cfg_latitude = response.lat.toString();
                            cfg_longitude = response.lon.toString();
                            cfg_ipCity = response.city + ", " + response.country;
                            autoCoordinatesLabel.text = i18n("Location: %1\nCoordinates: %2, %3", cfg_ipCity, response.lat, response.lon);
                            console.log("Coordinates fetched: ", response.lat, response.lon, cfg_ipCity);
                        } else {
                            console.error("Failed to fetch coordinates");
                            autoCoordinatesLabel.text = i18n("Failed to fetch coordinates");
                        }
                    }
                };
                xhr.send();
            }
        }

        Label {
            id: autoCoordinatesLabel
            text: i18n("Click 'Fetch Coordinates' to get your location")
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
            visible: autoRadio.checked
        }

        Label {
            text: i18n("Note: If you are using a VPN, the location will be incorrect")
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
            visible: autoRadio.checked
        }




        // This code is commented out because there was some issues with specific coords.
        // RadioButton {
        //     id: coordsRadio
        //     text: i18n("Latitude/Longitude")
        //     property string locationValue: "coordinates"
        //     checked: cfg_locationType === "coordinates"
        //     onCheckedChanged: {
        //         if (checked) {
        //             cfg_locationType = locationValue
        //         }
        //     }
        // }

        // TextField {
        //     id: manualLatField
        //     Kirigami.FormData.label: i18n("Latitude:")
        //     placeholderText: i18n("eg. 40.7128")
        //     text: cfg_latitude
        //     visible: coordsRadio.checked
        //     onTextChanged: if (coordsRadio.checked) cfg_latitude = text
        // }

        // TextField {
        //     id: manualLonField
        //     Kirigami.FormData.label: i18n("Longitude:")
        //     placeholderText: i18n("eg. -74.0060")
        //     text: cfg_longitude
        //     visible: coordsRadio.checked
        //     onTextChanged: if (coordsRadio.checked) cfg_longitude = text
        // }

        // Label {
        //     text: i18n("May not work in all cases, if the times are incorrect use the automatic option.")
        //     wrapMode: Text.WordWrap
        //     horizontalAlignment: Text.AlignLeft
        //     visible: coordsRadio.checked
        // }



        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Calculations")
        }

        /* ComboBox {
         id: smallStyleField
         Kirigami.FormData.label: i18n("Small Style:")
         model: [i18n("Icon"), i18n("Next time")]
         Component.onCompleted: {
            currentIndex = 0;
         } */
        ComboBox {
            id: methodField
            Kirigami.FormData.label: i18n("Method:")
            model: ["Jafari / Shia Ithna-Ashari", "University of Islamic Sciences, Karachi", "Islamic Society of North America", "Muslim World League", "Umm Al-Qura University, Makkah", "Egyptian General Authority of Survey", "Institute of Geophysics, University of Tehran", "Gulf Region", "Kuwait", "Qatar", "Majlis Ugama Islam Singapura, Singapore", "Union Organization islamic de France", "Diyanet İşleri Başkanlığı, Turkey", "Spiritual Administration of Muslims of Russia", "Moonsighting Committee Worldwide (not working)", "Dubai (experimental)", "Jabatan Kemajuan Islam Malaysia (JAKIM)", "Tunisia", "Algeria", "KEMENAG - Kementerian Agama Republik Indonesia", "Morocco", "Comunidade Islamica de Lisboa", "Ministry of Awqaf, Islamic Affairs and Holy Places, Jordan"]
            currentIndex: plasmoid.configuration.method !== undefined ? plasmoid.configuration.method : 0
        }



        ComboBox {
            id: schoolField
            Kirigami.FormData.label: i18n("School:")
            model: ["Shafi (standard)", "Hanafi"]
            currentIndex: plasmoid.configuration.school !== undefined ? plasmoid.configuration.school : 0
        }


        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Widget")
        }

        ComboBox {
            id: languageField
            Kirigami.FormData.label: i18n("Language:")
            model: ["English", "العربية"]
            currentIndex: plasmoid.configuration.languageIndex !== undefined ? plasmoid.configuration.languageIndex : 0
        }

        CheckBox {
            id: hourFormatCheckBox
            Kirigami.FormData.label: i18n("12-Hour Format:")
        }
        CheckBox {
            id: notificationsCheckBox
            Kirigami.FormData.label: i18n("Notifications enabled:")
        }
    }
}



// import QtQuick 2.0
// import QtQuick.Controls 2.0
// import org.kde.kirigami 2.5 as Kirigami
// import org.kde.kcmutils as KCM

// KCM.SimpleKCM {
//     property alias cfg_city: cityField.text
//     property alias cfg_country: countryField.text
//     // property alias cfg_smallStyle: smallStyleField.currentValue
//     property alias cfg_notifications: notificationsCheckBox.checked
//     property alias cfg_hourFormat: hourFormatCheckBox.checked
//     property alias cfg_method: methodField.currentIndex
//     property alias cfg_school: schoolField.currentIndex
//     property alias cfg_languageIndex: languageField.currentIndex

//     Kirigami.FormLayout {
//         TextField {
//             id: cityField
//             Kirigami.FormData.label: i18n("City:")
//             placeholderText: i18n("eg. New York")
//         }
//         TextField {
//             id: countryField
//             Kirigami.FormData.label: i18n("Country:")
//             placeholderText: i18n("eg. United States")
//         }

//         /* ComboBox {
//          id: smallStyleField
//          Kirigami.FormData.label: i18n("Small Style:")
//          model: [i18n("Icon"), i18n("Next time")]
//          Component.onCompleted: {
//             currentIndex = 0;
//          } */
//         ComboBox {
//             id: methodField
//             Kirigami.FormData.label: i18n("Method:")
//             model: ["Jafari / Shia Ithna-Ashari", "University of Islamic Sciences, Karachi", "Islamic Society of North America", "Muslim World League", "Umm Al-Qura University, Makkah", "Egyptian General Authority of Survey", "Institute of Geophysics, University of Tehran", "Gulf Region", "Kuwait", "Qatar", "Majlis Ugama Islam Singapura, Singapore", "Union Organization islamic de France", "Diyanet İşleri Başkanlığı, Turkey", "Spiritual Administration of Muslims of Russia", "Moonsighting Committee Worldwide (not working)", "Dubai (experimental)", "Jabatan Kemajuan Islam Malaysia (JAKIM)", "Tunisia", "Algeria", "KEMENAG - Kementerian Agama Republik Indonesia", "Morocco", "Comunidade Islamica de Lisboa", "Ministry of Awqaf, Islamic Affairs and Holy Places, Jordan"]
//             currentIndex: plasmoid.configuration.method !== undefined ? plasmoid.configuration.method : 0
//         }
//         ComboBox {
//             id: languageField
//             Kirigami.FormData.label: i18n("Language:")
//             model: ["English", "العربية"]
//             currentIndex: plasmoid.configuration.languageIndex !== undefined ? plasmoid.configuration.languageIndex : 0
//         }
//         ComboBox {
//             id: schoolField
//             Kirigami.FormData.label: i18n("School:")
//             model: ["Shafi (standard)", "Hanafi"]
//             currentIndex: plasmoid.configuration.school !== undefined ? plasmoid.configuration.school : 0
//         }
//         CheckBox {
//             id: hourFormatCheckBox
//             Kirigami.FormData.label: i18n("12-Hour Format:")
//         }
//         CheckBox {
//             id: notificationsCheckBox
//             Kirigami.FormData.label: i18n("Notifications enabled:")
//         }
//     }
// }
