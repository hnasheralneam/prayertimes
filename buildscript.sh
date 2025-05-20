echo "Run this from project root"
cp -r ../dev.hnasheralneam.prayertimes ../prayertimesbuild
cd ../prayertimesbuild
rm -rf .git
rm -f *.md
rm -f *.png
rm -f buildscript.sh
cd ..
zip -r prayertimes.plasmoid prayertimesbuild
rm -rf prayertimesbuild