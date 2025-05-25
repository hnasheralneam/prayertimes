import QtQuick 2.0
import QtQuick.Controls 2.0
import org.kde.kirigami 2.5 as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_city: cityField.text
    property alias cfg_country: countryField.text
    // property alias cfg_smallStyle: smallStyleField.currentValue
    property alias cfg_hourFormat: hourFormatCheckBox.checked
    property alias cfg_method: methodField.currentIndex
    property alias cfg_school: schoolField.currentIndex
    property alias cfg_languageIndex: languageField.currentIndex

    Kirigami.FormLayout {
        TextField {
            id: cityField
            Kirigami.FormData.label: i18n("City:")
            placeholderText: i18n("eg. New York")
        }
        TextField {
            id: countryField
            Kirigami.FormData.label: i18n("Country:")
            placeholderText: i18n("eg. United States")
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
            id: languageField
            Kirigami.FormData.label: i18n("Language:")
            model: ["English", "العربية"]
            currentIndex: plasmoid.configuration.languageIndex !== undefined ? plasmoid.configuration.languageIndex : 0
        }
        ComboBox {
            id: schoolField
            Kirigami.FormData.label: i18n("School:")
            model: ["Shafi (standard)", "Hanafi"]
            currentIndex: plasmoid.configuration.school !== undefined ? plasmoid.configuration.school : 0
        }
        CheckBox {
            id: hourFormatCheckBox
            Kirigami.FormData.label: i18n("12-Hour Format:")
        }
    }
}
