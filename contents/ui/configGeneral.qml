import QtQuick 2.0
import QtQuick.Controls 2.0
import org.kde.kirigami 2.5 as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
   property alias cfg_city: cityField.text
   property alias cfg_country: countryField.text
   property alias cfg_method: methodField.text
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
      TextField {
          id: methodField
          Kirigami.FormData.label: i18n("Method:")
          placeholderText: i18n("default: 2 refrer https://aladhan.com/prayer-times-api/")
      }
   }
}
