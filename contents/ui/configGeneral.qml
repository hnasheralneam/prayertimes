import QtQuick 2.0
import QtQuick.Controls 2.0
import org.kde.kirigami 2.5 as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
   property alias cfg_city: cityField.text
   property alias cfg_smallStyle: smallStyleField.currentValue
   property alias cfg_country: countryField.text

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

      ComboBox {
         id: smallStyleField
         Kirigami.FormData.label: i18n("Small Style:")
         model: [i18n("Icon"), i18n("Next time")]
         Component.onCompleted: {
            currentIndex = 0;
         }
      }
   }
}
