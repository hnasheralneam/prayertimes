#!/bin/bash
xgettext --from-code=UTF-8 --language=JavaScript --keyword=i18n --keyword=i18nc:1c,2 $(find ./contents -name "*.qml") -o ./po/dev.hnasheralneam.prayertimes.pot