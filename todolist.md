fix
- should have error when cannot pull successfully (eg no internet)
- make text color work on highlighted regardless (by checking contrast)
- alignment of arabic is messed up

features
- find way to openly cite sources (in panel for config?)
- add custom icon (some sort of sijadih)
- add taskbar representation (with customization options)
- time until next prayer
- show city/country names in dropdown
- notifications
- refresh times on location change

make a build script
- remove git files, readme, other repo stuff
- zip to plasmoid
example, untested:
```bash
echo "Run this from project root"
cp -r ../dev.hnasheralneam.prayertimes ../prayertimesbuild
cd ../prayertimesbuild
rm -rf .git
rm -rf *.md
cd ..
zip -r prayertimes.plasmoid prayertimesbuild
```
